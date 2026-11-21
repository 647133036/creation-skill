using System.IO;
using Unlose.Core.Config;
using Xunit;

namespace Unlose.Tests;

/// <summary>
/// Tests for working-volume resolution (GitHub issue #2): a session-start snapshot must cover the volume
/// the agent actually works on, not a hard-coded C:\.
/// DriveInfo cannot be mocked, so the eligibility rules are exercised through the pure overloads.
/// </summary>
public class WorkingVolumeResolverTests
{
    private static readonly (DriveType, bool, string, string)[] TwoNtfsVolumes =
    [
        (DriveType.Fixed, true, "NTFS", "C:\\"),
        (DriveType.Fixed, true, "NTFS", "D:\\")
    ];

    [Theory]
    [InlineData(@"D:\projects\app", "D:\\")]
    [InlineData(@"D:\projects\app\src\file.cs", "D:\\")]
    [InlineData("D:/projects/app", "D:\\")]
    [InlineData("d:\\projects", "D:\\")]
    [InlineData(@"D:\", "D:\\")]
    [InlineData("D:", "D:\\")]
    public void Resolve_ReturnsWorkingVolume_ForPathsOnEligibleDrive(string path, string expected)
        => Assert.Equal(expected, WorkingVolumeResolver.Resolve(path, TwoNtfsVolumes));

    [Fact]
    public void Resolve_KeepsDriveLetterCase_WhenNormalizing()
        => Assert.Equal("D:\\", WorkingVolumeResolver.Resolve(@"d:\projects", TwoNtfsVolumes));

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    [InlineData(null)]
    public void Resolve_ReturnsNull_ForEmptyInput(string? path)
        => Assert.Null(WorkingVolumeResolver.Resolve(path, TwoNtfsVolumes));

    [Fact]
    public void Resolve_ReturnsNull_ForNetworkShare()
    {
        // UNC paths have no drive root; a session on \\server\share must not produce a bogus volume
        Assert.Null(WorkingVolumeResolver.Resolve(@"\\server\share\project", TwoNtfsVolumes));
    }

    [Fact]
    public void Resolve_ReturnsNull_WhenVolumeIsNotConfiguredAsEligible()
    {
        // E: is not in the supplied snapshot of volumes (not present, or filtered out as non-NTFS/removable)
        Assert.Null(WorkingVolumeResolver.Resolve(@"E:\projects", TwoNtfsVolumes));
    }

    [Fact]
    public void Resolve_ReturnsNull_ForNonNtfsVolume()
    {
        var volumes = new[]
        {
            (DriveType.Fixed, true, "NTFS", "C:\\"),
            (DriveType.Fixed, true, "FAT32", "F:\\")
        };
        Assert.Null(WorkingVolumeResolver.Resolve(@"F:\projects", volumes));
    }

    [Fact]
    public void Resolve_ReturnsNull_ForRemovableVolume()
    {
        var volumes = new[]
        {
            (DriveType.Fixed, true, "NTFS", "C:\\"),
            (DriveType.Removable, true, "NTFS", "E:\\")
        };
        Assert.Null(WorkingVolumeResolver.Resolve(@"E:\projects", volumes));
    }

    [Theory]
    [InlineData("C:", "C:\\")]
    [InlineData("c:", "C:\\")]
    [InlineData(@"c:\", "C:\\")]
    [InlineData("d:/", "D:\\")]
    public void NormalizeRoot_CanonicalizesDriveRoots(string input, string expected)
        => Assert.Equal(expected, WorkingVolumeResolver.NormalizeRoot(input));

    [Fact]
    public void NormalizeRoot_PassesThroughNonDriveRoots()
    {
        // Comparison against a canonical volume root then simply fails to match, which is the intent
        Assert.Equal(@"\\server\share", WorkingVolumeResolver.NormalizeRoot(@"\\server\share"));
    }
}
