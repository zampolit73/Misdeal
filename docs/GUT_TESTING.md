# Misdeal — GUT unit testing pilot (2026-10-23)

## Installed

Third-party open-source **GUT (Godot Unit Test) 9.7.1**, MIT license, from upstream `bitwes/Gut` tag `v9.7.1` at commit `aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605`, is committed intact under `addons/gut/` (including its upstream license). **Godot 4.7.x** compatible; no extra subscriptions, C# or local CLI tools. The addon editor plugin is enabled in `project.godot`. Regular F5 still opens the original Misdeal game; no user-facing gameplay changes.

## Run inside Godot

After `git pull`, open project and find the **GUT** tab at the bottom dock. Tests live in `tests/unit/`: `test_battle_unit.gd` (8 cases) and `test_party_scaling.gd` (5 cases). Run the whole suite in GUT. On first plugin initialization the editor may request an editor restart, depending on cached scripts.

## Command line / GitHub Actions

From project root, with Godot 4.7.2 available:

```powershell
godot --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests/unit -gconfig= -gexit -glog=1
```

GitHub's **existing** `.github/workflows/godot-pr-smoke.yml` automatically runs the exact same GUT command for all non-doc PRs, parses the GUT result summary and requires **at least 13 real passing cases** (a missing/empty test suite is a failure). Captures GUT logs alongside native Godot smokes and visual proofs. Smart CI treats GUT plugin/test changes as FAST native-check changes, not extra screenshot-heavy work.

These are actual executable tests against the shipping BattleUnit and RunState implementations. Coverage: shipped Knight stats, valid/invalid tactics, incoming damage modifier, healing, death, combat start, solo/duo/trio party and enemy scaling, and preventing duplicate companions. They intentionally do **not** claim complete automated playthrough or visual correctness; existing full native Battle smoke and scene visual CI remain in force.

Never update `addons/gut` from the Asset Library indiscriminately. The Asset Library can advertise a different version aimed at another Godot minor release. Update GUT only as a deliberately pinned dependency upgrade, and rerun Godot native regression. Original repository / MIT license: https://github.com/bitwes/Gut.

## Proven first native result

[PR #8 initial GUT run](https://github.com/zampolit73/Misdeal/actions/runs/39951474299) ran actual Godot 4.7.2: **13/13 tests, 51 assertions**, all passed; existing native smokes/screenshots also passed. A follow-up patch makes the test arena own transient VFX children and CI asserts test discovery via GUT summary. Observe the final PR check on latest commit before merge. 
