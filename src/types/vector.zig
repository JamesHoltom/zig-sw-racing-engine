const raylib = @import("../modules/raylib.zig");

const VecParamTypeTag = enum {
    xy,
    xyz,
    val,
};

const VecParamTypeError = error{
    InvalidParamType,
};

const IVecParamType = union(VecParamTypeTag) {
    xy: IVec2,
    xyz: IVec3,
    val: i32,
};
const VecParamType = union(VecParamTypeTag) {
    xy: Vec2,
    xyz: Vec3,
    val: f32,
};

pub const IVec2 = struct {
    x: i32,
    y: i32,

    pub fn add(self: @This(), input: IVecParamType) IVec2 {
        switch (input) {
            VecParamTypeTag.xy => |xy| {
                return IVec2{
                    .x = self.x + xy.x,
                    .y = self.y + xy.y,
                };
            },
            VecParamTypeTag.xyz => |xyz| {
                return IVec2{
                    .x = self.x + xyz.x,
                    .y = self.y + xyz.y,
                };
            },
            VecParamTypeTag.val => |val| {
                return IVec2{
                    .x = self.x + val,
                    .y = self.y + val,
                };
            },
        }

        return self;
    }
    pub fn sub(self: @This(), input: IVecParamType) IVec2 {
        switch (input) {
            VecParamTypeTag.xy => |xy| {
                return IVec2{
                    .x = self.x - xy.x,
                    .y = self.y - xy.y,
                };
            },
            VecParamTypeTag.xyz => |xyz| {
                return IVec2{
                    .x = self.x - xyz.x,
                    .y = self.y - xyz.y,
                };
            },
            VecParamTypeTag.val => |val| {
                return IVec2{
                    .x = self.x - val,
                    .y = self.y - val,
                };
            },
        }

        return self;
    }
    pub fn mul(self: @This(), input: IVecParamType) IVec2 {
        switch (input) {
            VecParamTypeTag.xy => |xy| {
                return IVec2{
                    .x = self.x * xy.x,
                    .y = self.y * xy.y,
                };
            },
            VecParamTypeTag.xyz => |xyz| {
                return IVec2{
                    .x = self.x * xyz.x,
                    .y = self.y * xyz.y,
                };
            },
            VecParamTypeTag.val => |val| {
                return IVec2{
                    .x = self.x * val,
                    .y = self.y * val,
                };
            },
        }

        return self;
    }
    pub fn div(self: @This(), input: IVecParamType) IVec2 {
        switch (input) {
            VecParamTypeTag.xy => |xy| {
                return IVec2{
                    .x = @divFloor(self.x, xy.x),
                    .y = @divFloor(self.y, xy.y),
                };
            },
            VecParamTypeTag.xyz => |xyz| {
                return IVec2{
                    .x = @divFloor(self.x, xyz.x),
                    .y = @divFloor(self.y, xyz.y),
                };
            },
            VecParamTypeTag.val => |val| {
                return IVec2{
                    .x = @divFloor(self.x, val),
                    .y = @divFloor(self.y, val),
                };
            },
        }

        return self;
    }
    pub fn toFloat(self: @This()) Vec2 {
        return Vec2{
            .x = @as(f32, @floatFromInt(self.x)),
            .y = @as(f32, @floatFromInt(self.y)),
        };
    }
};

pub const Vec2 = struct {
    x: f32,
    y: f32,

    pub fn add(self: @This(), input: VecParamType) Vec2 {
        switch (input) {
            VecParamTypeTag.xy => |xy| {
                return Vec2{
                    .x = self.x + xy.x,
                    .y = self.y + xy.y,
                };
            },
            VecParamTypeTag.xyz => |xyz| {
                return Vec2{
                    .x = self.x + xyz.x,
                    .y = self.y + xyz.y,
                };
            },
            VecParamTypeTag.val => |val| {
                return Vec2{
                    .x = self.x + val,
                    .y = self.y + val,
                };
            },
        }

        return self;
    }
    pub fn sub(self: @This(), input: VecParamType) Vec2 {
        switch (input) {
            VecParamTypeTag.xy => |xy| {
                return Vec2{
                    .x = self.x - xy.x,
                    .y = self.y - xy.y,
                };
            },
            VecParamTypeTag.xyz => |xyz| {
                return Vec2{
                    .x = self.x - xyz.x,
                    .y = self.y - xyz.y,
                };
            },
            VecParamTypeTag.val => |val| {
                return Vec2{
                    .x = self.x - val,
                    .y = self.y - val,
                };
            },
        }

        return self;
    }
    pub fn mul(self: @This(), input: VecParamType) Vec2 {
        switch (input) {
            VecParamTypeTag.xy => |xy| {
                return Vec2{
                    .x = self.x * xy.x,
                    .y = self.y * xy.y,
                };
            },
            VecParamTypeTag.xyz => |xyz| {
                return Vec2{
                    .x = self.x * xyz.x,
                    .y = self.y * xyz.y,
                };
            },
            VecParamTypeTag.val => |val| {
                return Vec2{
                    .x = self.x * val,
                    .y = self.y * val,
                };
            },
        }

        return self;
    }
    pub fn div(self: @This(), input: VecParamType) Vec2 {
        switch (input) {
            VecParamTypeTag.xy => |xy| {
                return Vec2{
                    .x = self.x / xy.x,
                    .y = self.y / xy.y,
                };
            },
            VecParamTypeTag.xyz => |xyz| {
                return Vec2{
                    .x = self.x / xyz.x,
                    .y = self.y / xyz.y,
                };
            },
            VecParamTypeTag.val => |val| {
                return Vec2{
                    .x = self.x / val,
                    .y = self.y / val,
                };
            },
        }

        return self;
    }
    pub fn toInt(self: @This()) IVec2 {
        return IVec2{
            .x = @as(i32, @intFromFloat(self.x)),
            .y = @as(i32, @intFromFloat(self.y)),
        };
    }
    pub fn toRlVector(self: @This()) raylib.Vector2 {
        return raylib.Vector2{
            .x = self.x,
            .y = self.y,
        };
    }
};

pub const IVec3 = struct {
    x: i32,
    y: i32,
    z: i32,

    pub fn add(self: @This(), input: IVecParamType) VecParamTypeError!IVec3 {
        switch (input) {
            VecParamTypeTag.xy => {
                return VecParamTypeError.InvalidParamType;
            },
            VecParamTypeTag.xyz => |xyz| {
                return IVec3{
                    .x = self.x + xyz.x,
                    .y = self.y + xyz.y,
                    .z = self.z + xyz.z,
                };
            },
            VecParamTypeTag.val => |val| {
                return IVec3{
                    .x = self.x + val,
                    .y = self.y + val,
                    .z = self.z + val,
                };
            },
        }

        return self;
    }
    pub fn sub(self: @This(), input: IVecParamType) VecParamTypeError!IVec3 {
        switch (input) {
            VecParamTypeTag.xy => {
                return VecParamTypeError.InvalidParamType;
            },
            VecParamTypeTag.xyz => |xyz| {
                return IVec3{
                    .x = self.x - xyz.x,
                    .y = self.y - xyz.y,
                    .z = self.z - xyz.z,
                };
            },
            VecParamTypeTag.val => |val| {
                return IVec3{
                    .x = self.x - val,
                    .y = self.y - val,
                    .z = self.z - val,
                };
            },
        }

        return self;
    }
    pub fn mul(self: @This(), input: IVecParamType) VecParamTypeError!IVec3 {
        switch (input) {
            VecParamTypeTag.xy => {
                return VecParamTypeError.InvalidParamType;
            },
            VecParamTypeTag.xyz => |xyz| {
                return IVec3{
                    .x = self.x * xyz.x,
                    .y = self.y * xyz.y,
                    .z = self.z * xyz.z,
                };
            },
            VecParamTypeTag.val => |val| {
                return IVec3{
                    .x = self.x * val,
                    .y = self.y * val,
                    .z = self.z * val,
                };
            },
        }

        return self;
    }
    pub fn div(self: @This(), input: IVecParamType) VecParamTypeError!IVec3 {
        switch (input) {
            VecParamTypeTag.xy => {
                return VecParamTypeError.InvalidParamType;
            },
            VecParamTypeTag.xyz => |xyz| {
                return IVec3{
                    .x = @divFloor(self.x, xyz.x),
                    .y = @divFloor(self.y, xyz.y),
                    .z = @divFloor(self.z, xyz.z),
                };
            },
            VecParamTypeTag.val => |val| {
                return IVec3{
                    .x = @divFloor(self.x, val),
                    .y = @divFloor(self.y, val),
                    .z = @divFloor(self.z, val),
                };
            },
        }

        return self;
    }
    pub fn toFloat(self: @This()) Vec3 {
        return Vec3{
            .x = @as(f32, @floatFromInt(self.x)),
            .y = @as(f32, @floatFromInt(self.y)),
            .z = @as(f32, @floatFromInt(self.z)),
        };
    }
};

pub const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn add(self: @This(), input: VecParamType) VecParamTypeError!Vec3 {
        switch (input) {
            VecParamTypeTag.xy => {
                return VecParamTypeError.InvalidParamType;
            },
            VecParamTypeTag.xyz => |xyz| {
                return Vec3{
                    .x = self.x + xyz.x,
                    .y = self.y + xyz.y,
                    .z = self.z + xyz.z,
                };
            },
            VecParamTypeTag.val => |val| {
                return Vec3{
                    .x = self.x + val,
                    .y = self.y + val,
                    .z = self.z + val,
                };
            },
        }

        return self;
    }
    pub fn sub(self: @This(), input: VecParamType) VecParamTypeError!Vec3 {
        switch (input) {
            VecParamTypeTag.xy => {
                return VecParamTypeError.InvalidParamType;
            },
            VecParamTypeTag.xyz => |xyz| {
                return Vec3{
                    .x = self.x - xyz.x,
                    .y = self.y - xyz.y,
                    .z = self.z - xyz.z,
                };
            },
            VecParamTypeTag.val => |val| {
                return Vec3{
                    .x = self.x - val,
                    .y = self.y - val,
                    .z = self.z - val,
                };
            },
        }

        return self;
    }
    pub fn mul(self: @This(), input: VecParamType) VecParamTypeError!Vec3 {
        switch (input) {
            VecParamTypeTag.xy => {
                return VecParamTypeError.InvalidParamType;
            },
            VecParamTypeTag.xyz => |xyz| {
                return Vec3{
                    .x = self.x * xyz.x,
                    .y = self.y * xyz.y,
                    .z = self.z * xyz.z,
                };
            },
            VecParamTypeTag.val => |val| {
                return Vec3{
                    .x = self.x * val,
                    .y = self.y * val,
                    .z = self.z * val,
                };
            },
        }

        return self;
    }
    pub fn div(self: @This(), input: VecParamType) VecParamTypeError!Vec3 {
        switch (input) {
            VecParamTypeTag.xy => {
                return VecParamTypeError.InvalidParamType;
            },
            VecParamTypeTag.xyz => |xyz| {
                return Vec3{
                    .x = self.x / xyz.x,
                    .y = self.y / xyz.y,
                    .z = self.z / xyz.z,
                };
            },
            VecParamTypeTag.val => |val| {
                return Vec3{
                    .x = self.x / val,
                    .y = self.y / val,
                    .z = self.z / val,
                };
            },
        }

        return self;
    }
    pub fn toInt(self: @This()) IVec3 {
        return IVec3{
            .x = @as(i32, @intFromFloat(self.x)),
            .y = @as(i32, @intFromFloat(self.y)),
            .z = @as(i32, @intFromFloat(self.z)),
        };
    }
    pub fn toRlVector(self: @This()) raylib.Vector3 {
        return raylib.Vector3{
            .x = self.x,
            .y = self.y,
            .z = self.z,
        };
    }
};
