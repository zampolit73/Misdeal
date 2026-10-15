# Misdeal — Active Roadmap
Updated: 2026-10-15. **Live Act 1: 36/45.** Current technical status: `docs/PROJECT_STATE.md`.

## Completed / established

- [x] Playable table → event/combat → reward → table loop and boss/Fate Spread structure (12 + sealed XIII).
- [x] Solo, duo and trio protagonists/companions, tactical autobattle and party-size compensation.
- [x] DS2 / Fate Spread Variant C visual baseline, multiple approved battle arenas and character-animation production passes.
- [x] Act 1 pool expanded to **36** cards; D151, D152 and D153 released with original enemies, encounter-specific mechanics and card art.
- [x] D153 original **skeletal** puppeteer / bone marionettes, approved sprites/card/ruined-theatre backdrop; local `ThreadTether` and real battle→reward→table QA.
- [x] D153 D176 localized challenge pass and D177 fix. D178 **54/54 in native Godot**, 74/67/74% average remaining HP (solo/duo/trio).

## Next steps (in order)

1. [x] D153 improved challenge and 54/54 native Godot post-tune matrix; player indicated current tuning is acceptable.
2. [x] D180 enabled `threadbare_theatre` as **Act1 card #36/45** and updated D151/D152/D153 test guards.
3. [x] D181 **native Godot D153 release smoke PASS**: 36 unique cards, controlled Tier1 offer→choice→encounter, Fate Spread and boss XIII verified. Optional ordinary random-run spot-check remains useful.
4. [x] D182 user selected gameplay concept `ЧЁРНАЯ ПЕРЕПРАВА` for #37 and approved **rendered art variant 3**, diagonal pier/ferryman/drowned scene.
5. [x] Exact approved image option 3 committed; strict 448×274 card loader and isolated F6 preview created, remote bytes verified.
6. [x] D183: user-approved native 448×274 F6 preview for Black Crossing option 3.
7. [x] D184 user explicitly approved Ferryman **B** + Drowned **C** and both original generated animation concept sheets; local WebP packing/decoded-cell QA completed.
8. [x] D185: complete artifact cleanup and upload both original 576×480 WebP/Base64 atlases to GitHub; verify matching Git blob SHAs and decoded 25-pose/five-blank structure.
9. [x] D186: user F6 gallery feedback «все ок» approves both original five-state battle animations; do not request the same animation QA again without a regression.
10. [x] D187: user chose and repeatedly refined stormy **«Последний причал»** (no duplicate left ruin/right structure); installed final original 1280×720 WebP as isolated `black_crossing` backdrop.
11. [ ] F6 `res://scenes/dev/black_crossing_arena_preview.tscn` to confirm native arena art (not yet approved in Godot).
12. [ ] Build original `drowned_ferryman`/`drowned_hand` UnitData, two encounter formations and encounter-only warned water-surge push/slow.
13. [ ] 54-case battle QA, real battle→reward→table; only then release #37 as 37/45.
14. [ ] Continue Act1 toward 45 with nine remaining cards and avoid D151–D153 regressions.

## Rules for all subsequent phases

D143 (new enemies for every new fight-bearing card), D167 (world-scene card art), D168 (three user-selectable image variants first), accepted DS2, game-specific Godot 4.7.x/GDScript. Keep details of completed phases in `docs/archive/2026-10-15-pre-cleanup/docs/ROADMAP.md`; don't repaste historical milestones onto this active roadmap.
