# Cinematic Travel V3 — pilot (2026-11-27)

Player approved the three-scene animation and staging pilot, after the 24 locations had already been artistically accepted. No new illustrations, reward logic, battle art, or new timing contract.

| Location | Outcome count | Pilot changes |
| --- | ---: | --- |
| Blood Ledger | 4 | Unclamped trio route from the first frame, distance-aware gait, two local candle-light pools, progressive local book patch/half-close blend, paper/coin beat. |
| Whispering Well | 8 | Lamp shimmer, water ripple for actual non-leave outcomes, eased rescue approach and waiting-actor handoff, sink blend; companion with Ranger, short coin cue for paid actions. |
| Rattling Bridge | 7 | Moving instead of clamped rear walkers, recruiter keeps moving until exit, seated-to-live handoff, pinned-interior banner motion, brazier flicker/embers, modest camera push and wood step/creak cues. |

`travel_v3_motion.gd` samples the authored route 48 times per actor and normalizes segment distance by projected stature. Pose phase is seekable from local time; no wall-clock or gameplay RNG. Existing six authored poses and sole offsets remain unchanged. This addresses stationary cycling and mismatched cadence, not a claim of full horizontal foot IK. Camera overscan covers the 1280×720 frame and is shared by the background, patches, foreground, actors and feet. Local shaders reuse the original base texture and are restricted to authored masks; no new bitmap sources. Well ripples use bounded transient arcs, bridge a bounded seven-mote field. Pilot action beats use only existing SFX, no water sample or location loop added. Jack reads the real transient companion state and stays separate from the hero party count; remaining legacy scenes keep their original presentation.

The normal 4 s travel duration and original catalog/choice/loot/progression/save/skip/pause contracts are unchanged. Pilot scope is exactly three IDs. No full-act art or sound acceptance claim.

## Review

Open `scenes/dev/qa_hub.tscn`, F6, TRAVEL; search `blood_ledger`, `whispering_well` and `rattling_bridge`. Inspect all outcomes with arrows, solo/duo/trio with 1/2/3, P pause and R replay. F5 real event routes are also enabled for these three scenes. Check gait speed and soles, readable consequences, flag edges/light, water/rescue, actual audio timing and skip. Jack requires an actual companion in the campaign. Do not reset the profile. Do not scale to the remaining 21 scenes before visual review.

## Automated validation

Godot 4.7.2 headless: 17/17 GUT tests, 5,478 assertions, exit 0, across `test_travel_v3_pilot.gd`, `test_travel_transition.gd` and `test_travel_batch02.gd`. Evidence: `docs/qa/travel_v3_pilot/godot_targeted.log`. Native graphical/audio review is pending (the local headless environment could not start an X display); shader appearance and perceived sound quality are not visually/audibly certified.

## Full rollout — 2026-11-27

The player confirmed the initial pilot was OK and authorized continuation. All 24 original event scenes now use V3 (126 outcomes: Batch 02 31, Batch 03 72, Pilot Batch01 11, four older scenes 12). The pilot record above remains historical.

- Batch 02: candle workshop, dice debtor, tithe, crown and forge adopt the same route/footstep clock, while preserving exact existing V2 candle extinguishing, dice, refused bowl, crown and forge object reactions.
- Batch 03: nine additional scenes receive coherent overscan and measured routes. Existing entry/recruit/lost overlays are preserved; waiting heroes/Jack fade into the existing live walkers at their authored handoff times, and normal local outcome patches blend. The new local shader uses bounded flame/cloth masks where supported by the existing painting (e.g. forge, altar, prisoner lantern, campfire, tax stall). Quiet plates retain their authored atmosphere without arbitrary flame effects.
- Earlier seven: Last Signal, Gravedigger Shop, Lost Purse, Posthouse, Dressing Station, Campfire and Granary retain existing moving layers, scene props, bird and masks. The gait clock samples their existing routes; the short Batch01 route starts every party member moving without rear clamp. Short cues are timed to existing actions, not a single generic interval.
- Actual Jack is represented in all 24 locations at projected 34% adult stature; scene-owned recruitment still controls first visibility. No new asset, ambient loop, reward, save, card or battle-road changes. Existing side-view Jack frames remain the source; no claim of newly authored rear-facing dog frames or full horizontal foot IK.

F6 review as above; the new 21 locations still need native motion and audio acceptance. Test a real later event with Jack and a normal Event→Travel→Table route with skip. Do not redo the already accepted pilot art.

### Rollout QA

Godot 4.7.2 headless: 40/40 tests, 15,603 assertions, exit 0, across ten Travel-specific GUT suites; the new matrix covers 126 outcome contexts across 24 locations, visible sole contact and gait progress, deterministic seeking, the actual Jack flag, NPC handoffs and unchanged run state. The prior scene-specific tests additionally cover the existing solo/duo/trio shapes, props, exact source references, pause/skip and live route integration. [Evidence](qa/travel_v3_rollout/godot_targeted.log). No native framebuffer or audio listening was performed for the rollout; player review remains the visual gate.
