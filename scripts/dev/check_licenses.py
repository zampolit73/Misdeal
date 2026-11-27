#!/usr/bin/env python3
"""Misdeal license preflight: local, stdlib only; does not run Godot or contact the network."""
import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import re
import subprocess
import sys

ALLOWED = {"MIT", "MIT-0", "BSD-2-Clause", "BSD-3-Clause", "Apache-2.0",
           "ISC", "0BSD", "CC0-1.0", "OFL-1.1", "CC-BY-3.0", "CC-BY-4.0"}
MEDIA = {".png", ".jpg", ".jpeg", ".webp", ".gif", ".svg", ".avif", ".bmp",
         ".tga", ".psd", ".aseprite", ".ase", ".kra", ".wav", ".ogg", ".mp3",
         ".flac", ".aac", ".opus", ".mp4", ".webm", ".ogv", ".ttf", ".otf",
         ".woff", ".woff2", ".fnt", ".glb", ".gltf", ".fbx", ".obj", ".blend",
         ".b64", ".gdshader", ".gdshaderinc", ".dll", ".so", ".dylib"}
SHA256 = re.compile(r"^[a-f0-9]{64}$")
COMMIT = re.compile(r"^[a-f0-9]{40}$")


def git(root, *args):
    return subprocess.check_output(["git", "-C", str(root), *args])


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def safe_path(root, raw):
    if not isinstance(raw, str) or not raw or "\\" in raw:
        raise ValueError(f"Invalid repository path: {raw!r}")
    p = PurePosixPath(raw)
    if p.is_absolute() or ".." in p.parts or str(p) != raw or raw == ".":
        raise ValueError(f"Invalid repository path: {raw!r}")
    result = root.joinpath(*p.parts)
    if not result.resolve().is_relative_to(root.resolve()):
        raise ValueError(f"Path escapes repository: {raw}")
    return result


def relevant(path):
    p = PurePosixPath(path)
    if p.suffix.lower() in {".import", ".uid"}:
        return False
    if p.parts[0] == "assets":
        return p.suffix.lower() != ".md"
    if p.parts[0] in {"addons", "shaders"}:
        return True
    return p.suffix.lower() in MEDIA


def changed_paths(root, baseline):
    if not COMMIT.fullmatch(baseline):
        raise ValueError("Baseline must be a full Git commit SHA")
    subprocess.run(["git", "-C", str(root), "merge-base", "--is-ancestor",
                    baseline, "HEAD"], check=True, capture_output=True)
    raw = git(root, "diff", "--name-only", "-z", "--diff-filter=ACMRT",
              "--no-renames", baseline, "--")
    raw += git(root, "ls-files", "--others", "--exclude-standard", "-z")
    return sorted({p for p in raw.decode("utf-8", errors="strict").split("\0")
                   if p and relevant(p) and (root / p).is_file()})


def validate(root, release=False, inventory=False):
    errors, warnings = [], []
    manifest = json.loads((root / "THIRD_PARTY_ASSETS.json").read_text(encoding="utf-8"))
    if manifest["schema_version"] != 1:
        raise ValueError("Unsupported registry schema")
    notices = (root / "THIRD_PARTY_NOTICES.md").read_text(encoding="utf-8")
    if not notices.strip():
        errors.append("THIRD_PARTY_NOTICES.md is empty")

    def evidence(path):
        return bool(path and safe_path(root, path).is_file())

    ids = set()
    registered = {}
    for entry in manifest["legacy_items"]:
        item_id = entry["id"]
        if item_id in ids:
            errors.append(f"Duplicate ID: {item_id}")
        ids.add(item_id)
        if not entry["paths"] or not all(safe_path(root, p).exists() for p in entry["paths"]):
            errors.append(f"{item_id}: legacy paths missing; update the registry after removal")
        if not evidence(entry.get("evidence")):
            errors.append(f"{item_id}: missing provenance document")
        status = entry["status"]
        if status not in {"documented", "verified", "excluded"}:
            errors.append(f"{item_id}: invalid legacy status")
        if status == "verified":
            if not entry.get("licenses") or any(x not in ALLOWED for x in entry["licenses"]):
                errors.append(f"{item_id}: license not allowed for distribution")
            if not entry.get("license_files") or not all(evidence(p) for p in entry["license_files"]):
                errors.append(f"{item_id}: original license evidence missing")
            if item_id not in notices:
                errors.append(f"{item_id}: no third-party notice")
        elif status == "excluded":
            if not evidence(entry.get("export_evidence")):
                errors.append(f"{item_id}: exclusion not evidenced")
        elif release:
            errors.append(f"{item_id}: documented, not verified or excluded")
        else:
            warnings.append(f"{item_id}: legacy documentation only; release review pending")

    for entry in manifest["new_resources"]:
        item_id = entry["id"]
        if item_id in ids:
            errors.append(f"Duplicate ID: {item_id}")
        ids.add(item_id)
        if entry.get("status") != "verified":
            errors.append(f"{item_id}: not verified")
        if not all(isinstance(entry.get(k), str) and entry[k].strip()
                   for k in ("author", "revision", "obtained_on", "origin")):
            errors.append(f"{item_id}: missing author/revision/date/origin")
        if not evidence(entry.get("evidence")):
            errors.append(f"{item_id}: missing provenance document")
        origin = entry.get("origin")
        licenses = entry.get("licenses", [])
        if origin == "third-party":
            if not licenses or any(x not in ALLOWED for x in licenses):
                errors.append(f"{item_id}: license not in commercial allowlist")
            if not str(entry.get("source_url", "")).startswith("https://"):
                errors.append(f"{item_id}: missing HTTPS original source")
            if not entry.get("license_files") or not all(evidence(p) for p in entry["license_files"]):
                errors.append(f"{item_id}: original license/notice file missing")
            if item_id not in notices:
                errors.append(f"{item_id}: no third-party notice")
        elif origin in {"original", "generated"}:
            if licenses != ["PROJECT-ORIGIN"] or not entry.get("rights_review"):
                errors.append(f"{item_id}: project-origin declaration/rights review missing")
        else:
            errors.append(f"{item_id}: unknown origin")
        files = entry.get("files", {})
        if not isinstance(files, dict) or not files:
            errors.append(f"{item_id}: files must map paths to SHA-256")
            continue
        for path, digest in files.items():
            actual = safe_path(root, path)
            if path in registered:
                errors.append(f"{path}: duplicate resource registration")
            registered[path] = item_id
            if not isinstance(digest, str) or not SHA256.fullmatch(digest):
                errors.append(f"{path}: invalid SHA-256")
            elif not actual.is_file() or sha256(actual) != digest:
                errors.append(f"{path}: missing file or SHA-256 changed; re-review required")

    changes = changed_paths(root, manifest["baseline_commit"])
    for path in changes:
        if path not in registered:
            errors.append(f"Unregistered changed resource: {path}")
            if inventory:
                print(f"  {sha256(root / path)}  {path}")
    audit = manifest["legacy_audit"]
    if audit.get("completed") is not True or not evidence(audit.get("report")):
        message = "Pre-baseline asset and dependency inventory has not been fully reviewed"
        (errors if release else warnings).append(message)
    if release:
        for field in ("godot_license_bundle", "package_review_report"):
            if not evidence(manifest.get("release", {}).get(field)):
                errors.append(f"Release evidence missing: {field}")
    for msg in warnings:
        print("WARN:", msg)
    for msg in errors:
        print("FAIL:", msg, file=sys.stderr)
    print(f"License preflight: {'RELEASE' if release else 'DEV'}; "
          f"{len(changes)} changed resource(s), {len(registered)} registered path(s), "
          f"{len(warnings)} warning(s), {len(errors)} error(s)")
    return 1 if errors else 0


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[2])
    p.add_argument("--release", action="store_true", help="Require release evidence and resolved legacy audit")
    p.add_argument("--inventory", action="store_true", help="Print SHA-256 for unregistered changed resources")
    a = p.parse_args()
    try:
        return validate(a.root.resolve(), a.release, a.inventory)
    except (OSError, ValueError, KeyError, TypeError, subprocess.CalledProcessError) as exc:
        print(f"FAIL: license preflight could not validate: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
