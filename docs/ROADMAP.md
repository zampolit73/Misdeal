# Misdeal — Active Roadmap

Updated: 2026-10-16 (D198 native release QA user-confirmed). **Act 1 live: 37/45.** Technical truth: `docs/PROJECT_STATE.md`.

## Completed / locked

- [x] Playable cursed table, exactly 12 Fate Spread resolutions + sealed boss XIII, and tactical battle → reward → table core loop. Solo/duo/trio preserved; DS2 / Variant C visual system accepted.
- [x] #34 D151 Funeral Procession, #35 D152 Defiled Laboratory, #36 D153 Threadbare Theatre all released with distinct enemies, encounter mechanics and scene-led original art. D153 D178 54/54 native balance and D181 native release smoke PASS.
- [x] D182–D187 Black Crossing: accepted card variant 3, Ferryman B/Drowned C atlases and stormy «Последний причал» arena.
- [x] D188–D191 Black Crossing authored 1+2 fight, wave push/slow and D189 safe plank boundaries. **D191 native 54/54 wins**, 0 entire-party defeats.
- [x] D196 storm VFX held as the current visual baseline after user's request; no more wave tuning in this phase.
- [x] D197 user-native preflight and real battle → reward → table confirmed («Все ок»).
- [x] **D198 Black Crossing #37 fully released.** Live 37-card pool, migrated D151–D153/shepherd smoke guards and full-pool random-deal release scene committed. The user replied **«все ок»** to the requested Godot F6 release smoke (user-reported native PASS, no independent log).

## Next (strict order)

1. [ ] **D199 — select card #38 concept:** present 2–3 distinct dark-fantasy gameplay pitches, each with its risk/choice hook. Do not pre-select combat or event.
2. [ ] Once the user selects a concept, create 2–3 **actually rendered scene-first art options** (D167/D168). The user picks the one to integrate; avoid generic sprite compositions and AI micro-clutter.
3. [ ] Implement card #38 through focused Godot 4.7.x/GDScript resources and scenes. Combat cards require genuinely new enemies and a local mechanic (D143), relevant battle QA, user-native visual tests and separate normal-deal release smoke.
4. [ ] Grow Act 1 toward 45 (eight remaining cards), preserving all approved D151–D153 and D198 assets, the D196 surf version, existing party scaling and 12+XIII structure.

## Constraints

Godot 4.7.x + GDScript, data-driven focused additions, rapid playable vertical slice, no speculative global architecture. D143 new enemies for new combats; D167 credible world scene art; D168 user chooses from rendered variants before art integration.
