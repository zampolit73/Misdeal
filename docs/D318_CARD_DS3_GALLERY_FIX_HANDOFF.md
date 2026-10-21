# D318 — Gallery legibility repair and next genuine Card DS3 art batch (2026-10-21)

## Source/evidence
- D317's *real* user F6 gallery screenshot is `docs/qa/D317_card_ds3_gallery_user_screenshot.webp`. Opened that exact archived image, confirmed Black Altar prose paints over adjacent card illustrations/frames; category overlay cuts across paintings; accidental I–XII gallery sequence is false Fate labeling; original pictures are nearly black.
- User request this chat: repair gallery **first**, then continue implementing the approved scarlet/near-black/aged-bronze/parchment DS3 style on **all** real cards, no mechanics changes.
- Approved first brighter DS3 Card Design System concept remains canonical; do not switch to cooler muted study. Battle DS3 final approval and DS2 checkpoints remain immutable.

## Implemented directly to GitHub main (not just proposed)
1. `d6b2eda` — `scripts/dev/d315_card_ds3_gallery.gd` now displays a bounded 56-character preview inside its own **vertical clipping well**; source RunCardData is untouched. Category moves to real upper-right physical tab, title stays in parchment well and is max 2 lines; gallery fake numerals are hidden. Clicking opens a full-screen modal `DS3FullTextOverlay/ReaderBoard`, with independent original art, actual full text in a scrollable selectable `ReaderFullCopy`, ESC/close. Gallery still enumerates 40+9+6 and does NOT grant cards or play encounters.
2. `d6b2eda` — `shaders/card_ds3_ink.gdshader` replaces heavy 54% desaturating red/black crush with controllable 30% warm blend and midtone lift. **This impacts every active shared DS3 surface**: live two-offer Table, Reward, Spread, RMB inspection and gallery; geometry of other screens unchanged. An F6 and live UI visual comparison remains necessary.
3. `d6b2eda` — original `scripts/dev/d315_card_ds3_smoke.gd` now asserts all gallery preview containment (card bounds / title-vs-body / category-vs-art / hint-vs-body), no fake Fate numerals, a genuinely shorter preview, exact original `black_altar.tres.card_text` in the reader and working close, in addition to all original 55-gallery/Reward checks. D316 Spread/inspector smoke was preserved.
4. `61ca941` — common **live** Table style `scripts/ui/card_ds3_skin.gd::apply_table` also moves Type to existing top-right black tab and sets title/body max 2 lines (not a gallery-only illusion). `scripts/table/table_offer_skin.gd::short_description` now takes a defaulted optional length preserving DS2; `scripts/table/table.gd` limits DS3 live offer body to 56 chars but retains raw full text in RunCardData and live RMB reader. Two offers, actual I–XII/XIII numbering, hold/discard, reward effects and routing preserved.

## QA honesty
- **Code pushed; native Godot 4.7.x import and real F6 screenshot remain UNVERIFIED.** In this environment Godot executable not installed, and GitHub Actions connector enumerated neither push jobs nor status checks (empty result). Do not convert static review to QA PASS.
- Screenshot the user sent is D317 BEFORE changes. Do not claim new implementation visually accepted. Strong red palette reference remains approved, not finished.
- 40+15 source textures in gallery ≠ 55 individually repainted scenes. The D318 pass corrects layout and global grading; individual bespoke scene-art redraw remains genuinely incomplete.

## Next exact actions
1. User: `git -c gc.auto=0 pull --ff-only`, open `scenes/dev/d315_card_ds3_gallery.tscn` with F6. Send one screenshot at actual 1280×720 after D318, with Black Altar visible (and optionally click to show the scrolling reader).
2. Check no category text on painting, title in light parchment well, no cross-card prose, brighter still-readable original scenes. Confirm original live two-offer Table + Reward + full-text RMB reader + Spread (I–XIII) unchanged. If scripts/CI fail, **fix via GitHub immediately**.
3. Art production follows the approved D168 rule: for an actual *new replacement scene*, present 2–3 meaningfully different rendered compositions for selection; only then integrate the selected **exact** art in a per-ID WebP and update registry. Priority to screenshot-dark `black_altar`, `ash_rest`, and less readable original scenes after new F6 confirmation. Do NOT quietly replace previously user-selected `black_crossing` / `black_lantern_road` preview-only scenes or release them into the deck.
4. Continue 40 original + 9 upgrade + 6 reward catalog visual audit and replacements in specific scene batches, always preserve per-card art IDs, lore, source titles, resource effects, two-offer gameplay and rollback. Do not claim all individual redrawing completed prematurely.

## GitHub recovery
Branch `main` latest implementation `61ca941276c202f6393f0e0a603775b2828841ab` at time of this handoff, plus this document's subsequent documentation commit. Existing frozen checkpoints: `checkpoint/card-ds3-d315-audited-2026-10-21` = `e9dac0b0`, `checkpoint/battle-ds3-approved-2026-10-21` = `25878ca`, `checkpoint/ds2-pre-ds3-2026-10-20` = `4cbd206`. Reference D317 handoff: `docs/D317_CARD_DS3_GALLERY_SCREENSHOT_HANDOFF.md`.
