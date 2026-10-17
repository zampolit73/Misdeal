# D229 — Road Sentinel native-scale A/B art comparison, not a final sprite

**LATER OVERRIDING USER DECISION D230:** User explicitly chose the RIGHT/SECOND D229 as FINAL («давай примем 2 вариант и уже закончим с этим»). D229 artifact is now accepted and promoted unchanged to canonical `road_sentinel_frames.webp.b64`. All art-polish concerns/pending art votes below are historical as of D230; see `docs/D230_ROAD_SENTINEL_FINAL_APPROVAL.md`. **Native loader smoke still pending; #38 not yet in ordinary pool.**

Date: 2026-10-18. Status: **SIDE-BY-SIDE GODOT QA COMMITTED, NATIVE F6 / FINAL ART APPROVAL PENDING.** Live Act1 remains **37/45**, #38 stays QA-only. Do not confuse a user request to «продолжай» with acceptance of D228.

## Why this stage differs from D226–D228

After 3 successive native-96px art revisions, the visual change at game scale **×1** remained modest even where enlarged ×3 artwork looked more elaborate. The user has repeatedly asked for a **beautiful final sprite** approaching the already-approved Style-B armored spear Sentinel reference (D211 A + D220 B + D221). More sequential microscopic pixel detail passes are a poor substitute for a **direct visual comparison** with strict acceptance criteria. This stage adds synchronized old/new x1+x3 Godot gallery, not an unearned "production art passed" claim.

## Specific art source changes

New reproducible true native 96px source `tools/art/author_road_sentinel_d229.py` retains D228's 25 individually authored full-body idle4/walk6/attack6/hit3/death6 positions and silhouette: skeletal **armored LONG SPEAR guard** with bronze-framed hanging amber lantern and worn burgundy cloth. The new geometry deepens silhouette blocks at standard game scale:

- Actual dark-steel **left/right chest facets** and central seam instead of narrow repeated horizontal vent strips; bulkier segmented outer pauldron, collar and shoulder hinge; revised dark faulds/waist plates.
- Hood/shadow edge and iron cheek rim repositioned in relation to original moving skull (still correctly skeletal, no magic face substitution).
- Directional forge highlight on the existing **pointed spear** blade, not axe/halberd. All 25 poses keep their previous distinct spear/foot contact logic.
- No shaders, recolor-only filter, copied generated concept frames, baked environment or upscaled/blurry raster art. Art is deterministic per-pose native-scale geometrical pixel painting.

**Technical LOCAL validation:** `576×480`, six 96px columns, five animation rows, **25 authored unique nonempty cells + 5 wholly transparent unused**, and **ZERO** 2px cell-border collisions. Decoded WebP exactly matches original PNG pixels; previous D228 remains intact. Compared to D228, **12,880 of 276,480 RGBA pixels** changed (4.66%); 1,686 pixels changed transparency/outline. SHA-256 decoded WebP bytes **`dd8ab21d7e115fe23418778a40e8f27e01abace9f3ccb1630025a09d318d2618`**. This verifies a true source modification, **not that the art necessarily looks significantly better**.

## GitHub files

- `tools/art/author_road_sentinel_d229.py` — standalone artist, reused original authored motion coordinate matrix.
- `assets/pixel/units/black_lantern_road_qa/road_sentinel_d229_art_candidate.webp.b64` — transparent lossless candidate WebP/Base64.
- `docs/qa/D229_ROAD_SENTINEL_ART_QC.json` — dimensions, cell counts, SHA and changed pixel count.
- `scripts/dev/black_lantern_sentinel_d229_compare.gd` + **`res://scenes/dev/black_lantern_sentinel_d229_compare.tscn`** — new **side-by-side** D228 (LEFT PANEL) vs D229 (RIGHT PANEL) viewer. Each shows the native ×1 and nearest-neighbor ×3 frame. All **five animation states and both ←/→ facings are synchronized** across the four live view sprites, using original approved **D209 exact moonlit forest**. Both atlases independently pass in-Godot size / 25 frames / distinctness / padding / five clear-cell validation (native F6 still unverified).
- Local conversation-only `D229_D228_comparison.png` (x3 and exact x1), `D229_sentinel_animation_contact_sheet.png`, source/asset/QA ZIP `Misdeal_D229_Sentinel_Compare_QA.zip`. These local previews are not production files.

**No old D215/D226/D227/D228 sprite, original approved D221 art reference, enemy `.tres`, `MisdealUnitAnimationLibrary`, regular `BattleUnit`, D209 forest, `battle.gd`, `RunState`, or any shipped cards changed.** KARAMBA73 backup is frozen.

## Acceptance and next user action

Execute `git pull`; F6 `res://scenes/dev/black_lantern_sentinel_d229_compare.tscn`. Review **two versions simultaneously** on accepted forest in normal x1 (not just x3). Click WALK, ATTACK, DEATH in BOTH directions and judge actual silhouette readability, riveted armor, leg contact, spear thrust, lantern and death hold. **Native scene has NOT yet been run by the user**, and an error screenshot must be diagnosed/fixed directly through GitHub.

**Explicit art conclusion:** Offline side-by-side crop inspection finds the D229 x1 difference still somewhat subtle compared to D228; D229 **IS NOT CONFIRMED TO MEET** rich D221 illustration quality, nor is it ready for production role registration. If user does not prefer it at x1, STOP the series of tiny procedural detail revisions; before further 25-frame drawing, investigate a more expressive whole-silhouette, more artist-authored quality reference / layered pixel production pipeline that actually improves final x1 readability **without changing Godot's global 96px/6×5 animation format or replacing accepted design**. Discuss any fundamental renderer/asset-budget changes with user before implementation, instead of quietly calling them finished.

After accepted art for five original skeletons: combined 3heroes-vs-5enemies composition, real #38 encounter-only light, actual Battle→Reward→Table, 54-case balance matrix/full-pool smoke, then and only then 38/45 live.
