#!/usr/bin/env python3
from PIL import Image
import glob
import os

os.chdir("/Users/yishouzhuo/whu_files/SCPU/vga-scpu")

for f in sorted(glob.glob("frame_*.ppm")):
    png = f.replace(".ppm", ".png")
    with open(f) as ff:
        lines = ff.readlines()
    pixels = []
    for line in lines[3:]:
        parts = line.strip().split()
        for i in range(0, len(parts), 3):
            if i + 2 < len(parts):
                pixels.append((int(parts[i]), int(parts[i + 1]), int(parts[i + 2])))
    img = Image.new("RGB", (640, 480))
    img.putdata(pixels)
    img.save(png)
    print(f"Created {png}")

print("All conversions done!")
