const raylib = @import("modules/raylib.zig");
const trackTypes = @import("types/track.zig");

pub const FindSegmentError = error{
    SegmentNotFound,
};

pub fn FindSegmentIndex(z: f32, segments: []const trackTypes.Segment) FindSegmentError!usize {
    for (segments, 0..) |segment, i| {
        if (segment.point1.position.z <= z and segment.point2.position.z > z) {
            return @as(usize, @intCast(i));
        }
    }

    return FindSegmentError.SegmentNotFound;
}
