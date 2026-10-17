# Misdeal — Active Roadmap

Updated: 2026-10-17 (D206 isolated native F6 contract PASS, D207 54-case unit/combat matrix staged; release gates unchanged). **Act 1 live: 37/45.** Technical truth: `docs/PROJECT_STATE.md`.

## Completed / locked

- [x] Playable cursed table, exactly 12 Fate Spread resolutions + sealed boss XIII, and tactical battle → reward → table core loop. Solo/duo/trio preserved; DS2 / Variant C visual system accepted.
- [x] #34 D151 Funeral Procession, #35 D152 Defiled Laboratory, #36 D153 Threadbare Theatre all released with distinct enemies, encounter mechanics and scene-led original art. D153 D178 54/54 native balance and D181 native release smoke PASS.
- [x] D182–D187 Black Crossing: accepted card variant 3, Ferryman B/Drowned C atlases and stormy «Последний причал» arena.
- [x] D188–D191 Black Crossing authored 1+2 fight, wave push/slow and D189 safe plank boundaries. **D191 native 54/54 wins**, 0 entire-party defeats.
- [x] D196 storm VFX held as the current visual baseline after user's request; no more wave tuning in this phase.
- [x] D197 user-native preflight and real battle → reward → table confirmed («Все ок»).
- [x] **D198 Black Crossing #37 fully released.** Live 37-card pool, migrated D151–D153/shepherd smoke guards and full-pool random-deal release scene committed. The user replied **«все ок»** to the requested Godot F6 release smoke (user-reported native PASS, no independent log).

## Next (strict order)

1. [x] **D199:** #38 `black_lantern_road` approved design — five original skeletal roles, 2×-height Guide, travelling light; no live enemy assets or gameplay.
2. [x] **D200:** exact third card illustration installed QA-only, user-native art review previously reported OK. Keep it unchanged.
3. [x] **D204 → D205 arena selection:** user chose geography **A dead forest bend** and then **third of three finished forest backdrops**, exact source `лунная_дорога_через_туманный_лес.png` (1672×941); image is conversation-only, not yet Godot scene or GitHub assets.
4. [x] **D205 tech staging:** convert five previously generated 5×5 source concept atlases into 6×5 96px **review-only** candidates (25 nonempty unique frames per role). Edge-cropped source poses and Sentinel spear/axe mismatch **BLOCK art sign-off**; never enable them as live animations. Stager and QC spec documented.
5. [x] **D206 QA-only encounter and scoped effect source:** five unique UnitData, 2 five-enemy formations and isolated +16% enemy-only travelling-lantern buff/reset logic; *not wired into a playable battle, no native QA yet*. See `docs/D206_BLACK_LANTERN_ENCOUNTER_STAGING.md`.
6. [x] **D206 Godot native contract PASS:** user screenshot confirms 5 original UnitData, two formations, enemy-only lantern buffs/reset after the typed-array fix. This is NOT actual combat QA.
7. [x] **D207 54-case real-combat matrix written QA-only:** `res://scenes/dev/black_lantern_road_battle_matrix.tscn`; uses original UnitData, BattleUnit AI, deterministic scoped light, 2 formations × 3 classes × 3 party sizes × 3 orders. No art switching/live card inclusion.
8. [ ] **D207 native F6 matrix:** run that scene; review win/losses, difficulty by class/party size and buff uptime before any balance tuning. See `docs/D207_BLACK_LANTERN_BATTLE_MATRIX.md`.
9. [ ] **D205 native light-cue F6:** run `res://scenes/dev/black_lantern_road_light_preview.tscn`, verify clear moving circles / warning / five enemy proxies and pause. It is explicitly not battle code.
10. [ ] Import **exact selected** empty forest artwork into a 1280×720 QA-only arena and native-check ground/contact/contrast (requires proper image-byte GitHub upload; do not quietly repaint).
11. [ ] Finish/correct five genuinely distinct skeletal 25-frame atlases to the approved silhouettes; native animation gallery and sprite F6.
12. [ ] **Activate the staged encounter locally** only after art QA: wire #38 light into battle, then 54-case solo/duo/trio combat matrix, real battle→reward→table, and full-pool smoke. Only after approval release #38 to **38/45**.
13. [ ] Finish remaining seven cards without rewriting existing D151–D153 or D196 effects.

## Constraints

Godot 4.7.x + GDScript, data-driven focused additions, rapid playable vertical slice, no speculative global architecture. D143 new enemies for new combats; D167 credible world scene art; D168 user chooses from rendered variants before art integration.
