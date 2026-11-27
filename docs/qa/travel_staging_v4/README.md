# Travel Staging V4 — ground-plane and actor scale audit

Player accepted the full Cinematic Travel V3 rollout on 27 November 2026 and requested that the characters follow believable paths at scene-appropriate scale. V4 does not change the approved illustrations, animations, gameplay, scene duration or V3 motion/FX.

## Implementation

- The 22 scene profiles in `resources/travel/staging_v4.json` define local 1280×720 ground anchors, a reference stature, horizon, and where needed formation spacing, facing or recruit handoff waypoints. The two earlier curved routes (Borrowed Boots/False Weights, historically named campfire/granary) keep their original curves and recalibrate origin, scale and lane width.
- Batch 02 uses the same ground route and projected height for all outcomes of a given location; the action patches and actual party membership remain authoritative. The approved Broken Crown route and reference stature are retained. Scene coordinates, not the selected reward, determine projected size.
- Depth reduces projected stature naturally. Narrow roads, corridors and the bridge use tighter lanes; the visual route and gait sample the same feet. Reuse existing rear NE, rear NW and side walks where appropriate. No new sprites.
- The altar rescue uses a waypoint descent around the platform edge; the prisoner's existing open-gate patch becomes visible at the handoff, and the rescued actor crosses onto the corridor floor without reversing. Elevated actors use the supporting ground depth for stature and no floating floor dust. The well keeps its occluder. Jack remains attached to the real Ranger companion state.

## Visual staging audit

Sampled six timepoints per each of the 24 representative contexts using the actual Godot presentation nodes, contact coordinates, scales and texture frames. Reviewed offline contact sheets of the source plates plus exported actor positions before/after (not native framebuffer captures; shaders, overlays and foreground occlusion are not fully represented). Example first visible actor at t=1.5 s, rounded projected alpha-bounds height in pixels, same representative context:

| Scene | Before → after | Direction / reason |
| --- | ---: | --- |
| Banner Seamstress | 45 → 104 | Traverse the painted road closer to the camera, towards the right |
| Curse Forge | 337 → 275 | Walk on the workshop floor, proportional to smith and workbench |
| Rattling Bridge | 229 → 189 | Stay inside deck/railings, narrower formation |
| Debtor Bones | 197 → 160 | Head up-left into the actual tunnel using NW rear frames |
| Gravedigger Shop | 302 → 259 | Keep to the ground in front of the stand, continue along road |
| Lost Purse | 299 → 169 | Follow curve toward the horizon past the tomb, not over the grave |
| Borrowed Boots | 135 → 129 | Existing road, tighten lateral lanes |
| False Weights | 103 → 107 | Existing corridor, tighten lateral lanes |

Other profiles preserve or refine the existing ground corridor: Candle Seller, Blood Ledger, Wizard Tithe, Broken Crown, Last Signal, Unsent Letters, Black Altar, Chained Prisoner, Jack, Whispering Well, Last Camp, Ash Rest, Bone Tax, Faceless Card, Moon Seal and Echo Crypt.

## QA

Godot 4.7.2 headless, ten targeted suites: **39/39 passed, 20,660 assertions**. Includes all 126 catalog outcomes, real party subsets, companion continuity, pause/skip, grounded support and read-only contract; four new staging regressions check outcome independence, perspective and route sampling, elevated handoff stature/dust and forward prisoner exit. See [test log](godot_targeted.log).

Native visual acceptance: pending Windows player review. Offline composites check geometry but cannot certify real-time rendering, stride feel, occlusion, shaders or sound. QA Hub (F6) → TRAVEL, especially Banner Seamstress, Curse Forge, Rattling Bridge, Debtor Bones, Black Altar, Chained Prisoner. Use 1/2/3 for party sizes, ←/→ for outcomes, R for replay. In F5 verify normal handoff and skip. Do not reset save data. If any foot positions or scale still feel wrong, refine the relevant profile rather than applying another global multiplier.
