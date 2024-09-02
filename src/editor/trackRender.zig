const std = @import("std");
const raylib = @import("../modules/raylib.zig");
const cam = @import("camera.zig");
const trackTypes = @import("../types/track.zig");

pub fn Draw(track: trackTypes.Track, camera: cam.Camera) void {
    DrawStartLine();

    var alternateColour: bool = false;
    var offset = camera.position;

    for (track.segments) |segment| {
        DrawSegment(segment, offset, alternateColour);

        offset.x += segment.point2.position.x;
        offset.y += segment.point2.position.z;

        alternateColour = !alternateColour;
    }
}

fn DrawStartLine() void {}

fn DrawSegment(segment: trackTypes.Segment, offset: raylib.Vector2, alternateColour: bool) void {
    const p1 = raylib.Vector2{
        .x = offset.x + segment.point1.position.x,
        .y = offset.y + segment.point1.position.z,
    };
    const p2 = raylib.Vector2{
        .x = offset.x + segment.point2.position.x,
        .y = offset.y + segment.point2.position.z,
    };
    const length: f32 = @sqrt(std.math.pow(f32, p1.x + p2.x, 2) + std.math.pow(f32, p1.y + p2.y, 2));
    const segmentWidth: f32 = segment.point1.widths.road;
    const normalised = raylib.Vector2{ .x = (p1.x - p2.x) / length * segmentWidth, .y = (p1.y - p2.y) / length * segmentWidth };
    const normalisedInvert = raylib.Vector2{
        .x = normalised.x * -1,
        .y = normalised.y * -1,
    };
    const linePoints = [_]raylib.Vector2{
        raylib.Vector2{ .x = p1.x - normalisedInvert.y, .y = p1.y + normalisedInvert.x },
        raylib.Vector2{ .x = p2.x + normalised.y, .y = p2.y - normalised.x },
        raylib.Vector2{ .x = p2.x - normalised.y, .y = p2.y + normalised.x },
        raylib.Vector2{ .x = p1.x + normalisedInvert.y, .y = p1.y - normalisedInvert.x },
    };
    const colour = if (alternateColour) raylib.LIGHTGRAY else raylib.DARKGRAY;

    raylib.DrawLineV(linePoints[0], linePoints[1], colour);
    raylib.DrawLineV(linePoints[1], linePoints[2], colour);
    raylib.DrawLineV(linePoints[2], linePoints[3], colour);
    raylib.DrawLineV(p1, p2, raylib.YELLOW);
}
