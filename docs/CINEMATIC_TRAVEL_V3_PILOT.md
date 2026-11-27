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
