const std = @import("std");
const raylib = @import("../modules/raylib.zig");
const vecTypes = @import("../types/vector.zig");
const cam = @import("camera.zig");
const dbg = @import("debug.zig");
const render = @import("render.zig");
const road = @import("road.zig");
const track = @import("../track.zig");
const window = @import("../window.zig");

const windowSize = vecTypes.IVec2{
    .x = 320,
    .y = 240,
};

pub fn Run() !void {
    window.Init("Test Window", windowSize);
    defer window.Shutdown();

    raylib.SetWindowMinSize(windowSize.x, windowSize.y);

    const renderer = render.Load(windowSize);
    defer renderer.Unload();

    dbg.Init();
    defer dbg.Deinit();

    const trackData = try track.ReadTrackFromFile("temp.txt");

    var camera = cam.Camera{
        .position = raylib.Vector3{
            .x = 0.0,
            .y = 100.0,
            .z = 0.0,
        },
        .speed = 0.0,
        .fov = 100.0,
    };

    while (!raylib.WindowShouldClose()) {
        dbg.Update();

        const delta = raylib.GetFrameTime();
        camera.Update(delta);
        try camera.Loop(trackData.length);

        raylib.BeginTextureMode(renderer.tex);
        raylib.ClearBackground(raylib.BLUE);

        road.Draw(
            &renderer.tex,
            trackData,
            camera,
        ) catch {
            std.process.exit(2);
        };

        raylib.EndTextureMode();

        raylib.BeginDrawing();

        raylib.ClearBackground(raylib.BLACK);

        renderer.Render();

        dbg.DrawDebugText();

        raylib.EndDrawing();
    }
}
