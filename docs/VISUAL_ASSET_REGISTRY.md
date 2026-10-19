## D255 — User-approved visual direction for all three missing #38 enemies; 75-cel QA pack staged, ART GATE OPEN

## D281 — Native 1280×720 pure background for ClassSelect

**Correct production asset**: `assets/pixel/class_select/d281_clean_table_hd.webp` (1280×720, 168,948 bytes, SHA256 `7464edde5990b53a6d1ec8d1646e96080c9944be0a4a79e04bdba6689d5f28e1`). High-quality export from previously generated 1672×941 clean wizard/table master, NOT upscale of previously damaged 640x360 art. ClassSelect loads it with `scripts/ui/runtime_webp_texture.gd`. Legacy `d280_clean_table_01..04.webp.b64` and `class_select_clean_backdrop.gd` deleted. Existing logo keyed with `shaders/class_select_logo_key.gdshader` on this scene. Native Godot test PASS; user visual re-review OPEN.

---


## D266 — Court three original 25-pose QA animation sources, visual art acceptance OPEN

`assets/pixel/units/court_of_the_mute_qa/{mute_magistrate,ash_scrivener,bone_bailiff}_d266_qa.webp.b64` contain three independent 6×5×96 transparent original pose series, idle4/walk6/attack6/hit3/death6 and five clear spares each. [75/75 structural QC](qa/D266_THREE_ROLE_FULL25_AUDIT.json) and native F6 x1/x2 PASS. **These original procedurally drawn character sheets are stylized simplified QA candidates, not visually approved game-ready rich characters**. No library registration, #39 still unreleased. [D266 report](D266_COURT_ALL_THREE_ANIMATION_QA.md).

## D265 — New richer Court EMPTY battle plate, original 3×25 character art still missing

`assets/pixel/battle/arenas/court_of_the_mute_d265_rich_qa.webp.b64`, original 1280×720 lossless character-free tribunal QA with added stone/lighting detail. Native F6 `res://scenes/dev/court_of_the_mute_d265_richer_arena_preview.tscn` Godot 4.7.2 PASS, **G** shows same screenshot-approved lower floor. D263 source and selected second D261 448×274 card image untouched. **Not artistically accepted as production**. D265 all-three [strict original 75-pose intake](qa/D265_THREE_ROLE_FULL25_AUDIT.json) = **0/75 accepted; Magistrate/Scrivener/Bailiff complete transparent sprite atlases not provided**. Do not register fake proxy grids. [D265 detailed art gate](D265_COURT_RICH_ARENA_AND_ART_AUDIT.md).

## D263 — Empty Court architecture QA candidate, NOT production/approved arena

User-approved SECOND D261 `court_of_the_mute_selected_v1.webp.b64` card image remains byte-identical. D263 source-authored empty `1280×720` Court architectural plate: `assets/pixel/battle/arenas/court_of_the_mute_d263_qa.webp.b64` (stage-only), giant scales, stone bench, arches, walkable floor, NO baked combat characters. Native F6 at `res://scenes/dev/court_of_the_mute_d263_empty_arena_preview.tscn` Godot 4.7.2 PASS; artistically simplified, **NOT yet approved or registered for real Battle**. Generated art montage has incomplete/small opaque pose grids; do not declare 25-frame Magistrate/Scrivener/Bailiff or substitute prior unit art; full three original 25-frame packs still pending. [Detailed D263 source/QC](D263_COURT_EMPTY_ARENA_QA.md). Live 38/45, KARAMBA73 frozen.

## D261 — Court of the Mute #39, user-approved SECOND portrait composition

User selected D261 A and specifically **image #2** of three rendered `Суд безмолвных` art options. Exact portrait source `мрачный_трибунал_у_трона_смерти.png` (1086×1448, SHA256 `3b1abff4...`) depicts judge center, scribe right, two bailiffs guarding, giant hanging scale and ruined tribunal. GitHub selected export: `assets/pixel/card_unification_v1/run/court_of_the_mute_selected_v1.webp.b64`, source crop x0–1086/y222–886 resized without distorting figures to 448×274. WebP SHA256 `704eef55...`; Godot 4.7.2 native art preview CI PASS. The selected scene is **card art only**; it is NOT a combat background and does not substitute new full-body sprites. Arena and full 25-frame `mute_magistrate`, `ash_scrivener`, `bone_bailiff` still pending, #39 QA only, Act1 **38/45 LIVE**. [D261 exact choice and crop report](D261_COURT_SELECTED_ART_QA.md). KARAMBA73 unchanged.

## D260 — Original Black Lantern Road card art/arena/five sprites LIVE

Act1 **38/45**: real released `black_lantern_road` uses unchanged exact user-chosen D200 moonlit skeleton column image and D209 forest battle artwork. Five original 25-pose character roles are loaded strictly via game `MisdealUnitAnimationLibrary`: Guide, Lantern Bearer, Road Sentinel, Oil Acolyte, Lantern Archer. D259 canonical exports preserve D257 rich 25-frame approved-direction poses; D244/D224 originals unchanged. Headless Godot 4.7.2 live deal→real Battle win→Reward→Table PASS, user last reported `«Все ок»`. D257 11 historical source-side crop warnings are retained as quality records, not proof of currently missing in-game frames. Details [D260 release](D260_BLACK_LANTERN_CARD38_RELEASE.md). KARAMBA73 unchanged.

## D259 — Three remaining Black Lantern original 25-pose atlases in canonical runtime staging

`assets/pixel/units/deck_expansion_v1/{extinguished_guide,oil_acolyte,lantern_archer}_frames.webp.b64` built reproducibly from **exact D257 approved-direction source artwork**, with left→right per-cel export for Guide/Archer and byte-identical Acolyte. 25 complete distinct frames, five blank, 2px margins per role; strict shared library now exposes all five roles (D244 Sentinel and D224 Bearer exact old assets retained). This is **staged combat content** for unreleased card #38, not proof that old 11 source-truncation warnings disappeared. CI native five-role scene pass and user D258 no-blocker feedback recorded in [D259 canonical QA](D259_CANONICAL_FIVE_ROLE_RELEASE_PREP.md). 37/45 live; KARAMBA73 unchanged.

## D258 — All five approved-direction Black Lantern original silhouettes in combat QA

The D257 full-25 Guide/Acolyte/Archer atlases join exact retained D244 Road Sentinel and D224 Lantern Bearer **only in D258 test 3v5 and real Battle launcher**. Right-authored facing normalization for original-left Guide and Archer is performed in-memory for QA; production library and bitmaps untouched. Godot 4.7.2 validates real five-role Battle injection; outstanding native x1 motion/11 source floor-boundary warnings mean **not final art release**. See [D258 QA](D258_FIVE_ROLE_GODOT_QA.md). 37/45 LIVE, KARAMBA73 frozen.

## D257 — Three reconstructed original-rich Black Lantern atlases (QA ONLY)

2026-10-19: Committed `assets/pixel/units/black_lantern_road_qa/{extinguished_guide,oil_acolyte,lantern_archer}_d257_seam_recovery_qa.webp.b64`, sourced from exact D255 approved transparent 25-pose illustrated sheets with component-level horizontal seam recovery and localized lower-contour repair. Full real-source GitHub Actions generation PASS (75 unique/15 transparent/2px borders) **does not certify appearance**: 11 original bottom-edge warnings and native F6 artistic motion review remain. Combined visual preview `scenes/dev/black_lantern_d257_three_character_art_preview.tscn`, detailed [D257 documentation](D257_THREE_ATLAS_SEAM_RECOVERY_QA.md). **No global registration, no card #38 release.** Live 37/45, KARAMBA73 unchanged.

2026-10-19: After user asked to finish all remaining character art and replied **«отлично»** to the three newly rendered transparent complete sheets, archived the exact **visual directions** for `extinguished_guide`, `oil_acolyte`, `lantern_archer`. Built reproducible **three 576×480 transparent WebP 25-frame QA atlases** (each 4 idle/6 walk/6 attack/3 hit/6 death, 5 alpha-empty cels) at fixed per-role scale, 2px cell borders, 75 distinct and machine QC PASS. Generated one **QA-only all-three at ×2.1 and ×1** preview `res://scenes/dev/black_lantern_d255_three_character_art_preview.tscn`. **Important internal ART HOLD:** source-sheet cell cut lines visibly sever airborne lamps/cloth/projectiles in 12 Guide, 13 Acolyte and 9 Archer cels by the source-edge QA heuristic; particularly attack motion. These are not accepted finished animation despite 75 hashes and one user aesthetic reaction. **No automatic game/production role registration or #38 release**; do not ask for micro-approvals, repair all three source-bleed defects within one combined batch and perform native motion check before requesting the single overall full-art verdict. Source images, complete atlas exports, deterministic author and per-cell machine report preserved at `docs/D255_THREE_RICH_CHARACTER_ATLASES.md`. Main released pool **37/45**; D244 Sentinel/D224 Bearer, D253 light, D254 route, KARAMBA73 untouched.

## D251 — Guide rich triple-yoke illustrated source and 25-pose structural QA, ART FAIL; D249 readability patch

2026-10-19: Authored detailed new Guide source with correct rigid iron yoke and three chained lanterns, saved lossless technical 25-pose alpha atlas **QA ONLY** + reproducible extractor + machine report. 576×480/25 distinct/5 blank/2px checks PASS; **internal motion-art FAIL** from background matting halos, wide ATTACK chain foreshortening and inconsistent proportions on death. Do NOT show as final, register shared Guide role or request native F6 yet. Updated D249 3v5 **QA-only** HUD: enemy names hidden by default (button toggles), formation switch explicitly reads **ПЕРЕКРЁСТОК → / ← МАРШ**. Godot F6 of the new controls NOT RUN. Source `docs/D251_GUIDE_RICH_ART_INTERNAL_FAIL.md`. D250 native MARШ-only smoke remains last verified result, PЕРЕКРЁСТОК still pending; normal pool 37/45, KARAMBA73 frozen.

## D249 — User says D248 Guide technical 1v1 OK; real five-role 3v5 QA staged

2026-10-19: User replied «все ок» after isolated D248 Guide vs Knight: technical combat no-blocker ONLY, not finished art acceptance. The three exploratory high-detail Guide generation attempts were rejected internally: chain lanterns carried by hand instead of rigid overhead triple-lantern yoke, inaccurate frame counts and opaque labeled backgrounds. NO such concept images enter GitHub assets. Added isolated res://scenes/dev/black_lantern_d249_five_enemy_combat_qa.tscn: real 3 heroes vs five original authored enemies, both encounter formations, exact D209 forest and authentic D206 scoped moving amber-light zones (+16% illuminated enemy attack cadence). D244 Sentinel and D224 Bearer use previously staged rich atlases, D218 Guide/D217 Oil Acolyte SVG/D219 Archer use original technical QA art injected only in these instances, strict original 25-cel frame checks. New F6 native user test PENDING, not automatically passed. No released #38 Battle or reward/table/balance functionality changed, no RunState/UnitData/main Battle edits, pool stays 37/45 LIVE; KARAMBA73 untouched. Guide still needs real richly illustrated full 25 original poses with its rigid three-lamp iron yoke; then Acolyte and Archer rich art. Details docs/D249_BLACK_LANTERN_FIVE_ROLE_REAL_COMBAT_QA.md.

## D248 — Bearer accepted and staged, Guide technical combat probe, rich art outstanding

2026-10-19: User replied **«все ок»** to D247 Knight-vs-Lantern Bearer real native QA; accepted-to-proceed, **not full five-role card release**. Copied exact same D224 25-frame user-selected original atlas into `assets/pixel/units/deck_expansion_v1/lantern_bearer_frames.webp.b64`; registered `lantern_bearer` (source RIGHT) alongside D244 `road_sentinel` (source LEFT) in strict `MisdealUnitAnimationLibrary`, with rollback QA source preserved. **#38 remains outside ordinary 37/45 Act 1 cards.** Next tall three-chained-lantern `extinguished_guide`: old D218 original 25-pose pixel atlas is **simplified technical art**, not matching approved rich B-style. Added isolated `res://scenes/dev/black_lantern_guide_d248_combat_preview.tscn` real Guide vs Knight AI fight (both directions, death, HP×3 only) with D218 injected exclusively in QA instance; **new native F6 not yet run** and no Guide global registration. A generated shield-bearer picture was rejected as wrong identity, not imported. NEXT production art gate: illustrate complete high-detail 25 poses for actual triple-lamp Guide, internally QA, then a single completed-pack native F6; remaining Acolyte/Archer and full 3v5+light/matrix/reward/table later. `docs/D248_BEARER_ACCEPTED_GUIDE_PROBE.md`. Frozen KARAMBA73, DS2, approved D200/D209 and 37/45 LIVE unchanged.

## D247 — Sentinel D244 staged in library; Bearer D224 real 1v1 QA next

2026-10-19: User's `«так вродвсе ок. продолжай»` after D246 is **provisional no-blocker feedback for single-Sentinel actual combat**, not explicit full-art signoff. Archived D229 unchanged, staged D244 **byte-exact** in `assets/pixel/units/deck_expansion_v1/road_sentinel_frames.webp.b64` for unreleased #38. Updated D230 archival gallery to compare D229 vs current D244 shared library. Next role is **user-art-approved D224 shield-bearing Lantern Bearer**, whose previously packed 96px animation has known possible seam cut loss. Created **real Knight-versus-Bearer QA 1v1** `res://scenes/dev/black_lantern_bearer_d247_combat_preview.tscn` to assess feet, shield contact, separate lantern and death under authentic BattleUnit physics. D224 injected **only into this QA actor**, not registered globally; HP×3 only locally. **Godot D247 F6 PENDING**; no full #38 fight/matrix/reward acceptance; **37/45 LIVE**. Full details `docs/D247_SENTINEL_STAGING_AND_BEARER_COMBAT_QA.md`.

## D224 — original rich Lantern Bearer approved; source + 96px QA repack committed, F6 pending

User approved D223 corrected plank-shield + freehand lamp, then accepted rich **1374×1145 RGBA sheet** («подходит»). Exact visibly-lossless source is now stored in GitHub as `assets/pixel/units/black_lantern_road_qa/lantern_bearer_d224_approved_original_lossless.webp.b64`, plus separate **576×480 25-cel derived** `lantern_bearer_d224_approved_repacked_candidate.webp.b64`. Static 25 distinct poses/5 clear/0 final-tile edge hits; **original source poses overlap across several nominal cells, native F6 might reveal visual clipping or foot slide**. QA-only native scene `res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn`; user F6 NOT YET RECEIVED. No production library or #38 release. Full art/sha QA: `docs/D224_LANTERN_BEARER_APPROVED_ART_QA.md`. Act1 37/45, exact D209 forest unchanged.

---

## D218 — new giant Guide triple-chain lantern QA sprite staged (NOT production art)

The user-confirmed D217 post-border-fix F6 is PASS («все ок»). Original `extinguished_guide` sprite art in GitHub `assets/pixel/units/black_lantern_road_qa/extinguished_guide_d218_candidate.webp.b64` is 576×480 25 hand-authored original poses + 5 blank, 0 offline border issues. Its 3 lanterns and metal yoke differ unmistakably from the other 4 enemies; actual native visual 1.8× beside 1× Bearer comparison is staged in isolated scene `res://scenes/dev/black_lantern_guide_animation_preview.tscn` with the accepted D209 forest. **Native D218 F6/art QA still PENDING.** Full doc: `docs/D218_EXTINGUISHED_GUIDE_ANIMATION_QA.md`. No runtime sprite registry or Act1 pool change; still 37/45.

---

## D217 — Oil Acolyte 25-state vector-cel QA (new), raster variant remains conversation-only

In GitHub: `assets/pixel/units/black_lantern_road_qa/oil_acolyte_d217_vector_candidate.svg` is original source-only 576×480 transparent art with 25 original posed skeleton groups and five unused tiles. It has the **curved sickle, separate oil flask and amber belt lamp** silhouette. Standalone Godot F6 gallery `scenes/dev/black_lantern_oil_acolyte_animation_preview.tscn` uses Godot native SVG rasterization and post-render QC; native user PASS pending.

A separate **offline Pillow raster** D217 PNG/WebP candidate with 25 unique frames, five empty cells and zero edge flags is **only in this conversation's D217 ZIP**, NOT byte-identical to GitHub SVG and NOT installed in `MisdealUnitAnimationLibrary`. Do not claim an accepted production atlas or final role animation based on D217 staging. D216 Bearer F6 pending, D215 Sentinel user-native gallery accepted. Act1 still 37/45.

---

## D216 — New shield Lantern Bearer original animation atlas, QA-only, native F6 pending

Original true 25-cel `lantern_bearer` (576×480 RGBA WebP/Base64, 6×5, alpha margin clean) **in GitHub QA only**: `assets/pixel/units/black_lantern_road_qa/lantern_bearer_d216_candidate.webp.b64`. Separate wooden plank barricade + heavy amber lamp; authored source `tools/art/author_lantern_bearer_d216.py`; `res://scenes/dev/black_lantern_bearer_animation_preview.tscn` checks 3×/1× five-state motion over accepted forest scene. **Native F6 awaiting user.** D215 original spear Sentinel user said «всё ок» after native gallery instruction; no active #38 combat image switching. Details: `docs/D216_LANTERN_BEARER_ANIMATION_QA.md`.

---

## D215 — original spear Sentinel QA-only atlas, NOT approved active sprite

QA art-only GitHub asset `res://assets/pixel/units/black_lantern_road_qa/road_sentinel_d215_candidate.webp.b64` is **lossless WebP 576×480**. It contains original, authored native-size pixel skeleton poses (idle4/walk6/attack6/hit3/death6), 5 fully transparent cells; offline QC 25 unique, 0 border-contact violations. Reproducible generator `tools/art/author_road_sentinel_d215.py`; isolated native review `res://scenes/dev/black_lantern_sentinel_animation_preview.tscn`. The user selected D211 Armored Spear Sentinel option A; the D215 technical candidate follows spear/pauldron/lantern but is visually simpler and **NOT yet accepted by the user**. Do not add it to production animation loader until native F6/visual approval. D209 exact forest art is accepted, no need to choose again. Full stage gate `docs/D215_SENTINEL_NATIVE_ANIMATION_QA.md`. Act1 37/45, KARAMBA73 frozen.

---

## D210 — Approved #38 forest native, five original skeletal animation atlas roles QC BLOCKED

User-native Godot F6 screenshot and «все ок» (2026-10-17) accept the exact D209 third forest artwork in `assets/pixel/battle/arenas/black_lantern_road_arena_selected_v1.webp.b64` with 3 hero / 5 enemy proxy layout and two amber light circles, **visual-only**. The previous D203/D201 "arena pending" sections below are historical and superseded, not the current gate.

D205 candidate 5×5 sheets for five new distinct skeletons have 13/20/24/21/13 source-frame boundary contact warnings (Guide/Bearer/Sentinel/Acolyte/Archer); converted 6×5 preview art is not approved or in GitHub runtime assets. Road Sentinel is wielding an **axe**, contrary to locked **spear**; bearer shield rig, acolyte oil/sickle, Guide 2× scale/floor anchors and archer also need real animation review. D210 contact sheet and report are conversation attachments, not game imports. Acceptance conditions: `docs/D210_BLACK_LANTERN_ANIMATION_ART_QA.md`. Live Act1 37/45; no #38 battle or art switch.

---

# Misdeal — Active Visual Asset Registry

## D203 — D201 arena candidates audited but UNAPPROVED

The three old D201 wide environment images and several newer samples are **not** meaningfully distinct; repeated fortress/viaduct/lantern backdrops were rejected at the art-direction stage. A 1280×720 temporary **layout-only overlay** `d201_arena_gameplay_clearance_test.png` tested D201 option #2 against 3 hero + 5 new skeletal enemy proxy silhouettes and the 2× Guide plus two illustrative light pools; the playable floor fits in principle, but too many permanent orange highlights hurt mechanic readability. The image stays on the conversation surface; **no new card-38 arena asset is tracked in GitHub or approved by the user**. Detailed brief: `docs/D203_BLACK_LANTERN_ARENA_ART_QA.md`. Next art needs *forest, ford, toll gate* as distinct geography, no characters or baked tactical overlay. All existing approved art remains unchanged.

## D201 — D200 Black Lantern Road card art native-accepted; arena pending

The user responded «вск ок» to the D200 native 448×274 card preview. The exact selected THIRD art remains in `assets/pixel/card_unification_v1/run/black_lantern_road_selected_v1.webp.b64`. **This approves the card art only**, not any in-game arena. Next render 2–3 separate **empty** 1280×720 battle environment options; preserve readable level 2D ground and margins for hanging black lanterns. No existing selected sprites or combat art are to be overwritten before the user's selection.

## D200 — Road of Black Lanterns chosen THIRD scene art staged 448×274

User selected THIRD of a newer three-image production-scene group (`лунный_марш_скелетного_легиона.png`, generated ID `f1821747-a46a-4e58-9fd9-9fd2b0f0a214`, source 1604×981). D200 added the exact text-free scene converted to `assets/pixel/card_unification_v1/run/black_lantern_road_selected_v1.webp.b64` (448×274) and strict `CardUnificationV1` override, plus QA-only card and `res://scenes/dev/black_lantern_road_card_preview.tscn`. The user's selection approves the source composition; **native 448×274 F6 acceptance PENDING**. The five original sprites, 1280×720 arena and lanternlight encounter mechanic have NOT been implemented. Live pool remains 37/45.

## D199 — Road of Black Lanterns concept direction ACCEPTED; concept sheet not runtime art

User picked first of three moonlit lantern-road scene concepts for card #38, asked to remove AI detail noise, and required more than three skeletal enemies and a main Lantern Guide ~2× taller/distinct from others. Latest five-role character/encounter sheet was explicitly approved («последняя концепция подходит»). Reference image ID `6fadac31-7e69-40c7-878f-1cb7602bbd75`, filename `a_wide_detailed_pixel_art_concept_game_design_lay.png` from conversation, described fully in `docs/DECK_EXPANSION_D199_BLACK_LANTERN_ROAD.md`. That collage has **printed titles and panel UI**, so it is **not** an in-game 448×274 card illustration, 1280×720 arena or 25-frame animated sheet. **Clean D200 scene card art now exists in GitHub for native QA**, but the arena/five atlases are still NOT created. Live 37/45; do not put #38 into the normal deck.


## D182–D183 — Black Crossing card artwork (native F6 approved)

Chosen **third** image: diagonal ruined pier, ferryman above right, two drowned undead low left. `assets/pixel/card_unification_v1/run/black_crossing_approved_v1.webp.b64` (448×274 WebP from selected image; remote bytes verified). F6: `res://scenes/dev/black_crossing_card_preview.tscn` — user screenshot and explicit «утверждено», **PASS**. Original approved Ferryman/Drowned sprite atlases are shipped and user F6-approved (D186); the user-approved final stormy battle arena is now `assets/pixel/battle/arenas/black_crossing_storm_pier_approved_v1.webp.b64` (1280×720; native F6 accepted by user, D187). Live Act1 is **37/45** following D198 Black Crossing release; D196 storm-wave VFX is held as the current version. Native D198 random-deal release smoke was user-confirmed PASS; D196 surf remains the accepted-for-now visual baseline.

Updated: 2026-10-16 (D198). **Approved assets must not be replaced during cleanup.**

## D153 — approved production assets

- Card illustration (scene-led, 448×274): `assets/pixel/card_unification_v1/run/threadbare_theatre_approved_v1.webp.b64`.
- Battle environment (1280×720): `assets/pixel/battle/arenas/threadbare_theatre_approved_v1.webp.b64` — moonlit ruined theatrical backstage, asymmetric stairs/rigging, dark crimson fabric, clear unit floor. Approved after multiple lower-noise concept iterations.
- Skeletal Puppeteer atlas: `assets/pixel/units/deck_expansion_v1/threadbare_puppeteer_frames.webp.b64`.
- Skeletal Marionette atlas: `assets/pixel/units/deck_expansion_v1/bone_marionette_frames.webp.b64`. Both 576×480, 25 frames, approved redesigned character appearances.
- Old/rejected D153 atlas bytes remain in Git history/versioned backups for rollback. Do **not** swap to old generic mini-skeletons or copy the card bitmap onto the battlefield.
- Card-art quality bar: D167 scene-first; D168 show 3 actual art alternatives before finalization; avoid obvious replicated castles, micro-detail and generic AI decorative clutter.

## Prior visual registry (still useful for assets and rollback)

The detailed inventory of V1–V9 image paths, Godot loaders, DS2 details and prior Combat Expansion artwork below is a **historical inventory** and may include outdated release-status notes. Current gameplay state is always `docs/PROJECT_STATE.md`. Complete originally prefixed material is archived at `docs/archive/2026-10-15-pre-cleanup/docs/VISUAL_ASSET_REGISTRY.md`.

---

# Misdeal — Visual Asset Registry

Last updated: 2026-10-11

Purpose: make visual-source provenance and runtime mapping recoverable from GitHub without reading old chats.

## Canonical loading rules

- Dynamic text/state/buttons remain native Godot UI.
- Full-screen authored WebPs added through recent passes use runtime decoding through `scripts/ui/runtime_webp_texture.gd` or an equivalent battle-specific runtime decoder.
- New screen art should be native 1280×720 when it fills the viewport.
- Table-card art should stay near live display size or better; do not recreate the rejected 112×69 atlas approach.
- Source/master archives are not runtime dependencies.

## Production visual passes

### Card art

- v4: `assets/pixel/ui/visual_pass_v4/` — accepted corrected near-display redraw atlas.
- v5: `assets/pixel/ui/visual_pass_v5/` — completion batch for remaining table cards.
- v6 Bone Warden card: `assets/pixel/ui/visual_pass_v6/bone_warden_card.webp`.
- Broken Crown table card deliberately shares the approved Broken Crown artifact illustration.

All 25 active Act 1 cards resolve to current matching/object-specific art before legacy safety fallback.

### Battle arenas

Canonical live art: **Arena Redraw v2 (approved pack 1)**, integrated 2026-10-11. Ten arena IDs use native 1280×720 WebP assets in `assets/pixel/battle/arenas/arena_redraw_v2/`. The remaining two retain the prior v1 Base64-WebP payloads until pack 2 is approved and implemented.

| arena_id | Runtime source | Format |
| --- | --- | --- |
| `crypt` | `arena_redraw_v2/crypt.webp` | WebP bytes |
| `graveyard` | `arena_redraw_v2/graveyard.webp` | WebP bytes |
| `gallows` | `arena_redraw_v2/gallows.webp` | WebP bytes |
| `ossuary` | `arena_redraw_v2/ossuary.webp` | WebP bytes |
| `warden` | `arena_redraw_v2/warden.webp` | WebP bytes |
| `bone_crush` | `arena_redraw_v2/bone_crush.webp` | WebP bytes |
| `bone_swarm` | `arena_redraw_v2/bone_swarm.webp` | WebP bytes |
| `grave_crossfire` | `arena_redraw_v2/grave_crossfire.webp` | WebP bytes |
| `iron_wall` | `arena_redraw_v2/iron_wall.webp` | WebP bytes |
| `last_bell` | `arena_redraw_v2/last_bell.webp` | WebP bytes |
| `firing_square` | `arena_redraw_v1/firing_square.webp.b64` | Base64 WebP text |
| `bone_ritual` | `arena_redraw_v1/bone_ritual.webp.b64` | Base64 WebP text |

`scripts/battle/authored_backdrop.gd` is the authoritative live selector. It loads raw `.webp` bytes for the approved new pack and decodes legacy `.webp.b64` for the remaining two arenas; both paths create an `ImageTexture` and use nearest-neighbor fallback resizing. Live unit sprites, HUD, tactics, deployment and encounter data remain unchanged.

The new visual direction limits each environment to one dominant meaningful landmark, believable geography and a broad readable central combat floor. It preserves the existing Misdeal blue-black moonlight, warm firelight and restrained crimson gothic identity while avoiding repetitive AI-looking castles. The earlier `arena_redraw_v1`, `visual_pass_v4/v6` and `combat_expansion_v1` assets remain in Git history/repo for rollback. The 1672×941 PNG generation masters remain in the conversation package `misdeal_arena_redraw_pack1_review.zip`; the committed native WebPs are the complete runtime sources.

See `docs/ARENA_REVIEW_2026_10_11.md` for the approved arena-to-landmark map and local-validation checklist.

### Main menu

- Canonical main splash: `assets/pixel/main/approved_splash_hd/main_splash.webp`
- Runtime scene: `scenes/main/main.tscn`
- Runtime loader: `scripts/main/approved_main_backdrop.gd`
- Production size: 1280×720 WebP
- Accepted direction: restrained dark-gothic Wizard at the cursed table, reduced prop noise, red-black-gold foreground against cool moonlit city, live hotspot/UI kept outside the art.
- Superseded: the older compressed three-part splash and the intermediate over-rendered/off-model Wizard redraws.

### Wizard table

- Canonical runtime plate: `assets/pixel/table/approved_variant_c/table_exact.webp` (1280×720)
- Approved source master: `assets/source_archive/table/approved_variant_c/table_exact_master.webp` (1672×941)
- Approved normal-table composition: **final Variant C** — restrained oval ritual tabletop, Wizard centered behind it, two offer cards near the player, physical deck/discard holders at the sides.
- Superseded normal-table backdrop: `assets/pixel/table/visual_pass_v6/table_wizard.webp` (kept in repository history/assets, no longer referenced by `table.tscn`)
- Procedural `scripts/table/table_visual.gd` and `scripts/table/table_spread_visual.gd` remain available but are hidden on the canonical normal table.
- Scene/runtime logic: `scenes/table/table.tscn`, `scripts/table/table.gd`
- The full approved plate is the runtime visual foundation; run-specific cards, counts, Hold state, Wizard text and buttons remain live Godot UI aligned over it.
- Detailed run progress is not duplicated here; `РАСКЛАД СУДЬБЫ` owns the full I–XIII progression view.
- Important: authored table art bypasses the old heavy environment/card grade.
- Shared neutral card back: `assets/pixel/table/card_back_runtime.svg`.
- Runtime foundation rule: the two baked sample offer faces in `table_exact.webp` are permanently covered by neutral physical card backs beneath the live offer layer. Do not restore dark cleanup masks.
- Fate Spread Hold uses the same back when empty; Wizard Discard hides when empty and uses the back as the physical frame under the live top card when populated.
- Local status: the physical card-back pass is committed; local 1280×720 verification is pending.
- Visual lock: Fate Spread is frozen; the exact Variant C plate is the canonical normal-table art. Do not return to the procedural oval-table approximation.

### V7 high-visibility screens

- Knight portrait: `assets/pixel/class_select/v7/knight.webp`
- Ranger portrait: `assets/pixel/class_select/v7/ranger.webp`
- Mage portrait: `assets/pixel/class_select/v7/mage.webp`
- Reward: `assets/pixel/reward/v7/reward_backdrop.webp`
- Whispering Well: `assets/pixel/event/v7/whispering_well.webp`
- Curse Forge: `assets/pixel/event/v7/curse_forge.webp`
- Chained Prisoner: `assets/pixel/event/v7/chained_prisoner.webp`
- Black Altar: `assets/pixel/event/v7/black_altar.webp`
- Run End: `assets/pixel/run_end/v7/run_end.webp`

The same portraits are reused by Squad Dossier.

### Event choice mini-art

- Runtime mapping: `scripts/ui/approved_event_choice_art.gd`, consumed by `scripts/event/act_choice.gd` and `scripts/event/whispering_well.gd`.
- Visual rule: context art describes the event; mini-art describes the action. One dominant object/gesture/action is preferred over three repeated crops of the event image.
- Native 384×160 choice cells are preferred whenever an approved source already exists; the compact 192×80 sheet is now a fallback source, not the desired presentation size.
- Native Rattling Bridge source: `assets/pixel/event/choice/rattling_bridge_hd/` — 1152×160, three 384×160 cells: rescue / bag / walk away. Used for both bridge branches and as generic rescue/bag/leave actions where semantically truthful.
- Native approved Well/Prisoner atlas: `assets/pixel/ui/approved_event_choice_polish/event_choice_atlas.bin` — 1152×320, six 384×160 cells. Provides whisper, coins, occult-card, broken-chains and body-search actions.
- Compact approved sheet: `assets/pixel/event/choice/approved_choice_sheet_v2/` — 576×320, 192×80 cells. It remains the source for the approved Black Altar blood-sacrifice and cursed-offering cells; runtime reconstructs it before use.
- Reusable action vocabulary exposed by `ApprovedEventChoiceArt.get_action_texture()`: `rescue`, `bag`, `leave`, `whisper`, `coins`, `occult_card`, `chains`, `loot_body`, `blood`, `cursed_relic`.
- Explicit semantic event mappings now include Rattling Bridge, Whispering Well, Chained Prisoner, Black Altar recruitment, Lost Purse, Debtor Bones, Wizard Tithe, Blood Ledger, Bone Tax, Ash Rest recruitment and Last Camp recruitment.
- Curse Forge continues to use actual artifact art because its three choices are concrete relics.
- Role-development choices continue to show the actual offered upgrade art.
- Broken Crown now shows crown / coins / actual offered upgrade (or cursed-relic fallback) instead of three copies of the crown.
- Superseded runtime path: `assets/pixel/event/choice/black_altar_recruitment.svg`.


### V8 secondary event screens

| card_id | Runtime art |
| --- | --- |
| `candle_seller` | `assets/pixel/event/v8/candle_seller.webp` |
| `gravedigger_shop` | `assets/pixel/event/v8/gravedigger_shop.webp` |
| `blood_ledger` | `assets/pixel/event/v8/blood_ledger.webp` |
| `faceless_card` | `assets/pixel/event/v8/faceless_card.webp` |

### V9 final generic-event screens

| card_id | Runtime 1280×720 art | Archived generated master |
| --- | --- | --- |
| `rattling_bridge` | `assets/pixel/event/v9/rattling_bridge.webp` | `assets/source_archive/visual_pass_v9/rattling_bridge_master.webp` |
| `lost_purse` | `assets/pixel/event/v9/lost_purse.webp` | `assets/source_archive/visual_pass_v9/lost_purse_master.webp` |
| `debtor_bones` | `assets/pixel/event/v9/debtor_bones.webp` | `assets/source_archive/visual_pass_v9/debtor_bones_master.webp` |
| `bone_tax` | `assets/pixel/event/v9/bone_tax.webp` | `assets/source_archive/visual_pass_v9/bone_tax_master.webp` |
| `wizard_tithe` | `assets/pixel/event/v9/wizard_tithe.webp` | `assets/source_archive/visual_pass_v9/wizard_tithe_master.webp` |
| `ash_rest` | `assets/pixel/event/v9/ash_rest.webp` | `assets/source_archive/visual_pass_v9/ash_rest_master.webp` |
| `last_camp` | `assets/pixel/event/v9/last_camp.webp` | `assets/source_archive/visual_pass_v9/last_camp_master.webp` |
| `broken_crown` | `assets/pixel/event/v9/broken_crown.webp` | `assets/source_archive/visual_pass_v9/broken_crown_master.webp` |

Original V9 generated filenames from the conversation:

- Rattling Bridge — `лунный_мост_над_проклятым_ущельем.png`
- Lost Purse — `лунная_дорога_среди_мёртвых.png`
- Debtor Bones — `лунный_алтарь_костяных_костей.png`
- Bone Tax — `лунный_костяной_алтарь_у_готических_врат.png`
- Wizard Tithe — `готический_алтарь_под_полной_луной.png`
- Ash Rest — `готический_лагерь_под_полной_луной.png`
- Last Camp — `одинокий_лагерь_под_готическим_собором.png`
- Broken Crown — `разбитая_корона_в_лунных_руинах.png`

The archived masters are 1672×941 Q95 WebP exports from those generated PNGs. The runtime copies are separate 1280×720 production assets.

## Rejected / superseded art paths

### Rejected low-resolution v3

The broad v3 integration used roughly:

- 112×69 card cells;
- 320×180 arena cells.

It was locally rejected because upscaling produced muddy/blocky presentation. Do not restore this pipeline.

### Strong double grading

Legacy environment/card grade on already-dark authored art caused black crush on battle/table/event screenshots. Current authored surfaces either bypass it or use substantially reduced fallback strength.

### Generated full-screen UI mockups

Approved mockups may guide composition, but baked gameplay values/buttons/text are not production runtime UI. Preserve live Godot controls.

## Source preservation

Earlier production passes (v4-v8 and battle/table v6) are already recoverable from their committed runtime assets and Git history.

V9 additionally keeps larger source masters under `assets/source_archive/visual_pass_v9/` because these were the last generated images immediately before the transition away from broad art replacement.

If a future pass needs a different crop or export, start from the archived master where available rather than regenerating a new scene.

## Combat Expansion v1 dedicated visual set — 2026-10-11

The six gameplay-test encounters now have approved dedicated arena and card exports.

| Encounter | Battle backdrop | Table card |
| --- | --- | --- |
| `bone_swarm` | `assets/pixel/battle/arenas/combat_expansion_v1/bone_swarm.webp` | `assets/pixel/ui/combat_expansion_v1/cards/bone_swarm_card.webp` |
| `grave_crossfire` | `assets/pixel/battle/arenas/combat_expansion_v1/grave_crossfire.webp` | `assets/pixel/ui/combat_expansion_v1/cards/grave_crossfire_card.webp` |
| `iron_wall` | `assets/pixel/battle/arenas/combat_expansion_v1/iron_wall.webp` | `assets/pixel/ui/combat_expansion_v1/cards/iron_wall_card.webp` |
| `last_bell` | `assets/pixel/battle/arenas/combat_expansion_v1/last_bell.webp` | `assets/pixel/ui/combat_expansion_v1/cards/last_bell_card.webp` |
| `firing_square` | `assets/pixel/battle/arenas/combat_expansion_v1/firing_square.webp` | `assets/pixel/ui/combat_expansion_v1/cards/firing_square_card.webp` |
| `bone_ritual` | `assets/pixel/battle/arenas/combat_expansion_v1/bone_ritual.webp` | `assets/pixel/ui/combat_expansion_v1/cards/bone_ritual_card.webp` |

Production sizing:
- battle: 1280×720 WebP;
- card: 448×274 WebP.

These exports were cropped from the six user-approved composite concepts generated for Combat Expansion v1. The former semantic card aliases are retired. Bone Raider and Crypt Sentinel still intentionally reuse existing production unit silhouettes pending mechanical validation.

### Combat Expansion v1 archived composite masters

The approved generated composites used to derive the live arena/card exports are preserved for recropping:

- `assets/source_archive/combat_expansion_v1/bone_swarm_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/grave_crossfire_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/iron_wall_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/last_bell_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/firing_square_composite_master.webp`
- `assets/source_archive/combat_expansion_v1/bone_ritual_composite_master.webp`

These 1055×1491 source composites contain the approved arena concept in the upper portion and the approved card illustration in the lower portion. Use these masters rather than regenerating the concepts if a crop or export needs adjustment.

