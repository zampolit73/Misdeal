# Wizard Wager Visual V1

- approved_reference.png — user-approved concept of the optional **offer**, not the Death Wager reward.
- clean_master.png — text-free isolated panel reconstructed from the approved crop; no background replacement.
- layout_preview.webp — offline composition of the actual Table V5.1 frame, runtime plate and copy. Illustrates placement only, not a native screenshot.
- runtime: `assets/pixel/ui/wizard_wager_v1/wager_plate.webp` (744×475, lossless RGBA). Transparent outline, opaque interior; placed at (268,232).
- runtime layout, typography and transparent live buttons: `scripts/table/wizard_wager_visual.gd`; existing RunState offer/accept/refuse remain authoritative. The copy specifies that +25% damage persists while debt is active. The existing table stays untouched behind the modal.
- Verification: Godot 4.7.2 headless targeted GUT accept/refuse tests and D289 real-Table smoke. No native GPU capture was collected by the assistant. Player explicitly accepted the merged production presentation (PR #158) on 2026-11-26. Full Act I control-run coverage remains separate.
