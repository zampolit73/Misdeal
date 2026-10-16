# Misdeal — Active Roadmap

Updated: 2026-10-16 (D198 source release). **Act 1 live: 37/45.** Technical truth: `docs/PROJECT_STATE.md`.

## Completed / locked

- [x] Playable cursed table, exactly 12 Fate Spread resolutions + sealed boss XIII, and tactical battle → reward → table core loop. Solo/duo/trio preserved; DS2 / Variant C visual system accepted.
- [x] #34 D151 Funeral Procession, #35 D152 Defiled Laboratory, #36 D153 Threadbare Theatre all released with distinct enemies, encounter mechanics and scene-led original art. D153 D178 54/54 native balance and D181 native release smoke PASS.
- [x] D182–D187 Black Crossing: accepted card variant 3, Ferryman B/Drowned C atlases and stormy «Последний причал» arena.
- [x] D188–D191 Black Crossing authored 1+2 fight, wave push/slow and D189 safe plank boundaries. **D191 native 54/54 wins**, 0 entire-party defeats.
- [x] D196 storm VFX held as the current visual baseline after user's request; no more wave tuning in this phase.
- [x] D197 user-native preflight and real battle → reward → table confirmed («Все ок»).
- [x] **D198 code released** #37 `black_crossing` in the 37-card live Act1 pool, updated old 36-count QA guards, and added full-pool randomized Tier1 dealing release smoke.

## Next (strict order)

1. [ ] **Native D198 release verification:** `git pull`, F6 `res://scenes/dev/black_crossing_release_smoke.tscn`; expected **D198 / ACT 1 CARD #37 — RELEASE PASS**, 37 distinct cards, Black Crossing actually sampled in ordinary full-pool Tier1 offers, unchanged Fate Spread and XIII.
2. [ ] If D198 FAIL, inspect current GitHub code, correct regression and recommit directly; then re-run F6. Don't declare native release PASS on source inspection.
3. [ ] Upon native PASS, record result in `PROJECT_STATE`, `ROADMAP`, `HANDOFF`, and `CHANGELOG`; then proceed to **card #38**, with unique enemies/mechanic for combats and 2–3 rendered scene-art options before the user selects one.
4. [ ] Complete eight remaining cards toward **45** while preserving D151–D153, party scaling and original approved assets.

## Constraints

Godot 4.7.x + GDScript, data-driven focused additions, rapid playable vertical slice, no speculative global architecture. D143 new enemies for new combats; D167 credible world scene art; D168 user chooses from rendered variants before art integration.
