# D146 — Bone Shepherd visual parity pass (2026-10-14)

## User directive — binding
The user rejected D144/D145 flat SVG Bone Shepherd, Ossuary Lamb and card artwork as **not compatible with previously approved Misdeal visuals**. Stop adding new cards or treating D145 sprites as approved. Rework all three **to match the already-approved in-game references**, not a merely DS2-colored geometric or retro UI sheet.

## Actual visual source-of-truth, inspected in GitHub
- `assets/pixel/card_unification_v1/run/bone_patrol.webp`
- `assets/pixel/card_unification_v1/run/bone_swarm.webp`
- `assets/pixel/card_unification_v1/run/grave_crossfire.webp`
- `assets/pixel/units/combat_units_anim_v2/knight.webp.b64`
- `assets/pixel/units/combat_units_anim_pack2_candidates/bone_warden.webp.b64`
- `docs/DESIGN_SYSTEM.md` canonical DS2 and Fate Spread Variant C, which MUST remain untouched.

**Important finding**: the approved run-card images are cinematic, richly painted dark-fantasy illustrations with deep moonlight, intricate silhouettes, credible weathered materials and composition, **not simplified illustrative pixel-collages or UI screenshots**. The battle units have significantly more material detail, dimensional forms and 5-state full-frame acting than D145's SVG shapes. Matching a palette alone is NOT visual parity.

## Production requirements
1. **Card** `bone_shepherd`: an original scene showing 1 distinct hooded skeletal Shepherd with hooked lantern-crook and 2 horned quadrupedal Ossuary Lambs; grim moonlit cemetery, restrained warm lantern vs cold moonlight. Must be **standalone 448×274 art with NO baked title, border, paragraph, icon, buttons or healthbars**, because the existing game card UI supplies its own chrome and text. Same production-level painterly finish/composition as the three reference WebPs. Original roster remains 1+2.
2. **Shepherd unit**: genuinely separate idle 4, walk 6, attack 6, hit 3, death 6 frames, exact atlas **576×480**, 6×5 **96×96** cells. Lantern/crook, skull, aged cloth/ribs; readable actual silhouette at 1280×720 battle scale, consistent body size/origin and planted feet. Do not fake animation by duplicating a single unchanging pose.
3. **Lamb unit**: the same 25-frame / 5-row atlas and size; four legs grounded, horns, skeletal anatomy, funeral cloth, directional continuity across frames, credible dash, attack and death.
4. Use the proven unit presentation approach (existing WebP.b64 animation packs) and image textures if a genuine raster paint pass is produced. Existing SVG loading can be replaced narrowly for these roles only after candidate quality and in-engine QA. Do not restyle approved Knight or existing enemies.
5. Keep `EncounterData`, `UnitData`, Whistle cooldown/rush, targeting, roster, stat scalers, Fate Spread, run-length and existing 18 approved card/reward illustrations unchanged.

## Review gates / what is NOT done
- Image-generation attempts in this session produced **concept boards with baked layout, text, pose galleries and pixel-art mockups**, not individually production-ready painterly game textures. They are NOT approved, NOT imported, and MUST NOT silently replace the live textures. Last concept generation IDs (reference only): `183f119f-9b45-4222-a589-6cbe821dd472`, `d21574c0-8061-493e-8e41-fdee892a5d90`, `40749b7a-a52e-4f82-97c5-488b3ae848a4`, `d6e1b7d5-7e36-49bf-808d-d558eaef5731`.
- **No new runtime assets or animation atlases have been committed as part of D146 yet.** D145 remains installed but visually rejected. Do not claim its acceptance.
- Next: create **one true full-bleed painterly 448×274 card-art candidate** matching the exact sample WebPs; show it beside approved `bone_patrol`/`bone_swarm` and obtain the user's visual review. Next author 2 complete genuine 25-frame enemy atlases, validate ground baseline and action silhouettes before replacing live sources. Commit approved binaries (the repo has an established Git blob workflow for WebP) and narrow loader changes, then run F6 art gallery, battle playtest, smoke 54/54.
- After the actual visual update, update `PROJECT_STATE`, `ROADMAP`, `DECISIONS`, `VISUAL_ASSET_REGISTRY`, `CHANGELOG`, `NEXT_CHAT_HANDOFF`. Older D142 HUNT/duo imbalance remains separate and unresolved.

This document is a precise art direction/acceptance brief, **not a claim of new art implementation**.
