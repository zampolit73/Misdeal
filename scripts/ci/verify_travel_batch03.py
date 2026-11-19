"""Check the original and scale-revised Batch 03 runtime assets."""
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
revised = provenance.get("scale_review_sha256", {})
payload = provenance["sha256"] | revised
assert set(payload) == expected
for asset, digest in payload.items():
    assert sha256((root / asset).read_bytes()).hexdigest() == digest, asset
assert len(scenes) == 10 and sum(len(scene["states"]) for scene in scenes.values()) == 72
print(f"BATCH03_ASSET_PASS: {len(expected)} files verified, {len(revised)} scale revisions over {provenance['source_commit']}")
