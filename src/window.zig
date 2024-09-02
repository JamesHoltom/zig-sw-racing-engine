const std = @import("std");
const raylib = @import("modules/raylib.zig");
const vecTypes = @import("types/vector.zig");

pub fn Init(title: []const u8, size: vecTypes.IVec2) void {
    raylib.SetConfigFlags(raylib.FLAG_WINDOW_RESIZABLE | raylib.FLAG_VSYNC_HINT);
    raylib.SetTargetFPS(60);

    raylib.InitWindow(size.x, size.y, @ptrCast(title));
}

pub fn Shutdown() void {
    raylib.CloseWindow();
}

pub fn GetSize() vecTypes.IVec2 {
    return vecTypes.IVec2{
        .x = @intCast(raylib.GetScreenWidth()),
        .y = @intCast(raylib.GetScreenHeight()),
    };
}
