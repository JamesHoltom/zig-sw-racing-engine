const std = @import("std");
const raylib = @import("../modules/raylib.zig");
const str = @import("string").String;

var debugText: str = undefined;
var debugMode: u32 = 0;

pub fn Init() void {
    debugText = str.init(std.heap.page_allocator);
}

pub fn Deinit() void {
    debugText.deinit();
}

pub fn Update() void {
    if (raylib.IsKeyPressed(raylib.KEY_H)) {
        if (raylib.IsKeyDown(raylib.KEY_LEFT_SHIFT)) {
            if (debugMode > 0) {
                debugMode -= 1;
            } else {
                debugMode = 6;
            }
        } else {
            if (debugMode < 6) {
                debugMode += 1;
            } else {
                debugMode = 0;
            }
        }
    }
}

pub fn Reset() !void {
    debugText.clear();

    try debugText.concat("Debug:");

    switch (debugMode) {
        1 => try debugText.concat(" Camera"),
        2 => try debugText.concat(" Track"),
        3 => try debugText.concat(" Segment"),
        4 => try debugText.concat(" Segment (Full)"),
        5 => try debugText.concat(" Line"),
        6 => try debugText.concat(" Temp"),
        else => try debugText.concat(" Off"),
    }
}

pub fn Concat(mode: u32, comptime fmt: []const u8, args: anytype) !void {
    if (mode == debugMode) {
        const text = try std.fmt.allocPrint(
            std.heap.page_allocator,
            fmt,
            args,
        );
        try debugText.concat(text);
    }
}

pub fn DrawDebugText() void {
    raylib.DrawTextPro(
        raylib.GetFontDefault(),
        debugText.str().ptr,
        .{
            .x = 5,
            .y = 5,
        },
        .{
            .x = 0,
            .y = 0,
        },
        0.0,
        20.0,
        1.0,
        raylib.WHITE,
    );
}
