const Builder = @import("std").build.Builder;
const glfw = @import("mach-glfw/build.zig");

pub fn build(b: *Builder) void {
    const exe = b.addExecutable("zig-imgui-template", "src/main.zig");
    const target = b.standardTargetOptions(.{});
    exe.setTarget(target);
    exe.setBuildMode(b.standardReleaseOptions());

    exe.addPackagePath("glfw", "mach-glfw/src/main.zig");
    glfw.link(b, exe, .{});
    exe.addIncludeDir("src");
    exe.addIncludeDir("cimgui");
    exe.addIncludeDir("cimgui/imgui");
    exe.addIncludeDir("cimgui/imgui/backends");
    exe.addCSourceFiles(&[_][]const u8 {
        "cimgui/imgui/imgui.cpp",
        "cimgui/imgui/imgui_draw.cpp",
        "cimgui/imgui/imgui_tables.cpp",
        "cimgui/imgui/imgui_widgets.cpp",
        "cimgui/imgui/imgui_demo.cpp",
        "cimgui/imgui/backends/imgui_impl_glfw.cpp",
        "cimgui/imgui/backends/imgui_impl_opengl3.cpp",
        "cimgui/cimgui.cpp",
        }, &[_][]const u8 {});
    exe.linkLibCpp();

    exe.install();
    b.default_step.dependOn(&exe.step);

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const main_step = b.step("run", "run");
    main_step.dependOn(&run_cmd.step);
}
