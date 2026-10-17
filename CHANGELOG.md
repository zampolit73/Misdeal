# Changelog

Current implementation summaries only; the exhaustive pre-cleanup change history lives at [CHANGELOG archive](docs/archive/2026-10-15-pre-cleanup/CHANGELOG.md).

## 2026-10-18 — D232: one high-fidelity Sentinel 96px still and real Godot-scale comparison

- Avoided repeating the D215–D229 error of calling procedural/test-pose sprites visually final. Generated new Style-B long pointed spear/hood/rust-plate/amber-lantern references; rejected decorative multi-panel `25 frames` compositions as NON-Godot animation atlases.
- Isolated **ONE** individual figure from the illustrated reference, cleaned background alpha and nearest-scaled to 96×96. Original 115×129 cutout plus versioned single transparent WebP/Base64 committed as `assets/pixel/units/black_lantern_road_qa/road_sentinel_d232_{reference_cutout,single_96px}.webp.b64`; alpha bounds and lossless verification recorded in `docs/qa/D232_ROAD_SENTINEL_SINGLE_POSE_QC.json`.
- Added `res://scenes/dev/black_lantern_sentinel_d232_art_direction_preview.tscn` (D229 LEFT vs D232 ONE-POSE RIGHT, each x3 and true x1, exact approved D209 forest). **User-native F6/art decision still pending**, no fake 25 pose scenes or full combat claims.
- `MisdealUnitAnimationLibrary` and 37-card ordinary deck remain unchanged; sprite art finality still OPEN for Sentinel and four other role designs. Full handoff `docs/D232_SENTINEL_SINGLE_FRAME_ART_REVIEW.md`.

## 2026-10-18 — D231: Correct D230 premature Sentinel sprite-art 'FINAL' claim

- User explicitly objected that original atlas was much more beautiful than the newly registered sprite and asked what happened. Inspected actual local originals: `пиксельный_атлас_скелета_стража.png` **1254×1254** has far richer armor/cloak/lantern but incorrectly carries an **AXE**, and D221 accepted `лунный_страж_проклятой_дороги.png` **1672×941** has valid long spear but embedded presentation/background. Neither was transformed into transparent 25-frame game atlas; D229 was procedurally painted from geometric code and looks much simpler.
- Corrected acceptance boundary: the user chose D229 over D228 within two TECHNICAL 96px drafts, **not** as permission to abandon the rich final art quality. D230 art-final statement **superseded** by explicit user concern. D230 selected candidate/loader is retained as unused #38-only staging, not a visually finalized approved sprite; 37 cards live unaffected.
- New full handoff `docs/D231_SENTINEL_ART_FIDELITY_CORRECTION.md`. NEXT: verify appealing spear-bearing armor and lantern in single true game-scale frame, not yet another simplistic 25-pose version; then genuinely new high-quality 25-cel asset with native QA and later #38 integration. No actual art or release code changed by this correction.

## 2026-10-18 — D230: User final choice for second D229 Sentinel; exact production animation registration

- User explicitly selected **D229 SECOND (RIGHT) side-by-side Road Sentinel** as final art («давай примем 2 вариант и уже закончим с этим»). **Stop further Sentinel cosmetic passes**; D221 detailed concept remains historical inspiration only, not permission to override current final user selection.
- Promoted the **identical** approved original 25-frame WebP/Base64 atlas into `assets/pixel/units/deck_expansion_v1/road_sentinel_frames.webp.b64`. Source/canonical GitHub re-fetch comparison exact, no resizing or painting changes.
- Registered only `road_sentinel` in `scripts/battle/unit_animation_library.gd`, adding strong original-frame count/uniqueness/padding/unused-tile validation without touching other character art or Act1 card IDs.
- Corrected `scripts/battle/unit.gd` role-specific LEFT-authored atlas flipping for enemy-to-hero target facing; old combat roles behave unchanged.
- Added `res://scenes/dev/black_lantern_sentinel_d230_approved_smoke.tscn` with actual animation library source + final atlas identity check and five synchronized states at 3×/1× in both directions. **Native F6 still not received**, this is engine integration verification pending, NOT another artwork approval vote.
- Full milestone documentation: `docs/D230_ROAD_SENTINEL_FINAL_APPROVAL.md`. #38 still QA-only, Act1 37/45; other 4 enemies require final artwork and real battle route QA; KARAMBA73 untouched.

## 2026-10-18 — D229: side-by-side old/new Road Sentinel native-scale animation gallery

- User instructed continue after D228 art staging without confirming its native F6; retained D228 status as **pending**, NOT implicit PASS.
- Repainted native 96px forge-steel chest planes, segmented pauldron, hood edge and pointed spear highlight on all 25 pose-authored cels. D229 transparent WebP/Base64 original 576×480 6×5, 25 unique+5 empty, zero 2px cell-edge warnings, bit-exact PNG/WebP; 12,880 different RGBA pixels vs D228. Source `tools/art/author_road_sentinel_d229.py`, art `assets/pixel/units/black_lantern_road_qa/road_sentinel_d229_art_candidate.webp.b64`, QC `docs/qa/D229_ROAD_SENTINEL_ART_QC.json`.
- New `res://scenes/dev/black_lantern_sentinel_d229_compare.tscn` side-by-side real x1 plus x3 art comparison (D228 left vs D229 right, all 5 animations and both facing buttons synchronized) on exact approved D209 forest. No new production sprite switching.
- Actual x1 aesthetic improvement remains subtle; final user approved D221 Style B detail bar NOT met/declared passed. Native F6 pending. Keep original armor SPEAR, 5 skeleton roles and 37-card live pool untouched; frozen KARAMBA73 preserved. See `docs/D229_SENTINEL_NATIVE_SCALE_AB_REVIEW.md`.

## 2026-10-17 — D228: Road Sentinel original armor/cloth/spear/lantern pixel art pass

- Continued user's selected original D228 polish pipeline rather than distributing effort across other skeletons; no artwork choices re-opened.
- Reauthored native pixel geometry in **all 25** Sentinel state cels through new self-contained `tools/art/author_road_sentinel_d228.py`: irregular layered forged cuirass and pauldron, ripped oxblood mantle, real narrow steel spear with strapped shaft and short trailing ribbon, metal-caged Gothic amber lantern, while keeping original physically different walk/thrust/hit/death poses.
- Committed QA-only `assets/pixel/units/black_lantern_road_qa/road_sentinel_d228_art_candidate.webp.b64`, `docs/qa/D228_ROAD_SENTINEL_ART_QC.json`; **25 individual frames, 5 fully alpha-clear cells, 0 border warnings**, changed 29,154 RGBA pixels vs D227. Transparent WebP SHA `7ef8f0833a17d06812f7f472b8946f2bdcadc49dd3c0caf28f91adc750663322`.
- Added `res://scenes/dev/black_lantern_sentinel_d228_art_preview.tscn` and its GDScript with 3x/x1 gallery, both facing buttons, five animations on exact D209 forest. **Native F6 and final Style B art acceptance pending**, D227 preserved for comparison; no production sprite registration or real #38 release.
- Added `docs/D228_SENTINEL_ORNAMENTAL_PIXEL_ART_QA.md`, updated source-of-truth handoff. Act1 live 37/45; D196/D200/D209, boss XIII and KARAMBA73 untouched.

## 2026-10-17 — D227: Native 25-frame original Sentinel detail repaint and F6 staging

- User «хорошо» approved proceeding from D226 screenshot feedback; NOT final D226 art acceptance.
- Enhanced 25 individually posed Sentinel sprite cels with actual 96px-authored asymmetric plate armor, skull depth, mottled oxblood layered cloth, reinforced spear tip, moved iron-caged separate amber hanging lantern, guard boots; same authentic walk/thrust/hit/death pose logic. No image generator's wrong-role panel imported, no source sheet resampling.
- Added new versioned `tools/art/author_road_sentinel_d227.py`, QA asset `assets/pixel/units/black_lantern_road_qa/road_sentinel_d227_art_candidate.webp.b64`, `docs/qa/D227_ROAD_SENTINEL_ART_QC.json`. Offline validated **576×480 RGBA, 25 distinct authentic frames, 5 alpha-empty cels, zero 2px edge warnings**; WebP SHA `f1b50b919c76f5af9173ea33c77e484188077dbd72aee98110329210d84f7fbc`.
- Added `res://scenes/dev/black_lantern_sentinel_d227_art_preview.tscn` for two facing directions and all five animation states on approved D209 forest. **Native Godot F6 and polished D221 art fidelity acceptance PENDING.**
- D226 candidate preserved, runtime Battle/UnitData/RunState/forest/other 37 live cards/KARAMBA73 unchanged. Full checkpoint: `docs/D227_SENTINEL_PIXEL_FIDELITY_QA.md`.

## 2026-10-17 — D226 native screenshot result and D227 fidelity gap

- User sent actual Godot screenshot of `black_lantern_sentinel_d226_art_preview.tscn`: accepted D209 arena and both 3×/1× Sentinel views visible; shown `ХОДЬБА · ← ВЛЕВО` with no red QA error. Confirmed **gallery loads and left-facing walk pose displays**; cannot infer complete 5-state animation/right-facing PASS from a still.
- Art inspection: D226 is still visually technical/simplified compared to selected D221 highly detailed style-B armored spear Sentinel — thin/plain skull/chest shapes, flat iron, simple square lamp and insufficient native x1 detailing. **NO final-art acceptance**. Next is genuine artwork improvement to all 25 native 96px poses, not interpolation, forced rescale or toggling pixel filter. Original D226 retained for comparison.
- Only documentation changed in this pass. No production asset/animation library, arena, Battle, card pool, or immutable KARAMBA73 changed.

## 2026-10-17 — D226: Sentinel B-style native pixel art and new two-facing F6 scene

- User responded «все ок. давай дальше» to the D225 left/right Bearer gallery test; noted user-reported direction QA PASS, not full final-art/gameplay integration.
- Art generation initially produced a wrong Oil Acolyte presentation board; REJECTED with no import or misleading sprite claim.
- Authored new original per-frame Road Sentinel **96×96** pixel details using existing D215 pose/movement joints with rich rust-red cloth, deep hood and layered copper iron; kept real pointed spear + small amber lantern. Full **25 separate poses**, 5 empty/transparent unused slots, **0 edge warnings**, no rescaling-induced blur. `tools/art/author_road_sentinel_d226.py`, `assets/pixel/units/black_lantern_road_qa/road_sentinel_d226_art_candidate.webp.b64`, and machine-readable `docs/qa/D226_ROAD_SENTINEL_ART_QC.json`.
- Dedicated `res://scenes/dev/black_lantern_sentinel_d226_art_preview.tscn` + GDScript with both left/right directions, enlarged/native views, all five states on exact D209 arena. **User-native F6/final art fidelity acceptance pending.**
- Added `docs/D226_SENTINEL_STYLE_B_ART_QA.md` and updated context. No live sprites, Battle, deck #38, D196 surf, D200 card art, D209 arena, DS2 or frozen KARAMBA73 changed.

## 2026-10-17 — D225: Both-direction Lantern Bearer art gallery for native QA

- User D224 Godot screenshot confirms original accepted shield-and-handheld-lantern B art loaded at x3 and x1, with shield-attack shown and no red QA error; it does not prove every state or both directions.
- User asked whether animation was bidirectional and agreed to add preview controls. Read `scripts/battle/unit.gd` target-facing code; actual battle already uses `art_sprite.flip_h` but the isolated D224 gallery did not.
- Added `← ВЛЕВО` and `ВПРАВО →` buttons to **same** D224 Godot QA scene script; both sprites mirror together, label indicates active direction, start facing left toward heroes. No separate 25 frames needed. **Native Godot after change pending.**
- Reconfirmed both previews already use `TEXTURE_FILTER_NEAREST` and x3 integer scale; visible softness is inherited from downsampling original 1374×1145 illustration into 96px frames, so did not claim a fake filtering fix or modify locked art.
- Added `docs/D225_BEARER_FACING_PIXEL_CLARITY_QA.md` and aligned handoff/state/roadmap/decisions. No production Battle, source image, live 37-card pool or KARAMBA73 change.

## 2026-10-17 — D224: approved original 25-pose Bearer art preserved, standalone native grid QA

- User approved D223 corrected Bearer design («да все ок») and new dark-fantasy style-B 25-pose shield/hand-lantern original image («подходит»). Saved selected **1374×1145 PNG-visible pixels losslessly as WebP/B64** in GitHub QA asset `lantern_bearer_d224_approved_original_lossless.webp.b64`; PNG and WebP origin hashes in `docs/D224_LANTERN_BEARER_APPROVED_ART_QA.md`.
- Adaptive-repacked the image to Godot 576×480 6×5×96px and committed `lantern_bearer_d224_approved_repacked_candidate.webp.b64`: 25 unique pose cels, 5 empty clear slots, 0 new 2px border failures, byte-verified against GH upload. The source layout includes **overlapping neighboring cel artwork**; cropping may lose individual source pixels, so these metrics are technical QC only, not native art QA approval.
- Added reproducible `tools/art/inspect_and_repack_lantern_bearer_d224.py`, QA source/region data `docs/qa/D224_LANTERN_BEARER_ART_QC.json`, and isolated original-style Godot gallery `res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn`, with 3×/1× state buttons; **Godot F6 PENDING**.
- No changes to older D216 candidate, active animation library, real Battle, approved D209 arena, RunState 37-card pool, D196 waves, DS2, sealed boss or frozen KARAMBA73. D224 documentation added and handoff updated.

## 2026-10-17 — D223: corrected Lantern Bearer shield + separate lantern visual candidate

- After D222 rejected staff-bearing generated layouts, produced a new style-B Bearer composition and a cleanly **cropped, text-free character reference** `Misdeal_D223_Lantern_Bearer_Concept_B_Portrait.png` (388×386). Heavy iron-banded plank shield in one hand and an amber lantern in the separate free hand; no staff or spear. The background is still baked into the concept image.
- Presented design to user for **visual approval pending**. Not a native transparent atlas/25 frames, not committed as game art, no QA sprite replacement or card #38 release. Authored `docs/D223_LANTERN_BEARER_CORRECTED_CONCEPT.md` with source/crop SHA and next production gate.
- Retain D221 accepted Sentinel B look, D209 exact forest, normal pool 37/45 and frozen KARAMBA73.

## 2026-10-17 — D222: Lantern Bearer final-appearance concepts blocked by art QA

- After user requested to continue, attempted three B-style Lantern Bearer illustrations. All mistakenly added a long staff/diagonal pole and mounted lamp on wooden shield rather than separate heavy hand-carried lantern; assistant rejected concepts without requesting user accept compromised design. Those image panels contain simulated frame sheets and are **not actual 25-cel original sprites**.
- Logged precise rejection and next standalone full-body character look in `docs/D222_LANTERN_BEARER_FINAL_ART_REVIEW.md`; no art binary, Godot code, UnitData or release pool changes. Sentinel B look approval preserved; #38 QA-only, 37/45 cards live.

## 2026-10-17 — D221: group style B and detailed Sentinel character art accepted

- User selected illustration **B** as the cohesive dark-fantasy pixel direction for all 5 skeletons and replied «отлично» to the separately rendered plated/hooded long-spear Road Sentinel with suspended lamp.
- Approved the **visual character direction only**. The multi-scale concept image includes scene background and labels, **NOT a production 25-frame 6×5 transparent atlas**; no game art bytes or runtime animation registration changed.
- Added `docs/D221_SENTINEL_FINAL_STYLE_APPROVAL.md`; next character visual concept is Lantern Bearer in the same style, followed by real source-cel repaint/user approval. Live Act1 37/45, all other scenes and KARAMBA73 preserved.

## 2026-10-17 — D220: Isolated D219 user OK and hard final-art replacement gate

- User replied «все ок» after D219 standalone Lantern Archer preview F6 request. Treat as user-reported QA success only, not a full five-role motion video/production art acceptance.
- User explicitly asked whether five simple character sprites would later be replaced; confirmed YES. Locked that D215–D219 procedural 25-cel atlases are **temporary QA versions** and that ALL FIVE must be newly drawn to production dark-fantasy pixel-art quality, with real-size composition approval on D209 exact chosen forest BEFORE connecting finished characters into active battle/card #38. Preserve role-specific weapons/features, authentic 25 poses, alpha/foot QC; no upscaling or recycled skeleton sprites.
- Added `docs/D220_BLACK_LANTERN_FINAL_SPRITE_REPLACEMENT_GATE.md`; all changes to docs only. Act1 live 37/45, `RunState` and frozen KARAMBA73 unchanged.

## 2026-10-17 — D219: fifth original Lantern Archer 25-frame candidate and F6 gallery

- User gave positive feedback «отлично» after D218 Guide F6 request. This permits proceeding; native D218 full five-state motion still has no supplied detailed log.
- Created genuine QA-only 25-frame `lantern_archer` pixel-art atlas with curved bow, quiver, amber lantern, specifically differentiated six-frame draw/loose animation, two-grounded-step walk, recoil and collapse. Correct 576×480 alpha 6×5/96px in `assets/pixel/units/black_lantern_road_qa/lantern_archer_d219_candidate.webp.b64`, original reproducible `tools/art/author_lantern_archer_d219.py`.
- Addressed original bottom-bleeding death poses and unnatural upright quiver before export. Offline: 25 distinct nonempty, 5 unused transparent, zero 2px-border flags; GitHub Base64 exact text equality verified against local QA output.
- Added **QA-only** `res://scenes/dev/black_lantern_archer_animation_preview.tscn` / GDScript showing 3×/1× on accepted D209 arena with strict live image validation and five animation controls. Native F6 pending. No live sprite library, Battle, UnitData, projectile, card pool or KARAMBA73 changes. Detailed `docs/D219_LANTERN_ARCHER_ANIMATION_QA.md`.

## 2026-10-17 — D218 original towering Guide art/source and QA-only F6 gallery; D217 native post-fix PASS

- User replied «все ок» after the D217 original SVG death border fix and exact Godot F6 retest request. Treat D217 isolated user-native QA as PASS, not real combat.
- Added `tools/art/author_extinguished_guide_d218.py` (original 25 hand-directed pixel-frame configurations) and `assets/pixel/units/black_lantern_road_qa/extinguished_guide_d218_candidate.webp.b64`: 576×480 lossless alpha/WebP B64, 25 distinct populated cels, 5 entirely unused, zero offline alpha-boundary warnings after correcting original death drawing on extended canvas. Model has ragged large mantle, irregular armored shoulders, three chained lanterns on metal yoke, heavy attack/collapse.
- Added `scripts/dev/black_lantern_guide_animation_preview.gd` + `scenes/dev/black_lantern_guide_animation_preview.tscn`: exact D209 forest, original 1.8× Guide next to 1× Bearer at matched floor level, 2.8× detail and five QA state buttons with strict on-load checks. User-native D218 F6 pending; not a final battle-art approval. `docs/D218_EXTINGUISHED_GUIDE_ANIMATION_QA.md`.
- No production animation registry, collider, five-enemy stats, light bonuses or card pool changes; baseline 37/45 and KARAMBA73 remain safe.

## 2026-10-17 — D217 Godot border FAIL repaired in SVG art source

- User-native D217 F6 screenshot showed red QA FAIL on 0-based death row4 col4 and col5; backdrop D209 loaded fine. Investigated committed SVG and found exactly two late-death rib strokes extending into y94–96 outside the approved 96px-cell margin.
- Fixed only these SVG strokes in `assets/pixel/units/black_lantern_road_qa/oil_acolyte_d217_vector_candidate.svg` (commit `a8a80f1`). No tolerance changes to Godot's 25-frame/5-empty/border validator; post-fix GitHub geometry scan shows 25 groups and no predicted alpha-safe border violations. **Native Godot F6 recheck still pending.**
- Separate user D216 screenshot shows Lantern Bearer gallery renders at 3× + 1× and shield attack frame without red failure; five-state full artistic acceptance still not documented. All runtime scenes, card pool and KARAMBA73 unchanged.

## 2026-10-17 — D217: Oil Acolyte third original animation role, standalone QA only

- Drew a new 25-pose (idle4/walk6/attack6/hit3/death6) 576×480 RGBA Oil Acolyte **raster** candidate: light skeletal ritualist with separate green oil bottle, tiny amber belt lamp and curved open **sickle** instead of an early cleaver-like blade. Offline Pillow QA after edge fixes: 25 distinct visible, five transparent unused, zero edge contacts. This local raster PNG/WebP/B64 plus reproducible authoring code is available in a conversation ZIP, not committed as engine bytes.
- Added a **separate** original editable, transparent 25-state 576×480 SVG vector-cel QA candidate in GitHub: `assets/pixel/units/black_lantern_road_qa/oil_acolyte_d217_vector_candidate.svg`. Its graphics are **not byte-identical** to the raster candidate; do not substitute one QA result for another.
- Added `scenes/dev/black_lantern_oil_acolyte_animation_preview.tscn` and script; renders GitHub SVG using Godot SVG image decoder, does native post-decoding alpha/25-unique/5-blank/border inspections and displays all five states on the D209 accepted forest at 3× and 1×. **Godot F6 pending**.
- No new oil-burning mechanics, no modifications to `UnitData` stats, production animation library or live battle. D216 Bearer native F6 **still pending**, D215 Sentinel user accepted QA; deck remains 37/45, KARAMBA73 untouched. Detailed `docs/D217_OIL_ACOLYTE_ANIMATION_QA.md`.

## 2026-10-17 — D216: native D215 OK and QA-only 25-cel Lantern Bearer animation art

- User replied **«все ок продолжай дальше»** after D215 Road Sentinel animation gallery review; record user-native standalone gallery QA OK, not #38 battle release.
- Drew completely new flat pixel-art **Lantern Bearer** 576×480 RGBA row-per-state (idle4, walk6, attack6, hit3, death6), 25 individually articulated poses with wooden barricade shield and separately swinging amber lantern; 5 transparent unused cells and **zero border contact warnings** after shifting last falling poses.
- Committed lossless WebP/B64 under **QA-only** `assets/pixel/units/black_lantern_road_qa/lantern_bearer_d216_candidate.webp.b64`, confirmed GitHub encoded bytes match local source, source `tools/art/author_lantern_bearer_d216.py`, plus `res://scenes/dev/black_lantern_bearer_animation_preview.tscn` and controller. F6 native visual PASS **NOT YET REPORTED**.
- No shield mechanics, UnitData stat changes, production SpriteFrames registration, battle logic or regular deck changes. Detailed `docs/D216_LANTERN_BEARER_ANIMATION_QA.md`; Act1 37/45 and frozen `КАРАМБА73` preserved.

## 2026-10-17 — D215: First genuine spear Sentinel 25-frame QA candidate and native animation gallery

- Produced original 576×480 RGBA 6×5 atlas for D211 user-selected armored `road_sentinel`, through authored native-pixel limb/armor/spear/lantern cels rather than rescanning the rejected 5×5 axe sheet. **25 unique nonempty poses**, 5 alpha-empty, **zero cell-margin warnings** after death sprite adjustment; correct animation rows (4/6/6/3/6). First draft artistic fidelity is intentionally not described as user-approved.
- Committed lossless WebP/Base64 `assets/pixel/units/black_lantern_road_qa/road_sentinel_d215_candidate.webp.b64` and the reproducible offline `tools/art/author_road_sentinel_d215.py`. GitHub B64 matches generated source exact bytes.
- Added isolated F6 `scenes/dev/black_lantern_sentinel_animation_preview.tscn` and GDScript gallery, loads accepted D209 backdrop, performs cell checks and presents 3×/1× animations with state buttons. **Godot native test and final art sign-off pending**; no live animation library, battle scripts, UnitData or card pool changed.
- Current art QA gate: `docs/D215_SENTINEL_NATIVE_ANIMATION_QA.md`. Preserve accepted D200/D209 artwork and KARAMBA73. Live Act1 **37/45**.

## 2026-10-17 — D213/D214: Canonical original-animation master, full Lantern Bearer production spec

- User chose **D211 Armored Spear Sentinel option A** («а»), concept silhouette LOCKED only; five final sprite atlases remain uncreated/unapproved.
- Read actual `scripts/battle/unit_animation_library.gd` and found old chat's D212/D213 **sequential row-major** atlas layout contradicts the real per-state-row loader. Documented correct 576×480 RGBA, 6×5 cells, `idle4+2empty` / `walk6` / `attack6` / `hit3+3empty` / `death6`, 25 authored cels in `docs/D213_BLACK_LANTERN_MASTER_ANIMATION_BRIEF.md`. Do not use contradictory old chat diagram.
- Added `docs/D214_LANTERN_BEARER_PRODUCTION_SPEC.md`: thick-boned shield/plank escort with heavy lantern, detailed 25 individual animation-pose instructions, row-level correct Godot layout, alpha margins/leg placement/source-art/orientation QA and acceptance conditions. **Art brief only; no new shield gameplay.**
- Synchronized docs/DECISIONS, ROADMAP, PROJECT_STATE, HANDOFF and INDEX to preserve user approvals across chats. **No `.gd`/`.tres`/runtime sprite assets modified; Act1 37/45; D209 accepted forest and KARAMBA73 untouched.**

## 2026-10-17 — D211: Spear Sentinel A/B illustrated alternatives (art direction only)

- Created two isolated pixel-art **character silhouette concept crops**, both correctly show a LONG SPEAR unlike rejected D205 axe: A armored pauldron/lantern on shaft and B ragged hood/lantern on shaft. Comparison board `Misdeal_D211_Road_Sentinel_Concept_Options.png` contains native 96px cell scale sanity checks; source and board exist as conversation art only.
- **No real 25-frame atlas**, no isolated-alpha sprite and no native character motion approval; both diagonal spears reduce readable body size when forcing 96×96. User design choice A/B pending; next actual production needs new cel-accurate spearman, not cropping the concept sheet.
- Added `docs/D211_ROAD_SENTINEL_SPEAR_CONCEPT_OPTIONS.md` with strict exact-art/animation gate. No combat, card pool, accepted D209 arena or frozen KARAMBA73 changes.

## 2026-10-17 — D210: User-native D209 forest layout PASS; five-animation-sheet art audit

- User supplied screenshot of `black_lantern_road_arena_visual_preview.tscn` with correct third forest artwork, 3 hero + 5 enemy proxies, 2 legible light pools and replied «все ок». **D209 Godot visual-composition PASS** (not actual sprites/combat).
- Inspected all five D205 skeleton 5×5 concept atlases and their technical 6×5 remaps. Created conversation-only `Misdeal_D210_Animation_Review.png` and a QA ZIP/JSON summarizing states and frame-boundary warning counts 13/20/24/21/13; warns of Sentinel axe vs approved spear, missing distinctive bearer rig and oil-acolyte silhouette work. Art remains blocked; original animations not yet approved.
- Added `docs/D210_BLACK_LANTERN_ANIMATION_ART_QA.md` with acceptance contract; no new production sprite bytes, card pool changes, live combat wiring or changes to approved forest artwork. Baseline **37/45**, KARAMBA73 frozen.

## 2026-10-17 — D209: user-selected exact forest arena added to GitHub, native QA scene

- Imported **exact previously user-selected third** moonlit forest source as 1280×720 WebP/Base64 `assets/pixel/battle/arenas/black_lantern_road_arena_selected_v1.webp.b64`; 170,424 decoded bytes. Verified fetched GitHub blob SHA matches independently computed export Git blob SHA `6fad8192e4e2a9baa308db82e0ce84beeeb167ad`. No new art generation or substitute.
- Registered `black_lantern_road` in existing `scripts/battle/authored_backdrop.gd` loader without redirecting existing arenas, normal Battle scene or ordinary card offers.
- Added QA-only native `res://scenes/dev/black_lantern_road_arena_visual_preview.tscn` with the exact forest background, actual D206 lanternlight geometry/cue under 3 hero/5 enemy foot-contact envelopes (2× Guide), floor and pause controls. **Godot F6 not yet run**; not a playable card, rendered skeleton animation or art signoff.
- Details, hashes and next user test `docs/D209_BLACK_LANTERN_ARENA_NATIVE_QA.md`. D208 +22% speed trial remained reverted to +16%; live Act1 37/45 and frozen KARAMBA73 untouched.

## 2026-10-17 — D208 native QA PASS and local balance rollback

- User-provided Godot screenshot: D208 +22% scoped light trial **54/54 functional PASS**; 54 wins, zero defeats/timeouts, unchanged average HP 80/70/74%, worst HP 52/30/44%, and 13.2/14.6/13.3-second mean battles compared with D207 +16% (rounded displayed metrics).
- Measured actual attack exposure: **635 real enemy attacks, 59 under light (9.3%)**; 90 warnings, 11,433 active frames, 15,510 enemy-buffed frames, maximum 3 simultaneously lit. Increased raw attack-speed multiplier did not yield measurable aggregate difficulty difference at display precision.
- **Reverted +22% to prior validated +16%** in `scripts/battle/black_lantern_light.gd` (commit `cc624e3`), retaining D208 instrumentation for future route/zone timing analysis. No new post-revert instrumented native F6 is claimed.
- Next focus exact approved moonlit-forest backdrop/5 original skeletal atlas corrections and native readability, not stat inflation. Existing releases and KARAMBA73 untouched.

## 2026-10-17 — D208: Native D207 54/54 baseline and local light-risk pass

- User's real Godot screenshot confirms D207 54/54 completed, 54 wins, no party defeats or timeouts; 18 wins each by class and party size. HP avg 80/70/74%, worst 52/30/44%; individual deaths 0/2/4, durations 13.2/14.6/13.3s. Light 90 telegraphs, 11,434 active frames, 15,502 buffed-enemy exposure frames, max three buffed. Distinguish functional PASS from accepted difficulty/art.
- Made one controlled local change: `BlackLanternLightController.ATTACK_SPEED_MULTIPLIER` **1.16 → 1.22** for *lit enemies only*, no five-enemy global stat inflation or changes to existing live battles.
- Extended existing D207 54-case F6 matrix to label D208 and count *actual light-buffed enemy attacks* from existing `BattleUnit.diagnostic_attack`; new D208 Godot run pending. Full before/after source/QA notes: `docs/D208_BLACK_LANTERN_BALANCE_PASS.md`.
- Act1 stays 37/45, `КАРАМБА73` preserved, new arena/skeleton art still not imported/accepted.

## 2026-10-17 — D207: Native D206 contract PASS, isolated 54-case battle matrix staged

- User supplied **green native Godot F6 screenshot** confirming D206 five new UnitData, two five-enemy formations and enemy-only temporary light-buff/reset after typed-array fix.
- Added `scripts/dev/black_lantern_road_battle_matrix.gd` + `scenes/dev/black_lantern_road_battle_matrix.tscn`: deterministic **54 cases** with actual BattleUnit AI, 2 formations, Knight/Ranger/Mage, solo/duo/trio and 3 tactical orders, plus D206 scoped lanternlight. Captures wins/losses/timeouts, surviving HP, durations, casualties, illuminated enemy exposure, movement/clamp and buff cleanup.
- This is **diagnostic QA only**; battle simulation runs invisibly so no unfinished original enemy art is displayed or replaced by recycled sprites. No regular pool/real Battle route/source mechanics touched. D207 native F6 pending; code/source checks are not gameplay balance approval. Full contract: `docs/D207_BLACK_LANTERN_BATTLE_MATRIX.md`.
- Preserve existing live Act1 37/45, D196 waves and frozen KARAMBA73 checkpoint.

## 2026-10-16 — D206 hotfix: typed lanternlight arrays in Godot 4.7.2

- User-native F6 screenshot: runtime error in `scripts/battle/black_lantern_light.gd:109`, `Trying to assign an array of type "Array" to a variable of type "Array[Vector2]"`. Root cause was the conditional `get_pool_centers() if active else []` promoting the empty branch to an untyped array.
- Updated the staged encounter-only controller: initialize a strictly typed `Array[Vector2]` first, conditionally populate it, and avoid conditional expressions for typed zone arrays/returns. **Only the isolated QA light controller was changed**; regular battle remains untouched.
- Fixed in GitHub commit `9f751e7`; source review completed, **Godot-native F6 re-test pending**. Do not mark D206 smoke passed until user re-runs `res://scenes/dev/black_lantern_road_contract_smoke.tscn`.

## 2026-10-16 — D206: New five-enemy encounter data and scoped lanternlight source (QA-only)

- Created five **original** unbalanced `UnitData` candidates for `extinguished_guide`, `lantern_bearer`, `road_sentinel`, `oil_acolyte`, `lantern_archer`, plus a standalone `EncounterData` with two five-unit formations within existing battle bounds.
- Implemented independent, deterministic `BlackLanternLightController` (two moving light pools, telegraph, enemy-only temporary attack-interval multiplier, cleanup/reset). **Not wired into live battle or cards**; provisional parameters pending art and native balance.
- Added Godot F6 `black_lantern_road_contract_smoke.tscn` to verify resource identity, formations, buff scope and cleanup. Source committed, native run **NOT CONFIRMED**.
- Converted the user-selected exact option-3 forest scene to local 1280×720 WebP; exact original bytes and conversion hashes documented. **Neither local bitmap nor unresolved 5-role art candidates imported into GitHub.** Existing #34–#37, D196, DS2, Fate Spread and fixed `КАРАМБА73` backup preserved.
- Full contract and next handoff in `docs/D206_BLACK_LANTERN_ENCOUNTER_STAGING.md`. Live Act1 stays **37/45**, #38 QA-only.

## 2026-10-16 — D205 hotfix: Godot 4.7 parser type inference in lantern preview

- User screenshot showed Godot 4.7.2 parse error at `black_lantern_road_light_preview.gd:121`: implicit `opacity` inference from `abs(sin(...))` failed. Fixed with explicitly typed `float`, `absf()` and typed `v`/`eased` to prevent nearby inference issues. **Native re-test still pending**; change limited to isolated dev scene, no combat behavior or card pool changes.

## 2026-10-16 — D205: Selected forest artwork and isolated moving-lanternlight QA preview

- User selected **A: dead-forest bend** geography and then **the third** of 3 finished forest arena images (`лунная_дорога_через_туманный_лес.png`, 1672×941). Preserve as the selected scene source; no bitmap upload/engine stage claimed.
- Inspected five recent character concept sheets, each 1254×1254 RGBA in 5×5 format; remapped them offline to 576×480 6×5 candidate atlases, 25 distinct nonblank cells each with five blank cells. Detected 13/20/24/21/13 source-cell boundary risks and Sentinel's axe instead of approved spear. The generated animation QA pack is a chat artifact, not activated production media.
- Added offline developer helper `scripts/dev/stage_black_lantern_art.py` for deterministic candidate staging. **No new art bytes committed or live `unit_animation_library.gd` roles changed.**
- Added stand-alone QA-only `res://scenes/dev/black_lantern_road_light_preview.tscn` and controller. Two travelling pools, warning and pause button are demo-only; no combat buffs/damage/spawn/routing. Native F6 **NOT RUN**.
- Captured exact gates in `docs/D205_BLACK_LANTERN_ASSET_AND_LIGHT_STAGING.md`. Act1 **37/45**, #38 remains QA-only, `КАРАМБА73` frozen checkpoint untouched.

## 2026-10-16 — D204: Present three composition-only Black Lantern arena geographies

- Audited active repository and applied the four supplied DARK FORGE skill briefs. Rejected two accidental roadmap/infographic generations as unsuitable arena artwork; no incorrect bitmap enters the game.
- Created three distinct **conversation-only** 1280×720 pixel-style blockout PNGs: dead-forest bend, peat ford with dry central combat strip, and broken toll gate. Verified pixel dimensions and inspected the composition. These are technical **layout drafts**, not production background art and not user-approved assets.
- Documented A/B/C concepts and exact next art-approval gate in `docs/D204_BLACK_LANTERN_ARENA_BLOCKOUT_OPTIONS.md` and canonical handoff. **No runtime source/assets/Act1 pool changed**; frozen KARAMBA73 untouched, #38 still QA-only, Act1 37/45.

## 2026-10-16 — D203: Specialist-skill review of Black Lantern arena composition and combat clearance

- Read three user-supplied dark-fantasy designer, game-artist and developer SKILL.md archives and the art-style/QA references; project rules still override defaults.
- Rejected repeated fortress-on-hill/viaduct castle-scene generations as **not genuinely distinct** dark-forest arena options. No unapproved art imported.
- Verified existing D201 option #2 PNG at native 1280×720 and created a **conversation-only transparent staging-overlay test** with 3 hero proxies, 5 enemy proxies (2× Guide) and illustrative twin amber lantern zones. Floor region is derived from actual `battle.gd` coordinates; this is NOT Godot native F6 or implementation of the light mechanic.
- Documented 3 meaningful environment alternatives and artist/developer release criteria in `docs/D203_BLACK_LANTERN_ARENA_ART_QA.md`. Live Act1 remains **37/45**, card #38 QA-only, original D200 art and KARAMBA73 frozen restore branches unchanged.

## 2026-10-16 — D202: Freeze KARAMBA73 full GitHub-tracked project checkpoint

- User requested an explicit whole-project/context restore point tied to the recovery word **КАРАМБА73**.
- Frozen snapshot branch: `backups/KARAMBA73-2026-10-16`, including **all tracked** game code, scenes, Resources, `.webp.b64` art, `project.godot`, current docs and full Git commit ancestry. Source game mechanics and artwork unchanged by D202; only manifest/handoff/status/decision/index documentation added.
- Created `docs/checkpoints/KARAMBA73_2026-10-16.md` with the exact saved milestone (live 37/45, #38 QA-only, D200 art accepted, D201 arena approval pending) and **non-destructive** future restore steps: safety branch from then-current `main`, new commit using saved Git tree, no force push.
- Pending D201 concept art images produced in chat are **not part of the tracked game state**; they are not silently substituted as approved arena assets. User's untracked local files/caches likewise are not included in a GitHub snapshot.

## 2026-10-16 — D201: Record native card-art approval and start arena art selection

- User replied «вск ок» after requested native F6 preview of the exact D200 chosen third Black Lantern Road 448×274 card image. Mark **user-reported native card-art approval**; no independent Godot screenshot/log received.
- Next production stage is **2–3 original 1280×720 actor-free arena visual options**, clear road battleground with hanging lamps positioned outside fighter lanes. User must select one before it becomes the battlefield background.
- No gameplay, scripts, live deal registration, selected card art or opponent assets changed in this checkpoint; Act1 stays **37/45**, #38 remains QA-only.

## 2026-10-16 — D200: Install user-selected THIRD lantern-road card art for QA-only review

- User chose **third** of three newer standalone illustrated Lantern Road scenes after approving the five original skeletal enemy designs. Preserved exact chosen image (`лунный_марш_скелетного_легиона.png`) and exported it to text-free **448×274 WebP/Base64**. No rerender, replacement art or text in bitmap.
- Committed `assets/pixel/card_unification_v1/run/black_lantern_road_selected_v1.webp.b64` and strict cached `scripts/ui/card_unification_v1.gd` card-ID override; unchanged existing art catalog/UI.
- Added **QA-only** `resources/cards/black_lantern_road.tres` (Tier1 combat, encounter target still blank) and F6 `res://scenes/dev/black_lantern_road_card_preview.tscn`. It verifies exact 448×274 asset and confirms #38 is NOT in the 37-card live pool.
- **Native art preview QA pending**; arena, five original animation atlases and moving light zones are next. No gameplay/balance/#37 or Fate Spread edits.

## 2026-10-16 — D199: Approve Black Lantern Road five-skeleton concept for card #38

- User selected **gameplay proposal 3**, «Дорога чёрных фонарей» (Tier1 combat), then first among 3 moonlit forest-road image options. Rejected artificial detail noise and required Act1's skeleton-first enemy theme and **more than 3** actual enemy combatants.
- User then approved a cleaner road-scene revision and requested a **roughly 2×-height, truly distinct giant Lantern skeleton**. Last generated encounter/character sheet features **5 new skeletal roles** (large Погасший проводник; Носильщик фонаря; Страж дороги; Масляный служка; Стрелок фонарей). User approved with «последняя концепция подходит».
- Locked these choices in `docs/DECK_EXPANSION_D199_BLACK_LANTERN_ROAD.md`, `docs/DECISIONS.md` and the active roadmap/handoff. Moving, telegraphed lanternlight zones are the unique planned local mechanic; timings/damage stats still not implemented or balanced.
- **Reference sheet contains labels, therefore is NOT an approved runtime card bitmap or animation atlas.** Next production: clean standalone text-free 448×274 scene, walkable arena and five 25-pose original enemy sprites, with explicit art and Godot QA gates.
- **No runtime code or images modified by this documentation phase.** Live Act1 stays **37/45**, D198 released; card #38 remains concept-approved but not live.

## 2026-10-16 — D198 closeout: user-native card #37 release PASS; next D199

- After the requested Godot F6 full-pool `black_crossing_release_smoke.tscn`, the user replied **«все ок»**. Record **user-reported native release PASS** (not an independent engine log/screenshot). D197 Battle→Reward→Table route was already user-confirmed.
- `black_crossing` #37 is fully released in the **37/45** Act 1 pool. D191 54/54 combat still applies; D196 wave VFX remains the user's accepted-for-now presentation. No runtime code/art modifications in this closeout.
- Reconciled active project state, roadmap, encounter QA spec, decisions, visual registry, index and canonical handoff; next task **D199 gameplay concept choices for card #38** (8 cards remaining to reach 45).

## 2026-10-16 — D198: Black Crossing released into the 37-card Act 1 pool

- User confirmed the D197 native route (preflight → real battle → reward → table) with «Все ок». D196 surf is the approved current baseline for continued development; D191 native battle matrix 54/54 remains valid.
- Registered `black_crossing` as live Act1 **#37/45** in `RunState.ACT1_CARD_IDS`; card/encounter resource, scene art, original Ferryman/Drowned animation atlases and scoped wave mechanics unchanged.
- Updated D151, D152, D153, Bone Shepherd, D188 diagnostic/battle/release smoke guards, and legacy card/playtest previews for a **37-card** pool.
- Added `scenes/dev/black_crossing_release_smoke.tscn`: checks 37 unique real cards, originals, real full-pool random Tier1 offers across 80 seeded samples (NOT a forced two-card fixture), choice/completion/Fate Spread and sealed boss XIII.
- **Native D198 release smoke pending** — code in `main`, not yet a Godot PASS. Next: F6 the new scene; upon native PASS move to card #38.

## 2026-10-16 — D197: Black Crossing #37 release-route preflight

- User elected to leave D196 wave VFX as the current baseline and continue progression rather than tune surf further. D196 rendering and D191 battle logic untouched.
- Audited real Battle victory → Reward screen → RunState.complete_active_card() → Table code path. This is a source review, **not** native route confirmation.
- Added `scenes/dev/black_crossing_release_preflight.tscn` with production RunState/asset/encounter/deck/XIII audits and one button to launch real Black Crossing Battle→Reward→Table. Updated the existing Black Crossing playtest to support both QA-only 36/45 and future released 37/45 without changing its encounter routing.
- Kept `black_crossing` outside the ordinary random pool until native real reward route sign-off; D197 Godot preflight/result still pending. No gameplay or approved art changes.

## 2026-10-16 — D196: Advance Black Crossing breakers farther onto intact pier

- User native D195 screenshot: smoother foam, but the waves look static; requested a much more substantial forward-moving storm surge.
- Rendering-only: warning waterline advances from -91 to -62px relative to the foot contact; 1.6s impact begins continuously at -62px, covers 94px on screen rather than 37px, and then spreads semi-transparent, physically bounded runoff with moving broken foam across planks.
- No hitbox, warning/rest/slow timing, 43px left push, -30% movement, encounter stats, sprites, approved art or deck changes; D191 native 54/54 gameplay PASS remains valid. D196 visual F6 + real reward→table still required. Act1 36/45.

## 2026-10-16 — D195: Organic storm foam and breaker decay

- User native D194 Godot screenshot: wave size is an improvement, but evenly spaced light-blue triangular peaks look artificial; requested a professional animation pass.
- Rebuilt **render-only** foam from continuous asymmetric wave contours and three soft rounded irregular clusters per breaker. Denser 72-sample geometry, multiple flowing frequencies, quieter cold-blue tones, foam flecks, and visible wash/recede phase replace repeated polygon teeth.
- No changes to storm art, character animations, encounter balance, floor, wave hit lanes, 43px push, 30%/1.6s slow, or battle results. D191 **native 54/54** remains valid; D195 visual F6 and real reward→table route still require user confirmation, so live Act1 stays 36/45.

## 2026-10-16 — D194: Replace rejected spray scratches with true rolling breaker silhouette

- User D193 Godot screenshot and feedback: prior fragmented foam looked like tiny pale scratches on the deck despite the massive storm; not approved. D192 long turquoise banner was also rejected.
- Rebuilt encounter-only wave rendering as three offset overlapping storm swells with tapered 3D-like faces, raised and curling pale foam tops, animated chop, impact spray and a 38px shoreward sliding wash. Warning is darker and smaller than the impact.
- Left gameplay hit lane, knockback 43px left, 30% slow/1.6s, floor, animations, approved scene backdrop and original enemies **unchanged**. D191 native **54/54 FUNCTIONAL PASS** continues to apply, but D194 still needs Godot visual approval and real reward→table check. Act1 remains 36/45.

## 2026-10-16 — D193: Ground Black Crossing surf on planks

- Native D192 screenshot rejected: prior full-width bright turquoise water band appeared suspended at the far side of the board, above the foot line and distant surf.
- Replaced **only wave drawing** with shallow segmented tapering stormwater washes placed at the animated sole-contact level (+36px from UnitsLayer origin); staggered breaking foamy tongues, restrained bubbles and desaturated low-alpha blues; visible deck gaps throughout.
- No `BlackCrossingFloor`, battle unit, hit lane, push, slow or other combat logic change. D191 native **54/54 gameplay PASS** remains valid; D193 Godot **visual** approval and real reward→table are still outstanding. Live Act1 36/45.

## 2026-10-16 — D192: Fuller breaking surf, native 54-case confirmation

- User native D191 F6 screenshot **54/54 wins, 0 full defeats**; 18 wins for every party size and protagonist, mean HP 86/74/77%, worst 58/42/50%; 78 warnings, 62 wave impacts, 66 pushes and 66 slow resets.
- User real-battle screenshot still showed D189 wave as thin artificial line. Replaced *only* Black Crossing's procedural drawing with layered sea-body polygons, an advancing lifting crest, irregular curled whitecaps, swells, broken wake and restrained spray.
- Left `BlackCrossingSurgeController` gameplay timings, damage, hit lane, push/slow, floor bounds, enemy stats and original approved artwork unchanged. D192 native **visual** F6 is pending; reward→table and #37 release not yet approved. Act1 remains 36/45.

## 2026-10-16 — D191: Black Crossing native-QA parity hardening
- Inspected current GitHub `main` and D190 handoff; D189 surf/floor source exists, native Godot still unavailable in assistant environment.
- Updated Black Crossing 54-case smoke to mirror real battle solo/duo/trio hero spawn positions, floor-depth mapping, and initial placement clamp; replaced artificial hero positions.
- Set explicit release gate of 54/54 wins (not merely 54 completed cases), preserving per-frame plank legality and post-combat slow reset checks.
- No arena/card/unit bitmap, enemy stats, wave behavior, party scaling, or live deck change. Await native F6 playtest + matrix + reward→table confirmation; 36/45 live.

## 2026-10-16 — D190: New-chat checkpoint after D189
- Rechecked live GitHub source; **D189 surf-animation and safe-pier movement correction already committed**, so no duplicate gameplay patch.
- Rewrote canonical `docs/HANDOFF.md` with pre-fix Godot screenshot metrics, the exact two visual issues, D189 code paths and the **post-fix F6 retest still required**.
- Corrected stale status in `PROJECT_STATE` (Black Crossing QA-only `CARD_PATHS` lookup) and stale D187 preview-pending wording. No gameplay, stats or approved art changed; Act1 remains 36/45.

## 2026-10-16 — D189: Black Crossing rolling surf and intact planks fix
- User's native D188 smoke screenshot: historical 54/54 functional PASS (85/78/84% average HP; 81 wave warnings, 58 strikes, 71 pushes and 71 cleanup resets). Separate battle screenshot shows amber rectangle wave and actor soles standing on broken forward beams.
- Replaced overlay rectangles with animated irregular sea foam, crest, water body and spray. Shared `BlackCrossingFloor` gives consistent intact-deck movement bounds for battle spawn/AI, hero drag zone, wave knockback, and 54-case matrix; wave lanes moved to the middle of the deck.
- Strictly local D188 art/geometry change; does not modify enemy HP, run pool or accepted original art. **Native Godot retest after D189 is pending**; prior 54/54 is not a substitute.

## 2026-10-16 — D188: Original Black Crossing battle & scoped wave QA
- User confirmed D187 arena Godot F6 OK; unchanged user-approved selected storm plate and original 25-frame Ferryman/Drowned art.
- Added two unique UnitData and two-placement 1+2 Ferryman/Drowned encounter, QA-only card lookup (not live in Act1), and neutral warned wave strip with bounds-safe push and temporary 30% movement slowdown.
- Added 54-seeded real BattleUnit matrix and isolated real Battle→Reward→Table playtest. Subsequent pre-D189 native matrix confirmed 54/54 functional PASS, but visual/off-floor defects required D189. Act1 remains 36/45.

## 2026-10-16 — D187: Black Crossing storm arena selected and source-integrated
- User approved final clean stormy "Последний причал" after removing the repeated left ruin and right background pier-frame; exported exactly this final image to 1280×720 WebP/Base64.
- Added unique `black_crossing` arena lookup/presentation in existing authored backdrop and visual scripts and clean 1280×720 F6 preview. No crypt atmosphere, no sprites or UI baked into the art.
- Native Godot arena check pending. No encounter waves, enemies/resource data, battle QA or Act1 pool change (36/45).

## 2026-10-15 — D186: Black Crossing original animation visual QA accepted
- User reported «все ок» after F6 for `scenes/dev/black_crossing_animation_preview.tscn`, accepting original Ferryman B and Drowned C five-state animations; no gameplay, art bytes or balance edits needed.
- Began D187 original arena art direction; three distinct 1280×720 battle backdrops to be reviewed before importing anything. Live pool remains 36/45.

## 2026-10-15 — D185: Original Black Crossing combat atlases installed
- Uploaded full Ferryman and Drowned 576×480 atlas WebPs into Godot-compatible tracked `.webp.b64` under `assets/pixel/units/deck_expansion_v1/`; each has 25 distinct/padded cells and 5 unused blank cells verified after local decode.
- Removed visibly disconnected Drowned pixel fragments; retained approved source design and documented one Ferryman derived attack-transition pose.
- Confirmed GitHub blob SHAs match the local encoded raster bytes. Native Godot F6 original-enemy animation acceptance still pending; no #37 encounter, waves, battle or live-pool change.

## 2026-10-15 — D184: Approved Black Crossing combat art and staged original role loader
- User confirmed Ferryman B / Drowned C and approved both generated original animation sprite-sheet previews.
- Locally created two 576×480 atlas candidates, checked 25 distinct alpha-padded poses, five unused transparent cells, documented the Ferryman's originally missing sixth attack pose. Remote raster upload was subsequently completed in D185; native F6 remains unverified.
- Added strict no-fallback D183 role support to MisdealUnitAnimationLibrary and an isolated F6 gallery; **the two `.webp.b64` files have not been committed**. All existing characters, encounters and live pool (36/45) remain untouched.

## 2026-10-15 — D183: Black Crossing card-art native acceptance
- User F6 screenshot + «утверждено»: original third D182 card illustration PASS in the intended 448×274 framing.
- Next combat models need separate silhouette approval, full original 25-frame sprite animation sheets and native QA; no changes to live cards or encounters.
- Current live Act1 **36/45**; release #37 remains gated by original enemies, independent arena, wave mechanic and battle/reward route.

## 2026-10-15 — D182: Black Crossing #37 direction approved, QA-only candidate staged
- User selected new drowned ferryman + two drowned corpse encounter with timed, telegraphed waves, and card-art option #3 (diagonal pier composition).
- Added standalone `resources/cards/black_crossing.tres` and detailed handoff spec; **no live registry/pool change**.
- Approved exact option-3 448×274 image now committed as `black_crossing_approved_v1.webp.b64`; strict loader and F6 art preview added. Remote text matched source export exactly. Native preview and enemies/arena/waves are pending; Act1 remains 36/45.

## 2026-10-15 — D181: D153 release-routing smoke confirmed in Godot
- User screenshot confirms F6 `D153 / ACT 1 RELEASE — PASS`: 36 unique cards, Tier1 controlled offer/choice, encounter routing, Fate Spread resolution, boss XIII gate.
- No gameplay or source edits required. Release #36 verified with this deterministic route fixture; randomized multi-run offer frequency remains untested.
- Next original #37 gameplay and art concept selection pending; D143/D167/D168 remain mandatory.

## 2026-10-15 — D180: D153 releases as Act1 card #36 (native smoke subsequently passed D181)
- Added `threadbare_theatre` to the normal Tier1 `ACT1_CARD_IDS` pool; now 36 unique nonboss cards.
- Fixed former 35-card assumptions in D151/D152/D153 smoke scenes and playtests, avoiding false failure after release.
- Added `threadbare_theatre_release_smoke.tscn`: tests real RunState offer, card selection, encounter routing, Fate Spread choice and boss XIII gating in a deterministic two-card Tier1 fixture.
- Previously confirmed native D176/D177 54/54 combat matrix remains valid for unchanged D153 values. Post-release deterministic normal-deal Godot F6 was subsequently confirmed PASS (D181).

## 2026-10-15 — Documentation hygiene (D179)
- Archived exact pre-cleanup copies of AGENTS, PROJECT_STATE, ROADMAP, DECISIONS, CHANGELOG, old handoffs, visual registry and D153 working docs.
- Consolidated current-state, release gates and next steps into a short canonical set with `docs/INDEX.md` and `docs/HANDOFF.md`; preserved full historical decision references.
- Updated README to the current playable game instead of the original early prototype; clarified Godot/dev test boundaries.
- No changes to gameplay, card pool, unit stats, mechanics, accepted art, or scenes.

## 2026-10-15 — D153 post-balance QA (D176–D178)
- D176: encounter-only Puppet Master/Marionette HP/damage/cadence/movement pass; no global balance changes.
- D177: restored resource serialization, added exact-path `UnitData` diagnostic.
- D178: user native Godot F6 54/54 FUNCTIONAL PASS; average survivor HP 74/67/74% solo/duo/trio, worst 39/15/37%; 123 link / 91 break / 54 master-death breaks.
- Historical D178 state: D153 was QA-only outside the 35-card pool. D180 has activated it; normal-deal regression check pending.

## 2026-10-15 — D153 original art and real battle
- User-approved skeletal marionettes, original crowned puppeteer, 25-pose original animations, selected gothic theatre card scene and moonlit ruined-stage battle arena committed.
- Encounter-local ThreadTether integrated into the real Battle flow (32% mitigation/285px); user previously confirmed battle→reward→table.
- Pre-balance matrix: 54/54 functional PASS with ~85/82–83/86% remaining HP, prompting localized D176 tuning.

## Previous released milestones
- D151 Funeral Procession: original skeletal units/Last Rite, live card **34/45**.
- D152 Defiled Laboratory: original toxic-hazard encounter, environment-led art, live card **35/45**.
- DS2 and Fate Spread Variant C established; earlier events, arenas, tactical cards, UI passes preserved in the archive.
