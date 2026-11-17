"""Verify exact retained V2 bytes and local animation references; no external dependencies."""
from pathlib import Path
import hashlib
import json


def verify():
    root = Path(__file__).resolve().parents[2] / "assets/pixel/travel/batch_02"
    provenance = json.loads((root / "provenance.json").read_text(encoding="utf-8"))
    assert provenance["zip_sha256"] == "59069da6d72dd088def9774395ccafdce776f3e51975239cd6d28e4394a36e14"
    for record in provenance["retained_files"]:
        file = root / record["path"]
        assert hashlib.sha256(file.read_bytes()).hexdigest() == record["sha256"], file
        assert "grip" not in file.name
    config = json.loads((root / "staging.json").read_text(encoding="utf-8"))
    assert len(config["scenes"]) == 7
    count = 0
    revised = 0
    for scene in config["scenes"]:
        for action in scene["states"]:
            count += 1
            revised += bool(action.get("v2_fixed"))
            folder = root / scene["id"] / "animation" / action["key"]
            timeline = json.loads((folder / "timeline.json").read_text(encoding="utf-8"))
            # Preview videos are review-only, deliberately not shipped.
            for key in ["base", "state_layer", "final", "poses"]:
                if timeline.get(key):
                    target = (folder / timeline[key]).resolve()
                    assert target.is_relative_to(root.resolve()) and target.is_file(), target
            if (folder / "poses.json").is_file():
                for pose in json.loads((folder / "poses.json").read_text(encoding="utf-8"))["poses"]:
                    assert (folder / pose["path"]).is_file()
                    x, y, width, height = pose["rect"]
                    assert 0 <= x < x + width <= 1280 and 0 <= y < y + height <= 720
    assert count == 31 and revised == 11
    assert not list(root.rglob("*.zip")) and not list(root.rglob("*.mp4"))
    print(f"BATCH02_ASSETS_PASS: 7 scenes / 31 outcomes / 11 V2 corrections / {len(provenance['retained_files'])} exact asset hashes")


if __name__ == "__main__":
    verify()
