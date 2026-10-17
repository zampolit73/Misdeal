# D222 — Lantern Bearer final style-B artwork: concept attempts REJECTED, precise gate

Date: 2026-10-17. STATUS **NOT APPROVED / NOT A SPRITE ATLAS**. This is an art-QA decision for continuing the user's request to replace five technical skeleton sprites with finished original artwork before card #38 ships. Act1 remains **37/45**, #38 QA-only.

## Binding references

- User-approved art direction **B** for the whole five-skeleton lineup (D220).
- **Road Sentinel** detailed armored long-spear illustration user-approved with «отлично» (D221), visual direction only; not an animation atlas.
- Exact third moonlit forest arena D209 and chosen D200 card artwork remain immutable.
- Lantern Bearer equipment/character contract D213/D214: **broad skeleton, rustic heavy plank barricade/board shield in one hand, genuinely separate heavy hand-carried amber lantern in the OTHER**, no polearm/spear/long staff. Animation gesture later: short **SHIELD BASH**, not thrust. These are art identity constraints; no invented active blocking mechanics.

## What was generated and why it was not accepted

During D222 a series of **three illustrative, background-composited, UI-labeled concept-animation boards** were generated for `lantern_bearer` in group style B. These **are not 576×480 source atlases** and were not committed to production. All three repeatedly depict a **long staff/pole in the non-shield hand** or as a diagonal staff across the chest while the glowing lantern is fixed to the wooden barricade. This violates the locked identity of Lantern Bearer and makes the figure appear like the already approved **Road Sentinel spear carrier**. They also contain fake/baked row captions and export specifications; neither claims of `25 original frames` nor `ready for integration` printed in illustrative images are evidence of genuine animation or a valid transparent atlas. The assistant explicitly rejected the result; the user has NOT approved any of the three images.

**Source conversation illustration references:** generated `wide_cinematic_game_concept_animation_sheet_in_dar.png` (attempt 1), `a_widescreen_dark_fantasy_pixel_art_concept_anima.png` (attempt 2), `a_dark_high_detail_pixel_art_concept_animation_sh.png` (attempt 3). They are conversation media, NOT current GitHub production art and must not be substituted in `unit_animation_library.gd` or D209 arena.

## Exact next character art gate

Generate/paint **ONE isolated full-body Lantern Bearer on a plain transparent or quiet neutral backdrop**, not a decorative image board or a complete generated 25-pose animation sheet.

- FACING LEFT (enemy situated at right of arena); keep left-facing shield forward, other hand visibly separate.
- WIDE crooked wooden board (2–3 planks, rusty iron reinforcement), gripped at torso height; skull and legs visible.
- Other hand is OPEN and visibly holds the short handle of a **separate iron-framed heavy lantern suspended beside its hip**. The flame is dim amber. **Absolutely NO spear, staff, pike, rod, halberd, sword, axe or diagonal shaft.**
- Thick exposed bone, bulky strapped pauldron, faded oxblood mantle. Older, functional roadside guard; substantially shorter than towering Guide, and less armored/less military than approved Road Sentinel.
- Pixel-native chunky silhouette legible at ≈96px; foot sole visible, no impossible hand anatomy or over-detailed dust.
- Once character silhouette is actually correct, ask user art approval. Only then paint **25 individual meaningful transparent cels in correct rows** (idle4, walk6, attack6, hit3, death6 in 576×480 RGBA, 6×5×96px, 5 unused fully transparent, border safe), native gallery F6 then group scene with all five on exact D209 arena.
- Do NOT fake 25 actual cels by cropping a composite illustration, and DO NOT release #38 with D215–D219 simplified QA sprites.

No actual `.gd`/`.tscn`/`.tres` or game asset changes were made in D222; the present image attempts were rejected in assistant review, not signed off by user. Preserve KARAMBA73, old encounters and 37-card pool.
