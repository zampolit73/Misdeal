# Unified Card System V1 — approved and implemented (26 Nov 2026)

**Status:** Historical reference. Shared native architecture was implemented, but the player found the gold-edged appearance mediocre and approved Cursed Deck V2 on 26 Nov 2026. The new materials are implemented; see [V2 QA](qa/cursed_deck_v2/README.md) and the [approved board](../assets/source_archive/cursed_deck_v2/approved_reference.webp). Native visual acceptance of V2 remains pending.

## Problem and actual sources

Player screenshots show the Hero Development parchment cards, ornate Event Choice V3.2 cards, table DS3 letterboxed cards, visually inconsistent Fate Spread previews, and the relatively restrained Wizard Wager contract. The current code uses different presentation paths: `card_ds3_skin.gd` and `table_offer_skin.gd` for physical cards/table and inspection, `fate_spread_overlay.gd` for compact previews, `event_choice_presentation.gd` for ActChoice/WhisperingWell, `hero_development.gd`, `elite_trophy.gd`, `death_wager_view.gd` for reward families. Artwork remains sourced from approved card/choice/relic catalogs.

## Proposed visual contract

- One thin, muted aged-bronze outlined card with restrained corner cuts, charcoal leather category tab, art recess with full landscape use, warm parchment title/body, consistent serif heading/legible body, burgundy selection action. Avoid double frames, excessive ornament and large empty letterbox bands; use existing art intact and composition-aware fit, never stretch or crop critical subjects.
- Shared layout variants: standard physical Table card and inspection; full choice card (2–4 choices) with live costs/effects/restrictions; compact Fate Spread miniature with only known art/title/state, no CTA. Same outer identity even when the amount of text differs. No resizing or moving the occult spread, 12 slots or sealed XIII without separate approval.
- States: idle, hover, keyboard focus, pressed, chosen, disabled with readable reason, and held/discarded/revealed/unknown/locked miniatures. No hidden outcomes exposed. Positive and penalty signs remain explicit; gold cost is neutral, not an inferred debuff. Keep actual existing full text (wrap or existing inspection/tooltip); board copy is illustrative, not a new content contract.
- A common action treatment applies to ordinary choice/confirm/refuse controls. Preserve the approved two-sided Wizard Wager contract and other cinematic compositions; harmonize typography/palette/action chrome, not replace every non-card modal with a card grid. Keep old art assets for rollback. No gameplay, balancing, rewards, save, input route or outcome changes.

## Implementation order (completed through step 3; step 4 pending native visual acceptance)

1. Shared native Godot card skin, reusable text-free frame and state styles; production Table, read-only card inspection and Fate Spread thumbnails/held/discard, preserving their existing positions and boss back.
2. Event choice shared presentation for 24 events including WhisperingWell, 2/3/4 options and disabled long restrictions. Reuse all existing choice art.
3. Hero Development (normal and bonus), Elite Trophy and Death Wager card choices. Preserve direct-choice vs confirm semantics. Apply the same materials to Merchant offers where relevant; harmonize wager action chrome only if needed, preserve its approved contract.
4. Focused real Godot frames for each migrated surface, verify unavailable states, keyboard/mouse and existing gameplay routes. Then one integrated player acceptance.

Do not treat the separate pending native visual acceptance of Combat Report V1 as confirmed by this request.

## Implemented

The player approved the archived concept board on 2026-11-26. Production cards now share `scripts/ui/unified_card_skin.gd`: one 704×1008 text-free bronze/leather/parchment face, cached layout variants, coherent serif headings and live burgundy action states. Migrated Table/reader/Fate known and unknown live faces, all 24 Event Choice routes, normal/bonus Hero Development, Elite Trophy and Death Wager; Merchant keeps its approved cabinet with common price/action treatment. Preserve the sealed XIII, printed reference backs and approved two-sided Wizard Wager. Existing art catalogs and gameplay/confirmation rules remain authoritative. Godot 4.7.2 headless: 24/24 targeted tests, 2030 assertions, D315/D316/D274 smoke PASS. Native framebuffer CI and local visual acceptance pending. [QA](qa/unified_card_system_v1/README.md). Combat Report V1 native acceptance remains separate.
