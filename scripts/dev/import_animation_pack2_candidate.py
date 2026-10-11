#!/usr/bin/env python3
"""Validate/encode a 6x5 Misdeal unit animation candidate as export-safe WebP Base64.

This tool NEVER enables art in BattleUnit. Requires Pillow (PIL).
"""
import argparse
import base64
import hashlib
import io
from pathlib import Path
from PIL import Image

CELL = 96
SIZE = (576, 480)
STATES = (("idle", 4), ("walk", 6), ("attack", 6), ("hit", 3), ("death", 6))
ROLES = ("bone_thrall", "grave_bellkeeper", "crypt_guard", "bone_warden")


def inspect(source: Image.Image):
    errors, warnings = [], []
    if source.size != SIZE:
        return [f"Wrong sheet size {source.size}, expected {SIZE}"], []
    if "A" not in source.getbands():
        errors.append("Missing transparency/alpha channel")
    rgba = source.convert("RGBA")
    for row, (name, count) in enumerate(STATES):
        content_fingerprints = set()
        for column in range(count):
            cell = rgba.crop((column*CELL, row*CELL, (column+1)*CELL, (row+1)*CELL))
            alpha = cell.getchannel("A")
            mask = alpha.point(lambda v: 255 if v > 45 else 0)
            bounds = mask.getbbox()
            key = f"{name}[{column}]"
            if bounds is None:
                errors.append(f"{key} is completely transparent")
                continue
            nontransparent = mask.histogram()[255]
            if nontransparent < 70:
                errors.append(f"{key} has too little artwork ({nontransparent} opaque px)")
            if nontransparent > 0.70*CELL*CELL:
                errors.append(f"{key} is mostly opaque: suspected baked-in background")
            sole = bounds[3] - 1
            if not 87 <= sole <= 94:
                warnings.append(f"{key} foot/contact baseline y={sole}, expected 87..94")
            if bounds[0] < 2 or bounds[2] > 94:
                warnings.append(f"{key} touches left/right cell boundary; inspect weapon/frame bleed")
            if cell.getpixel((0,0))[3] > 30 or cell.getpixel((95,95))[3] > 30:
                errors.append(f"{key} has opaque cell corner; likely background or neighbor bleed")
            content_fingerprints.add(hashlib.sha256(cell.tobytes()).hexdigest())
        if name in ("walk", "attack") and len(content_fingerprints) <= 1:
            errors.append(f"{name} has identical frames, not a real pose animation")
    return errors, warnings


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--role", choices=ROLES, required=True)
    p.add_argument("--source", type=Path, required=True, help="RGBA PNG/WebP with 6x5 cells of 96x96")
    p.add_argument("--output-dir", type=Path, required=True)
    p.add_argument("--strict", action="store_true", help="Reject even art-review warnings")
    args = p.parse_args()
    with Image.open(args.source) as img:
        errors, warnings = inspect(img)
        for e in errors: print("ERROR:", e)
        for w in warnings[:24]: print("WARNING:", w)
        if len(warnings)>24: print(f"... {len(warnings)-24} more warnings")
        if errors or (args.strict and warnings):
            raise SystemExit("Candidate rejected; no file was generated")
        out = io.BytesIO()
        img.convert("RGBA").save(out, format="WEBP", lossless=True, method=6)
    raw = out.getvalue()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    target = args.output_dir / f"{args.role}.webp.b64"
    target.write_text(base64.b64encode(raw).decode("ascii") + "\n", encoding="ascii")
    print(f"SAVED {target} ({len(raw)} bytes WebP, {len(warnings)} art-review warnings).")
    print("Review the Godot F6 candidate preview before enabling this role in production.")


if __name__ == "__main__":
    main()