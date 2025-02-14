const std = @import("std");

const c = @import("c.zig").c;
const Error = @import("errors.zig").Error;
const getError = @import("errors.zig").getError;

/// Returns the GLFW time.
///
/// This function returns the current GLFW time, in seconds. Unless the time
/// has been set using @ref glfwSetTime it measures time elapsed since GLFW was
/// initialized.
///
/// This function and @ref glfwSetTime are helper functions on top of glfw.getTimerFrequency
/// and glfw.getTimerValue.
///
/// The resolution of the timer is system dependent, but is usually on the order
/// of a few micro- or nanoseconds. It uses the highest-resolution monotonic
/// time source on each supported platform.
///
/// @return The current time, in seconds, or zero if an
/// error occurred.
///
/// @thread_safety This function may be called from any thread. Reading and
/// writing of the internal base time is not atomic, so it needs to be
/// externally synchronized with calls to @ref glfwSetTime.
///
/// see also: time
pub inline fn getTime() f64 {
    const time = c.glfwGetTime();

    // The only error this could return would be glfw.Error.NotInitialized, which should
    // definitely have occurred before calls to this. Returning an error here makes the API
    // awkward to use, so we discard it instead.
    getError() catch {};

    return time;
}

/// Sets the GLFW time.
///
/// This function sets the current GLFW time, in seconds. The value must be a positive finite
/// number less than or equal to 18446744073.0, which is approximately 584.5 years.
///
/// This function and @ref glfwGetTime are helper functions on top of glfw.getTimerFrequency and
/// glfw.getTimerValue.
///
/// @param[in] time The new value, in seconds.
///
/// Possible errors include glfw.Error.NotInitialized and glfw.Error.InvalidValue.
///
/// The upper limit of GLFW time is calculated as `floor((2^64 - 1) / 10^9)` and is due to
/// implementations storing nanoseconds in 64 bits. The limit may be increased in the future.
///
/// @thread_safety This function may be called from any thread. Reading and writing of the internal
/// base time is not atomic, so it needs to be externally synchronized with calls to glfw.getTime.
///
/// see also: time
pub inline fn setTime(time: f64) Error!void {
    c.glfwSetTime(time);
    try getError();
}

/// Returns the current value of the raw timer.
///
/// This function returns the current value of the raw timer, measured in `1/frequency` seconds. To
/// get the frequency, call glfw.getTimerFrequency.
///
/// @return The value of the timer, or zero if an error occurred.
///
/// @thread_safety This function may be called from any thread.
///
/// see also: time, glfw.getTimerFrequency
pub inline fn getTimerValue() u64 {
    const value = c.glfwGetTimerValue();

    // The only error this could return would be glfw.Error.NotInitialized, which should
    // definitely have occurred before calls to this. Returning an error here makes the API
    // awkward to use, so we discard it instead.
    getError() catch {};

    return value;
}

/// Returns the frequency, in Hz, of the raw timer.
///
/// This function returns the frequency, in Hz, of the raw timer.
///
/// @return The frequency of the timer, in Hz, or zero if an error occurred.
///
/// @thread_safety This function may be called from any thread.
///
/// see also: time, glfw.getTimerValue
pub inline fn getTimerFrequency() u64 {
    const frequency = c.glfwGetTimerFrequency();

    // The only error this could return would be glfw.Error.NotInitialized, which should
    // definitely have occurred before calls to this. Returning an error here makes the API
    // awkward to use, so we discard it instead.
    getError() catch {};

    return frequency;
}

test "getTime" {
    const glfw = @import("main.zig");
    try glfw.init();
    defer glfw.terminate();

    _ = getTime();
}

test "setTime" {
    const glfw = @import("main.zig");
    try glfw.init();
    defer glfw.terminate();

    _ = try glfw.setTime(1234);
}

test "getTimerValue" {
    const glfw = @import("main.zig");
    try glfw.init();
    defer glfw.terminate();

    _ = glfw.getTimerValue();
}

test "getTimerFrequency" {
    const glfw = @import("main.zig");
    try glfw.init();
    defer glfw.terminate();

    _ = glfw.getTimerFrequency();
}
