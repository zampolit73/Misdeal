# D269 — Court upper-tribunal atmospheric depth and direct F6 comparison

**Date:** 2026-10-19. **Official Godot 4.7.2 [GitHub Actions PASS](https://github.com/zampolit73/Misdeal/actions/runs/39252464563).** **Stage:** incremental scene-local visual QA, NOT final rich battlefield illustration / no card #39 release.

## What is implemented

- `scripts/battle/battle_visual.gd`: scoped `court_of_the_mute` upper-tribunal pass, a pair of faint cold shafts through the vault, gentle practical-light breathing on existing architecture's four braziers and 13 sparse deterministic motes. No painted characters, borrowed sprites, new gameplay lights, expensive particles, new signals, target/AI changes or edits to the committed D265 plate. The original backdrop remains **the unchanged provisional actor-free D265 QA WebP**, not a newly approved rich painting.
- **Strict safety bound:** every Court-specific `_draw_court_ambience()` primitive stays above **Arena-local Y=336** (screen top offset Y=96). Original user-picked Court playable floor begins **screen Y=532**, thus new effects stop at least 100 screen pixels before the active floor. The full legal screen rectangle remains x40–1268 / y532–710, with no change to `CourtFloor`, placement or combat positions. Lighting does not obscure the units/tactical HUD.
- `res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn`: its QA controller now offers **L** to turn only this Court-specific upper-tribunal ambient pass on/off while the real Battle runs, and **G** for a translucent *debug-only* view of the exact same locked bottom combat floor. G defaults hidden; pressing G again hides; overlay ignores mouse events, does not alter drag/attack physics. F6 startup menu explicitly explains both toggles. This overlay is not added to normal shipped Battle menu.
- `scenes/dev/court_of_the_mute_d269_visual_qa_contract.tscn` checks a **real** F6 Court Battle with seven real actors, correct D265 Court plate and D262 verdict, exact hidden G overlay, and toggling L/G twice back to original state.
- Existing `.github/workflows/d268-court-battle-qa.yml` now executes this D269 native test, in addition to D268 parser/gallery/six-real-Battle setups/54-case BattleUnit matrix and the true *QA-only direct selection* Fight→Reward→Table route.

## Native proof

[Godot 4.7.2 successful Actions run](https://github.com/zampolit73/Misdeal/actions/runs/39252464563) includes:

- `D269_COURT_NATIVE_VISUAL_QA_PASS`: Court plate + 7 genuine actors, L light AB and G exact floor test passed.
- `D262_COURT_REAL_BATTLE_PASS`: six solo/duo/trio × two deployments genuine Battle setups passed.
- `D268_COURT_54_CASE_FUNCTIONAL_PASS`: 54 cases, 54 victories, zero losses/timeouts, same existing mild D268 Court-only balance. Average hero HP solo/duo/trio ~83.84% / 75.54% / 80.16%; two individual fallen across trio matrix.
- `D268_COURT_QA_ROUTE_PASS`: direct QA selection of unreleased #39 → real Battle victory → Reward → Table. This is NOT a normal card deal.

Native automation proves loading, toggles and regression correctness; **not actual high-quality art**. The few generated exploratory full-screen combat compositions that bake characters/controls into the scene are **not acceptable as production battle textures** and were deliberately NOT committed; only existing character-free QA original remains installed. Never crop such baked-actor compositions into game arena without replacing all figures and baked UI.

## Remaining art gates and release

1. Visual inspection of D267 rich character full25 animation in native x1 and x2 with the 27 flagged source-edge poses (Judge 5, Scribe 0, Bailiff 22), particularly Bailiff death3–5. Confirm feet, hands and held objects in genuine movement. Do not distort all three approved character identities merely to clear heuristic flags.
2. Commission/author a **true rich original actor-free** 1280×720 Court tribunal suitable for **live Battle**. Anchors: selected second D261 card image/DS2 dark fantasy, Gothic scale/throne, asymmetric purposeful architecture, convincing stone/contact shadows, upper cold moonlight and edge braziers, **full contiguous player combat stone terrace from screen Y532–710**. No captions, UI or painted animated enemy/hero bodies; preserve the D264 screenshot-approved floor. Keep D265 QA plate for rollback.
3. Integrate only correct final actor-free bitmap behind original runtime SpriteFrames; Godot true-window/native 1280×720 artistic review and full D268/D269 QA, then **separate** card #39 release with ordinary RunState deal test, change 38/45 → 39/45. Until then `resources/cards/court_of_the_mute.tres` has `target_path = ""`; `RunState.ACT1_CARD_IDS` still **38/45**, D260 released #38 unchanged and KARAMBA73 frozen.

**One-minute optional local check:** `git pull` → Godot F6 `res://scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn` → 3 heroes/formation → `L` twice (upper scene lighting A/B), `G` twice (green floor legal bounds), Fight → inspect red verdict. Background still provisional QA artwork.
