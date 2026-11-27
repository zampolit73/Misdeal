# HUD Visual V2 — targeted verification

2026-11-27 · Godot 4.7.2. [Player-approved offline references](../../../assets/source_archive/hud_visual_v2/README.md).

- GUT: HUD Visual V2 (4 tests), Combat HUD (4), Battle Result (5): **13/13 passed, 344 assertions**. Covers real scene data, approved bounds, baked Table contours, longer text/conditions, true encounter title, solo/duo/trio modifiers, conditional tooltip, hidden combat modifiers and preserved card/arena/planner geometry.
- D289 existing Table and D291 existing Battle smoke scripts: both PASS in headless mode; their old marker names contain NATIVE_PASS, but these runs do not verify rendered pixels.
- No broad suite run or native screenshot obtained locally. Player visual acceptance pending: F5, Table and a fight, inspect both top HUDs; optional naturally encountered conditions/long copy/second wave.

Evidence: [targeted GUT](godot_targeted.log), [smoke checks](godot_smoke.log).
