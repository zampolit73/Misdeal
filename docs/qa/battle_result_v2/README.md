# Battle Result Visual V2 QA

- Approved concept: [three original candidate frames](../../../assets/source_archive/battle_result_v2/README.md), player approval 2026-11-27.
- Production: presentation on real Battle/ResultOverlay nodes, no replacement action handlers or gameplay art.
- Godot 4.7.2, GUT 9.7.1: **25/25 targeted tests, 469 assertions**, exit 0. [Actual test log](godot_targeted.log).
- Suites: battle result V2, Combat Report V1, System Dialog, Run Save.
- New checks: actual victory payout incl. relic and side objective, exact Last Deal cost, safe report focus, read-only report, failed save rollback/error inside the dialog, Classic final defeat without report, restored Last Deal offer.
- The existing gameplay-core runner was attempted headless; it stopped after victory at the reward transition. The unchanged SceneTransition implementation awaits RenderingServer.frame_post_draw; no native framebuffer was available. No end-to-end pass is claimed.
- Added native capture points to the existing release gameplay-core runner: `battle_result_v2_victory.png`, `battle_result_v2_last_deal.png`, `battle_result_v2_defeat.png`. No new CI job. Native CI execution not verified here. The player confirmed the integrated production result is OK and implemented on 2026-11-27 (player acceptance closed).

## Player checks

1. Planned victory: confirm text fits; open and close the report; claim reward once.
2. Disposable profile: loss, inspect actual price, accept or refuse; after paid retry, a second defeat must not offer another deal.
3. Classic: no report action; final result leads to the existing RunEnd rather than a separate new screen.
