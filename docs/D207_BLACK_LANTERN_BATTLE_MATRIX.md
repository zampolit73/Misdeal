# D207 — Black Lantern Road: 54-case real BattleUnit balance baseline

Date: 2026-10-17. **NEW SOURCE COMMITTED, NATIVE D207 F6 NOT YET RUN.** Act1 remains **37/45**; #38 is not in ordinary offers.

## D206 native Godot gate CLOSED (user screenshot)

User provided native Godot 4.7.x F6 screenshot of `res://scenes/dev/black_lantern_road_contract_smoke.tscn` on 2026-10-17 showing the **green**:

- `СТАТИЧЕСКИЕ ПРОВЕРКИ ПРОЙДЕНЫ`
- `5 уникальных UnitData • 2 расстановки • 5 врагов`
- `Свет ускоряет только освещённых врагов и снимает эффект`

This is a **USER-SUPPLIED NATIVE PASS of the D206 isolated contract**, including recovery after the array-type hotfix (`9f751e7`). It is NOT the real battle, arena, art QA, 54-case balance or Battle → Reward → Table.

## New in D207 (QA-only)

New `res://scenes/dev/black_lantern_road_battle_matrix.tscn`, backed by `scripts/dev/black_lantern_road_battle_matrix.gd`.

The scene follows the project's prior `black_crossing_battle_smoke.gd` technique: **actual BattleUnit scene instances**, real target acquisition/AI/attacks, existing RunState solo/duo/trio party and enemy compensation, normal default floor projection/clamping, actual five new UnitData and two authored formations, and the already isolated BlackLanternLightController configured with all participants. The scene steps battles deterministically at 30fps and yields every 90 frames to keep the editor responsive.

- Matrix **2 formations × 3 protagonists × 3 party sizes × 3 basic tactics = 54 scenarios**.
- Explicit seeds so trials are reproducible.
- Measures wins/losses/timeouts, mean/worst surviving HP, time, hero casualties, active-light frames, buffed-enemy frames and maximum concurrent buffed enemies.
- Verifies all 54 cases conclude with a definite win/loss, every fighter remains in legal floor bounds, no light attack-interval modifiers leak after cleanup, the light mechanic activates at least once, and the 37-card active RunState pool remains unchanged.
- **Any loss is a gameplay/balance finding, not automatically a technical FAIL**. The smoke is intended to reveal whether solo Knight/Ranger/Mage is survivable, and if five unique opponents are too punishing or too trivial.
- The dedicated simulated arena is invisible. Existing old art is NOT used to represent the five new skeletons to the player, and no sprite/source/arena renderer is switched. The test can validate unit mechanics even while original art is pending.
- It does not simulate global narrative, Wizard debts/marks, side objectives, tactics Sacrifice/Defiance or the complete battle→reward→table flow. It is a baseline on **unupgraded** parties.

## User action / evidence requested

1. `git pull`
2. Godot F6: `res://scenes/dev/black_lantern_road_battle_matrix.tscn`
3. Send the final matrix result (screenshot with class/party size/HP/light metrics or error).

**Do not claim D207 PASSED until that screenshot/result is received**. Even a functional PASS is not a release balance gate: review actual statistics first and locally tune UnitData or light values, then re-run. Do not release before the exact chosen `лунная_дорога_через_туманный_лес.png` arena is committed/tested and five approved **original** 25-frame skeleton atlases (correct Sentinel SPEAR) are in the game, followed by normal Battle → Reward → Table smoke.

Existing #34–#37, D196 waves, DS2/Fate Spread 12+XIII, combat scripts, normal card pool and frozen `backups/KARAMБА73-2026-10-16` (actual branch uses Latin `KARAMBA73`) remain untouched.
