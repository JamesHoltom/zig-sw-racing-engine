const raylib = @import("../modules/raylib.zig");

pub const Track = struct {
    segments: [128]Segment,
    numSegments: usize,
    segmentLength: f32,
    length: f32,
    looped: bool,
};

pub const SegmentColours = struct {
    road: raylib.Color,
    rumble: raylib.Color,
    grass: raylib.Color,
};

pub const SegmentWidths = struct {
    road: f32,
    rumble: f32,
};

pub const SegmentPoint = struct {
    position: raylib.Vector3,
    widths: SegmentWidths,
};

pub const Segment = struct {
    point1: SegmentPoint,
    point2: SegmentPoint,
    curve: f32,
    colours: SegmentColours,
};
