# Battle Result Visual V2 — approved design and production implementation

2026-11-26 candidate baseline `bc82b002`; player approved all three frames on 2026-11-27. Production now uses the approved native presentation via `scripts/battle/battle_result_visual.gd`, without introducing runtime artwork or changing existing gameplay. The original Battle nodes own their signals, result rules and saves. The planned-mode report is moved inside the same panel; Classic keeps only its real actions. [Targeted QA and native acceptance](../../../docs/qa/battle_result_v2/README.md).

The design supersedes the legacy `Battle/ResultOverlay`, not the separately approved final RunEnd screen. Original candidate frames follow; they remain offline references rather than native screenshots.

## Candidate frames (1280×720, offline layout proof)

- [Last Deal](last_deal_candidate.webp) · HP cost example.
- [Victory](victory_candidate.webp) · actual generic victory copy and two permitted actions.
- [Final defeat](defeat_candidate.webp) · offer already used, no second purchase.

All three use original Main Menu V2 primary/secondary plates, the same 18 px nine-slice geometry and bevel alpha contours as System Dialog V1, live serif type direction (Liberation Serif local preview), and the actual approved [Firing Square arena](../../pixel/battle/arenas/approved_d283/firing_square.webp). No new card illustrations or art. The background is the unchanged arena art with scrim, **not a captured native battle result**; real runtime must retain current arena, combatants and HUD below the scrim. These WebPs are preview documentation only, not runtime UI, and have no gameplay authority.

## Layout contract at 1280×720

| State | Modal bounds | Primary | Secondary | Planned-only report |
|---|---|---|---|---|
| Victory | (320,180,640,360) | right 280×64 reward | none | left 280×64 |
| Last Deal available | (268,127,744,466) | left 330×65 accept | right 330×65 refuse | below, centered 330×53 |
| Final defeat | (300,180,680,360) | right 300×64 finish | none | left 300×64 |

The modal groups the existing actions, live encounter title, original Wizard quote and genuine price/outcome messages. Keep the warm gold/ivory palette and burgundy primary action from System Dialog V1; readable negative price in #F0A299. Divider and price region are not buttons. Short explanatory line restates the existing single-use retry rule. Use existing attached data, never baked text; real price is `RunState.get_last_deal_price_text()` (the exact selected relic, or actual HP cost including oath). Longer victory copy with side objective payouts and relic effects must fit/wrap without overlap; expand copy region or use contained overflow if necessary.

## Implementation guardrails if approved

- Reuse the original nodes, exact signals and routing: `_finish_battle`, `_show_last_deal_offer`, `_show_final_defeat`, `_on_last_deal_accept_pressed`, `_on_last_deal_refuse_pressed`, `_on_continue_pressed`. Keep entry wounds, existing payment/backup/checkpoint, original failure handling and no second deal or duplicate payout. Ensure save-error copy is visible on failure.
- Integrate the existing dynamic report button into the panel only in planned mode; Classic remains without this action and the remaining control is centered. Preserve the approved Combat Report V1 overlay at layer 60, existing journal, close and return focus. Keep all report and result actions at the existing layer and mouse/keyboard accessible; distinguish focus using the existing bevel, not a second rectangular outline. Do not introduce new action handlers, automatic choice, retry, price or reward.
- Share the accepted System Dialog presentation where practical; no global theme or approved art replacement. Preserve actual combat arena, HUD and sprite/layer behavior untouched, no RunEnd changes.
- Targeted verification: real victory→reward, actual loss with relic and HP-cost offers, acceptance with save/reload, failed save leaves offer usable, refusal→RunEnd, used deal→final defeat, planned report→same result, Classic without report, long copy and native 1280×720 capture. Avoid broad unrelated regression. Runtime is NOT RUN for this visual candidate.

Approval gate: player reviews composition then approves actual implementation.
