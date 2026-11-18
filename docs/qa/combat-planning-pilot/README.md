# Combat Planning — native evidence

Godot 4.7.2, native Windows renderer, 1280×720. These are actual viewport captures, not interface mockups.

- `setup.png`: isolated experiment launcher, composition/mode/seed/preset.
- `editor.png`: real per-hero controls and actual selected Grave Bell enemy.
- `real_engine_live.png`: engine-driven combat, second Knight order after intro/pause checks.
- `report_grave_bell_staged.png`: factual losing mixed-plan timeline.
- `comparison.json`: all 15 controlled Grave Bell fights, initial stats/positions, movement/HP/target samples and journals.
- `wave_check.json`: actual Iron Wall intermission, surviving-unit replanning without healing, next-wave clock check.

Validation: full GUT **313/313 tests, 77,892 assertions**; native capture PASS. The final native run has no script/import/assertion or resource-leak errors; Windows reports its existing root-certificate-store diagnostic. CI repeats the native runner and retains fresh evidence.

Seed 31017, trio, original deployment: old assault and pilot one-order assault both win at 15.75s with Knight 134 HP, Ranger 90 HP and Mage dead. Defense loses at 46.12s, hunt at 17.40s, mixed example at 15.55s. No outcomes, damage or HP were forced. Accelerated comparison uses fixed 1/60 steps through real Battle/Unit code; separate engine-driven checks cover actual mouse input, intro, pause/resume and editor lock. This is a behavioral pilot, not a complete balance study or campaign rollout.

See [pilot guide](../../COMBAT_PLANNING_PILOT.md) for controls and limitations. Do not merge before user gameplay review.
