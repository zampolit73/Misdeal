# D249 — Isolated five-enemy encounter composition, real BattleUnit AI (NOT release)

Date: 2026-10-19. After D248 Guide 1v1 the user said **«все ок»**. Treat this as *user-reported technical movement no-blocker for the simplified D218 Guide*; not as approval of painterly art or full #38. **This D249 scene itself has NOT been run in Godot by the assistant.**

## Exact isolated deliverable

`res://scenes/dev/black_lantern_d249_five_enemy_combat_qa.tscn`, F6 in Godot 4.7 after `git pull`:

- Actually instantiates **3 real BattleUnit heroes** Knight/Ranger/Mage vs **5 true resource-defined enemies** (`extinguished_guide`, `lantern_bearer`, `road_sentinel`, `oil_acolyte`, `lantern_archer`) from existing `black_lantern_road.tres`. Uses original D209 forest and exact `BattleUnit` pursuit, targeting, turning, attacks, range, knockback/health/death, **unchanged UnitData values**. It is intentionally a direct diagnostic fight; real-party RunState bonuses and Battle→Reward→Table are not exercised, so do NOT infer final balance or victory rate.
- **Two source-authored five-enemy formations** via `СМЕНИТЬ РАССТАНОВКУ` and immediate restart, with original Y-projection onto battle floor, not fake marker placements.
- Uses exact approved-to-proceed **D244 Sentinel + D224 Bearer** from shared strict `MisdealUnitAnimationLibrary` (two registered roles), and **D218 Guide WebP, D217 Oil Acolyte SVG, D219 Archer WebP** as *isolated one-instance technical ORIGINAL pose candidates*. All three have 25 distinct frames, five transparent unused and 96px 2px margin gates checked by original library validators before the 3v5 starts. SVG uses Godot-native `Image.load_svg_from_buffer()`, like the existing D217 gallery; no new runtime dependency.
- Attaches actual existing encounter-local `BlackLanternLightController` to `UnitsLayer`, with its warm circles and **+16% attack speed for enemies standing in active light** (no made-up light visuals). Buttons `СНОВА`, `СМЕНИТЬ РАССТАНОВКУ`, `СВЕТ ВКЛ/ВЫКЛ` compare real targeting and pressure. On end, signals count living heroes/enemies and stop the scoped light, without changing global state.
- Does not edit `Battle`, `BattleUnit`, `UnitData`, encounter resources, `RunState`, arena, DS2, Fate Spread or any real game route. Guards `RunState.ACT1_CARD_IDS.size() == 37` and absence of #38.

## User QA requested (ONE F6)

Open above scene and press F6. Confirm all 8 actors appear and move on the road, Guide remains distinct/tall with its three lamps (though visibly simplified), Archer shoots/positions with original bow art, shield vs spear remain readable, light circles visibly cycle and boost enemy speed, and both authored formations work. A short screen recording or `«всё ок»` is enough if no defect; any error screenshot permits direct GitHub fix. **Do not demand per-frame approvals**.

## Art review outcome / blocker

Three further concept-sheet generation attempts are internally rejected: they rendered hooded skeletons holding chain lanterns in their HANDS rather than **one rigid wide iron shoulder yoke with THREE chain-hung lamps**; some have wrong idle count and baked-in background/text. None was imported or described as a valid Godot sprite atlas. The original D218 yoke-shape reference remains the actual *identity lock*, but needs painterly Style B fidelity matching D224/D244 before the Guide role can be made live. User-approved D238 says produce the entire 25-pose set together, and do internal checks first. Never replace Guide with Shield Bearer or fake missing cel duplicates.

## Next after runtime QA

1. Final rich full-25 Guide art with the *same three-lamp yoke*, original 4/6/6/3/6 and five empty, margin/scale/art QA, one full native review.
2. Original rich Oil Acolyte and Archer complete packs (the temporary D217/D219 models are NOT a release).
3. Only then enable the authentic #38 real combat route, 54-case / 3v5 balance matrix with scope-specific moving light, reward and Fate Spread traversal, smoke ordinary 38/45; keep freeze `backups/KARAMBA73-2026-10-16` unchanged.

**Release status after D249 code staging: 37/45 LIVE; #38 QA only.**
