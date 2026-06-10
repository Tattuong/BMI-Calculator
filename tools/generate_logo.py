"""Generate a square full-bleed BMI Calculator logo (1024x1024)."""

from PIL import Image, ImageDraw

SIZE = 1024
TOP_LEFT = (13, 148, 136)      # #0D9488
BOTTOM_RIGHT = (20, 184, 166)    # #14B8A6


def lerp(a: int, b: int, t: float) -> int:
    return int(a + (b - a) * t)


def gradient(size: int) -> Image.Image:
    img = Image.new("RGB", (size, size))
    px = img.load()
    for y in range(size):
        ty = y / (size - 1)
        for x in range(size):
            tx = x / (size - 1)
            t = (tx + ty) / 2
            px[x, y] = (
                lerp(TOP_LEFT[0], BOTTOM_RIGHT[0], t),
                lerp(TOP_LEFT[1], BOTTOM_RIGHT[1], t),
                lerp(TOP_LEFT[2], BOTTOM_RIGHT[2], t),
            )
    return img


def draw_icon(draw: ImageDraw.ImageDraw) -> None:
    white = (255, 255, 255)
    cx, cy = SIZE // 2, SIZE // 2 - 20

    # Measurement ring
    draw.arc(
        [cx - 210, cy - 250, cx + 210, cy + 130],
        start=200,
        end=-20,
        fill=white,
        width=18,
    )

    # Head
    draw.ellipse([cx - 52, cy - 210, cx + 52, cy - 106], fill=white)

    # Body
    draw.rounded_rectangle(
        [cx - 78, cy - 98, cx + 78, cy + 92],
        radius=40,
        fill=white,
    )

    # Scale base
    draw.rounded_rectangle(
        [cx - 170, cy + 108, cx + 170, cy + 248],
        radius=36,
        fill=white,
    )

    # Scale dial
    draw.pieslice(
        [cx - 118, cy + 118, cx + 118, cy + 248],
        start=200,
        end=-20,
        fill=(230, 245, 242),
    )
    draw.arc(
        [cx - 118, cy + 118, cx + 118, cy + 248],
        start=210,
        end=-30,
        fill=white,
        width=10,
    )

    # Dial ticks
    for i, angle in enumerate(range(210, 331, 15)):
        import math

        rad = math.radians(angle)
        inner = 78 if i % 2 == 0 else 88
        outer = 98
        x1 = cx + inner * math.cos(rad)
        y1 = cy + 183 + inner * math.sin(rad)
        x2 = cx + outer * math.cos(rad)
        y2 = cy + 183 + outer * math.sin(rad)
        draw.line([(x1, y1), (x2, y2)], fill=white, width=5)

    # Needle
    draw.line([(cx, cy + 183), (cx, cy + 138)], fill=white, width=8)
    draw.ellipse([cx - 12, cy + 171, cx + 12, cy + 195], fill=white)


def main() -> None:
    img = gradient(SIZE)
    draw = ImageDraw.Draw(img)
    draw_icon(draw)
    out = r"c:\Users\Luan\TuongDev\BMI Calculator\assets\logo.png"
    img.save(out, format="PNG", optimize=True)
    print(f"Saved {out} ({img.size[0]}x{img.size[1]})")


if __name__ == "__main__":
    main()
