const std = @import("std");
const raylib = @import("../modules/raylib.zig");
const trackTypes = @import("../types/track.zig");
const vecTypes = @import("../types/vector.zig");
const cam = @import("camera.zig");
const dbg = @import("debug.zig");
const seg = @import("../segment.zig");

pub const ProjectResult = struct {
    screenPosition: vecTypes.IVec2,
    widths: trackTypes.SegmentWidths,
    isZeroed: bool,
};

pub fn Project(point: trackTypes.SegmentPoint, offset: raylib.Vector3, tex: *const raylib.RenderTexture2D, camera: cam.Camera, debug: bool) ProjectResult {
    // The camera depth is the distance between the camera and the screen (in OpenGL terms, the Z_NEAR value).
    const depth = camera.GetCameraDepth();
    // Use the center of the screen texture as the vanishing point for perspective calculations.
    const halfScreen: vecTypes.IVec2 = .{
        .x = @divFloor(tex.texture.width, 2),
        .y = @divFloor(tex.texture.height, 2),
    };
    const halfScreenFloat = halfScreen.toFloat();
    const local = vecTypes.Vec3{
        .x = point.position.x + offset.x - camera.position.x,
        .y = point.position.y - offset.y - camera.position.y,
        .z = point.position.z + offset.z - camera.position.z,
    };

    if (local.z == 0.0) {
        return ProjectResult{
            .screenPosition = halfScreen,
            .widths = trackTypes.SegmentWidths{
                .road = point.widths.road,
                .rumble = point.widths.rumble,
            },
            .isZeroed = true,
        };
    }

    const screenScale: f32 = depth / local.z;

    if (debug) {
        dbg.Concat(
            6,
            "\nhS={d: >3.2}, {d: >3.2}\nl={d: >3.2}, {d: >3.2}, {d: >3.2}\nsS={d: >3.2}",
            .{
                halfScreen.x,
                halfScreen.y,
                local.x,
                local.y,
                local.z,
                screenScale,
            },
        ) catch unreachable;
    }

    return ProjectResult{
        .screenPosition = halfScreen.add(.{ .xy = halfScreenFloat.mul(.{ .xyz = local }).mul(.{ .val = screenScale }).toInt() }),
        .widths = trackTypes.SegmentWidths{
            .road = @round(halfScreenFloat.x * point.widths.road * screenScale),
            .rumble = @round(halfScreenFloat.x * point.widths.rumble * screenScale),
        },
        .isZeroed = false,
    };
}

pub fn Draw(tex: *const raylib.RenderTexture2D, trackData: trackTypes.Track, camera: cam.Camera) !void {
    // The amount of Z distance to draw segments up to.
    const drawDist: f32 = 2000.0;
    const baseSegmentIndex = try seg.FindSegmentIndex(camera.position.z, &trackData.segments);
    const baseSegment = trackData.segments[baseSegmentIndex];
    const playerPosition = camera.GetPlayerZPosition();
    const playerZ: f32 = try std.math.mod(f32, playerPosition, trackData.length);
    const playerSegmentIndex = try seg.FindSegmentIndex(playerZ, &trackData.segments);
    const playerSegment = trackData.segments[playerSegmentIndex];
    var segment = trackData.segments[baseSegmentIndex];
    const baseSegmentLength: f32 = segment.point2.position.z - segment.point1.position.z;
    const baseRemainingZ: f32 = @mod(camera.position.z, baseSegmentLength) / baseSegmentLength;
    const playerSegmentLength: f32 = playerSegment.point2.position.z - playerSegment.point1.position.z;
    const playerRemainingZ: f32 = @mod(playerPosition, playerSegmentLength) / playerSegmentLength;

    var currentSegment: usize = baseSegmentIndex;
    var xDist: f32 = 0.0;
    var dxDist: f32 = -(segment.curve * baseRemainingZ);
    var maxY: i32 = 0;
    var zDist: f32 = 0.0;
    var debugCurrentLine: u32 = 0;

    try dbg.Reset();
    try dbg.Concat(
        1,
        "\nIndex: {d: >3}\nCurrent: #{d}\nRemaining: b={d: >3.3}, p={d: >3.3}, dX={d: >3.3}",
        .{
            baseSegmentIndex,
            currentSegment,
            baseRemainingZ,
            playerRemainingZ,
            dxDist,
        },
    );
    try dbg.Concat(
        2,
        "\nPos={d: >3.3},{d: >3.3},{d: >3.3}",
        .{
            camera.position.x,
            camera.position.y,
            camera.position.z,
        },
    );

    while (zDist < drawDist) {
        defer {
            zDist += segment.point2.position.z - segment.point1.position.z;
            currentSegment += 1;
            debugCurrentLine += 1;

            if (currentSegment == trackData.numSegments) {
                currentSegment = 0;
            }

            segment = trackData.segments[currentSegment];
        }

        const yOffset: f32 = std.math.lerp(playerSegment.point1.position.y, playerSegment.point2.position.y, playerRemainingZ);
        const zOffset: f32 = if (baseSegmentIndex > currentSegment and trackData.looped) trackData.length else 0.0;
        const point1 = Project(
            segment.point1,
            .{
                .x = xDist + (baseSegment.curve * baseRemainingZ),
                .y = yOffset,
                .z = zOffset,
            },
            tex,
            camera,
            currentSegment == baseSegmentIndex,
        );
        const point2 = Project(
            segment.point2,
            .{
                .x = xDist + dxDist + (baseSegment.curve * baseRemainingZ),
                .y = yOffset,
                .z = zOffset,
            },
            tex,
            camera,
            currentSegment == baseSegmentIndex,
        );

        try dbg.Concat(
            3,
            "\n#{d:0>2}: X={d: >3.3}~{d: >3.3}, dX={d: >3.3}~{d: >3.3}, Y={d: >3.3}, bY={d: >3.3}, p1={d: >3.3},{d: >3.3},{d: >3.3}, p2={d: >3.3},{d: >3.3},{d: >3.3}",
            .{
                currentSegment,
                xDist,
                xDist + dxDist,
                dxDist,
                dxDist + segment.curve,
                yOffset,
                playerSegment.point2.position.y - playerSegment.point1.position.y,
                segment.point1.position.x,
                segment.point1.position.y,
                segment.point1.position.z,
                segment.point2.position.x,
                segment.point2.position.y,
                segment.point2.position.z,
            },
        );
        // } else if (debugMode == 5) {
        //     const text = try std.fmt.allocPrint(
        //         std.heap.page_allocator,
        //         "\n#{d:0>2}: y={d: >3.3} p1={d: >3.3},{d: >3.3},{d: >3.3}, p2={d: >3.3},{d: >3.3},{d: >3.3}",
        //         .{
        //             currentSegment,
        //             yOffset,
        //             segment.point1.position.x + xDist - camera.position.x,
        //             segment.point1.position.y - yOffset - camera.position.y,
        //             segment.point1.position.z + zOffset - camera.position.z,
        //             segment.point2.position.x + xDist - camera.position.x,
        //             segment.point2.position.y - yOffset - camera.position.y,
        //             segment.point2.position.z + zOffset - camera.position.z,
        //         },
        //     );
        //     try debugText.concat(text);
        // } else if (debugMode == 6) {
        //     const text = try std.fmt.allocPrint(
        //         std.heap.page_allocator,
        //         "\n#{d:0>2}: p1={d: >3.3},{d: >3.3}, p2={d: >3.3},{d: >3.3},",
        //         .{
        //             currentSegment,
        //             point1.screenPosition.x,
        //             point1.screenPosition.y,
        //             point2.screenPosition.x,
        //             point2.screenPosition.y,
        //         },
        //     );
        //     try debugText.concat(text);

        xDist += dxDist;
        dxDist += segment.curve;

        if (point1.screenPosition.y >= point2.screenPosition.y or point2.screenPosition.y <= maxY) {
            continue;
        }

        maxY = point2.screenPosition.y;

        const startY: usize = @intCast(@max(point1.screenPosition.y, 0));
        const endY: usize = @intCast(@min(point2.screenPosition.y, tex.texture.height - 1));
        const diffY = @as(f32, @floatFromInt(point2.screenPosition.y - point1.screenPosition.y));
        const screenTop: usize = @intCast(@max(0 - point1.screenPosition.y, 0));

        try dbg.Concat(
            4,
            "\n#{d:0>2}: L={s}, sT={d}, sY={d}, eY={d}, 0'd={s},{s}",
            .{
                currentSegment,
                if (baseSegmentIndex > currentSegment) "Y" else "N",
                screenTop,
                startY,
                endY,
                if (point1.isZeroed) "Y" else "N",
                if (point2.isZeroed) "Y" else "N",
            },
        );

        if (startY > endY) {
            continue;
        }

        for (startY..endY, screenTop..) |y, j| {
            const iterY: f32 = @as(f32, @floatFromInt(j)) / diffY;
            const roadIterX = @as(i32, @intFromFloat(@floor(std.math.lerp(@as(f32, @floatFromInt(point1.screenPosition.x)), @as(f32, @floatFromInt(point2.screenPosition.x)), iterY))));
            const roadIterW = @as(i32, @intFromFloat(@floor(std.math.lerp(point1.widths.road, point2.widths.road, iterY))));
            const rumbleIterW = @as(i32, @intFromFloat(@floor(std.math.lerp(point1.widths.road + point1.widths.rumble, point2.widths.road + point2.widths.rumble, iterY))));

            try dbg.Concat(
                5,
                "\n#{d:0>2}, X={d: >3}, sX={d: >3}~{d: >3}, Y={d: >3}, iY={d: >3.4} roadW={d: >3}, rumbleW={d: >3}",
                .{
                    currentSegment,
                    roadIterX,
                    point1.screenPosition.x,
                    point2.screenPosition.x,
                    y,
                    iterY,
                    roadIterW,
                    rumbleIterW,
                },
            );

            for (0..@intCast(tex.texture.width)) |x| {
                if (x == roadIterX) {
                    raylib.DrawPixel(@intCast(x), @intCast(y), raylib.WHITE);
                } else if (x < roadIterX - rumbleIterW or x > roadIterX + rumbleIterW) {
                    raylib.DrawPixel(@intCast(x), @intCast(y), segment.colours.grass);
                } else if (x < roadIterX - roadIterW or x > roadIterX + roadIterW) {
                    raylib.DrawPixel(@intCast(x), @intCast(y), segment.colours.rumble);
                } else {
                    raylib.DrawPixel(@intCast(x), @intCast(y), segment.colours.road);
                }
            }
        }
    }
}
