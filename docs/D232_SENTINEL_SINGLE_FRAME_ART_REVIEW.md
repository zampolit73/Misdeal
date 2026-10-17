# D232 — Road Sentinel: ONE high-fidelity idle pose for real 96px approval

Date: 2026-10-18. Status: **ACTUAL ONE 96×96 ALPHA CHARACTER FRAME STAGED IN GITHUB; ART USER APPROVAL AND GODOT F6 PENDING; NO ANIMATION/PRODUCTION SWITCH**. Live Act1 **37/45**, card #38 QA-only.

## Immediate user instruction

User said **«продолжай»** following D231's acknowledgment that the beautiful earlier original atlas had been lost in repeated procedural sprite edits. D231 hard requirement: **one rich-looking full-body spear Sentinel at native game x1 on exactly accepted D209 moonlit forest BEFORE authoring any new 25-frame combat atlas**. The user's detailed approved D221 spear Sentinel and deep Style-B ambient palette remain visual references; the earlier 1254×1254 beauty-source mistakenly depicted an axe/halberd and must NOT be reinstated unchanged.

## Rendering/extraction result (honest source provenance)

- Tried new original illustrative image generation several times. The generator repeatedly returned **labeled multi-panel fake animation/atlas presentations** despite requesting one standalone alpha-ready pose. Reject those compositions as engine sprite sheets: their printed `25 frames` / `576×480` claims are not real Godot assets, and the apparent repeated poses cannot be treated as genuine frame animation.
- One generated frame in `a_detailed_concept_art_sprite_sheet_image_in_a_d.png` had a better actual high-contrast skeletal soldier: a pointed long **spear**, antique russet iron plate, muted burgundy hooded cloak and separate amber lantern. From this frame ONLY, cropped image rectangle **(927,57,1042,186)** (115×129 RGB region), segmented black background and alpha, producing isolated approximately **100×115 visible sprite**. Source cutout is now preserved as **`assets/pixel/units/black_lantern_road_qa/road_sentinel_d232_reference_cutout.webp.b64`** (115×129 RGBA, WebP lossless).
- Single pose scaled with **NEAREST** to fit maximum 88px of height on transparent 96×96 frame, keeping safe alpha margins `bbox (9,5,86,93)`. `assets/pixel/units/black_lantern_road_qa/road_sentinel_d232_single_96px.webp.b64` holds the new **ONE ORIGINAL ILLUSTRATION-DERIVED STATIC FRAME ONLY**. It is NOT painted pixel-by-pixel at final 96px, does NOT provide 24 additional poses, and extraction may require hand-cleaning dark armor/halo pixels after look approval. Do not misrepresent generated poster concept as finished sprite atlas.
- Pillow lossless pixel equality (original RGBA canvas and decoded WebP) verified for both exports. SHA-256 decoded WebP `7721a6a64998c7487fbd759c89efa4f626671ad6dec55667d45572ca093df2aa` for 96px; source cutout `8e6fe4bf084b25e76b40bf0b48200785e99d17157b3f71a327d8c041fb6d999c`. Details in `docs/qa/D232_ROAD_SENTINEL_SINGLE_POSE_QC.json`.
- A local side-by-side transparent checker preview `D231_triptych_96px_x4.png` compares current D229 technical source, new D232 nearest sample (crisp), and alternative bilinear-ish Lanczos (soft). **Chose crisp nearest** for F6 QA. The direct D209 game-scale comparison is `D231_combat_scale_on_approved_D209_arena.png`; both are conversation attachments/ZIP, not binary project sprites.

## Native Godot comparison (GitHub `main`)

- `scripts/dev/black_lantern_sentinel_d232_art_direction_preview.gd` + `res://scenes/dev/black_lantern_sentinel_d232_art_direction_preview.tscn`: scene loads **exact D209 third-approved 1280×720 forest** via existing authored backdrop; LEFT is unchanged D229 first `idle` cel from the 576×480 QA atlas; RIGHT is the new **single transparent 96×96** still. Both shown at x3 and x1 with `TEXTURE_FILTER_NEAREST` and alpha margin/visibility validation.
- A direct native Godot build/run of D232 scene is **NOT AVAILABLE** in this session; native F6 must be confirmed by user. Scene intentionally has NO fake walk/attack/death controls because only a single static pose has been authored. If native parser/runtime fails, read the source in GitHub and fix directly.
- Existing **`MisdealUnitAnimationLibrary.get_frames("road_sentinel")` still returns the technical D229 staged atlas** from `assets/pixel/units/deck_expansion_v1/road_sentinel_frames.webp.b64`; this code/asset, `BattleUnit`, active card pool, enemy stats, real encounter, moving light and D209 forest all remain **UNCHANGED** in D232. D230 overbroad `FINAL` art assertion remains superseded by D231 user objection.

## Next step

User `git pull`, F6 `res://scenes/dev/black_lantern_sentinel_d232_art_direction_preview.tscn`; review **readability and art quality in the ×1 right panel**, not just x3, and confirm whether it materially restores the richer feel. Ask **ONE** question: **«Такой уровень детализации при ×1 подходит для итогового Стража или ещё не то?»** This is acceptance of one **look**, not the full asset. Do not generate 25 poses or switch the prod role until this is settled.

If user approves, choose a reliable **25-authored-pose actual sprite** pipeline that keeps source design, real 6×5×96px alpha/feet/weapon fidelity. Do NOT just auto-cut generated grids, replicate the same pose 25 times, fake death/walk frames or silently change global Godot sprite budget. If x1 richness still insufficient, discuss explicit art-scale constraints rather than calling it final.

No KARAMBA73, D200 third card illustration, D209 arena, shipped 37 cards, DS2, D196 waves or Fate Spread 12 + sealed XIII changed.
