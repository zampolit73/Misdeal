"""Fast isolated Git fixtures for the license preflight; no engine or network."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

GATE = Path(__file__).resolve().parents[2] / "scripts/dev/check_licenses.py"


class LicenseGateTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.git("init", "-q")
        self.git("config", "user.email", "fixture@example.invalid")
        self.git("config", "user.name", "License fixture")
        self.write("README.md", "baseline")
        self.git("add", ".")
        self.git("commit", "-qm", "baseline")
        self.manifest = {
            "schema_version": 1,
            "baseline_commit": self.git("rev-parse", "HEAD").stdout.strip(),
            "legacy_items": [],
            "new_resources": [],
            "legacy_audit": {"completed": False, "report": None},
            "release": {"godot_license_bundle": None, "package_review_report": None},
        }
        self.write("THIRD_PARTY_NOTICES.md", "# Notices\n")
        self.save()

    def git(self, *args):
        return subprocess.run(["git", "-C", str(self.root), *args], check=True,
                              capture_output=True, text=True)

    def write(self, path, content):
        p = self.root / path
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(content, encoding="utf-8")

    def save(self):
        self.write("THIRD_PARTY_ASSETS.json", json.dumps(self.manifest))

    def run_gate(self, *args):
        self.save()
        return subprocess.run([sys.executable, str(GATE), "--root", str(self.root), *args],
                              capture_output=True, text=True)

    def register(self, license="MIT"):
        path = "assets/pixel/example.webp.b64"
        self.write(path, "example bytes")
        self.write("licenses/fixture/LICENSE.txt", "example license evidence")
        self.write("docs/fixture.md", "example provenance")
        self.write("THIRD_PARTY_NOTICES.md", "fixture: example author/source")
        self.manifest["new_resources"] = [{
            "id": "fixture", "status": "verified", "origin": "third-party",
            "author": "Example author", "revision": "v1",
            "obtained_on": "2026-11-27", "source_url": "https://example.invalid",
            "licenses": [license], "license_files": ["licenses/fixture/LICENSE.txt"],
            "evidence": "docs/fixture.md",
            "files": {path: hashlib.sha256((self.root / path).read_bytes()).hexdigest()},
        }]
        return path

    def test_dev_pass_release_fails_unfinished_audit(self):
        self.assertEqual(self.run_gate().returncode, 0)
        result = self.run_gate("--release")
        self.assertEqual(result.returncode, 1)
        self.assertIn("inventory has not been fully reviewed", result.stderr)

    def test_unregistered_untracked_and_committed_b64_asset(self):
        self.write("assets/new.webp.b64", "data")
        for stage in ("untracked", "committed"):
            if stage == "committed":
                self.git("add", ".")
                self.git("commit", "-qm", "changed resource")
            result = self.run_gate("--inventory")
            self.assertEqual(result.returncode, 1)
            self.assertIn("Unregistered changed resource: assets/new.webp.b64", result.stderr)

    def test_registered_and_hash_change(self):
        path = self.register()
        self.assertEqual(self.run_gate().returncode, 0)
        self.write(path, "different bytes")
        self.assertIn("SHA-256 changed", self.run_gate().stderr)

    def test_noncommercial_and_unknown_blocked(self):
        for license in ("CC-BY-NC-4.0", "GPL-3.0-only", "UNLICENSED"):
            self.register(license)
            result = self.run_gate()
            self.assertEqual(result.returncode, 1)
            self.assertIn("not in commercial allowlist", result.stderr)

    def test_missing_license_and_notice_block(self):
        self.register()
        (self.root / "licenses/fixture/LICENSE.txt").unlink()
        self.write("THIRD_PARTY_NOTICES.md", "# Notices")
        result = self.run_gate()
        self.assertEqual(result.returncode, 1)
        self.assertIn("original license/notice file missing", result.stderr)
        self.assertIn("no third-party notice", result.stderr)

    def test_strict_release_requires_all_review_evidence(self):
        self.register()
        self.write("docs/legacy-review.md", "completed review fixture")
        self.write("licenses/godot.txt", "engine notices fixture")
        self.write("docs/package-review.md", "export reviewed fixture")
        self.manifest["legacy_audit"] = {"completed": True, "report": "docs/legacy-review.md"}
        self.manifest["release"] = {"godot_license_bundle": "licenses/godot.txt",
                                    "package_review_report": "docs/package-review.md"}
        self.assertEqual(self.run_gate("--release").returncode, 0)

    def test_import_artifacts_are_not_separate_assets(self):
        self.write("assets/scene.png.import", "metadata")
        self.write("assets/scene.gd.uid", "uid")
        self.assertEqual(self.run_gate().returncode, 0)


if __name__ == "__main__":
    unittest.main()
