# Misdeal — Reward Cinematics 1.0 / normal loot

Approved concept: `approved_reference.png`. Runtime plate is a 1280×720 exact resampling and local removal of the dynamic copy from this concept; the bag, coins, bowl, table, logo, glass and all frame ornaments remain painted. `layout_preview.webp` is a non-runtime sample with demonstration values. Do not use it as the background.

## Integration
- Use `runtime/loot_plate.webp` only for `normal_loot` in `scripts/reward/reward.gd`. Keep all other reward modes, existing reward handlers, checkpoint and Travel/RunEnd routing intact.
- Draw real Godot labels in the coordinate rectangles of `layout_1280x720.json`; preserve both normal and `ДОЛГ ПОГАШЕН` title/summary variants. Amount is `25 * RunState.get_reward_multiplier()`; never bake the number. The displayed wallet and stats must be current, and after successful claim reflect actual RunState (not extra mutation).
- The single claim control replaces the presentation of existing normal-loot button index 0 (`blood_coin`), not its grant logic. Use the existing single transaction path. Avoid duplicate input/claims, and restore original presentation when other modes are shown, especially major_upgrade -> normal_loot.
- Claim state overlays are 408×74 local opaque WebP crops registered exactly at `[436,600,408,74]`. Hide the overlay for normal, use hover/pressed/disabled as appropriate. Render live caption above each state. Add subtle keyboard focus using a real control, with no bright glow. Use texture coordinates consistently when scaling the canvas.
- Keep existing text details/inspection accessible if applicable, keyboard and mouse controls, and existing accessibility behavior. The visual sample is not a data source.
- Optional brief reward animation: use an existing coin sound (avoid duplicate playback), a short amount/actual wallet update without simulated grant; do not add a second confirmation or introduce save timing risks.
- Native validation needed: normal 25, doubled loot, transition from major upgrade, a special reward untouched, successful claim and correct route. Validate on Godot 4.7.x at 1280×720 with isolated fixture saves. No runtime validation performed in this art pack.

## Provenance
All imagery derived from the user-approved generated concept. Text was removed locally; no scene-wide redraw or recolor. Preview font is illustrative; use the existing project UI typography in-game.
