const std = @import("std");
const raylib = @import("../modules/raylib.zig");

const maxSpeed: f32 = 300.0;
const maxRevSpeed: f32 = -25.0;
const turnSpeed: f32 = 20.0;
const forwardAccel: f32 = 4.0;
const reverseAccel: f32 = 4.0;
const brake: f32 = 8.0;
const decel: f32 = 6.0;

pub const Camera = struct {
    position: raylib.Vector3,
    speed: f32,
    fov: f32,

    pub fn Update(self: *@This(), delta: f32) void {
        if (raylib.IsKeyDown(raylib.KEY_UP)) {
            self.speed = @min(self.speed + forwardAccel, maxSpeed);
        } else if (raylib.IsKeyDown(raylib.KEY_DOWN)) {
            if (self.speed > 0.0) {
                self.speed = @max(self.speed - brake, 0.0);
            } else {
                self.speed = @max(self.speed - reverseAccel, maxRevSpeed);
            }
        } else {
            if (self.speed > 0.0) {
                self.speed = @max(self.speed - decel, 0.0);
            } else if (self.speed < 0.0) {
                self.speed = @min(self.speed + decel, 0.0);
            }
        }

        self.position.z += self.speed * delta;

        if (raylib.IsKeyDown(raylib.KEY_LEFT)) {
            self.position.x -= turnSpeed * delta;
        }

        if (raylib.IsKeyDown(raylib.KEY_RIGHT)) {
            self.position.x += turnSpeed * delta;
        }
    }

    pub fn GetPlayerZPosition(self: *const @This()) f32 {
        return self.position.z + (self.position.y * self.GetCameraDepth());
    }

    pub fn GetCameraDepth(self: *const @This()) f32 {
        return 1.0 / @tan(std.math.degreesToRadians(self.fov / 2.0));
    }

    pub fn Loop(self: *@This(), z: f32) !void {
        self.position.z = try std.math.mod(f32, self.position.z, z);
    }
};
