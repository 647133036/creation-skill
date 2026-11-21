using System.IO;
using System.Linq;

namespace Unlose.Core.Config;

/// <summary>
/// Resolves which volume a session-start snapshot should cover from the caller's working directory.
///
/// Background (GitHub issue #2): session-start snapshots were pinned to <c>C:\</c> regardless of where
/// the agent actually worked, so a project on <c>D:\</c> received no pre-session protection while an
/// unrelated C: shadow copy was taken. Callers that know their working directory (the MCP server and the
/// CLI, both of which inherit the agent host's current directory) now resolve it through here.
///
/// Only volumes VSS can shadow-copy are accepted — fixed local NTFS drives, the same eligibility rule
/// used for first-run default protection. Anything else returns <c>null</c> so the caller falls back to
/// the configured protected volumes instead of failing the snapshot.
/// </summary>
public static class WorkingVolumeResolver
{
    /// <summary>Snapshot of the machine's volumes. Injectable so tests are not bound to real drive letters.</summary>
    public delegate IEnumerable<(DriveType Type, bool Ready, string Format, string Root)> VolumeEnumerator();

    /// <summary>
    /// Volume root (e.g. <c>D:\</c>) holding <paramref name="path"/>, provided it is an eligible VSS
    /// volume; <c>null</c> when the path is empty, unresolvable, network/device-based, or the volume is
    /// not a fixed ready NTFS drive.
    /// </summary>
    public static string? Resolve(string? path, VolumeEnumerator? volumes = null)
        => Resolve(path, (volumes ?? DefaultVolumeDetector.GetRawVolumes)());

    /// <summary>
    /// Pure overload: matches <paramref name="path"/> against a supplied volume snapshot so tests can
    /// exercise the eligibility rules without depending on the machine's real drives.
    /// </summary>
    public static string? Resolve(
        string? path, IEnumerable<(DriveType Type, bool Ready, string Format, string Root)> volumes)
    {
        var root = RootOf(path);
        if (root is null) return null;

        return DefaultVolumeDetector.Filter(volumes)
            .FirstOrDefault(v => string.Equals(NormalizeRoot(v), root, StringComparison.OrdinalIgnoreCase));
    }

    /// <summary>
    /// Volumes a snapshot should cover. An explicit volume list always wins; otherwise the configured
    /// protected volumes are used, plus — for session-context triggers — the volume the caller is working
    /// on when it is not already configured (GitHub issue #2).
    /// Session triggers only add coverage: a project on D:\ gets a pre-session shadow copy even if the user
    /// never added D:\ to the protected list, while C:\ keeps being snapshotted as configured.
    /// </summary>
    public static string[] ResolveTargets(
        Enums.TriggerType trigger,
        string[]? explicitVolumes,
        string[] configured,
        string? workingDirectory,
        VolumeEnumerator? volumes = null)
    {
        if (explicitVolumes is { Length: > 0 })
            return explicitVolumes;

        if (string.IsNullOrWhiteSpace(workingDirectory) || !IsSessionContext(trigger))
            return configured;

        var workingVolume = Resolve(workingDirectory, volumes);
        if (workingVolume is null)
            return configured;

        if (configured.Any(v => string.Equals(
                NormalizeRoot(v), workingVolume, StringComparison.OrdinalIgnoreCase)))
            return configured;

        return [.. configured, workingVolume];
    }

    /// <summary>
    /// Triggers that represent an agent session starting, i.e. the ones whose caller knows a working
    /// directory worth protecting. Scheduled/manual/restore snapshots keep their existing semantics.
    /// </summary>
    public static bool IsSessionContext(Enums.TriggerType trigger) =>
        trigger is Enums.TriggerType.AgentPreSession or Enums.TriggerType.AgentInitiated;

    /// <summary>
    /// Volume root of a filesystem path (e.g. <c>D:\projects\app</c> → <c>D:\</c>) without touching the
    /// filesystem. Returns <c>null</c> for empty input, UNC/device paths and paths whose root cannot be
    /// determined.
    /// </summary>
    public static string? RootOf(string? path)
    {
        if (string.IsNullOrWhiteSpace(path)) return null;

        try
        {
            var full = Path.GetFullPath(path.Trim());
            var root = Path.GetPathRoot(full);
            if (string.IsNullOrWhiteSpace(root)) return null;
            // UNC shares and device paths (\\.\GLOBALROOT\..., \\server\share) are not VSS volumes
            if (root.StartsWith(@"\\", StringComparison.Ordinal)) return null;
            return NormalizeRoot(root);
        }
        catch
        {
            // Invalid characters / malformed path: treat as unresolvable, caller falls back
            return null;
        }
    }

    /// <summary>
    /// Canonical <c>X:\</c> form: "d:", "d:\", "D:/" all become "D:\"; an empty or non-drive root is
    /// returned unchanged so the comparison above simply fails to match.
    /// </summary>
    public static string NormalizeRoot(string root)
    {
        if (string.IsNullOrWhiteSpace(root)) return string.Empty;
        var trimmed = root.Trim();
        if (trimmed.Length >= 2 && trimmed[1] == ':')
            return char.ToUpperInvariant(trimmed[0]) + @":\";
        return trimmed;
    }
}
