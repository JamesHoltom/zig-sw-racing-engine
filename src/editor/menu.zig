const std = @import("std");
const raylib = @import("../modules/raylib.zig");
const raygui = @import("../modules/raygui.zig");

var activeMenu: i32 = -1;
var activeSubMenu: i32 = -1;
var currentPosition: raylib.Vector2 = raylib.Vector2{ .x = 0, .y = 0 };

pub fn BeginGuiMenu(bounds: raylib.Rectangle, title: []const u8) bool {
    if (raygui.GuiButton(bounds, @ptrCast(title)) > 0) {
        if (activeMenu == menuIndex) {
            activeMenu = -1;
        } else {
            activeMenu = menuIndex;
        }
    } else if (activeMenu > -1 and raylib.CheckCollisionPointRec(raylib.GetMousePosition(), menuBounds)) {
        activeMenu = menuIndex;
    } else if (activeMenu == menuIndex and !raylib.CheckCollisionPointRec(raylib.GetMousePosition(), listBounds) and raylib.IsMouseButtonReleased(raylib.MOUSE_BUTTON_LEFT)) {
        activeMenu = -1;
    }

    return retVal;
}

pub fn EndGuiMenu() void {}

pub fn BeginGuiMenuItem(title: []const u8) bool {
    if (raygui.GuiButton(bounds, @ptrCast(title)) > 0) {
        retVal = .{ .DEFAULT = @intCast(index) };
        activeMenu = -1;
    }

    if (option.subItems.len > 0) {
        const listHeight: f32 = buttonSize.y * @as(f32, @floatFromInt(option.RECENT_ITEMS.listItems.len + 1));

        for (option.RECENT_ITEMS.listItems, 0..) |item, itemIndex| {
            const itemBounds = raylib.Rectangle{
                .x = startX,
                .y = currentY + (buttonSize.y * @as(f32, @floatFromInt(itemIndex + 1))),
                .width = buttonSize.x,
                .height = buttonSize.y,
            };

            if (item.len > 0) {
                if (raygui.GuiButton(itemBounds, @ptrCast(item)) > 0) {
                    retVal = .{
                        .RECENT_ITEMS = .{
                            .index = @intCast(index),
                            .itemIndex = @intCast(itemIndex),
                        },
                    };
                    activeMenu = -1;
                }
            } else {
                raygui.GuiSetState(raygui.STATE_DISABLED);

                _ = raygui.GuiButton(itemBounds, "--------");

                raygui.GuiSetState(raygui.STATE_NORMAL);
            }
        }

        currentY += listHeight;
    }
}

pub fn EndGuiMenuItem() void {}

pub fn BeginGuiMenuSubItem(title: []const u8) bool {}

pub fn EndGuiMenuSubItem() void {}
