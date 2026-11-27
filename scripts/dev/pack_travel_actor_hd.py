"""Offline authoring only: repack the original painted cels into 3x Travel cells.
No new poses, procedural anatomy, or combat atlas modifications.
Requires Pillow/numpy/scipy; none is a game/runtime dependency.
"""
import argparse
import base64
import hashlib
import io
from pathlib import Path

import numpy as np
from PIL import Image
from scipy.ndimage import label

ROOT = Path(__file__).resolve().parents[2]
PIXEL = ROOT / "assets/pixel"
OUT = PIXEL / "travel/actors_hd"
DENSITY = 3
CELL = 96
PX = CELL * DENSITY
ROLES = ("knight", "ranger", "mage", "jack")


def encoded(path):
    return Image.open(io.BytesIO(base64.b64decode(path.read_bytes()))).convert("RGBA")


def cell(image, column, row, columns, rows):
    return image.crop((round(column*image.width/columns), round(row*image.height/rows),
                       round((column+1)*image.width/columns), round((row+1)*image.height/rows)))


def clean_source(image, threshold, role, is_walk, keep_largest):
    pixels = np.array(image.convert("RGBA"))
    pixels[pixels[:, :, 3] < threshold] = 0
    # The original D412 Ranger source contains neutral-grey storyboard floor lines.
    if role == "ranger" and is_walk:
        ys = np.indices(pixels.shape[:2])[0]
        rgb = pixels[:, :, :3].astype(np.int16)
        neutral = (rgb.max(axis=2)-rgb.min(axis=2) < 20) & (rgb.max(axis=2) > 76)
        pixels[(ys > image.height*0.79) & neutral] = 0
    if keep_largest:
        components, count = label(pixels[:, :, 3] > 0)
        sizes = np.bincount(components.ravel())
        sizes[0] = 0
        if count:
            pixels[components != sizes.argmax()] = 0
    cleaned = Image.fromarray(pixels)
    return cleaned.crop(cleaned.getbbox())


def packed_cel(source, low, role, kind, is_walk=False):
    cleaned = clean_source(source, 128 if kind in ("living", "rear", "dog") else 166,
                           role, is_walk and kind == "side", kind == "side")
    target = low.getbbox()
    assert target and cleaned.width > 2 and cleaned.height > 2
    if kind == "dog":
        # Ignore old nearly transparent matte: it inflated the running envelope.
        alpha = np.asarray(low)[:, :, 3]
        visible = Image.fromarray((alpha >= 128).astype(np.uint8) * 255).getbbox()
        assert visible
        # Preserve original planted sole and silhouette width; use real source aspect.
        x0, y0, x1, y1 = target
        width = visible[2] - visible[0]
        height = round(width * cleaned.height / cleaned.width)
        x = visible[0]
        target = (x, y1-height, x+width, y1)
    x0, y0, x1, y1 = target
    # Match the existing registered screen geometry, retaining painted high-frequency detail.
    result = Image.new("RGBA", (PX,PX))
    resized = cleaned.resize(((x1-x0)*DENSITY,(y1-y0)*DENSITY), Image.Resampling.LANCZOS)
    result.alpha_composite(resized, (x0*DENSITY,y0*DENSITY))
    return result


def save(name, atlas):
    OUT.mkdir(exist_ok=True, parents=True)
    buf = io.BytesIO()
    # Colour quality 95 (alpha is lossless). The original PNG sources remain unchanged.
    atlas.save(buf, format="WEBP", quality=95, method=6)
    path = OUT / (name+".webp.b64")
    path.write_bytes(base64.b64encode(buf.getvalue()) + b"\n")
    print(path.relative_to(ROOT), atlas.size, len(path.read_bytes()),
          hashlib.sha256(path.read_bytes()).hexdigest())


def main():
    args = argparse.ArgumentParser(description=__doc__)
    args.add_argument("--living-source", type=Path, required=True,
                      help="Original 1230x1278 RGBA living-pose image from the rescue generation receipt.")
    opts = args.parse_args()
    for role in ROLES:
        is_dog = role == "jack"
        path = PIXEL / ("units/jack/source.png" if is_dog else f"units/hero_c3_d412/{role}_source.png")
        src = Image.open(path).convert("RGBA")
        low = encoded(PIXEL / ("units/jack/atlas.webp.b64" if is_dog else f"units/hero_c3_d412_polish/{role}.webp.b64"))
        counts = (4,6,6) if role == "mage" else (4,6)
        atlas = Image.new("RGBA", (6*PX,len(counts)*PX))
        for row, count in enumerate(counts):
            for column in range(count):
                out = packed_cel(cell(src,column,row,6,5),cell(low,column,row,6,5),
                                 role,"dog" if is_dog else "side",row==1)
                atlas.alpha_composite(out,(column*PX,row*PX))
        save("side_"+role,atlas)
    for kind, scene in (("ne","campfire_without_master"),("nw","last_dressing_station")):
        directory = PIXEL / f"travel/{scene}/rear_walk"
        src = Image.open(directory/"source.png").convert("RGBA")
        atlas = Image.new("RGBA", (6*PX,3*PX))
        for row,role in enumerate(ROLES[:3]):
            low = Image.open(directory/(role+".png")).convert("RGBA")
            for column in range(6):
                out = packed_cel(cell(src,column,row,6,3),cell(low,column,0,6,1),role,"rear")
                atlas.alpha_composite(out,(column*PX,row*PX))
        save("rear_"+kind,atlas)
    src = Image.open(opts.living_source).convert("RGBA")
    low = encoded(PIXEL/"travel/cinematic_v5/rescue_batch/living_poses.webp.b64")
    atlas = Image.new("RGBA",(4*PX,4*PX))
    for row, role in enumerate(ROLES):
        for column in range(4):
            out = packed_cel(cell(src,column,row,4,4),cell(low,column,row,4,4),role,"living")
            atlas.alpha_composite(out,(column*PX,row*PX))
    save("living",atlas)


if __name__ == "__main__":
    main()
