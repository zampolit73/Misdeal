# D246 — One real Sentinel vs Knight battle for D244 movement QA (not release)

Date: 2026-10-19. User requested to temporarily insert **only Road Sentinel** to see how his walk, facing, attack and death behave during a real fight. D244's final visual signoff is still pending, so do not register the sprite in the shared runtime animation library and do not release Act 1 card #38.

## Deliverable

- Open `res://scenes/dev/black_lantern_sentinel_d246_combat_preview.tscn` and press **F6** in Godot 4.7.x after `git pull`. This QA scene automatically starts **one real `BattleUnit` Road Sentinel D244 vs one real `BattleUnit` Knight** on the approved D209 dark forest road. This is not a dummy animation loop or a static proxy.
- Both actors run the existing targeting, melee movement, separation, dynamic facing, damage, hit-stop, attack timing, frame-state transitions and death code. The current `road_sentinel.tres` speed, attack interval, damage, range and scale are unchanged.
- For visual observation, **only HP is multiplied by three in this QA scene** so repeated walks and actual attacks can be seen before the encounter ends. This is **not a balance playtest**; do not use the outcome as evidence that card #38 is tuned.
- UI offers `СНОВА` (restart the fight), `СМЕНИТЬ СТОРОНУ` (new fight approaching in the other direction), and `ПОКАЗАТЬ СМЕРТЬ` (deliberately kill Sentinel through `BattleUnit.take_damage` to inspect the actual death path). Both facings arise from real enemy targeting, not flipping an unrelated animation widget.
- New script `scripts/dev/black_lantern_sentinel_d246_combat_preview.gd` reads the already-committed D244 `.webp.b64` and applies it **only** to that one Sentinel `BattleUnit` instance, after validating the same 25-cel visible/padded/distinct/blank technical criteria as the live animation library. It does **not** populate the shared `MisdealUnitAnimationLibrary._frames_cache` or modify the D229 production fallback; only the isolated F6 session sees D244 as a battle actor.

## QA request

Watch the actual in-game ×1 motion as the Sentinel closes distance: whether his feet plant on D209 ground, if his cloak/lantern are synchronized to body movement, whether the spear actually lunges toward the Knight, and how facing flips if the units switch sides. **One short video covering both directions is enough**. This is a runtime movement test **before** final artistic approval and before the other four enemy arts are ready.

## Scope / safeguards

No edits to `scripts/battle/unit.gd`, `scripts/battle/unit_animation_library.gd`, `RunState.ACT1_CARD_IDS`, encounter assets, Knight/Sentinel `UnitData`, real battle UI or balance. `black_lantern_road` is still QA-only and **37/45 cards remain LIVE**. D200 approved card art, D209 selected arena, D196 wave baseline, DS2 and the frozen `backups/KARAMBA73-2026-10-16` are untouched.

Static checks can inspect path wiring and source structure, but **Godot F6 was not run by the assistant**; user native play remains PENDING until recording/feedback. This test also does not cover full #38 3v5 combat, light-zone mechanic, rewards, Fate Spread or balance matrix.