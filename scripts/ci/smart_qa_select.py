#!/usr/bin/env python3
"""OPT1: conservative, dependency-free selector for Misdeal's existing native QA.

Auto: docs-only -> no Godot; gameplay -> targeted FAST; UI/assets -> VISUAL.
Unknown/repository-wide changes fall back to all native smokes (never skip).
Explicit RELEASE always runs the entire core set and all supported screen captures.
This does not alter/disable legacy stage-specific Actions.
"""
import argparse
import os
import subprocess
from pathlib import Path

CORE = ("class-select", "table", "battle", "wizard-objective",
        "wizard-preview", "cards", "card-surfaces")
ALL_TESTS = CORE + ("qa-hub",)
SCREENS = ("class-select", "table", "wizard-prep", "card-gallery", "reward-upgrade", "qa-hub")
DOC_SUFFIXES = (".md", ".txt")

def classify(paths, request="auto"):
    paths = [p.replace("\\", "/") for p in paths if p]
    if request not in ("auto", "fast", "visual", "release"):
        raise ValueError("Unknown QA mode: " + request)
    if request == "release":
        return dict(mode="release", tests=list(ALL_TESTS),
                    scenes=list(SCREENS), reason="manual full release review")
    if request in ("fast", "visual") and not paths:
        return dict(mode=request, tests=list(ALL_TESTS),
                    scenes=list(SCREENS) if request == "visual" else [],
                    reason="manual run without change scope")
    if not paths:
        return dict(mode="fast", tests=list(ALL_TESTS), scenes=[],
                    reason="no diff supplied; fail-safe full native checks")
    if all(p.startswith("docs/") or p in ("README.md", "CHANGELOG.md", "AGENTS.md")
           or (p.endswith(DOC_SUFFIXES) and not p.startswith("scripts/"))
           for p in paths):
        return dict(mode="docs", tests=[], scenes=[],
                    reason="documentation-only diff; no Godot assets touched")

    tests = set()
    scenes = set()
    want_visual = False
    unknown = []
    for p in paths:
        if p.startswith("docs/") or p in ("README.md", "CHANGELOG.md", "AGENTS.md"):
            continue
        if p.startswith(("tests/unit/", "addons/gut/")) or p == ".gutconfig.json":
            tests.update(ALL_TESTS)  # GUT/update test infrastructure requires whole native suite
        elif p in ("scripts/dev/qa_hub.gd", "scripts/dev/qa_hub_smoke.gd",
                 "scenes/dev/qa_hub.tscn"):
            tests.add("qa-hub")
            scenes.add("qa-hub")
            want_visual = True
        elif p.startswith("scenes/class_select/") or p == "scripts/class_select.gd":
            tests.add("class-select")
            scenes.add("class-select")
            want_visual = True
        elif p.startswith(("scripts/table/", "scenes/table/")):
            tests.update(("table", "cards", "card-surfaces"))
            scenes.update(("table", "card-gallery"))
            want_visual = True
        elif p.startswith(("scripts/battle/", "scenes/battle/", "resources/encounters/",
                           "resources/units/", "scripts/core/")):
            tests.update(CORE)  # potentially shared game rules
            scenes.update(("table", "wizard-prep"))
        elif p.startswith(("assets/", "shaders/")):
            want_visual = True
            tests.update(("cards", "card-surfaces"))
            scenes.update(("table", "card-gallery"))
            if any(q in p for q in ("battle/", "units/", "arenas/")):
                tests.update(("battle", "wizard-objective", "wizard-preview"))
                scenes.add("wizard-prep")
        elif p.startswith(("scripts/ui/", "scenes/reward/", "scripts/reward/")):
            want_visual = True
            tests.update(("table", "cards", "card-surfaces"))
            scenes.update(("table", "card-gallery", "reward-upgrade"))
        elif p.startswith(("scenes/dev/d308_", "scripts/dev/d308_")):
            want_visual = True
            tests.update(("wizard-preview", "wizard-objective"))
            scenes.add("wizard-prep")
        elif p.startswith(("scenes/dev/d315_", "scripts/dev/d315_")):
            want_visual = True
            tests.update(("cards", "card-surfaces"))
            scenes.update(("card-gallery", "reward-upgrade"))
        elif p.startswith(("resources/cards/", "scripts/data/", "scripts/event/",
                           "scenes/event/")):
            tests.update(("table", "cards", "card-surfaces"))
            scenes.add("table")
            want_visual = p.startswith("scenes/event/")
        elif p.startswith(("scripts/dev/ci3_", ".github/workflows/godot-render-previews.yml")):
            want_visual = True
            tests.add("qa-hub")
            scenes.update(SCREENS)
        elif p.startswith(("scripts/dev/ci4_", "scripts/dev/ci5_",
                           ".github/workflows/godot-battle-frames.yml",
                           ".github/workflows/godot-ci5-battle-and-animation.yml")):
            tests.update(CORE)
            scenes.add("wizard-prep")
            want_visual = True
        elif p.startswith(("scripts/ci/", ".github/", "project.godot")):
            tests.update(ALL_TESTS)
            scenes.update(SCREENS)
            want_visual = True
        else:
            unknown.append(p)

    if unknown:
        tests.update(ALL_TESTS)
        scenes.update(SCREENS)
        want_visual = True
    if not tests:
        tests.update(ALL_TESTS)
    mode = request if request != "auto" else ("visual" if want_visual else "fast")
    if mode == "visual" and not scenes:
        scenes.update(SCREENS)
    if mode == "fast":
        scenes.clear()
    return dict(mode=mode,
                tests=[t for t in ALL_TESTS if t in tests],
                scenes=[s for s in SCREENS if s in scenes] if mode == "visual" else [],
                reason="unclassified paths: " + ", ".join(unknown[:5]) if unknown
                       else "recognized change scope")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--mode", choices=("auto", "fast", "visual", "release"),
                        default="auto")
    parser.add_argument("--base", default="")
    parser.add_argument("--head", default="HEAD")
    parser.add_argument("--output", default="")
    parser.add_argument("--files", nargs="*", default=None)
    args = parser.parse_args()
    if args.files is not None:
        paths = args.files
    elif args.base:
        paths = subprocess.check_output(
            ["git", "diff", "--name-only", args.base + "..." + args.head],
            text=True).splitlines()
    else:
        paths = []
    result = classify(paths, args.mode)
    print("Misdeal QA: " + str(result))
    if args.output:
        with Path(args.output).open("a", encoding="utf-8") as fd:
            for key in ("mode", "tests", "scenes", "reason"):
                value = result[key]
                if isinstance(value, list):
                    value = " ".join(value)
                fd.write(f"{key}={value}\n")

if __name__ == "__main__":
    main()
