#!/usr/bin/env python3
"""D205 art-staging tool: remap five 5x5 concept sheets into 6x5 candidates.

Produces 96px RGBA frames in the engine's idle/walk/attack/hit/death order
(4,6,6,3,6). The rearrangement does NOT prove a natural animation or repair
source art cropped across old cell boundaries. NEVER activates production roles.
Requires Pillow for offline art production only.
"""
import argparse
import base64
import hashlib
import io
import json
from pathlib import Path
from PIL import Image

ROLES = {
    "extinguished_guide": "пиксельный_спрайт_лист_скелета_фонарщика.png",
    "lantern_bearer": "пиксельный_атлас_мрачного_фонарщика_нежити.png",
    "road_sentinel": "пиксельный_атлас_скелета_стража.png",
    "oil_acolyte": "спрайт_лист_скелета_аколита_с_фонарём.png",
    "lantern_archer": "пиксельный_атлас_скелета_лучника.png",
}
ANIMATIONS = ("idle", "walk", "attack", "hit", "death")
CELL = 96
# Every one of the 25 source poses appears once. Adjacent poses from another
# state are used as transitions to meet the live library's 4/6/6/3/6 contract.
FRAME_MAP = (
    tuple((0, x) for x in range(4)),
    ((0, 4),) + tuple((1, x) for x in range(5)),
    ((3, 4),) + tuple((2, x) for x in range(5)),
    tuple((3, x) for x in range(3)),
    ((3, 3),) + tuple((4, x) for x in range(5)),
)
assert sorted(k for group in FRAME_MAP for k in group) == [
    (y, x) for y in range(5) for x in range(5)
]


def stage_image(source):
    if source.width != source.height or source.width < 500:
        raise ValueError(f"Expected large square 5x5 RGBA source, got {source.size}")
    if source.mode != "RGBA":
        raise ValueError("Expected transparent RGBA source")
    old = {}
    edge_warnings = []
    for row in range(5):
        for col in range(5):
            box = (
                round(col * source.width / 5),
                round(row * source.height / 5),
                round((col + 1) * source.width / 5),
                round((row + 1) * source.height / 5),
            )
            tile = source.crop(box)
            alpha = tile.getchannel("A").point(lambda a: a if a >= 42 else 0)
            tile.putalpha(alpha)
            bounds = alpha.getbbox()
            if bounds is None:
                raise ValueError(f"Source frame ({row},{col}) is empty")
            if (
                bounds[0] < 2 or bounds[1] < 2
                or bounds[2] > tile.width - 2 or bounds[3] > tile.height - 2
            ):
                edge_warnings.append([row, col])
            old[row, col] = tile.crop(bounds)
    atlas = Image.new("RGBA", (576, 480))
    hashes = set()
    for row, sources in enumerate(FRAME_MAP):
        for col, key in enumerate(sources):
            tile = old[key]
            factor = min(85 / tile.width, 85 / tile.height)
            size = (max(1, round(tile.width * factor)), max(1, round(tile.height * factor)))
            tile = tile.resize(size, Image.Resampling.NEAREST)
            atlas.alpha_composite(
                tile, (col * CELL + (CELL - size[0]) // 2, row * CELL + 93 - size[1])
            )
            cell = atlas.crop((col * CELL, row * CELL, (col + 1) * CELL, (row + 1) * CELL))
            hashes.add(hashlib.sha256(cell.tobytes()).hexdigest())
    if len(hashes) != 25:
        raise ValueError("Non-unique exported animation frames")
    for row, frames in enumerate(FRAME_MAP):
        for col in range(len(frames), 6):
            blank = atlas.crop((col * CELL, row * CELL, (col + 1) * CELL, (row + 1) * CELL))
            if blank.getchannel("A").getbbox():
                raise ValueError("Unexpected nontransparent unused frame")
    return atlas, edge_warnings


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-dir", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    report = {"status": "ART_QA_ONLY", "roles": {}}
    for role, filename in ROLES.items():
        with Image.open(args.source_dir / filename) as opened:
            atlas, warnings = stage_image(opened.convert("RGBA"))
        atlas.save(args.output_dir / f"{role}_candidate_6x5.png")
        stream = io.BytesIO()
        atlas.save(stream, format="WEBP", lossless=True, method=6)
        packed = base64.b64encode(stream.getvalue()).decode("ascii")
        (args.output_dir / f"{role}_candidate_frames.webp.b64").write_text(
            packed + "\n", encoding="ascii"
        )
        report["roles"][role] = {
            "source": filename, "poses": 25, "source_edge_warnings": warnings,
            "candidate_webp_size": len(stream.getvalue()),
        }
        print(role, "25 source poses; suspect borders:", len(warnings))
    (args.output_dir / "D205_art_qc.json").write_text(
        json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    print("QA-only conversion complete. Visual approval and native Godot test still required.")


if __name__ == "__main__":
    main()
