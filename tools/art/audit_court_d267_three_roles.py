#!/usr/bin/env python3
"""Court of the Mute: strict all-three atlas intake and honest art readiness.

No placeholders, copied frames, or synthetic "25" repair is permitted.
A missing atlas is BLOCKED, not a passing character. All three must pass
individually before native Godot F6 can judge motion and the visual design.
"""
from pathlib import Path
from io import BytesIO
import base64, hashlib, json
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "assets/pixel/units/court_of_the_mute_qa"
REPORT = ROOT / "docs/qa/D267_THREE_ROLE_FULL25_AUDIT.json"
ROLES = ("mute_magistrate", "ash_scrivener", "bone_bailiff")
ROWS = (4, 6, 6, 3, 6)
CELL = 96
FLOOR = 125
MARGIN = 2

def audit(role: str) -> dict:
    path = SRC / f"{role}_d267_rich_qa.webp.b64"
    row = {
        "role": role,
        "path": str(path.relative_to(ROOT)),
        "status": "BLOCKED_MISSING_SOURCE",
        "authored_frames_found": 0,
        "required_frames": 25,
        "empty_spare_cells": 5,
        "visual_approval": "NOT_RUN",
        "native_motion_F6": "NOT_RUN",
    }
    if not path.is_file():
        return row
    try:
        packed = path.read_text("ascii").strip()
        raw = base64.b64decode(packed, validate=True)
        image = Image.open(BytesIO(raw)).convert("RGBA")
        row["sha256"] = hashlib.sha256(raw).hexdigest()
        row["dimensions"] = list(image.size)
        if image.size != (576, 480):
            raise ValueError("Expected 576x480 / 6x5 of 96px")
        signatures = set()
        used = 0
        for r, frames in enumerate(ROWS):
            for col in range(6):
                tile = image.crop((col*CELL,r*CELL,(col+1)*CELL,(r+1)*CELL))
                alpha = tile.getchannel("A")
                if col >= frames:
                    if alpha.getbbox() is not None:
                        raise ValueError(f"Unused cell must be transparent: {r}:{col}")
                    continue
                visible = sum(value >= 32 for value in alpha.getdata())
                if visible < FLOOR:
                    raise ValueError(f"Empty tiny or missing original cel: {r}:{col}")
                for edge in (
                    alpha.crop((0,0,CELL,MARGIN)),
                    alpha.crop((0,CELL-MARGIN,CELL,CELL)),
                    alpha.crop((0,0,MARGIN,CELL)),
                    alpha.crop((CELL-MARGIN,0,CELL,CELL))
                ):
                    if max(edge.getdata()) >= 32:
                        raise ValueError(f"Out-of-cell or cropped 2px border: {r}:{col}")
                digest = hashlib.sha256(tile.tobytes()).hexdigest()
                if digest in signatures:
                    raise ValueError(f"Repeated cel is not authored movement: {r}:{col}")
                signatures.add(digest)
                used += 1
        if used != 25:
            raise ValueError(f"Expected 25 original poses, found {used}")
        row["status"] = "STRUCTURAL_PASS_PENDING_GODOT_VISUAL"
        row["authored_frames_found"] = used
    except Exception as exc:
        row["status"] = "BLOCKED_INVALID_SOURCE"
        row["error"] = str(exc)
    return row

def main():
    rows = [audit(role) for role in ROLES]
    complete = all(row["status"] == "STRUCTURAL_PASS_PENDING_GODOT_VISUAL" for row in rows)
    qc = {
        "version": "D267",
        "stage": "ALL_THREE_STRUCTURAL_READY_NATIVE_F6_NOT_APPROVED" if complete
                 else "ORIGINAL_CHARACTER_ART_HOLD",
        "animation_contract": "idle4/walk6/attack6/hit3/death6, 6x5 at 96px",
        "roles": rows,
        "original_frames_required_total": 75,
        "original_frames_structurally_accepted": sum(row["authored_frames_found"] for row in rows),
        "production_registered": False,
        "card39_released": False,
        "live_act1_card_count": 38,
        "important": "Structure/hash checks do NOT establish original motion, grip, boots or art quality. Never auto-activate a role on structural PASS.",
    }
    REPORT.parent.mkdir(parents=True, exist_ok=True)
    REPORT.write_text(json.dumps(qc, ensure_ascii=False, indent=2)+"\n",encoding="utf-8")
    print("D267_COURT_ATLAS_AUDIT",json.dumps({"stage":qc["stage"],"counts":{r["role"]:r["authored_frames_found"] for r in rows}},ensure_ascii=False))
    # A successful audit procedure with missing data is NOT an art PASS.
    # CI must not fail every other game change while waiting for real original art.

if __name__ == "__main__":
    main()
