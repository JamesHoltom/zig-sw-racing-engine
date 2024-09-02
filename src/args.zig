const std = @import("std");

pub const CLArguments = struct {
    openEditor: bool,
};

pub fn GetCLArguments() !CLArguments {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    var clArgs: CLArguments = CLArguments{
        .openEditor = false,
    };

    for (args[1..], 0..) |arg, i| {
        std.log.info("{d}: {s}", .{ i, arg });

        if (std.mem.eql(u8, arg, "openEditor")) {
            clArgs.openEditor = true;
        }
    }

    return clArgs;
}
