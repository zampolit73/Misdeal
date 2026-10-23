## Windows editor Run All — fixed by GUT2 (2026-10-23)

**Status:** [PR #9 merged](https://github.com/zampolit73/Misdeal/pull/9); native GUT **16/16 PASS** in [GitHub run 39954278962](https://github.com/zampolit73/Misdeal/actions/runs/39954278962). For Godot 4.7.2 on Windows, run `git pull`, then **fully close and restart Godot**. Open bottom GUT tab, drag its top border upward, press **Run All**; expect 16 passing tests. If the editor previously lacked configured test directories, project-owned `scripts/dev/gut_editor_defaults.gd` now seeds `res://tests/unit/` from the tracked CLI `.gutconfig.json`. It does **not** override any existing custom GUT test-directory choices (including disabled paths). This fixes the likely first-install "nothing happens" behavior; an actual local GUI click must still be confirmed by the user.

If it still does nothing, press the GUT settings/tools icon, check **Test Directories** includes `res://tests/unit/`, and expand GUT Output / Godot Output and Debugger to inspect the actual error before modifying code. No need to `git stash pop` old `project.godot`.

# Misdeal — GUT 9.7.1 unit testing (installed)

Merged in [PR #8](https://github.com/zampolit73/Misdeal/pull/8), commit `7290f35`; official [native PASS run 39952061209](https://github.com/zampolit73/Misdeal/actions/runs/39952061209), **13/13 GUT cases, 51 assertions**.

GUT is vendored under `addons/gut/`, enabled in `project.godot`. Original upstream MIT license in `addons/gut/LICENSE.md`, source: `bitwes/Gut` `v9.7.1` commit `aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605`, targeted at Godot 4.7.x. **No separate download or account.**

After `git pull`, open Misdeal in Godot 4.7.2 and select bottom **GUT** tab. Run All Tests to execute `tests/unit/test_battle_unit.gd` (8 real Knight tests: stats, tactics, damage, healing, death, combat start) and `tests/unit/test_party_scaling.gd` (5 solo/duo/trio pressure and companion rules). If newly installed editor plugin does not appear until the next editor session, restart Godot once.

CLI (optional, from the project root):
```powershell
godot --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests/unit -gconfig= -gexit -glog=1
```

The existing impact-aware `.github/workflows/godot-pr-smoke.yml` now runs **GUT on all non-documentation PRs** and requires at least 13 discovered and passing tests, while continuing other native smoke tests and relevant screenshots. GUT is a developer unit-test tool, **not** a gameplay AI, 60fps visual-motion validator or replacement for running full playthroughs. Keep approved art and game balance separate. CI3–CI5 original opt-in tests remain.
