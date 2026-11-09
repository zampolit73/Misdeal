# Misdeal — current roadmap

## Completed checkpoint

- D420 user-authorized all24 enemy visual roles/600 new poses, individual stature and authored motion feedback. [Native QA and F6](ENEMY_VISUAL_POLISH.md); RELEASE/player review tracked in [PR90](https://github.com/zampolit73/Misdeal/pull/90).

- D418 Ranger-only Jack event with three choices and complete animal combat pack; [QA and local F6](D418_JACK_EVENT.md).

- D412 approved hero animation pack and D413 dossier live; D414–D417 safely integrated.
- Autonomous visual VP1–VP7: native baseline/audit, Reward modifier/readout fixes, truthful merchant/event states and full effects, RunEnd scroll containment, result-button canvas ordering, approved-art guards and complete RELEASE QA.
- 224/224 GUT,13 selector tests,52 native states, Battle→Reward→Table and solo/duo/trio motion. [Release evidence](VISUAL_POLISH_RELEASE_QA.md), [audit](VISUAL_POLISH_AUDIT.md).

## Priorities after this delivery

1. Fix only concrete new player/native regression evidence; preserve accepted Misdeal style and mechanics.
2. Separate technical P2 cleanup for pre-existing GUT type warnings, Windows certificate/log environment and route-runner shutdown resources. These are not visual blockers or proof of a failed game route.
3. Review D420 enemies in real F5 after the explicit all-enemy polish request; fix concrete prop/pose/stature feedback while retaining balance and architecture.
4. Continue the existing authored content/vertical-slice backlog toward45 Act1 cards from the current40 only after validating current GitHub and release gates. New combats still require original enemies (D143); future card artwork still requires D168 options. No new three-offer mechanic or replacement of I–XII/XIII.

Detailed historical backlog/approval context is preserved in [pre-polish roadmap archive](archive/2026-11-09-pre-visual-polish/ROADMAP.md). Historical pending checkboxes are not current technical truth; reconcile them with merged code before resuming. Current constraints remain in AGENTS.md, CONCEPT.md, DECISIONS.md and DESIGN_SYSTEM.md.
