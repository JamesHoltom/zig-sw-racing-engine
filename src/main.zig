const std = @import("std");
const arg = @import("args.zig");
const game = @import("game/game.zig");
const editor = @import("editor/editor.zig");

/// Main entrypoint.
pub fn main() !void {
    const args = try arg.GetCLArguments();

    if (args.openEditor) {
        try editor.Run();
    } else {
        try game.Run();
    }
}
