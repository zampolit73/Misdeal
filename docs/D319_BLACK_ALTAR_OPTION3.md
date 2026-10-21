# D319 — Approved Black Altar option 3: real card-art integration and gallery screenshot fix (2026-10-21)

## Native screenshot evidence

The user provided TWO actual Godot F6 screenshots after D318: (1) the full 40+15 DS3 gallery at 1280×720, (2) a functioning click-open `ЧЁРНЫЙ АЛТАРЬ` full-text reader showing the intact original sentence and illustration. First picture establishes substantial improvement: card text no longer overflows between neighbors, art is lighter and all 55 catalog keys resolve. **Remaining defects:** a native Godot mouseover tooltip `ЧЁРНЫЙ АЛТАРЬ — СОБЫТИЕ / Нажмите...` floats across adjacent cards, and the card title uses almost-black ink on a visually black background and is unreadable. The reader dialog remains functionally correct but still needs final visual approval.

## Artist selection

User replied **`3`**, approving the THIRD (BOTTOM) illustrated scene of the generated three-option Black Altar sheet, not the middle bowl or top cathedral. That scene shows a red-lit altar on temple steps between tall winged stone figures, in the same saturated scarlet/black/bronze world as accepted Card DS3. This choice supersedes the D318 "candidate only" note **for Black Altar ONLY**, not 54 unrelated artworks.

Exact source derived from original conversation-generated 1604×981 three-panel PNG, cropping its selected third panel at (510, 650) → (1057, 981) and downsampling via Lanczos to canonical 448×274. Result is a `7,648` byte quality-16 WebP chosen for GitHub connector-friendly text-backed transfer; bytes have SHA256 `3e873813db79ba9f67df9de00be07e80e177ad1f6429af36d6592f13ac6bde0e`. Source composition preserved by simple crop and resize; no regeneration, text/GUI baked into bitmap or gameplay content change. Higher-bitrate export can follow native user QA if it appears too compressed; do not call that done already.

## Actual commits / assets

- `4831b931b01ae1cdfe2119f82b27750fbe61cd8f` (`main`): `scripts/dev/d315_card_ds3_gallery.gd` deliberately clears native `Button.tooltip_text` so hovering cannot place an oversized widget over other cards. In-card `ЧИТАТЬ КАРТУ` and scrollable modal continue working. In shared `scripts/ui/card_ds3_skin.gd`, only actual tabletop face title font switches to readable bone/ivory with a 1px black outline; Reward heading elsewhere not recolored. D315 smoke asserts gallery card tooltips empty.
- `a5cb905e375955dc1383547ccc5b6201c2069398` (`main`): binary `assets/pixel/card_unification_v1/run/black_altar_d319_option3.webp` (WebP 448×274, checksum above), and explicit *per-card* override of only `black_altar` in `scripts/ui/card_unification_v1.gd::RUN_CARDS`. It becomes the actual runtime card texture from `CardArtCatalog`, including gallery, live Table and lore inspection. Older `EVENTS` scene background, approved Wave-1 art files and REDRAW atlas remain intact as rollback. D315 smoke now asserts the selected file SHA256 and the returned card texture's 448×274 dimensions.

## QA / next implementation

Changes pushed, but **no post-D319 F6 screenshot or Godot 4.7.x native CI PASS confirmed**. The native screenshots in this turn are D318-before-D319. Ask one F6 screenshot after `git -c gc.auto=0 pull --ff-only`: Black Altar card no longer spawns tooltip, title is readable, *selected third illustration appears*; click for full reader. Brief real Table sanity check to ensure same image and 12+XIII Fate progress untouched. If source test fails, fix GitHub code.

Only **1 of 55** illustrations has been newly replaced by a user-approved bespoke D319 scene. 40 original RunCardData cards, 9 upgrade and 6 reward art entries still have their prior catalog assets/DS3 skin/grade; do not claim a full all-card redraw. Continue D168 options-first with the next *individual* outlier (such as `ash_rest`), then integrate chosen exact artwork without modifying mechanics or reopening approved Battle DS3.
