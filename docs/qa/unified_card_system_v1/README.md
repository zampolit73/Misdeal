# Unified Card System V1 — verification

Player approved the concept board on 2026-11-26. This is the implementation gate, not player acceptance of the new live UI.

## Scope and evidence
- Godot 4.7.2 import: PASS.
- GUT 5 targeted suites: 24/24 tests, 2030 assertions. Includes the 24 live event definitions for solo/trio parties, real prices/restrictions, single-award behavior, exact approved artwork locks, card reader focus and no mutation, 12+XIII geometry, hidden-state privacy, all nine upgrade effects, three live reward views and merchant purchase state.
- D315 full real resource gallery/reward smoke, D316 inspection/Fate slots, D274 table offer smoke: PASS (headless executed Godot, not a visual screenshot).
- CI `d315-card-ds3.yml` additionally requests 15 real framebuffer captures in `d315-card-ds3-native`, including table, held, four spread stages, all three reward families, bonus and reader, events and the unavailable/resolved states. CI capture and visual review pending; the workspace has no X display or Xvfb.

## Integrated player gate
1. F5 → Table, select/hold and RMB/F read. Open R and compare known/unknown/held/rejected miniature styling; no new information should leak from hidden cards.
2. Open a two-/three-/four-option event (in particular Candle Seller / Whispering Well); check costs, unavailable text, hover/keyboard focus and selected state.
3. Inspect the next hero-development reward and, when encountered, elite trophy (separate confirm), death wager and the merchant. Check at normal window size and at 960×540.
4. Confirm no cropped critical art or baked old card corners break the unified look. The approved sealed XIII and printed reference backs remain intentionally distinct from revealed face cards. Merchant preserves the authored cabinet rather than replacing it with a new card grid; Wizard Wager preserves its already-approved two-sided contract.

No gameplay, item, reward, run save or deck data changed. Prior Combat Report V1 native acceptance remains independent.
