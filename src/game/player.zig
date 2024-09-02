const raylib = @import("raylib.zig");
const cam = @import("camera.zig");
const seg = @import("segment.zig");

pub fn Draw(tex: *const raylib.RenderTexture2D, segment: seg.Segment, camera: cam.Camera) void {
    const halfScreen: raylib.Vector2 = .{
        .x = @as(f32, @floatFromInt(tex.texture.width)) / 2.0,
        .y = @as(f32, @floatFromInt(tex.texture.height)) / 2.0,
    };
    const elevation: f32 = segment.position2.y - segment.position1.y;
    const remainingZ: f32 = (segment.position2.z - camera.position.z) / (segment.position2.z - segment.position1.z);
    const playerPosition: raylib.Vector2 = .{
        .x = halfScreen.x,
        .y = halfScreen.y - (0.0 * halfScreen.y),
    };

    for (playerPosition - 10..playerPosition, 0..) |y, i| {}
}
