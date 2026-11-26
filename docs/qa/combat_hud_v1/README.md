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
