# D188 — Black Crossing encounter & storm waves (QA candidate)

Updated 2026-10-16. **Source-integrated only. Native Godot QA NOT RUN. Act1 live pool remains 36/45.**

## User approvals carried forward

- D182/D183 card illustration **option 3** and card preview F6 PASS.
- D184–D186 Ferryman B ragged cloak and Drowned C torn clothing, unique source-derived 25-frame atlases, gallery approved in Godot.
- D187 original **stormy «Последний причал»** 1280×720. User confirmed final cleaned image and most recent F6 preview with «все ок», validating the displayed arena. Preserve the left blank ocean horizon and the absent right-side timber-frame structure.
- Original content not yet live: `black_crossing` stays **outside** `RunState.ACT1_CARD_IDS`, but now has a QA-only `CARD_PATHS` lookup to support actual Battle→Reward→Table without registering as a normal deal.

## Original encounter implementation

| Role | Path | Stats |
| --- | --- | --- |
| Ferryman (1) | `resources/units/drowned_ferryman.tres` | 124 HP, 8 hit damage, 1.62 s interval, 115 attack range, 51 move |
| Drowned (2) | `resources/units/drowned_hand.tres` | 80 HP, 9.5 hit damage, 1.34 s interval, 43 attack range, 71 move |

`resources/encounters/black_crossing.tres` contains 1+2 original enemies, two authored placements and separate formation hints, arena id `black_crossing`. Party-size multipliers are unchanged. Initial parameters are **candidates**, not proven balanced.

`scripts/battle/black_crossing_surge.gd` is an encounter-only `BlackCrossingSurgeController`:
- A fixed horizontal band in the fight floor alternates between center Y **337** and **403**; x = 130–1130, full band height 68.
- Initial delay **3.2s**, visible amber warning **1.4s**, then the blue surf **pushes affected living combatants 43 px left** (clamped to normal legal arena bounds) and reduces movement speed **30% for 1.6s**, followed by **4.5s** rest. **Both factions** can be caught; no raw damage, permanent slow, stun or global hazard.
- `BattleUnit.wave_move_speed_multiplier` remains **1.0 by default** and only the D188 controller changes it. `stop_surge()` restores 1.0 to all affected units. The controller starts with `_on_fight_pressed()` and stops before victory/defeat/results in `_finish_battle()`.
- Hazard overlay is separate from the approved storm bitmap, under units. No new effect for other arenas or D151–D153.

## QA gates

1. After `git pull`, **F6** `res://scenes/dev/black_crossing_battle_smoke.tscn`. Actual Godot `BattleUnit` deterministic 54 cases: two formations × three protagonists × solo/duo/trio × assault/hunt/formation. Must complete, ensure win/loss counts, at least one victory per size, no timeouts, wave warnings/surges/pushes, and **zero lingering slowdown**. Prints average/worst surviving HP, hero deaths and wave counts. **No 54/54 claim until user shares the actual screen.**
2. **F6** `res://scenes/dev/black_crossing_playtest.tscn`: a real Knight run with QA-only Black Crossing card chosen from a controlled pair, actual stormy arena, wave telegraph, original enemy sprites, victory → `ЗАБРАТЬ НАГРАДУ` → Reward → Table. Try solo and spacing/tactics if feasible. A screenshot and difficulty impression are valuable. This is not the randomized normal-deal route.
3. Analyze if 54-case matrix says the fight is trivial/overpowered, especially solo and duo; tune **only new D188 enemy resources or controller parameters**, then rerun F6.
4. Only after battle-feel approval and native tests, enable card #37 into `ACT1_CARD_IDS`, adjust existing 36-card guard scenes for release and add separate normal-deal smoke. Keep Fate Spread 12 + sealed XIII.

Do not repeat previous approved image or sprite approvals and do not silently release #37.
