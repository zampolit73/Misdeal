# Combat Report Visual V1 — QA

- Approved concept: [reference](../../../assets/source_archive/combat_report_v1/concept_candidate.webp), player approval 2026-11-26; [clean master](../../../assets/source_archive/combat_report_v1/clean_master.webp).
- Runtime: `scripts/battle/planning/battle_report_visual.gd`, campaign adapter `battle_plan_campaign.gd`; 1000×588 overlay, original V4 emblems and existing source journal. No additional actions or statistics.
- Godot 4.7.2 editor import PASS; targeted GUT `test_combat_report_visual_v1`, `test_combat_planning`, `test_combat_hud_visual_v1`: **19/19 tests, 208 assertions PASS**. Test real campaign startup, victory/defeat, preserved Last Deal controls, earlier-wave/time events, scroll keys, focus, empty and solo, Classic, and no duplicate journal results on reopening.
- Existing native planning CI capture now also opens the real production report and captures `campaign_combat_report_v1.png` and `campaign_combat_report_v1_scrolled.png`. Capture runner parse check PASS; native frame rendering **NOT RUN locally** (X11 sockets unavailable). CI and player visual acceptance pending.
- F5 → planned battle → result → «РАЗБОР ПРИКАЗОВ»: review the real hero sections, scroll to final entries, close with button and Escape, confirm unchanged result buttons. Reopen; journal must remain identical.
