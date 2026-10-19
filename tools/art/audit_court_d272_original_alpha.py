#!/usr/bin/env python3
"""D272 independent Court alpha output audit; no sprite edits or false artistic claims.

Checks native 576x480 WebP bytes from already-approved D267 atlases; every
authored cel must have safe transparent edges, distinct pixels and actual art.
Warnings in D267 source are provenance, not automatic output corruption.
"""
import base64
import hashlib
import io
import json
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
DIRECTORY = ROOT / "assets/pixel/units/court_of_the_mute_qa"
ROLES = ("mute_magistrate", "ash_scrivener", "bone_bailiff")
STATES = (("idle", 4), ("walk", 6), ("attack", 6), ("hit", 3), ("death", 6))
EXPECTED = {
    "mute_magistrate": {"walk": {2, 3}, "attack": {0, 1, 3}},
    "ash_scrivener": {},
    "bone_bailiff": {
        "idle": {0, 1, 2, 3},
        "walk": set(range(6)), "attack": set(range(6)),
        "hit": {0, 1, 2}, "death": {3, 4, 5},
    },
}
OUTPUT = ROOT / "docs/qa/D272_COURT_NATIVE_ALPHA_QA.json"


def inspect():
    results = []
    bad = []
    previous_hashes = set()
    for role in ROLES:
        fp = DIRECTORY / f"{role}_d267_rich_qa.webp.b64"
        blob = base64.b64decode(fp.read_text(encoding="ascii").strip())
        image = Image.open(io.BytesIO(blob)).convert("RGBA")
        if image.size != (576, 480):
            bad.append(f"{role}: wrong atlas dimensions {image.size}")
            continue
        tiles = []
        for row, (state, length) in enumerate(STATES):
            for col in range(6):
                tile = image.crop((col * 96, row * 96, (col + 1) * 96, (row + 1) * 96))
                a = tile.getchannel("A")
                count = sum(1 for px in a.getdata() if px > 32)
                if col >= length:
                    if a.getbbox() is not None:
                        bad.append(f"{role}:{state}:unused cell {col} not fully transparent")
                    continue
                mask = a.point(lambda px: 255 if px > 32 else 0)
                bbox = mask.getbbox()
                if not bbox or count < 100:
                    bad.append(f"{role}:{state}:{col}:blank or tiny pose")
                    continue
                left, top, right, bottom = bbox
                if left < 2 or top < 2 or right > 94 or bottom > 94:
                    bad.append(f"{role}:{state}:{col}:alpha touches outer 2px gutter, bbox={bbox}")
                digest = hashlib.sha256(tile.tobytes()).hexdigest()
                if digest in previous_hashes:
                    bad.append(f"{role}:{state}:{col}:duplicate full RGBA frame")
                previous_hashes.add(digest)
                tiles.append({
                    "state": state, "frame": col, "bbox": list(bbox),
                    "nontransparent_pixels": count,
                    "left_gutter_px": left, "right_gutter_px": 96 - right,
                    "top_gutter_px": top, "bottom_gutter_px": 96 - bottom,
                    "source_edge_flag": col in EXPECTED[role].get(state, set()),
                    "sha256": digest,
                })
        if len(tiles) != 25:
            bad.append(f"{role}:expected 25 authored frames, got {len(tiles)}")
        if role == "bone_bailiff":
            death = [t for t in tiles if t["state"] == "death"]
            if len(death) != 6 or len({t["sha256"] for t in death}) != 6:
                bad.append("bone_bailiff:death sequence did not contain six distinct safe exported frames")
        flagged = [f"{v['state']}:{v['frame']}" for v in tiles if v["source_edge_flag"]]
        results.append({
            "role": role,
            "atlas_sha256": hashlib.sha256(blob).hexdigest(),
            "authored_count": len(tiles),
            "source_edge_review_points": flagged,
            "source_flags_count": len(flagged),
            "min_frame_outer_gutter": min(
                (min(v["left_gutter_px"], v["right_gutter_px"], v["top_gutter_px"], v["bottom_gutter_px"]) for v in tiles),
                default=-1,
            ),
            "frames": tiles,
        })
    if sum(r["source_flags_count"] for r in results) != 27:
        bad.append("source warning pointer count mismatches known D267 27 markers")
    if sum(r["authored_count"] for r in results) != 75:
        bad.append("not all 75 approved output frames validated")
    report = {
        "version": "D272",
        "source_art": "D267 original approved rich RGBA, untouched",
        "output_gutter_audit": "PASS" if not bad else "FAIL",
        "source_edge_flags": 27,
        "source_flags_mean_actual_output_clipped": False,
        "native_x1_human_motion_approval": "PENDING_VISUAL_REVIEW",
        "checked_poses": sum(r["authored_count"] for r in results),
        "role_summary": [
            {k: v for k, v in r.items() if k != "frames"}
            for r in results
        ],
        "failures": bad,
    }
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print("D272_COURT_ALPHA_AUDIT", json.dumps({k: v for k, v in report.items() if k != "role_summary"}))
    for r in results:
        print("D272_ROLE", r["role"], "poses", r["authored_count"],
              "source_flags", r["source_flags_count"], "min_output_gutter", r["min_frame_outer_gutter"])
    if bad:
        raise AssertionError("; ".join(bad))
    print("D272_COURT_75_ALPHA_NATIVE_PASS: all 75 user-approved exported frame gutters clean; D267 27 ORIGINAL SOURCE edge markers remain visual review pointers only")


if __name__ == "__main__":
    inspect()
