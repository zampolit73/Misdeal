# D188–D198 — Black Crossing encounter, waves and live card #37

Updated 2026-10-16 (D198 QA closed). **D191 native 54/54 combat PASS; D196 waves retained; D197 real battle→reward→table user-confirmed; D198 37-card native release smoke user-confirmed PASS. Live Act 1 37/45.**

## User approvals carried forward

- D182/D183 card illustration **option 3** and card preview F6 PASS.
- D184–D186 Ferryman B ragged cloak and Drowned C torn clothing, unique source-derived 25-frame atlases, gallery approved in Godot.
- D187 original **stormy «Последний причал»** 1280×720. User confirmed final cleaned image and most recent F6 preview with «все ок», validating the displayed arena. Preserve the left blank ocean horizon and the absent right-side timber-frame structure.
- **D198 LIVE:** `black_crossing` is in `RunState.ACT1_CARD_IDS` as Tier1 card **#37/45**, appears in ordinary random deals, and retains the same card lookup, original artwork and combat.

## Original encounter implementation

| Role | Path | Stats |
| --- | --- | --- |
| Ferryman (1) | `resources/units/drowned_ferryman.tres` | 124 HP, 8 hit damage, 1.62 s interval, 115 attack range, 51 move |
| Drowned (2) | `resources/units/drowned_hand.tres` | 80 HP, 9.5 hit damage, 1.34 s interval, 43 attack range, 71 move |

`resources/encounters/black_crossing.tres` contains 1+2 original enemies, two authored placements and separate formation hints, arena id `black_crossing`. Party-size multipliers are unchanged. Initial parameters were validated with the D191 54/54 native balance/functional matrix and are unchanged in D198.

`scripts/battle/black_crossing_surge.gd` is an encounter-only `BlackCrossingSurgeController`:
- **D189 floor fix:** legal UnitsLayer-local combat rectangle x110–1170, y240–368 (unit origin, before radius inset); actual sprite feet are roughly screen y389–483 on solid center deck. Heroes can only be dragged into x145–535, y250–362. Smoke uses the exact same `BlackCrossingFloor` file and asserts units never leave the safe plank rectangle. **Wave lanes now y284/330**, 25px half width, x135–1145, entirely inside the safe floor.
- Initial delay **3.2s**, **1.4s warning** and **1.6s wash** are unchanged. D192 full-width aqua body was rejected in the user's real Godot screenshot: it floats above the deck because it was drawn near Unit origin Y rather than boot-contact Y. **D193 visual-only rewrite** proved too weak as white scratches on the deck. **D194 broad raised waves** were bigger and an improvement, but the repeated triangular foamy caps were rejected as artificial in the Godot screenshot. **D195 visual pass:** 3 swells, 72-point undulating faces and rounded overlapping whitewater clusters; user native screenshot says the motion is too stationary. **D196 visual-only fix:** warning approaches from footline -91px to -62px; impact starts at -62px and advances 94px (was 37px) and drives a second shallow whitewater runoff polygon/streak layer along planks, clipped before broken foreground edge. Drawn at foot contact y+36; no rectangular full-screen wave strip and no invisible tiny patches. Detection remains the exact original 50px D189 hit lane; all effects and timers unchanged. The wave still **pushes hit actors 43px left** (clamped to the D189 whole-plank legal bounds) and slows movement by **30% for 1.6s**, followed by **4.5s** rest. **Both factions** can be caught; no raw damage, permanent slow or stun.
- `BattleUnit.wave_move_speed_multiplier` remains **1.0 by default** and only the D188 controller changes it. `stop_surge()` restores 1.0 to all affected units. The controller starts with `_on_fight_pressed()` and stops before victory/defeat/results in `_finish_battle()`.
- Hazard overlay is separate from the approved storm bitmap, under units. No new effect for other arenas or D151–D153.

## Completed and pending QA

1. D182/D183 original card art option 3 and native preview accepted; D184–D186 original Ferryman B/Drowned C sprites accepted; D187 clean storm arena accepted.
2. **D191 native post-D189 functional PASS:** 54/54 wins, 0 full-party defeats, 18/18/18 victories per party size and 18/18/18 per protagonist, mean remaining HP 86/74/77%. 78 wave warnings, 62 impacts, 66 pushes and 66 full slow resets. D198 is deck-only, so another 54-case matrix is not required.
3. D192–D195 had several native visual rejections; D196 became the current forward-moving wave with 94px drawn advance and foam runoff. User said «давай пока оставим этот. продолжай». Do not change D196 unless new feedback warrants it.
4. **D197 native real route approved:** after user ran preflight and real Battle→Reward→Fate Spread/Table test, they answered «Все ок».
5. **D198 LIVE and native release user-reported PASS:** card #37 was enabled in the 37-card pool; previous smoke guards were updated, and `res://scenes/dev/black_crossing_release_smoke.tscn` checks ordinary full-pool Tier1 dealing, original assets, Fate Spread and XIII. After the F6 request the user replied **«все ок»** (2026-10-16): record a **user-confirmed** native release PASS, not an independently captured Godot log. #37 release is closed; card #38 planning is next.

Keep D151–D153, safe planks, 43px push, 30% movement slow/1.6s and accepted art unchanged. Preserve 12 resolutions + XIII.
