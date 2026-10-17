# Misdeal — Active Roadmap

Updated: 2026-10-18 (D232 rich single-pose 96px Sentinel comparison staged, awaiting user Godot x1 art choice; 25-pose finale pending; Act1 live 37/45). **Act 1 live: 37/45.** Technical truth: `docs/PROJECT_STATE.md`.

## Completed / locked

- [x] Playable cursed table, exactly 12 Fate Spread resolutions + sealed boss XIII, and tactical battle → reward → table core loop. Solo/duo/trio preserved; DS2 / Variant C visual system accepted.
- [x] #34 D151 Funeral Procession, #35 D152 Defiled Laboratory, #36 D153 Threadbare Theatre all released with distinct enemies, encounter mechanics and scene-led original art. D153 D178 54/54 native balance and D181 native release smoke PASS.
- [x] D182–D187 Black Crossing: accepted card variant 3, Ferryman B/Drowned C atlases and stormy «Последний причал» arena.
- [x] D188–D191 Black Crossing authored 1+2 fight, wave push/slow and D189 safe plank boundaries. **D191 native 54/54 wins**, 0 entire-party defeats.
- [x] D196 storm VFX held as the current visual baseline after user's request; no more wave tuning in this phase.
- [x] D197 user-native preflight and real battle → reward → table confirmed («Все ок»).
- [x] **D198 Black Crossing #37 fully released.** Live 37-card pool, migrated D151–D153/shepherd smoke guards and full-pool random-deal release scene committed. The user replied **«все ок»** to the requested Godot F6 release smoke (user-reported native PASS, no independent log).

## D225 next QA gate — D224 art turning left/right

- [x] **D224 native gallery screenshot received:** correct D209 backdrop, selected Bearer full art visible in x3 and x1, shield-attack pose on screen. This is **NOT** the full five-motion or two-way motion PASS.
- [x] **D225 gallery both-facing controls added** to `scripts/dev/black_lantern_bearer_d224_art_preview.gd`: two buttons `← ВЛЕВО` / `ВПРАВО →` flip both views together and update the current state label. Both views retain nearest filtering; no actual 25-cel image bytes changed.
- [x] **D225 native Godot direction controls user OK:** user replied «все ок. давай дальше» after F6 request; this confirms gallery directional QA at user-report level, not production combat/art.
- [x] **D225 native Godot F6 previously requested (now user-confirmed):** same `res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn`. Check walk / shield attack / fall in BOTH directions. The image's slightly soft details originate from prior 1374→96 pixel repack, not a missing NEAREST setting. Original art refinement later, do NOT silently sharpen user-approved source.
- [ ] Original five-role final polished atlases + combined five-vs-three art review, Battle→Reward→Table and #38 release gates remain.

## D232 CURRENT — ONE art-quality check before authentic 25-cel animation

- [x] **D232 one alpha-cleared high-detail original-looking spear guard sample**: correctly shaped long spear, ornate iron armor, separate hand lantern and oxblood cape. Extracted from **one** generated pixel illustration pose and scaled to exactly 96×96 with NEAREST; **NOT native pixel-painted and NOT a valid 25-cel animation sheet**. Original cutout saved as lossless WebP/B64; alpha safe (9,5)–(86,93).
- [x] **D232 actual x1/x3 comparison scene:** `res://scenes/dev/black_lantern_sentinel_d232_art_direction_preview.tscn`, D229 old LEFT vs new static candidate RIGHT, five-state playback INTENTIONALLY ABSENT, correct D209 forest.
- [ ] **D232 real user visual/art direction acceptance:** examine x1 on Godot; only after acceptance work on original 25 true poses. Native Godot not run here.
- [ ] **D232 25-frame production (future):** recreate high-fidelity style in true state cels/alpha/bounds, protect spear and lantern, then real 3v5/battle/reward/light/54-case checks. Do not re-register single still as BattleUnit animation.
- [x] D229 production-stage 25-cel atlas and #38 pool intentionally unchanged; **37/45** live.

## D231 PREVIOUS — restore promised rich Sentinel visual bar; D230 final-art flag REOPENED

- [x] **Diagnosed visual regression / expectation mismatch:** original 1254×1254 illustrated `пиксельный_атлас_скелета_стража.png` has elaborate armor, cloak and lantern but an incorrect **AXE**, 5×5 generated poses; accepted D221 spear concept is rich but includes baked background. Both differ substantially from plain procedural D229 6×5×96px code-generated atlas. D230's claim of final quality was misleading. `docs/D231_SENTINEL_ART_FIDELITY_CORRECTION.md`.
- [x] **D229 SECOND vs FIRST D228 choice retained AS TECHNICAL SHORTLIST** (not final aesthetic quality waiver); D230 role registration currently exists only for unreleased encounter #38.
- [ ] **Proper high-fidelity original game sprites:** produce a single REAL game-scale crisp spear Sentinel matching accepted D221 richness for renewed art approval before painting all 25 poses; no more slight noisy Python shape bumps. If current 96px fidelity is insufficient, obtain user input before changing asset budget/format.
- [ ] **Full 25-pose release-ready Sentinel atlas**, 5 other state roles each complete, combined battle QA. No releasing original AXE art or procedural D229 as visually final. Live Act1 37/45.

## D230 PREVIOUS / SUPERSEDED FINAL-ART CLAIM — Road Sentinel final art DONE; proceed to remaining four enemies

- [x] **User formally chose option TWO / RIGHT D229 as final Road Sentinel** («давай примем 2 вариант и уже закончим с этим»). Never restart pixel-polish passes or ask again between D228/D229. Final art bytes exactly equal approved D229 source. `docs/D230_ROAD_SENTINEL_FINAL_APPROVAL.md`.
- [x] **D230 role-specific production atlas and library registration:** `assets/pixel/units/deck_expansion_v1/road_sentinel_frames.webp.b64`, `MisdealUnitAnimationLibrary.get_frames("road_sentinel")` strict 25 genuine frames/5 empty, `BattleUnit` authored-left orientation correct. Card #38 still QA-only.
- [x] **D230 isolated production-loader F6 smoke staged:** `res://scenes/dev/black_lantern_sentinel_d230_approved_smoke.tscn` compares selected art with actual animation library output at x1/x3 and both directions; does not re-open art approval.
- [ ] **D230 engine-native smoke (may bundle with combined QA):** Godot F6 not yet user-confirmed. Errors should prompt code fixes only, not aesthetic reconsideration.
- [ ] **Next art role:** Lantern Bearer source-approved D224 shield + free-hand lantern; complete its accepted final frame quality as needed; after that original Oil Acolyte, 1.8× Extinguished Guide, Lantern Archer. Then collective 3-vs-5 forest, real #38 battle/light/reward/matrix and release, 37→38 cards only after PASS.

## D229 PREVIOUS / SUPERSEDED artistic comparison — compare actual x1 before another repaint

- [x] **D229 original native 96px art experiment**: real large chest/pauldron facets, richer hood, improved real-spear blade edge, preserves all 25 moving states + 5 fully empty with 0 border violations. Old D228 art unchanged. `docs/D229_SENTINEL_NATIVE_SCALE_AB_REVIEW.md`.
- [x] **D229 A/B Godot F6 comparison scene**: `res://scenes/dev/black_lantern_sentinel_d229_compare.tscn`, D228 left and D229 right, both x3/x1, common animation state + direction controls, exact chosen D209 forest.
- [ ] **USER native F6 and aesthetic result**: compare A/B especially ×1; D228 native F6 was NOT separately accepted just because user asked to continue. Check walk/attack/death and left/right. No assumed PASS.
- [ ] **Final Sprite art fidelity:** x1 differences remain subtle; consider higher-quality silhouette composition at same 96px, *not* endless micro-polish, before agreeing to production sprite. Then remaining original four enemy final passes, combined battle and #38 real release.

## D228 previous QA gate — style-B Sentinel art fidelity

- [x] **D228 native sprite repaint shipped to QA branch of main:** detailed 96px original armor shapes, frayed burgundy cloak, upgraded genuine spear head and bindings, lantern metal cage. 25 different physical animation cels/5 empty/zero alpha border violations, correct 6×5 row-per-state. D227 preserved for visual comparison. `docs/D228_SENTINEL_ORNAMENTAL_PIXEL_ART_QA.md`.
- [x] **Isolated D228 F6 Godot gallery added:** `res://scenes/dev/black_lantern_sentinel_d228_art_preview.tscn` x3/x1, left/right, all five state buttons, approved D209 backdrop.
- [ ] **D228 native user art/animation QA:** verify appearance at x1, full spear thrust, lantern/cape staying attached through walking and collapse, both directions. No actual F6 PASS as of this commit. Polished accepted D221 visual target remains a hard gate.
- [ ] **Before live release:** final-art quality for all five enemies, integrated real #38 Battle→Reward→Table/light and full-pool/matrix smoke; ordinary pool stays 37/45.

## D227 previous native art QA gate — original painted Sentinel 96px

- [x] **D227 25-frame pixel art pass committed**: true native-resolution geometry (armor, skull, cloth, spear, lamp and greaves), alpha-safe original frames `idle4/walk6/attack6/hit3/death6`, five transparent cells, 25 unique, zero border touches. Original D226 QA untouched; **full D221 visual fidelity still not claimed**. `docs/D227_SENTINEL_PIXEL_FIDELITY_QA.md`.
- [x] **D227 F6 scene committed** `res://scenes/dev/black_lantern_sentinel_d227_art_preview.tscn` with x3 / x1 and LEFT/RIGHT, on accepted D209 forest.
- [ ] **D227 user Godot QA and art decision:** check walking soles, exact spear thrust, arm/lantern placement, final grounded collapse in both orientations; compare D226 vs D227. **Native PASS not yet received**.
- [ ] Full polished five-role artwork, real integrated #38 battle, reward route/matrix and 38/45 release checks all pending. Old released pool stays 37/45.

## D226 previous gate — painted Road Sentinel

- [x] **D226 richer original 25-cel spear Sentinel candidate:** deterministic native 96px drawn art in approved armored A silhouette/B palette with torn russet hood and copper-iron wear; 25 unique + 5 transparent, zero edge warnings, original pointed spear/amber lamp. **Not the final D221 fine-detail quality yet.**
- [x] **D226 isolated Godot F6 gallery:** original D209 moonlit forest, 3× and 1× frames, left/right direction switches, five states, strict validators. Source/asset/QA documented in `docs/D226_SENTINEL_STYLE_B_ART_QA.md`.
- [x] **D226 screenshot: native loading and leftward walk visible** — user showed x3 + x1 gallery on D209 background with no red QA error. This is **partial evidence only**, not all five motion states and left/right toggles tested.
- [ ] **D226 art fidelity / D227 native 96px repaint:** skull, plate volume, rusty metal clusters, spear head, lantern shape and burgundy mantle still visibly simpler than user-approved D221 illustration. Preserve 25 authored poses; not permitted to call D226 a final art PASS based solely on rendered gallery.
- [ ] **D226 full five-state/direction user-native visual review:** `res://scenes/dev/black_lantern_sentinel_d226_art_preview.tscn`, confirm direction, leg contact, real spear thrust, visible lantern at 1×, death; assess against D221 accepted detailed illustration. No live sprite swap until approved.
- [ ] **Full five-hero original art completion + real #38 battle/reward/table/release smoke** remains outstanding; live 37/45.

## D209/D210 status

- [x] **D209 native arena art visual PASS** — user F6 screenshot and «все ок» on selected third black-forest art, 3 hero + 5 enemy proxies and moving pools; this confirms layout only, not final character art.
- [x] **D210 art preflight** — five source 5×5 sheets and remapped 6×5 candidates visually audited; 13/20/24/21/13 boundary-contact warnings, Sentinel axe vs approved spear. Five atlas approval gates still **BLOCKED**. See `docs/D210_BLACK_LANTERN_ANIMATION_ART_QA.md`.
- [x] **D211 Sentinel option A approved** by user («а»): armored long-spear silhouette with small lantern. No authentic production atlas yet. `docs/D211_ROAD_SENTINEL_SPEAR_CONCEPT_OPTIONS.md`.
- [x] **D213 canonical animation master brief committed:** fixes prior chat D212/D213 row-major mismatch. All five Godot atlases MUST be row-per-state: idle(4), walk(6), attack(6), hit(3), death(6); 5 transparent surplus cells. `docs/D213_BLACK_LANTERN_MASTER_ANIMATION_BRIEF.md`.
- [x] **D214 Bearer production specification committed:** 25 explicit pose directions, heavy lantern + wooden defensive plank, real pixel/foot/alpha gates; purely ART specifications, no real atlas. `docs/D214_LANTERN_BEARER_PRODUCTION_SPEC.md`.
- [x] **D215 first original Road Sentinel QA atlas produced and committed:** handmade pose-specific 25 frames, 6×5 correct rows, transparent WebP/B64, no border spills, isolated native gallery F6; 3× and 1× on D209. **User art approval and native F6 PENDING; QA-only, not enabled in gameplay.** `docs/D215_SENTINEL_NATIVE_ANIMATION_QA.md`.
- [ ] Produce/review FIVE **genuinely authored** idle/walk/attack/hit/death 96px transparent atlases. Begin with Sentinel's correct spear; retain prior selected arena and card illustration.
- [x] **D215 Road Sentinel native F6 OK** — user replied «все ок продолжай дальше» after five-state standalone gallery check. QA candidate is acceptable for next art step; still not registered as live sprite or in battle.
- [x] **D216 Lantern Bearer original 25-frame QA asset staged:** shield-first melee, separately held amber lamp, walk/hit/death (576x480 WebP/B64, 25 distinct poses, 5 blank, zero border flags). Authored Python source + QA-only Godot gallery committed. `docs/D216_LANTERN_BEARER_ANIMATION_QA.md`.
- [x] **D217 Oil Acolyte QA source/gallery staged:** genuine third role with original flask+curved sickle+small belt-lamp identities. Local independent 25-pose PNG/WebP raster passed offline alpha QC; GitHub hosts a **separate 25-state original SVG QA** plus native `load_svg_from_buffer` F6 scene. Neither is production library art. `docs/D217_OIL_ACOLYTE_ANIMATION_QA.md`.
- [x] **D217 error diagnosis + source fix:** user Godot F6 screenshot flagged death row4 cells4/5; deleted only two offending low rib strokes from editable SVG, commit `a8a80f1`. QA checks remain strict, no gameplay/source substitution; native retest required.
- [x] **D217 native Oil Acolyte F6 retest user-reported PASS:** user replied «все ок» after the exact post-hotfix F6 request; removed border errors from death row4 col4/5, without loosening QA. No video or full-flow battle acceptance.
- [x] **D218 Guide QA atlas and F6 gallery source committed:** 25 original 96px cels, 5 unused transparent, no offline border contact; large leader silhouette with 3 chained lamps, 1.8x beside 1x Bearer on accepted D209 art. Full: `docs/D218_EXTINGUISHED_GUIDE_ANIMATION_QA.md`. **Godot F6 still pending**.
- [ ] **D218 native Guide F6:** `res://scenes/dev/black_lantern_guide_animation_preview.tscn`, inspect size ratio, feet, light chains, five motions, final corpse.
- [x] **D219 isolated Lantern Archer F6 positive user report** — user replied «все ок» after the D219 gallery test; technical preview only, NOT polished production-art approval.
- [x] **D220 explicit user-facing final-art requirement documented** — all FIVE QA-simplified sprites must be fully repainted into approved Misdeal dark-fantasy pixel art and reviewed together on D209 at real scale before production registration and #38 release. See `docs/D220_BLACK_LANTERN_FINAL_SPRITE_REPLACEMENT_GATE.md`.
- [x] **D221 Sentinel final appearance chosen** — user accepted detailed heavy-armored long-spear Sentinel illustration in selected collective style B («отлично»). Design approval only; composite is not transparent 25-cel game art. `docs/D221_SENTINEL_FINAL_STYLE_APPROVAL.md`.
- [x] **D222 Bearer concept quality review:** three B-style illustration panels generated but all had **unapproved long staff + lantern on shield** rather than a separate hand lantern, so REJECTED in art QA; do not use as assets. `docs/D222_LANTERN_BEARER_FINAL_ART_REVIEW.md`.
- [x] **D223 corrected Bearer visual concept illustrated:** 388×386 character-only crop with broad wood barricade and **separate hand-held lantern**, no pole, style B; conversation asset (not in-game art). User artistic approval **PENDING**. `docs/D223_LANTERN_BEARER_CORRECTED_CONCEPT.md`.
- [x] **D223 Lantern Bearer appearance approved** («да все ок»), shield one hand and separate lantern other; no spear.
- [x] **D224 Bearer 25-pose art sheet approved** («подходит»): exact RGBA source converted to visibly-lossless WebP/B64 in GitHub, 25-cel 576×480 repack + reproducible author and machine-readable QC, strict isolated F6 scene; no live sprite switch. `docs/D224_LANTERN_BEARER_APPROVED_ART_QA.md`.
- [ ] **D224 user-native F6:** `res://scenes/dev/black_lantern_bearer_d224_art_preview.tscn`; check 5 animations at 3× and 1× for any missing pixels at seam, feet/lantern/shield movement, final corpse; only then production art readiness.
- [x] **D223 Lantern Bearer specific visual acceptance** — user confirms D223 or requests edits, then real full-quality 25-cel animated original sprite in correctly packed rows.
- [ ] **D222 Lantern Bearer corrected standalone character appearance** — shield plus separate HANDHELD lantern, absolutely no staff/spear or composite fake 25-frame sheet; show to user before true final atlas.
- [ ] **D221 Lantern Bearer appearance** — present in same B art direction with broad wooden defensive barrier and heavy hand lantern, obtain user look approval before 25-cel art.
- [ ] **D220 actual FIVE final atlases:** original repaint, not upscale/recolor. Art options → explicit approval → native gallery/combined scene → integrate battle→reward→table → release smoke.
- [x] **D219 final Lantern Archer QA-only atlas produced:** new original 25-frame archer bow, quiver and lantern, with proper bow draw and user-native gallery before battle.
- [ ] **D216 five-state art approval** — gallery **renders** (user screenshot shows 3×/1× and shield attack, no QA FAIL); idle/walk/hit/death motion not yet separately confirmed. Scene: `res://scenes/dev/black_lantern_bearer_animation_preview.tscn`, check stance/foot contact, shield attack and final collapse on approved D209 arena.
- [ ] After sprite approval: Godot animation F6, actual #38 five-enemy battle with encounter-only light, then real reward→table and release smoke before Act1 **38/45**.

## D219 — fifth original role, art integration/release still gated

- [x] D218 triple-lantern Guide standalone preview: user replied **«отлично»** after native F6 request. Positive user feedback; no independently supplied new screenshot/log, nor real battle validation.
- [x] D219 original Lantern Archer 25-pose alpha WebP/B64 and editable Pillow art source created and committed: curled bow, quiver, amber lamp, intentional draw→loose→recover; **25 distinct / 5 empty / 0 border flags** offline, GitHub content verified; native F6 pending.
- [ ] **D219 native F6:** `res://scenes/dev/black_lantern_archer_animation_preview.tscn`. Judge 3×/1× bowstring, arrow leftward, alternating feet, grounded death and health/HUD room on accepted forest.
- [ ] Joint animation-scale/orientation QA for all five roles on D209; D216 Bearer complete five-motion user check if needed.
- [ ] Only after art/native QA: register five distinct original enemy roles in animation library for **QA-only** real `black_lantern_road` encounter, wire moving light, verify real Battle→Reward→Table; 54-case regression and full-pool release smoke before live card #38/45.
- [ ] Preserve `backups/KARAMBA73-2026-10-16`, live 37-card deck and accepted older encounters.

## Next (strict order)

1. [x] **D199:** #38 `black_lantern_road` approved design — five original skeletal roles, 2×-height Guide, travelling light; no live enemy assets or gameplay.
2. [x] **D200:** exact third card illustration installed QA-only, user-native art review previously reported OK. Keep it unchanged.
3. [x] **D204 → D205 arena selection:** user chose geography **A dead forest bend** and then **third of three finished forest backdrops**, exact source `лунная_дорога_через_туманный_лес.png` (1672×941); image is conversation-only, not yet Godot scene or GitHub assets.
4. [x] **D205 tech staging:** convert five previously generated 5×5 source concept atlases into 6×5 96px **review-only** candidates (25 nonempty unique frames per role). Edge-cropped source poses and Sentinel spear/axe mismatch **BLOCK art sign-off**; never enable them as live animations. Stager and QC spec documented.
5. [x] **D206 QA-only encounter and scoped effect source:** five unique UnitData, 2 five-enemy formations and isolated +16% enemy-only travelling-lantern buff/reset logic; *not wired into a playable battle, no native QA yet*. See `docs/D206_BLACK_LANTERN_ENCOUNTER_STAGING.md`.
6. [x] **D206 Godot native contract PASS:** user screenshot confirms 5 original UnitData, two formations, enemy-only lantern buffs/reset after the typed-array fix. This is NOT actual combat QA.
7. [x] **D207 54-case real-combat matrix written QA-only:** `res://scenes/dev/black_lantern_road_battle_matrix.tscn`; uses original UnitData, BattleUnit AI, deterministic scoped light, 2 formations × 3 classes × 3 party sizes × 3 orders. No art switching/live card inclusion.
8. [x] **D207 native F6 matrix 54/54 functional PASS** (user screenshot): 0 defeats/timeouts, avg HP solo/duo/trio 80/70/74%, worst 52/30/44%, light buff observed; **balance not yet approved**. Baseline: `docs/D208_BLACK_LANTERN_BALANCE_PASS.md`.
9. [x] **D208 narrow candidate staged:** increase the #38 *lit-enemy-only* speed modifier 1.16 → 1.22; no generic enemy stat changes. Add actual light-buffed enemy attack counting to deterministic matrix.
10. [x] **D208 native F6 rerun PASS:** 54 wins, no defeat/timeout, HP and duration unchanged to display precision; 59 of 635 enemy attacks accelerated (9.3%). +22% bonus reverted to already-tested +16% in `cc624e3`. Keep actual-attack instrumentation; **do not call balance approved**. Full comparison: `docs/D208_BLACK_LANTERN_BALANCE_PASS.md`.
11. [ ] **D205 native light-cue F6:** run `res://scenes/dev/black_lantern_road_light_preview.tscn`, verify clear moving circles / warning / five enemy proxies and pause. It is explicitly not battle code.
12. [x] **D209 exact forest arena committed:** selected third source re-exported as 1280×720 WebP/Base64; GitHub stored SHA exactly matches local export. Existing authored-backdrop now supports `black_lantern_road`, other arenas unchanged.
13. [x] **D209 native visual F6 PASS** — user screenshot confirms approved original forest background, 3 hero and 5 enemy proxies, large Guide outline and moving lantern circles. Visual layout accepted; actual sprite foot contact not yet tested. See `docs/D209_BLACK_LANTERN_ARENA_NATIVE_QA.md`.
14. [ ] Finish/correct five genuinely distinct skeletal 25-frame atlases to the approved silhouettes; native animation gallery and sprite F6.
15. [ ] **Activate the staged encounter locally** only after art QA: wire #38 light into battle, then 54-case solo/duo/trio combat matrix, real battle→reward→table, and full-pool smoke. Only after approval release #38 to **38/45**.
16. [ ] Finish remaining seven cards without rewriting existing D151–D153 or D196 effects.

## Constraints

Godot 4.7.x + GDScript, data-driven focused additions, rapid playable vertical slice, no speculative global architecture. D143 new enemies for new combats; D167 credible world scene art; D168 user chooses from rendered variants before art integration.
