const std = @import("std");
const str = @import("string").String;
const raylib = @import("modules/raylib.zig");
const trackTypes = @import("types/track.zig");

pub const ReadTrackError = error{
    InvalidSectionType,
    MissingFileData,
};

pub fn ReadTrackFromFile(name: []const u8) anyerror!trackTypes.Track {
    const selfPath = try std.fs.selfExeDirPathAlloc(std.heap.page_allocator);
    const fullPath = try std.fs.path.join(std.heap.page_allocator, &[_][]const u8{
        selfPath,
        "assets",
        name,
    });

    const trackFile = try std.fs.cwd().openFile(fullPath, .{ .mode = .read_only });
    defer trackFile.close();

    var fileReader = std.io.bufferedReader(trackFile.reader());
    var stream = fileReader.reader();
    var lineBuffer: [128:0]u8 = undefined;
    var readMode: u8 = 0;
    var stagesRead: u8 = 0;

    var trackColours: [16]trackTypes.SegmentColours = undefined;
    var trackWidths: [16]trackTypes.SegmentWidths = undefined;
    var trackSegments: [128]trackTypes.Segment = undefined;
    var isLooped: bool = undefined;
    var segmentLength: f32 = undefined;
    var nextIndex: usize = 0;
    var previousPosition = raylib.Vector3{
        .x = 0.0,
        .y = 0.0,
        .z = 0.0,
    };

    while (try stream.readUntilDelimiterOrEof(&lineBuffer, '\n')) |lineData| {
        if (lineData.len == 0 or lineData[0] == '#') {
            continue;
        } else if (lineData[0] == '[') {
            nextIndex = 0;

            if (std.mem.eql(u8, lineData, "[DATA]")) {
                readMode = 1;
                stagesRead |= 0b00000001;

                std.log.debug("Reading data...", .{});
            } else if (std.mem.eql(u8, lineData, "[WIDTHS]")) {
                readMode = 2;
                stagesRead |= 0b00000010;

                std.log.debug("Reading road widths...", .{});
            } else if (std.mem.eql(u8, lineData, "[COLOURS]")) {
                readMode = 4;
                stagesRead |= 0b00000100;

                std.log.debug("Reading road colours...", .{});
            } else if (std.mem.eql(u8, lineData, "[SEGMENTS]")) {
                if (stagesRead & 0b00000111 != 0b00000111) {
                    return ReadTrackError.MissingFileData;
                }

                readMode = 8;
                stagesRead |= 0b00001000;

                std.log.debug("Reading road segment data...", .{});
            } else {
                return ReadTrackError.InvalidSectionType;
            }

            continue;
        }

        var splitData = std.mem.split(u8, lineData, " ");

        switch (readMode) {
            1 => {
                isLooped = std.mem.eql(u8, splitData.first(), "1");
                segmentLength = try std.fmt.parseFloat(f32, splitData.next().?);
            },
            2 => {
                const roadWidth = try std.fmt.parseFloat(f32, splitData.first());
                const rumbleWidth = try std.fmt.parseFloat(f32, splitData.next().?);
                trackWidths[nextIndex] = trackTypes.SegmentWidths{
                    .road = roadWidth,
                    .rumble = rumbleWidth,
                };
            },
            4 => {
                const roadColour = raylib.Color{
                    .r = try std.fmt.parseInt(u8, splitData.first(), 10),
                    .g = try std.fmt.parseInt(u8, splitData.next().?, 10),
                    .b = try std.fmt.parseInt(u8, splitData.next().?, 10),
                    .a = 255,
                };
                const rumbleColour = raylib.Color{
                    .r = try std.fmt.parseInt(u8, splitData.next().?, 10),
                    .g = try std.fmt.parseInt(u8, splitData.next().?, 10),
                    .b = try std.fmt.parseInt(u8, splitData.next().?, 10),
                    .a = 255,
                };
                const grassColour = raylib.Color{
                    .r = try std.fmt.parseInt(u8, splitData.next().?, 10),
                    .g = try std.fmt.parseInt(u8, splitData.next().?, 10),
                    .b = try std.fmt.parseInt(u8, splitData.next().?, 10),
                    .a = 255,
                };

                trackColours[nextIndex] = trackTypes.SegmentColours{
                    .road = roadColour,
                    .rumble = rumbleColour,
                    .grass = grassColour,
                };
            },
            8 => {
                const positionX = try std.fmt.parseFloat(f32, splitData.first());
                const positionY = try std.fmt.parseFloat(f32, splitData.next().?);
                const curve = try std.fmt.parseFloat(f32, splitData.next().?);
                const width1Index = try std.fmt.parseInt(usize, splitData.next().?, 10);
                const width2Index = try std.fmt.parseInt(usize, splitData.next().?, 10);
                const colourIndex = try std.fmt.parseInt(usize, splitData.next().?, 10);
                const point1 = trackTypes.SegmentPoint{
                    .position = previousPosition,
                    .widths = trackWidths[width1Index],
                };
                previousPosition.x += positionX;
                previousPosition.y += positionY;
                previousPosition.z += segmentLength;
                const point2 = trackTypes.SegmentPoint{
                    .position = previousPosition,
                    .widths = trackWidths[width2Index],
                };

                trackSegments[nextIndex] = trackTypes.Segment{
                    .point1 = point1,
                    .point2 = point2,
                    .curve = curve,
                    .colours = trackColours[colourIndex],
                };
            },
            else => return ReadTrackError.InvalidSectionType,
        }

        nextIndex += 1;
    }

    const track = trackTypes.Track{
        .segments = trackSegments,
        .numSegments = nextIndex,
        .segmentLength = segmentLength,
        .length = previousPosition.z,
        .looped = isLooped,
    };

    return track;
}
