# Combat HUD Visual V1 — player review

[Approved concept](../../../assets/source_archive/combat_hud_v1/approved_reference.webp) · [Offline geometry proof](../../../assets/source_archive/combat_hud_v1/layout_preview.webp) · [Provenance](../../../assets/source_archive/combat_hud_v1/README.md).

## Presentation contract

- Live planned combat only. A passive 414 px-wide panel at (838,156), 48/72/96 px high for one/two/three living planned heroes. Original class emblem, live role name, current Roman stage, selected tactic and remaining time (or «до конца») retain the original executor meaning. No added stats, controls or gameplay.
- One to three live transitions appear below on a separate readable strip for the existing 2.7 seconds. Real timeout/time/damage/kill/HP reasons are preserved; no transition is inferred.
- Hide dead heroes and compact without empty rows. Hide during preparation, intro, wave break, classic mode and result. Scene, wizard objective, DS3 header, combat planner V4 editor, arena/units/HP bars and order executors remain unchanged.
- All Controls ignore pointer input; the only new material is derived from the accepted frame. Runtime typography and labels are not baked.

## Evidence

Godot 4.7.2 / GUT 9.7.1, headless: 3/3 focused HUD tests plus 12/12 existing Combat Planning tests, 166 assertions. Actual Battle scene startup, solo/trio, duo after casualty, live executor data, simultaneous transition reasons/expiry, classic fallback, wave break and result hiding. The test freezes actor processing only after real combat begins so it can inspect deterministic executor transitions. No new rendered Godot screenshot is claimed; native player acceptance remains open.

## Native check

F5 → start a planned battle (or QA Hub Combat Planning). Use one hero with two stages and an event/time limit, later a 2–3 hero party. Observe the live countdown, last stage («до конца»), transition strip, disappearance of dead rows and no HUD over the result. Exercise a second wave and classic mode. Keep the current arenas and existing top/side panels unchanged.

## Combat Intro Visual V1

- Production Battle scene has an initially hidden 520×130 non-interactive title plate using the existing contour-corrected Main Menu V2 secondary material. No new runtime art; actual caption and encounter text remain live. Entrance, hold and exit remain 0.22/0.36/0.20 seconds.
- Godot 4.7.2 / GUT 9.7.1: **9/9, 244 assertions** (HUD V1 and Battle Result V2 suites), exit 0. [Log](godot_combat_intro_targeted.log). Real planned first-battle start, direct actual second-wave caption presentation and fade, correct geometry/texture/text, full dismissal and no HUD/result regression.
- Existing native campaign planning capture now saves `campaign_combat_intro_v1.png`; parse check passed, native rendering was not run locally.
- Native check: F5 → «БОЙ»; see «СХВАТКА» and actual encounter then unobscured combat. In a two-wave fight check «ВОЛНА II» before orders begin.
