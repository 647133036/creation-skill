using Unlose.Core.Config;
using Unlose.Core.Data;
using Unlose.Core.Enums;
using Unlose.Core.Interfaces;
using Unlose.Core.Models;
using Unlose.Service;
using Microsoft.Extensions.Logging.Abstractions;
using Xunit;

namespace Unlose.Tests;

/// <summary>
/// Session-start volume coverage tests (GitHub issue #2): the snapshot must include the volume the agent
/// works on, not just the configured protected volumes, while every existing behaviour (explicit volume,
/// non-session triggers, coalescing) stays intact.
/// </summary>
public class SnapshotVolumeCoverageTests : IDisposable
{
    private readonly string _dir;
    private readonly string _dbPath;

    public SnapshotVolumeCoverageTests()
    {
        _dir = Path.Combine(Path.GetTempPath(), "unlose-coverage-test-" + Guid.NewGuid().ToString("N")[..8]);
        Directory.CreateDirectory(_dir);
        _dbPath = Path.Combine(_dir, "snapshots.db");
    }

    public void Dispose()
    {
        try { Microsoft.Data.Sqlite.SqliteConnection.ClearAllPools(); } catch { }
        try { Directory.Delete(_dir, recursive: true); } catch { }
    }

    [Fact]
    public async Task SessionTrigger_WithoutWorkingDir_UsesConfiguredVolumesOnly()
    {
        var (mgr, vss) = CreateManager(["C:\\"]);

        await mgr.CreateAsync(TriggerType.AgentPreSession, triggerDetail: "kimi.exe (PID=1)");

        Assert.Equal<string>(["C:\\"], vss.CreatedVolumes);
    }

    [Fact]
    public async Task SessionTrigger_WithWorkingDirOnAnotherVolume_AddsThatVolume()
    {
        var (mgr, vss) = CreateManager(["C:\\"]);

        await mgr.CreateAsync(
            TriggerType.AgentInitiated,
            triggerDetail: "kimi.exe (mcp)",
            workingDirectory: @"D:\projects\app");

        // The configured C:\ stays, and the working volume is appended — coverage only grows
        Assert.Equal<string>(["C:\\", "D:\\"], vss.CreatedVolumes);
    }

    [Fact]
    public async Task SessionTrigger_WithWorkingDirAlreadyConfigured_DoesNotDuplicate()
    {
        var (mgr, vss) = CreateManager(["C:\\", "D:\\"]);

        await mgr.CreateAsync(
            TriggerType.AgentPreSession,
            triggerDetail: "kimi.exe (PID=1)",
            workingDirectory: @"D:\projects\app");

        Assert.Equal<string>(["C:\\", "D:\\"], vss.CreatedVolumes);
    }

    [Fact]
    public async Task NonSessionTrigger_IgnoresWorkingDir()
    {
        var (mgr, vss) = CreateManager(["C:\\"]);

        await mgr.CreateAsync(
            TriggerType.Manual,
            triggerDetail: "user",
            workingDirectory: @"D:\projects\app");

        // Manual/scheduled snapshots keep their existing semantics
        Assert.Equal<string>(["C:\\"], vss.CreatedVolumes);
    }

    [Fact]
    public async Task ExplicitVolume_WinsOverWorkingDir()
    {
        var (mgr, vss) = CreateManager(["C:\\"]);

        await mgr.CreateAsync(
            TriggerType.AgentInitiated,
            triggerDetail: "kimi.exe (cli)",
            volumes: ["E:\\"],
            workingDirectory: @"D:\projects\app");

        Assert.Equal<string>(["E:\\"], vss.CreatedVolumes);
    }

    [Fact]
    public async Task SessionTrigger_WithUnusableWorkingDir_FallsBackToConfiguredVolumes()
    {
        var (mgr, vss) = CreateManager(["C:\\"]);

        await mgr.CreateAsync(
            TriggerType.AgentInitiated,
            triggerDetail: "kimi.exe (cli)",
            workingDirectory: @"\\server\share\project");

        Assert.Equal<string>(["C:\\"], vss.CreatedVolumes);
    }

    [Fact]
    public async Task ConcurrentCreate_DoesNotCoalesce_WhenRecentSnapshotMissesARequiredVolume()
    {
        var (mgr, vss) = CreateManager(["C:\\"], autoRelease: false);

        // First request: C:\ only (e.g. process detection, which knows no working directory)
        var t1 = mgr.CreateAsync(TriggerType.AgentPreSession, triggerDetail: "kimi.exe (PID=1)", volumes: ["C:\\"]);
        await vss.Entered.WaitAsync(TimeSpan.FromSeconds(5));

        // Second request needs C:\ + D:\: the in-flight C:\ snapshot must not satisfy it
        var t2 = mgr.CreateAsync(
            TriggerType.AgentInitiated,
            triggerDetail: "kimi.exe (mcp)",
            volumes: ["C:\\", "D:\\"],
            workingDirectory: @"D:\projects\app");

        vss.Release();
        var r1 = await t1.WaitAsync(TimeSpan.FromSeconds(10));
        var r2 = await t2.WaitAsync(TimeSpan.FromSeconds(10));

        Assert.NotNull(r1);
        Assert.NotNull(r2);
        Assert.NotEqual(r1!.Id, r2!.Id);
        // C:\ once for t1, then C:\ + D:\ for t2
        Assert.Equal<string>(["C:\\", "C:\\", "D:\\"], vss.CreatedVolumes);
    }

    private (SnapshotManager Manager, RecordingVssGateway Vss) CreateManager(
        string[] configuredVolumes, bool autoRelease = true)
    {
        // Synchronous DB init: the tests only need the schema, not the async setup path
        DatabaseInitializer.EnsureCreatedAsync(_dbPath).GetAwaiter().GetResult();
        var repo = new SqliteRepository(_dbPath);
        var vss = new RecordingVssGateway { AutoRelease = autoRelease };
        var config = new UnloseConfig { Snapshot = new SnapshotConfig { Volumes = configuredVolumes } };
        // Fixed volume set so assertions do not depend on the test machine's real drives
        var mgr = new SnapshotManager(
            NullLogger<SnapshotManager>.Instance, vss, repo, new EventBus(), config,
            volumeEnumerator: () => Volumes);
        return (mgr, vss);
    }

    /// <summary>Two eligible NTFS volumes: C:\ (always configured) and D:\ (the agent's project drive).</summary>
    private static readonly (DriveType, bool, string, string)[] Volumes =
    [
        (DriveType.Fixed, true, "NTFS", "C:\\"),
        (DriveType.Fixed, true, "NTFS", "D:\\")
    ];

    /// <summary>Fake VSS gateway that records every volume it is asked to snapshot.</summary>
    private sealed class RecordingVssGateway : IVssGateway
    {
        private readonly TaskCompletionSource _entered = new(TaskCreationOptions.RunContinuationsAsynchronously);
        private readonly TaskCompletionSource _release = new(TaskCreationOptions.RunContinuationsAsynchronously);
        private readonly List<string> _createdVolumes = [];

        public bool AutoRelease { get; init; }
        public Task Entered => _entered.Task;
        public void Release() => _release.TrySetResult();
        public string[] CreatedVolumes { get { lock (_createdVolumes) return [.. _createdVolumes]; } }

        public async Task<SnapshotRecord> CreateShadowCopyAsync(string volumePath, CancellationToken ct = default)
        {
            lock (_createdVolumes) _createdVolumes.Add(volumePath);
            _entered.TrySetResult();
            if (!AutoRelease)
                await _release.Task.WaitAsync(ct);
            return new SnapshotRecord { Volumes = [volumePath], ShadowId = Guid.NewGuid().ToString() };
        }

        public Task DeleteShadowCopyAsync(string shadowId, CancellationToken ct = default) => Task.CompletedTask;
        public Task<bool> RestoreShadowCopyAsync(string shadowId, string targetVolume, CancellationToken ct = default)
            => Task.FromResult(true);
        public Task<IReadOnlyList<VssShadowInfo>> ListShadowCopiesAsync(CancellationToken ct = default)
            => Task.FromResult<IReadOnlyList<VssShadowInfo>>([]);
        public Task<string?> MountShadowCopyAsync(string shadowId, CancellationToken ct = default)
            => Task.FromResult<string?>(null);
        public Task<IReadOnlyList<string>?> RestoreFilesFromShadowAsync(
            string shadowId, IReadOnlyList<string> relativePaths, string targetPath, CancellationToken ct = default)
            => Task.FromResult<IReadOnlyList<string>?>([]);
    }
}
