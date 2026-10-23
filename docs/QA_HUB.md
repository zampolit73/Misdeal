# OPT1 + OPT4 — Smart CI and Godot QA Hub

Shipped [PR #7](https://github.com/zampolit73/Misdeal/pull/7) to main (2026-10-23). **Godot 4.7.2**, GDScript, no Codex/API purchase or new Godot add-on.

## Open the QA Hub in Godot (OPT4)

1. Open `scenes/dev/qa_hub.tscn` from Godot FileSystem.
2. Press **F6** to run this scene only. **F5** still starts Misdeal's original main menu; `project.godot` is unchanged.
3. Select a category: `ВСЁ / ИГРА / КАРТЫ / БОЙ / АНИМАЦИИ / ИНТЕРФЕЙС`.
4. Select a live scene or existing authored test launcher, read the right-hand description, press **ЗАПУСТИТЬ СЦЕНУ**.
5. To return, select `qa_hub.tscn` in the editor and press **F6** again. This is a test-only process, not a user-facing menu. The hub prepares a fresh Knight/encounter only when needed for Table/Graveyard Battle.

The hub points to existing live F6 scenes: main menu, class select, tabletop, D315 DS3 gallery, D149 event preview, original Graveyard Battle, existing Court and Black Lantern Battle launchers, existing Court/Pack2 animation previews, Wizard panel, and UI component preview. **Nothing is imported into ordinary player gameplay or changed in approved card art.**

Native smoke `scripts/dev/qa_hub_smoke.gd` validates categories, every referenced PackedScene, list navigation and launch control. `ci3_capture_rendered_scene.gd` now accepts key `qa-hub` for a genuine 1280×720 screenshot.

## One impact-aware PR gate (OPT1)

The existing `.github/workflows/godot-pr-smoke.yml` is still the single required PR check. `scripts/ci/smart_qa_select.py` selects conservatively by **actual PR changed file paths** and has eight Python unit cases:

- **Documentation-only:** selector tests + Actions summary; skip Godot download/import/render entirely.
- **AUTO / FAST:** Godot editor import, strict PASS markers from relevant native smokes; shared combat, unknown files, and high-risk changes fall back to the full core suite.
- **AUTO / VISUAL:** above plus software-OpenGL screenshots of touched existing scenes (ClassSelect, Table, Wizard, DS3 Card Gallery, QA Hub). Original PNGs/logs are uploaded.
- **RELEASE:** manually choose `release` under GitHub → Actions → **Misdeal Godot PR smoke** → **Run workflow**. Executes all 7 old native smokes + QA Hub, all 5 real screenshot cases, and invokes original CI4 Graveyard Battle / CI5 Court trio + Grave Bell duo / 75 Court animation poses. Release aggregation is configured; **the first combined RELEASE mode has not yet been separately dispatched/observed**, whereas its CI4/CI5 constituent scripts had independently passed prior runs.

Manual `fast` or `visual` selections are also available; `auto` with no scope runs full native checks. Unknown paths are **never** treated as docs-only. Existing specialist stage-specific workflows remain intact. CI3/CI4/CI5 are preserved for `workflow_dispatch` instead of duplicating PR validation on each commit. Errors and original rendered artifacts are retained for 14 days.

### Verified rollout

[PR #7](https://github.com/zampolit73/Misdeal/pull/7) **merged** after official [native Smart QA PASS](https://github.com/zampolit73/Misdeal/actions/runs/39944961444): selector Python tests, Godot import, **8/8** strict native smokes and **5/5** original 1280×720 screenshots, including real QA Hub PNG. Original Hub screenshot downloaded and inspected in chat: complete visible categories, scroll list, details, launch control without clipping. Regular game art, balance, run data and UI screens unchanged.

The old CI3/CI4/CI5 jobs are still individually reproducible on-demand; native screenshot evidence is **not** proof of subjective art/animation quality.
