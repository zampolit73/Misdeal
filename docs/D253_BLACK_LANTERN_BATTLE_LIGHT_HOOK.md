# D253 — Real Battle integration of the original Black Lantern light controller

Date: 2026-10-19. This is **gameplay plumbing behind an unreleased card**, not #38 public release.

## Implementation

The existing D206 `BlackLanternLightController` is now preloaded by `scripts/battle/battle.gd` and instantiated ONLY for `encounter.encounter_id == "black_lantern_road"`. Setup occurs after spawning all actual party and enemy `BattleUnit` instances. Before attaching the controller, the exact enemy role multiset (one `extinguished_guide`, `lantern_bearer`, `road_sentinel`, `oil_acolyte`, `lantern_archer`) is required: missing/duplicate/unrelated roles reject the effect rather than silently applying it to a partial cast. All other encounters do nothing.

`configure(units)` snapshots actual enemy intervals after ordinary RunState difficulty modifiers and creates the controller under `UnitsLayer`; the light begins only after the real `Fight` action, cinematic intro, and `unit.start_combat()`. D206 remains unchanged: 1.4s warning, 3.1s active, 1.8s rest, alternating moving 93px areas, illuminated enemies' attack interval divided by 1.16. No hero is buffed by this effect.

Both normal victory and defeat call `stop_light()` before post-battle resolution, restoring each enemy's pre-light interval. The existing controller additionally restores on `_exit_tree`. No new character art registration, balance edits, encounter data edits or RunState release.

## Static verification and remaining gates

Checked exact code insertion, setup/start/stop routing, previous other special encounter controllers untouched, and strict five-role guard. Native Godot 4.7 actual #38 main Battle→Reward→Table is **NOT RUN** and must not be labeled passed. The released deck is still 37/45. D252 user video proved only standalone two-formation 3v5 on original D209 forest, not this main Battle integration.

Local D251 rich Guide atlas edge-rematting improves some halo pixels but not the compressed long-chain attack, awkward lantern linkage and death scale. As an internally rejected experiment it was not committed, not registered and not offered for another user F6. The Guide's locked silhouette remains a rigid horizontal iron shoulder yoke with exactly three chain-hung lamps, across 25 original B-style poses; Oil Acolyte and Lantern Archer also need full rich 25-frame art. Only after these art gates should the actual Battle/reward route, solo/duo/trio matrix and card-pool release be tested.

Keep D244 Sentinel, D224 Bearer, D200/D209 approved forest art, DS2, Fate Spread XIII, and frozen KARAMBA73 unchanged.
