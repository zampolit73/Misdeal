#!/usr/bin/env python3
"""D259: stage D257 complete original Black Lantern atlases in native RIGHT-facing format.

Do not edit the 75 QA poses or mutate any released UnitData / card pool.
Only LEFT-origin Guide/Archer are mirrored *within each 96px tile* to match
BattleUnit's existing right-authored frame convention (D258 user QA).
"""
from pathlib import Path
from io import BytesIO
import base64, hashlib, json
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "assets/pixel/units/black_lantern_road_qa"
DEST = ROOT / "assets/pixel/units/deck_expansion_v1"
REPORT = ROOT / "docs/qa/D259_BLACK_LANTERN_CANONICAL_ATLASES_QC.json"
COUNTS = (4, 6, 6, 3, 6)
ROLES = {
    "extinguished_guide": True,
    "oil_acolyte": False,
    "lantern_archer": True,
}
SIZE = 96


def input_atlas(role: str):
    path = SOURCE / (role + "_d257_seam_recovery_qa.webp.b64")
    blob = base64.b64decode(path.read_text(encoding="ascii").strip(), validate=True)
    im = Image.open(BytesIO(blob)).convert("RGBA")
    assert im.size == (576, 480), (role, im.size)
    return blob, im


def check_image(im: Image.Image, role: str):
    hashes = []
    for row, used in enumerate(COUNTS):
        for col in range(6):
            tile = im.crop((col*SIZE, row*SIZE, (col+1)*SIZE, (row+1)*SIZE))
            alpha = tile.getchannel("A")
            if col >= used:
                assert alpha.getbbox() is None, (role, row, col, "spare not transparent")
                continue
            assert alpha.getbbox(), (role, row, col, "missing cel")
            assert sum(px > 24 for px in alpha.getdata()) >= 150, (role, row, col, "empty figure")
            for edge in (alpha.crop((0, 0, 2, SIZE)),
                         alpha.crop((SIZE-2, 0, SIZE, SIZE)),
                         alpha.crop((0, 0, SIZE, 2)),
                         alpha.crop((0, SIZE-2, SIZE, SIZE))):
                assert edge.getbbox() is None, (role, row, col, "border bleed")
            hashes.append(hashlib.sha256(tile.tobytes()).hexdigest())
    assert len(hashes) == len(set(hashes)) == 25, (role, "frame duplicate")
    return hashes


def stage(role: str, mirror: bool):
    raw, art = input_atlas(role)
    source_hashes = check_image(art, role)
    if mirror:
        out = Image.new("RGBA", art.size, (0, 0, 0, 0))
        for row, used in enumerate(COUNTS):
            for col in range(used):
                bounds=(col*SIZE, row*SIZE, (col+1)*SIZE, (row+1)*SIZE)
                tile=art.crop(bounds).transpose(Image.Transpose.FLIP_LEFT_RIGHT)
                out.paste(tile, (col*SIZE, row*SIZE))
        buffer=BytesIO()
        out.save(buffer, format="WEBP", lossless=True, method=6)
        dest_bytes=buffer.getvalue()
    else:
        out=art
        dest_bytes=raw
    dest=DEST / (role + "_frames.webp.b64")
    dest.write_text(base64.b64encode(dest_bytes).decode("ascii")+"\n", encoding="ascii")
    unpacked=base64.b64decode(dest.read_text().strip(), validate=True)
    assert unpacked == dest_bytes
    result=Image.open(BytesIO(unpacked)).convert("RGBA")
    assert result.getchannel("A").tobytes() == out.getchannel("A").tobytes()
    target_hashes=check_image(result, role)
    if mirror:
        for row, used in enumerate(COUNTS):
            for col in range(used):
                bounds=(col*SIZE, row*SIZE, (col+1)*SIZE, (row+1)*SIZE)
                original=art.crop(bounds).transpose(Image.Transpose.FLIP_LEFT_RIGHT)
                packed=result.crop(bounds)
                assert original.getchannel("A").tobytes() == packed.getchannel("A").tobytes()
    return {
        "role":role,
        "source_origin":"LEFT" if mirror else "RIGHT",
        "canonical_origin":"RIGHT",
        "source_sha256":hashlib.sha256(raw).hexdigest(),
        "canonical_sha256":hashlib.sha256(dest_bytes).hexdigest(),
        "source_distinct":len(set(source_hashes)),
        "canonical_distinct":len(set(target_hashes)),
        "empty_spares":5,
        "path":str(dest.relative_to(ROOT)),
        "status":"STAGED_NOT_RELEASED",
    }


def main():
    DEST.mkdir(parents=True, exist_ok=True)
    rows=[stage(r,flip) for r,flip in ROLES.items()]
    REPORT.parent.mkdir(parents=True,exist_ok=True)
    REPORT.write_text(json.dumps({
        "version":"D259","status":"STRUCTURAL_PASS_ART_REVIEW_USER_NO_BLOCKER",
        "roles":rows,
        "original_source_warnings":11,
        "released_card_count":37,
        "card38_live":False,
        "note":"D258 user reported all OK, complete QA animation not independently captured; no card activation."
    },ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    print("D259_STAGED_ATLASES_PASS", [(r["role"],r["canonical_sha256"][:10]) for r in rows])


if __name__=="__main__":
    main()
