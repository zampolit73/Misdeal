# Misdeal — Active Roadmap

Updated: 2026-10-16 (D200 native card-art user-confirmed; D201 arena selection next). **Act 1 live: 37/45.** Technical truth: `docs/PROJECT_STATE.md`.

## Completed / locked

- [x] Playable cursed table, exactly 12 Fate Spread resolutions + sealed boss XIII, and tactical battle → reward → table core loop. Solo/duo/trio preserved; DS2 / Variant C visual system accepted.
- [x] #34 D151 Funeral Procession, #35 D152 Defiled Laboratory, #36 D153 Threadbare Theatre all released with distinct enemies, encounter mechanics and scene-led original art. D153 D178 54/54 native balance and D181 native release smoke PASS.
- [x] D182–D187 Black Crossing: accepted card variant 3, Ferryman B/Drowned C atlases and stormy «Последний причал» arena.
- [x] D188–D191 Black Crossing authored 1+2 fight, wave push/slow and D189 safe plank boundaries. **D191 native 54/54 wins**, 0 entire-party defeats.
- [x] D196 storm VFX held as the current visual baseline after user's request; no more wave tuning in this phase.
- [x] D197 user-native preflight and real battle → reward → table confirmed («Все ок»).
- [x] **D198 Black Crossing #37 fully released.** Live 37-card pool, migrated D151–D153/shepherd smoke guards and full-pool random-deal release scene committed. The user replied **«все ок»** to the requested Godot F6 release smoke (user-reported native PASS, no independent log).

## Next (strict order)

1. [x] **D199 concept chosen:** card #38 is **«Дорога чёрных фонарей»**, skeleton-heavy fight with 5 original enemy roles; user chose the **first** moonlit road composition among three initial illustrations and explicitly approved the last character/encounter concept sheet. Main Guide must stand ~2× taller and look radically distinct; AI visual noise must be removed. See `docs/DECK_EXPANSION_D199_BLACK_LANTERN_ROAD.md`.
2. [x] **D200 art selection + source integration:** after three new standalone scene illustrations, user chose the **THIRD**. The exact selected moonlit skeleton procession (not the labelled concept sheet) was exported text-free at 448×274, committed as WebP/Base64 and wired to existing unified card art; dedicated QA-only RunCardData and F6 preview created. **Native 448×274 F6 art approval user-reported PASS** («вск ок» in reply to the requested F6 preview); runtime screenshot not independently provided.
3. [ ] **D201/D203 arena options and approval:** skill-guided QA found multiple castle-road candidates compositionally repetitive. A temporary 1280×720 **D201 option #2 floor staging overlay** demonstrated space for 3 heroes and 5 skeletons, including a giant 2× Guide, but excessive baked lanterns obscure the intended movable light pools. See `docs/D203_BLACK_LANTERN_ARENA_ART_QA.md`. **Next:** show 2–3 truly different actor-free original environments (dead-forest bend / gloomy ford / abandoned toll gate), choose one, then integrate exact approved background and native F6-test feet/contrast. Current candidates NOT approved.
4. [ ] Create five original animated skeletal enemy atlases (Guide ~2× tall) with full-body feet/facing; preview gallery native F6.
5. [ ] Implement the scoped moving-lanternlight mechanic and 5-enemy/two-formation encounter in QA-only Godot Resources, then solo/duo/trio 54-case matrix, battle→reward→table and full-pool release smoke. Activate #38 only after user-approved native QA, reaching 38/45.
6. [ ] Complete the **seven** cards remaining *after* #38 is released, while preserving existing #34–#37, D196 waves, 12+XIII and party scaling.

## Constraints

Godot 4.7.x + GDScript, data-driven focused additions, rapid playable vertical slice, no speculative global architecture. D143 new enemies for new combats; D167 credible world scene art; D168 user chooses from rendered variants before art integration.
