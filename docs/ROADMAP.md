# Misdeal — Active Roadmap
Updated: 2026-10-16 (D197 release preflight). **Live Act 1: 36/45.** Current technical status: `docs/PROJECT_STATE.md`.

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
11. [x] D187: user-confirmed native arena F6 («все ок»). Approved cleaned storm picture locked.
12. [x] D188: new Ferryman/Drowned UnitData, 1+2 enemy encounter with two formations, scoped 1.4s warning + push/slow wave, no damage/stun; QA-only card lookup.
13. [x] D188 **user native 54/54 FUNCTIONAL PASS** before geometry/visual correction; 85/78/84% mean HP and 81 warnings / 58 surges / 71 pushes / 71 clean resets. User's real battle screenshot revealed a rectangular debug-like surf visual and characters on broken beams.
14. [x] D189 source fix: rolling irregular surf with foam/spray, and shared safe plank movement/deployment/push bounds for D188 only.
15. [x] D191 **user native Godot matrix PASS** post-D189: 54/54 wins, no party defeats; mean HP 86/74/77% (solo/duo/trio), 78 warned / 62 surge / 66 pushed / 66 cleaned. Actual combat screenshot: unit movement on upper deck improved, but surf looked like thin lines.
16. [x] D192 source-only breaking surf visual pass: large shaded advancing water body, foamy curled lip, individual irregular foam caps and spray. All hit lanes, push/slow timing and movement floor untouched.
17. [x] D192 **native visual FAIL**: screenshot shows a large teal band floating over the sea/horizon, above combatants' feet. The source drew at unit-origin lane Y rather than art boot-contact Y.
18. [x] D193 local visual-only fix: shoreline drops 36px to foot contact, dark slate translucent broken crests/eddy patches replace continuous wide teal rectangle; no art, floor or combat parameter changes.
19. [x] D193 native screenshot: **VISUAL FAIL**. Seven weak foam fragments read as chalk scratches; no storm-wave volume despite massive environmental storm.
20. [x] D194 source remake: three 450px overlapping storm breakers, organically tapered dark raised faces, breaking whitecaps + wind spray + moving shallow wash, using animation keyed to warning/surge phase. Rendering stays grounded at unit foot contact and does not change hit lane, push or slow.
21. [x] D194 native screenshot: major swell reads better, but repeated solid white triangular foam peaks still look computer-generated. User requested more professional movement/detail, not release.
22. [x] D195 drawing-only polish: remove seven-point cap triangle repetition; use 72-sample asymmetric wave envelopes, three rounded staggered foam clusters per breaker, mixed-frequency turbulence and time-delayed whitewater wash/recede, with restrained cold storm palette.
23. [x] D195 native screenshot: smoother foam but wave is still too static and doesn't convincingly run up the planks. User requests more pronounced advance.
24. [x] D196 render-only pass: warning moves from -91px to -62px relative to boot line; surge starts at -62px without jump and advances 94px toward the intact deck (vs 37px); an additional shallow, capped runoff layer follows the falling crest. No changes to hit lanes, timings, push or slow.
25. [x] User approved leaving D196 surf as the **current provisional visual baseline** and asked to continue toward release. No more wave tuning in this pass.
26. [x] D197 pre-release audit scene: verify 36-card QA-only state, card/encounter art, original enemy formation, production Tier1 RunState offer→selection→Fate Spread→XIII; one button launches real Black Crossing battle→reward→table. Old playtest now also supports the future 37-card state.
27. [ ] **NEXT NATIVE ROUTE GATE:** user `git pull`, F6 `res://scenes/dev/black_crossing_release_preflight.tscn`, confirm preflight PASS and use its button to complete actual battle → choose reward → return to Fate Spread/table. Native D197 result pending; D191 54/54 remains confirmed.
28. [ ] After real route confirmed, activate #37, update existing 36-card smoke guards, run a separate actual-pool/ordinary-deal smoke. Do not call a source-only preflight a real reward UI test.
29. [ ] Continue Act1 toward 45, eight cards remain *after* #37 goes live; avoid D151–D153 regressions.

## Rules for all subsequent phases

D143 (new enemies for every new fight-bearing card), D167 (world-scene card art), D168 (three user-selectable image variants first), accepted DS2, game-specific Godot 4.7.x/GDScript. Keep details of completed phases in `docs/archive/2026-10-15-pre-cleanup/docs/ROADMAP.md`; don't repaste historical milestones onto this active roadmap.
