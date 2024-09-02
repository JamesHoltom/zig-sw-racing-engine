const std = @import("std");
const raylib = @import("../modules/raylib.zig");
const raygui = @import("../modules/raygui.zig");
const vecTypes = @import("../types/vector.zig");
const window = @import("../window.zig");
// const menu = @import("./menu.zig");
const cam = @import("camera.zig");
const trackRender = @import("trackRender.zig");
const track = @import("../track.zig");
const trackTypes = @import("../types/track.zig");

const windowSize = vecTypes.IVec2{
    .x = 1280,
    .y = 800,
};
// const buttonSize = raylib.Vector2{ .x = 100.0, .y = 32.0 };

pub fn Run() !void {
    window.Init("Editor", windowSize);
    defer window.Shutdown();

    const trackData = try track.ReadTrackFromFile("temp.txt");

    var camera = cam.Camera{
        .position = raylib.Vector2{
            .x = 0.0,
            .y = 0.0,
        },
    };

    while (!raylib.WindowShouldClose()) {
        const delta = raylib.GetFrameTime();
        camera.Update(delta);

        raylib.BeginDrawing();

        raylib.ClearBackground(raylib.BLACK);

        trackRender.Draw(trackData, camera);

        raylib.EndDrawing();
    }
}
