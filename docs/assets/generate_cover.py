"""
Generate my-nvim-settings cover image (2560x1280).
Deep blue/purple/cyan gradient, bold monospace title, muted subtitle, rounded corners.
"""

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont

W, H = 2560, 1280
CORNER_RADIUS = 80

# ── 1. Base canvas (dark navy) ───────────────────────────────────────────────
base = Image.new("RGBA", (W, H), (8, 10, 22, 255))

# ── 2. Color blobs ──────────────────────────────────────────────────────────
def make_blob(size, color_rgba, cx, cy, rx, ry):
    layer = Image.new("RGBA", size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    draw.ellipse([cx - rx, cy - ry, cx + rx, cy + ry], fill=color_rgba)
    return layer

blobs = [
    # (r,   g,   b,   a,    cx,    cy,   rx,   ry,  blur)
    ( 20,  30, 120, 220,   600,  500,  800,  600,  140),   # deep blue, left
    ( 60, 180, 220, 180,  2000,  300,  700,  500,  120),   # cyan, top-right
    (120,  40, 180, 190,  1300, 1000,  900,  400,  110),   # purple, bottom-center
    ( 30,  80, 160, 150,  1600,  640,  600,  400,   90),   # mid blue, center-right
    (180,  60, 200, 120,   400,  200,  500,  350,  100),   # magenta, top-left
]

canvas = base.copy()
for r, g, b, a, cx, cy, rx, ry, blur in blobs:
    blob = make_blob((W, H), (r, g, b, a), cx, cy, rx, ry)
    blob = blob.filter(ImageFilter.GaussianBlur(radius=blur))
    canvas = Image.alpha_composite(canvas, blob)

# Extra full-image blend pass for silky smoothness
canvas = canvas.filter(ImageFilter.GaussianBlur(radius=12))

# ── 3. Film grain ────────────────────────────────────────────────────────────
rng = np.random.default_rng(42)
noise = rng.integers(0, 255, (H, W), dtype=np.uint8)
grain_alpha = (noise * 0.15).astype(np.uint8)
grain_layer = np.stack([noise, noise, noise, grain_alpha], axis=-1).astype(np.uint8)
grain_img = Image.fromarray(grain_layer, "RGBA")
canvas = Image.alpha_composite(canvas, grain_img)

# ── 4. Fonts ─────────────────────────────────────────────────────────────────
TITLE_SIZE = 200
SUBTITLE_SIZE = 68
TAGLINE_SIZE = 48

try:
    font_title = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", TITLE_SIZE, index=1)
    font_subtitle = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", SUBTITLE_SIZE, index=1)
    font_tagline = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", TAGLINE_SIZE, index=0)
except Exception:
    font_title = ImageFont.truetype("/System/Library/Fonts/Supplemental/Courier New Bold.ttf", TITLE_SIZE)
    font_subtitle = ImageFont.truetype("/System/Library/Fonts/Supplemental/Courier New Bold.ttf", SUBTITLE_SIZE)
    font_tagline = ImageFont.truetype("/System/Library/Fonts/Supplemental/Courier New Bold.ttf", TAGLINE_SIZE)

TITLE_TEXT = "my-nvim-settings"
SUBTITLE_TEXT = "One prompt for LLM agent setup"
TAGLINE_TEXT = "Clone. Inject prompt. Install and verify."

# ── 5. Measure text ──────────────────────────────────────────────────────────
tmp = Image.new("RGBA", (W, H), (0, 0, 0, 0))
d = ImageDraw.Draw(tmp)

t_bbox = d.textbbox((0, 0), TITLE_TEXT, font=font_title)
t_w, t_h = t_bbox[2] - t_bbox[0], t_bbox[3] - t_bbox[1]

s_bbox = d.textbbox((0, 0), SUBTITLE_TEXT, font=font_subtitle)
s_w, s_h = s_bbox[2] - s_bbox[0], s_bbox[3] - s_bbox[1]

tag_bbox = d.textbbox((0, 0), TAGLINE_TEXT, font=font_tagline)
tag_w, tag_h = tag_bbox[2] - tag_bbox[0], tag_bbox[3] - tag_bbox[1]

GAP1 = 50
GAP2 = 70
total_h = t_h + GAP1 + s_h + GAP2 + tag_h
block_top = (H - total_h) // 2 - 20

title_x = (W - t_w) // 2 - t_bbox[0]
title_y = block_top - t_bbox[1]

subtitle_x = (W - s_w) // 2 - s_bbox[0]
subtitle_y = title_y + t_h + GAP1

tagline_x = (W - tag_w) // 2 - tag_bbox[0]
tagline_y = subtitle_y + s_h + GAP2

# ── 6. Title with glow ──────────────────────────────────────────────────────
def draw_text_layer(text, x, y, font, color):
    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(layer).text((x, y), text, font=font, fill=color)
    return layer

# Glow: cyan/blue glow layers
glow_specs = [
    ((100, 200, 255, 50),  22),
    ((140, 220, 255, 80),  11),
    ((180, 240, 255, 110),  5),
]
for color, blur_r in glow_specs:
    glow = draw_text_layer(TITLE_TEXT, title_x, title_y, font_title, color)
    glow = glow.filter(ImageFilter.GaussianBlur(radius=blur_r))
    canvas = Image.alpha_composite(canvas, glow)

# Sharp white title
title_layer = draw_text_layer(TITLE_TEXT, title_x, title_y, font_title, (255, 255, 255, 250))
canvas = Image.alpha_composite(canvas, title_layer)

# ── 7. Subtitle ──────────────────────────────────────────────────────────────
subtitle_layer = draw_text_layer(
    SUBTITLE_TEXT, subtitle_x, subtitle_y, font_subtitle, (200, 220, 240, 230)
)
canvas = Image.alpha_composite(canvas, subtitle_layer)

# ── 8. Tagline ───────────────────────────────────────────────────────────────
tagline_layer = draw_text_layer(
    TAGLINE_TEXT, tagline_x, tagline_y, font_tagline, (150, 170, 200, 180)
)
canvas = Image.alpha_composite(canvas, tagline_layer)

# ── 9. Rounded corner mask ───────────────────────────────────────────────────
mask = Image.new("L", (W, H), 0)
ImageDraw.Draw(mask).rounded_rectangle([(0, 0), (W - 1, H - 1)], radius=CORNER_RADIUS, fill=255)
canvas.putalpha(mask)

# ── 10. Final polish blur ────────────────────────────────────────────────────
canvas = canvas.filter(ImageFilter.GaussianBlur(radius=1))

# ── 11. Save ─────────────────────────────────────────────────────────────────
out_path = "/Users/woojin/my-nvim-settings/docs/assets/cover.png"
canvas.save(out_path, "PNG", dpi=(400, 400))
print(f"Saved: {out_path}")
print(f"Size: {canvas.size}")
print(f"Mode: {canvas.mode}")
