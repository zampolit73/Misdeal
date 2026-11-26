# Pause Menu Visual V1

- User approved the concept and authorized implementation on 2026-11-26.
- [Approved screenshot concept](../../../assets/source_archive/pause_menu_v1/approved_reference.png) and [offline layout proof](../../../assets/source_archive/pause_menu_v1/layout_preview.webp).
- Production menu opens with Escape through the original RunMenu. Active scene remains visible behind a 52% scrim; panel is centered at 370×568 in the 1280×720 design viewport.
- All five original actions remain live native buttons. Save and Save & Exit retain the original safe-scene gate; disabled buttons are skipped by keyboard navigation. Save messages/errors stay dynamic. Resume restores focus; the existing Main Menu confirmation and save/load service are unchanged.

## Verification

Godot 4.7.2 / GUT 9.7.1: [14/14 tests, 273 assertions](godot_targeted.log). Two targeted tests instantiate the real Table and Battle, exercise Escape, focus, actual save/load via isolated slots, canceled Main Menu confirmation, safe/unsafe save gates and pausing live combat. In headless only, the route observer emits the normal transition frame signal; no production transition or save behavior is mocked or changed. Twelve existing save-state regressions pass. The final import completed without script parse errors.

The offline layout proof is not a GPU screenshot. Native visual acceptance is pending on the player's machine: F5 → new or continued run → Escape on Table and during Battle. Verify all five actions, readable disabled states and resume. The existing generic confirmation dialog is deliberately separate from this local pause-menu skin.
