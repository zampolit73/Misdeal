# Cursed Deck V3 · Black & Gold

Base: b6c879f (Cursed Deck V2). Player supplied native Table/Fate screenshots with poor contrast and approved the Black & Gold concept on 2026-11-26. The actual approved screenshot mockup is archived in [source](../../../assets/source_archive/cursed_deck_v3/approved_reference.webp). Runtime front is an original text-free SVG; the illustration catalogs, back/unknown images, outer dimensions, state and input plumbing are unchanged.

## Scope and checks
- Shared dark opaque face, light antique-gold heading/action, ivory copy, pale semantic green/red, readable disabled restrictions. Sampled actual imported face at four text regions; all six text pigments exceed 4.5:1 WCAG-formula contrast in the headless test (not a certification of rendered readability).
- Table and gallery titles/previews use larger fonts with bounded fitting; all live revealed Fate miniature titles use the new gold instead of legacy dark ink. Unknown art remains hidden.
- All 24 event scenes (solo/trio), hero development, legacy reward cards, elite trophy and death wager use the same face. Merchant cabinet and Wizard Wager are separate cinematic surfaces, as is the reader's right-hand vellum; preserve their approved palette. No gameplay, data, artwork, or save-schema changes.

## Godot 4.7.2 results (Linux, headless)
- Full editor import: PASS, no script parse errors.
- GUT: 26/26 tests across unified cards, events, reader, Fate layout and visual polish (2605 assertions).
- D315_CARD_DS3_NATIVE_PASS; D380_REWARD_COPY_PASS; D379_REWARD_LAYOUT_PASS.
- D316_CARD_SURFACES_NATIVE_PASS.
- D278_TABLE_UI_PASS (d274_table_offer_smoke).
- Native framebuffer: BLOCKED locally (Xorg unable to establish listening sockets). The existing CI native capture job remains enabled; human acceptance still pending.

F5 check: Table at 1280×720 (including long Cyrillic title), R Fate (revealed/held/discard), RMB reader, a 2–4-choice event with an unaffordable option, normal/bonus development and rewards. Verify readability and confirm no unexpected illustration, choice or focus changes.
