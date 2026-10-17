# Misdeal — Active Roadmap

Updated: 2026-10-17 (D211 spear option A selected, D213 canonical five-role frame rows corrected, D214 detailed Lantern Bearer specification completed; art production pending). **Act 1 live: 37/45.** Technical truth: `docs/PROJECT_STATE.md`.

## Completed / locked

- [x] Playable cursed table, exactly 12 Fate Spread resolutions + sealed boss XIII, and tactical battle → reward → table core loop. Solo/duo/trio preserved; DS2 / Variant C visual system accepted.
- [x] #34 D151 Funeral Procession, #35 D152 Defiled Laboratory, #36 D153 Threadbare Theatre all released with distinct enemies, encounter mechanics and scene-led original art. D153 D178 54/54 native balance and D181 native release smoke PASS.
- [x] D182–D187 Black Crossing: accepted card variant 3, Ferryman B/Drowned C atlases and stormy «Последний причал» arena.
- [x] D188–D191 Black Crossing authored 1+2 fight, wave push/slow and D189 safe plank boundaries. **D191 native 54/54 wins**, 0 entire-party defeats.
- [x] D196 storm VFX held as the current visual baseline after user's request; no more wave tuning in this phase.
- [x] D197 user-native preflight and real battle → reward → table confirmed («Все ок»).
- [x] **D198 Black Crossing #37 fully released.** Live 37-card pool, migrated D151–D153/shepherd smoke guards and full-pool random-deal release scene committed. The user replied **«все ок»** to the requested Godot F6 release smoke (user-reported native PASS, no independent log).

## D209/D210 status

- [x] **D209 native arena art visual PASS** — user F6 screenshot and «все ок» on selected third black-forest art, 3 hero + 5 enemy proxies and moving pools; this confirms layout only, not final character art.
- [x] **D210 art preflight** — five source 5×5 sheets and remapped 6×5 candidates visually audited; 13/20/24/21/13 boundary-contact warnings, Sentinel axe vs approved spear. Five atlas approval gates still **BLOCKED**. See `docs/D210_BLACK_LANTERN_ANIMATION_ART_QA.md`.
- [x] **D211 Sentinel option A approved** by user («а»): armored long-spear silhouette with small lantern. No authentic production atlas yet. `docs/D211_ROAD_SENTINEL_SPEAR_CONCEPT_OPTIONS.md`.
- [x] **D213 canonical animation master brief committed:** fixes prior chat D212/D213 row-major mismatch. All five Godot atlases MUST be row-per-state: idle(4), walk(6), attack(6), hit(3), death(6); 5 transparent surplus cells. `docs/D213_BLACK_LANTERN_MASTER_ANIMATION_BRIEF.md`.
- [x] **D214 Bearer production specification committed:** 25 explicit pose directions, heavy lantern + wooden defensive plank, real pixel/foot/alpha gates; purely ART specifications, no real atlas. `docs/D214_LANTERN_BEARER_PRODUCTION_SPEC.md`.
- [ ] Produce/review FIVE **genuinely authored** idle/walk/attack/hit/death 96px transparent atlases. Begin with Sentinel's correct spear; retain prior selected arena and card illustration.
- [ ] After sprite approval: Godot animation F6, actual #38 five-enemy battle with encounter-only light, then real reward→table and release smoke before Act1 **38/45**.

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
