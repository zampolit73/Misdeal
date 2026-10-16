# D188 — Black Crossing encounter & storm waves (QA candidate)

Updated 2026-10-16 (D192 visuals). **Post-D189/D191 Godot 54/54 functional PASS; D192 improved breaking-wave visuals await F6 approval. Act1 36/45.**

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
- **D189 floor fix:** legal UnitsLayer-local combat rectangle x110–1170, y240–368 (unit origin, before radius inset); actual sprite feet are roughly screen y389–483 on solid center deck. Heroes can only be dragged into x145–535, y250–362. Smoke uses the exact same `BlackCrossingFloor` file and asserts units never leave the safe plank rectangle. **Wave lanes now y284/330**, 25px half width, x135–1145, entirely inside the safe floor.
- Initial delay **3.2s**. **1.4s early warning** now grows into a shaded dark blue swell with uneven foam rather than an orange rectangle or thin ruler-like line. During the 1.6s impact, D192 draws **a deep layered body of advancing water, rising foamy curling lip, patchy whitecaps, turbulent wakes and restrained spray**. This is rendering-only and visually extends beyond the 50px gameplay hit lane; detection is still the exact D189 rectangle. The wave still **pushes hit actors 43px left** (clamped to the D189 whole-plank legal bounds) and slows movement by **30% for 1.6s**, followed by **4.5s** rest. **Both factions** can be caught; no raw damage, permanent slow or stun.
- `BattleUnit.wave_move_speed_multiplier` remains **1.0 by default** and only the D188 controller changes it. `stop_surge()` restores 1.0 to all affected units. The controller starts with `_on_fight_pressed()` and stops before victory/defeat/results in `_finish_battle()`.
- Hazard overlay is separate from the approved storm bitmap, under units. No new effect for other arenas or D151–D153.

## QA gates

1. **Historical pre-D189 native Godot 54/54 PASS** from screenshot: 54 wins/0 full defeats; 18 wins per party size and protagonist, average HP 85/78/84%, worst HP 58/46/63%, duration 10.4/11.3/10.6s, individual hero deaths 0/1/4 and surf warnings/strikes/pushes/resets 81/58/71/71. **This is before the D189 floor adjustment** and must not be presented as D189 validation. After `git pull`, **re-run F6** `res://scenes/dev/black_crossing_battle_smoke.tscn`. D191 additionally mirrors real battle solo/duo/trio spawn and deployment regions, requires 54/54 wins for release, checks that fighters stay on solid planks and that no slow modifier survives. **D191 post-fix native Godot 54/54 PASS is now confirmed from user screenshot** (86/74/77% mean HP; 78/62/66/66 wave events); repeat matrix only if gameplay changes.
2. **F6** `res://scenes/dev/black_crossing_playtest.tscn`: this is the **first priority for visual feedback** after D192. Verify that feet stay on the real planks, that a rising shaded breaker approaches from the ocean, that the whitecaps roll forward rather than resembling glowing lines, and that all fighters remain on the deck after knockback. Continue to `ЗАБРАТЬ НАГРАДУ` → Reward → Table. This test is a controlled offer, not the random-release route.
3. Analyze if 54-case matrix says the fight is trivial/overpowered, especially solo and duo; tune **only new D188 enemy resources or controller parameters**, then rerun F6.
4. Only after battle-feel approval and native tests, enable card #37 into `ACT1_CARD_IDS`, adjust existing 36-card guard scenes for release and add separate normal-deal smoke. Keep Fate Spread 12 + sealed XIII.

Do not repeat previous approved image or sprite approvals and do not silently release #37.
