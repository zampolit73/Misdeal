# D277 — Approved hybrid two-card antique material pass

Status: D277 implementation committed to main (0d3a1b958809eb47f1adaf62f2bd5baca35a2457). Native 1280×720 Godot visual verdict remains pending; technical CI tracked separately.

## User approval and boundaries

The user selected a specific two-card hybrid of the cursed Misdeal table. D274–D276 established a functional, readable two-card composition with full-Russian-lore RMB inspection; user confirmed it via two screenshots. D277 improves the craft and material appearance only, avoiding repaints of independently approved encounter images, rendering screenshots as buttons, changing Fate Spread or rewiring input.

## Changes

- More variegated warm paper shader (deterministic; stable under animations).
- Fine bronze corner engraving and decorative metal rivets built with a lightweight draw-only Control, using one reusable script.
- Gold line/detail on the crimson Choose strap, with brighter hover treatment through existing button signals.
- Softer worn-bronze frame palette and modest gilded details in the existing compact inspect dialog.
- Extended native Godot 4.7.2 contract test and CI path triggers.

## Manual Godot 4.7 QA

1. git pull, run game at 1280×720. Compare same ordinary two-card deal with D276 screenshot: artwork still full size, titles/description centered, text stays dark on parchment, gilded corners do not intrude.
2. Hover L/R card: raised original card and warm crimson/bronze accent; hover exit restores normal, no floating tooltip. Keep `УДЕРЖАТЬ` above card.
3. RMB opens the compact inspection modal with gilded inner detail, full original lore, scroll as needed, Esc/close/outside click works. LMB still chooses and transitions into Battle/Event, subsequent reward and return.
4. Check marked card, held card, single boss view, wizard wager and meddling, and Fate Spread [R]; changes must not affect these systems.

## Important

Godot native technical CI success means scripts/resources/node contracts are valid, NOT proof the final texture matches the selected illustrative concept. Do not mark user artwork approval until the user reviews actual screenshots.
