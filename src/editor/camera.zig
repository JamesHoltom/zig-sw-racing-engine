const std = @import("std");
const raylib = @import("../modules/raylib.zig");

const keySpeed: f32 = 50.0;

pub const Camera = struct {
    position: raylib.Vector2,

    pub fn Update(self: *@This(), delta: f32) void {
        if (raylib.IsKeyDown(raylib.KEY_UP)) {
            self.position.y -= keySpeed * delta;
        }

        if (raylib.IsKeyDown(raylib.KEY_DOWN)) {
            self.position.y += keySpeed * delta;
        }

        if (raylib.IsKeyDown(raylib.KEY_LEFT)) {
            self.position.x -= keySpeed * delta;
        }

        if (raylib.IsKeyDown(raylib.KEY_RIGHT)) {
            self.position.x += keySpeed * delta;
        }
    }
};
