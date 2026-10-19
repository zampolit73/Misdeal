# D259 — Canonical original five-role art staging and real Battle release preparation

2026-10-19 · branch `main` · **STAGED — NOT IN LIVE CARD POOL**

## User feedback and gate interpretation

The user answered **«все ок»** following the D258 real Battle F6 instructions. Record **no reported gameplay/visual blocker**, not an independently recorded video of every hero-count and formation, and do not extrapolate to art source warning resolution or approved challenge tuning. Preserve user-selected original five-skeleton identity, D209 forest and D200 selected run-card art.

## Implemented

1. `tools/art/stage_black_lantern_d259.py` deterministically consumes the **three committed D257 original 25-pose alpha sheets** and stages:
   - `assets/pixel/units/deck_expansion_v1/extinguished_guide_frames.webp.b64`
   - `assets/pixel/units/deck_expansion_v1/oil_acolyte_frames.webp.b64`
   - `assets/pixel/units/deck_expansion_v1/lantern_archer_frames.webp.b64`.
   Source LEFT Guide/Archer tiles are mirrored **per 96px frame** to the canonical RIGHT-facing BattleUnit source convention. RIGHT-origin Oil Acolyte is byte-exact. The generator checks 25 unique original cels, 5 transparent unused cells, visible silhouettes, 2px padding and lossless alpha. Source QA originals remain unchanged; `docs/qa/D259_BLACK_LANTERN_CANONICAL_ATLASES_QC.json` captures SHA-256 and orientation. Original D257 11 lower-edge warnings are retained; no claim of newly painted replacement boots.
2. `MisdealUnitAnimationLibrary` registers all five strictly-authored Black Lantern original roles (existing D244 `road_sentinel` and D224 `lantern_bearer` byte-exact), using canonical `deck_expansion_v1/*_frames.webp.b64` paths and the established strict format/hash/blank-cell checks. **No changed `BattleUnit`, character stats, equipment, Fate rules or global facing logic.**
3. `resources/cards/black_lantern_road.tres` now points to the real `resources/encounters/black_lantern_road.tres`. This fixes the missing normal card→encounter route while keeping `RunState.ACT1_CARD_IDS` at **37** and #38 out of ordinary dealing.
4. NEW genuine library-only F6 `res://scenes/dev/black_lantern_d259_real_battle_route_qa.tscn`: no D258 post-ready sprite injection; selecting solo/duo/trio and either enemy formation opens **unchanged real** `scenes/battle/battle.tscn`, checks all five roles use the same original `SpriteFrames` returned by the shared library, and leaves native Fight→Reward→Table intact.
5. NEW D259 real Battle headless preflight and dedicated Godot 4.7.2 Actions workflow `.github/workflows/d259-black-lantern-native-qa.yml`. It checks real Battle eight-unit trio, Crossroads formation, D253 lanternlight, **five unmodified library-loaded original roles**, and 54-case original BattleUnit matrix regression. Native stage/recovery original QA scenes retained.

## Verified / remaining

- The D259 atlas stage GitHub Actions **PASS**: [asset job](https://github.com/zampolit73/Misdeal/actions/runs/39204724854).
- Godot 4.7.2 **D259 canonical-library preflight and 54/54 regression PASS**: [native run](https://github.com/zampolit73/Misdeal/actions/runs/39205118907). Five sprites loaded **without QA replacement**; 54/54 completed (54 wins, no party defeats/timeouts) on previously accepted 1.16x light bonus. **Balance not automatically accepted**; original D208 54 wins likewise and later visuals still matter.
- Separate end-to-end CI driver `black_lantern_d259_end_to_end_runner.tscn` is designed to push actual Fight, watch win, click actual Continue, claim actual Reward, return to Table. Its outcome must be explicitly recorded from the completed GitHub run; never mark PASS from just compilation or preflight.
- The project still logs an **unrelated existing** `assets/concepts/approved_battle_direction.jpg` import error in full editor import; not introduced by D259, no speculative replacement of user-approved art.

## Required next release gates

1. Confirm headless Fight→Reward→Table end-to-end result and repair any actual failures.
2. Treat user's D258 «все ок» as permission to continue, but if any newly staged native Battle art shows incorrect facing, floor/HP crowding or clipped props, fix original coherent 25-pose pack as a batch.
3. Assess **54/54 wins** against the project's solo accessibility and short-fight goal. No generic enemy-stat inflation or changing the D206 light multiplier without targeted evidence; explicitly record a hold/pass decision.
4. Then consider **a separate final commit** activating `black_lantern_road` in `RunState.ACT1_CARD_IDS` (38/45) and updating QA guards/tests to distinguish unreleased historical D258 from current release. Until that intentional step, live pool remains 37/45.

**Preserved:** DS2/Fate Spread, 12 resolutions+boss XIII, D200 accepted run-card art, D209 forest, D244/D224 sprites, all combat metrics, light behavior, frozen KARAMBA73 backup.
