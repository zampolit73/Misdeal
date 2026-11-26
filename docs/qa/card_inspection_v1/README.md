# Card Inspection Visual V1 — review and acceptance

The player approved the two-column visual concept on 2026-11-26. [Approved concept](../../../assets/source_archive/card_inspection_v1/approved_reference.webp) · [Offline layout preview](../../../assets/source_archive/card_inspection_v1/layout_preview.webp) · [Art provenance](../../../assets/source_archive/card_inspection_v1/README.md).

## Contract
- The same CardLoreInspect scene is mounted by Table and Reward. No selection/claim action is added. Real title, full type/role, description, card art and optional hold/mark annotation are passed unchanged.
- Center 900×452 plate at (190,134) for 1280×720; dim the real scene by 60%. Preserve the same DS3 physical front with an enlarged 250×340 footprint; title and category are live. The parchment has readable ink, serif typography and distinct scrollable annotation region when necessary.
- Escape, close button, outside click, scroll wheel, arrows, PageUp/PageDown/Home/End and original focus return remain functional.
- Only actual visible mark/hold notes are displayed, never hidden event outcomes. Real cards and original mechanics untouched.

## Evidence
Godot 4.7.2 / GUT 9.7.1, headless:
- `test_card_inspection_visual_v1.gd`: 3/3 tests, 44 assertions (layout/texture, scroll, close/return focus, real marked/held offer, no state mutation, live upgrade reader).
- `d274_table_offer_smoke.gd`: D278_TABLE_UI_PASS.
- `d316_card_surfaces_smoke.gd`: D316_CARD_SURFACES_NATIVE_PASS.
- Display-server setup could not open a local rendering socket. No new native screenshot or player visual acceptance is claimed.

## Player acceptance
1. F5 → reach Table → right-click any card. Confirm the actual physical art and parchment are readable, and no selection occurs.
2. Inspect a combat or marked/held card; verify complete long copy, optional annotation, wheel and keyboard scrolling.
3. Close with Escape, background or button; confirm focus and identical two offers. At an eligible development reward, right-click an upgrade and close without claiming.
