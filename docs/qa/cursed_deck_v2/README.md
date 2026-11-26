# Cursed Deck V2 — verification

The user approved the new worn physical-paper card concept on 2026-11-26 after finding the bronze V1 implementation visually mediocre. The archived reference is an art-direction board, not a native screenshot. The migration retains the shared V1 native component and the real content/art catalogs.

- Shared text-free face, actual back with moon seal and unknown (unmarked) face: 512x768 RGBA WebP, separately imported. No rasterized localized text.
- Paper card actions now draw thin ink rules and use live dark text. Hover/focus/selection add a subdued paper outline, disabled remains readable. Native controls own all input.
- Table, inspection, known Fate cards and unknown live replacements, 24 events, development, elite and death wager use the paper skin. Two-line miniature titles replace the earlier unnecessarily tiny single line. No live card art or well is shown when its content is unknown. The zero-card discard stack displays the neutral back over the painted example; no fictitious title is shown in the live layer. The original painted generic future cards V–XI and sealed XIII remain as part of the established spread composition. Merchant cabinet and Wizard Wager retain their approved non-card action surfaces.
- Godot 4.7.2 import PASS. Targeted GUT: 25/25, 2061 assertions. Regression suites cover all existing 24 event definitions, card reader, Fate geometry/privacy, original art locks, development/wager and elite confirmation, merchant price/lock state and V2 paper textures/action/selected states.
- D315 gallery/reward, D316 card surfaces and D274 table affordances: headless PASS.
- Native framebuffer review: NOT RUN locally (no X display). Existing triggered CI captures 15 actual frames. Player visual acceptance remains pending.

## F5 acceptance
Check both dealt cards, RMB/F reader and the R spread (revealed/unknown/empty held/discard/central seal). Compare 2–4 event options, selection/unavailability, and reward effects. Existing hit areas, layout, choices, outcomes, art catalogs and game rules are unchanged. Review baked-plate edges and cropped art in the native render; composition was not independently visually accepted.
