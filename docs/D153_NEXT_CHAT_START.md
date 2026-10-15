# Misdeal — D153 approved redraw handoff (2026-10-15)

**SOURCE OF TRUTH:** `zampolit73/Misdeal`, branch `main`. Open `AGENTS.md`, `docs/CONCEPT.md`, `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, and this file before editing. Github access is connected: use it; never ask the user to transfer ZIPs or paste GDScript.

## Latest user approval (supersedes prior sprite-art approvals)

User rejected the original committed D153 animation atlases as **stylistically mismatched** to the previously approved 448×274 illustrated ruined skeletal theatre card. The user supplied the exact approved theatre image again and requested **both characters be redrawn to match that illustration while staying readable in the established Misdeal combat-pixel style**.

Two new distinct **redrawn concept atlases were generated in the previous conversation**:
- `d153_threadbare_puppeteer_redraw.png` / `.webp` / `.webp.b64`: a crowned skeletal master in layered, ragged **deep crimson** theatre robes, exposed pale skull/ribcage and hanging golden threads.
- `d153_bone_marionette_redraw.png` / `.webp` / `.webp.b64`: a smaller skeletal stage puppet in bone-white and crimson shredded costume, small gold headpiece and hanging cords. Both visibly belong to the same ruined theatre.
- Raw generated-source images, before resizing: `a_transparent_background_pixel_art_sprite_sheet_1.png` and `a_clean_transparent_background_spritesheet_sprit_2.png`, produced in the previous project conversation.
- The user explicitly responded **«Подходит)»**, accepting this **new artistic direction**. **Do not silently replace the approved design with generic/minimal pixel skeletons and do not restart art selection.**

**CRUCIAL TECHNICAL LIMITATION / NOT DONE:** Those approved redraws are **not yet committed to GitHub**, so **the old, user-rejected D153 sprites are still active in `main`** at:
- `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64`
- `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64`

The previous assistant made nearest-neighbor resized candidates at **576×480**, plus local WebP/.b64 copies, but the image-generation sheet was **not exact production grid art**. A fresh *decoded WebP* alpha/cell diagnostic found **25/25 used cells touch a 2px cell boundary** in EACH atlas and **5/5 unused cells contain neighboring sprite pixels** in EACH atlas (row 0 columns 4–5; row 3 columns 3–5). This will fail Misdeal's strict `_all_authored_deck_frames_padded()` check and could make animations flicker/bleed. Unique visible used frames alone do NOT make these new redraws shipping-ready. Do NOT overwrite live atlas paths or claim Godot F6 PASS until each image is correctly segmented, repositioned inside 96×96 cells with safe transparent edges, unused cells cleared, full feet retained and all 25 frames preserved.

**Availability caution:** the approved original/redraw images were generated as conversation artifacts. Previous-session container paths (e.g. `/mnt/data/d153_*_redraw.*`) should NOT be assumed portable to a new chat. First attempt to recover these files through Project conversation attachments or available prior-session artifacts. If they are not accessible, use the user-approved previews above as the reference, without misleading the user that GitHub already contains the new art. Do not ask the user to rebuild an archive manually.

## Next implementation step (assistant owns GitHub)

1. Recover the user-approved two new redraws, create **valid** transparent 576×480, 6 columns × 5 rows, 96×96 per cell, **idle4 / walk6 / attack6 / hit3 / death6**. Full feet, source-right facing, coherent character scale and recognizable right-facing attacks. Clear 5 unused cells; 2px alpha-safe margins; 25 distinct, visible poses per role. Check for overlap, per-cell animation consistency and alpha after final WebP encoding.
2. Commit new rasters (using existing export-safe `.webp.b64` runtime paths) to connected GitHub, preserving rejected V1 bytes under versioned rollback paths or git history. Refetch each file and verify content/hash. Do not substitute existing enemy art.
3. Update `docs/PROJECT_STATE.md`, `docs/ROADMAP.md`, `CHANGELOG.md`, `docs/D153_ANIMATION_ATLASES.md` and this handoff with **real** deployed state.
4. **Only after upload + static QA:** ask user `git pull` and F6 `res://scenes/dev/threadbare_theatre_art_preview.tscn`. Inspect both five-state cycles, sprite size, motion, feet, no empty/cropped frames or wrong facing. User has approved **art direction**, **not** native animation gallery.
5. After user native art gallery acceptance, build new ruined theatre **battle arena** (not placeholder `crypt`), integrate D153-scoped `ThreadTetherController` in production `battle.gd`, test real battle→reward→table and deterministic 54-case matrix. Release `threadbare_theatre` as card #36 only when all gates pass.

## What already passed, must remain untouched

- User-chosen third D153 card art: a scene from an actual ruined puppet theatre, skeletal master and two skeleton marionettes, moonlight and aged red curtains. The existing 448×274 card illustration already renders in Godot.
- Isolated `res://scenes/dev/threadbare_theatre_smoke.tscn` **PASS** in user's real Godot with zero displayed errors: 32% damage reduction within 285px, disconnect/reconnect, immediate break on master death, cleanup; two formations and original skeletal roster. This does **not** mean real battle integration.
- D153 is **QA-only, NOT LIVE**, absent from `RunState.CARD_PATHS` and `ACT1_CARD_IDS`; live Act1 remains **35/45**. Physical run 12 Fate Spread slots + sealed XIII. Preserve D143 genuine-new-enemy rule, D167 scene-led card art, D168 show three different card concepts before approval (already done for the D153 illustration), DS2/Variant C and D151/D152.
