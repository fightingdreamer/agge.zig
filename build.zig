const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const c_flags = [_][]const u8{
        "-std=c++11",
    };

    const upstream = b.dependency("upstream", .{});
    const src_path = upstream.path("src/agge");
    const include_path = upstream.path("agge");

    // -------------------------------------------------------------------------

    const lib_agge = b.addStaticLibrary(.{
        .name = "agge",
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lib_agge);

    lib_agge.addIncludePath(include_path.dirname());
    lib_agge.addCSourceFiles(.{
        .root = src_path,
        .flags = &c_flags,
        .files = &.{
            "blenders_intel.cpp",
            "color.cpp",
            "curves.cpp",
            "dash.cpp",
            "figures.cpp",
            "hybrid_event.cpp",
            "math.cpp",
            "parallel.cpp",
            "stroke.cpp",
            "stroke_features.cpp",
            "vector_rasterizer.cpp",
        },
    });
    lib_agge.linkLibCpp();
    lib_agge.installHeadersDirectory(include_path, "agge", .{});
    lib_agge.installHeadersDirectory(src_path, "", .{});
}
