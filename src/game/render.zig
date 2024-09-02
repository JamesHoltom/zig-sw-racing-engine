const std = @import("std");
const raylib = @import("../modules/raylib.zig");
const vecTypes = @import("../types/vector.zig");
const window = @import("../window.zig");

pub const Renderer = struct {
    tex: raylib.RenderTexture2D,
    size: vecTypes.IVec2,

    pub fn Unload(self: @This()) void {
        raylib.UnloadRenderTexture(self.tex);
    }

    pub fn Render(self: @This()) void {
        const windowSize = window.GetSize().toFloat();
        const texSize = self.size.toFloat();
        const screenScale: f32 = @min(windowSize.x / texSize.x, windowSize.y / texSize.y);
        const destSize = texSize.mul(.{ .val = screenScale });
        const destPos = windowSize.sub(.{ .xy = destSize }).div(.{ .val = 2.0 });

        raylib.DrawTexturePro(
            self.tex.texture,
            .{
                .x = 0.0,
                .y = 0.0,
                .width = texSize.x,
                .height = texSize.y,
            },
            .{
                .x = destPos.x,
                .y = destPos.y,
                .width = destSize.x,
                .height = destSize.y,
            },
            .{
                .x = 0.0,
                .y = 0.0,
            },
            0.0,
            raylib.WHITE,
        );
    }
};

pub fn Load(size: vecTypes.IVec2) Renderer {
    const renderer = Renderer{
        .tex = raylib.LoadRenderTexture(size.x, size.y),
        .size = size,
    };

    raylib.SetTextureFilter(renderer.tex.texture, raylib.TEXTURE_FILTER_POINT);

    return renderer;
}
