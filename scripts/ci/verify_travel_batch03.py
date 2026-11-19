"""Check that the review build ships the exact Batch 03 art payload."""
from hashlib import sha256
import json
from pathlib import Path

root = Path(__file__).resolve().parents[2] / "assets/pixel/travel/batch_03"
provenance = json.loads((root / "provenance.json").read_text(encoding="utf-8"))
scenes = json.loads((root / "scenes.json").read_text(encoding="utf-8"))
expected = set()
for scene in scenes.values():
    assets = set(scene["planes"].values()) | set(scene["phases"].values())
    assets.update(state["overlay"] for state in scene["states"].values() if state["overlay"])
    expected.update(f'{scene["folder"]}/{asset}' for asset in assets)
assert set(provenance["sha256"]) == expected
for asset, digest in provenance["sha256"].items():
    assert sha256((root / asset).read_bytes()).hexdigest() == digest, asset
assert len(scenes) == 10 and sum(len(scene["states"]) for scene in scenes.values()) == 72
print(f"BATCH03_ASSET_PASS: {len(expected)} files match {provenance['source_commit']}")
