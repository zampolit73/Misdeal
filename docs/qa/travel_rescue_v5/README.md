# Cinematic Travel V5 — ritual, prisoner and companion batch (F6 review)

Source baseline `938c57ea77bb357f8330eb8919e517fbfe4d05ac`, 2026-11-27. The actual 6.6 s review scene is `scenes/dev/travel_rescue_v5_preview.tscn`. Z/X location, arrows outcome, 1/2/3 party size, Q/E composition, R/Space replay, P pause, H hide controls, M sound, J existing companion on the first two scenes. Jack's own card has only legal Ranger-containing parties and the outcome controls companion continuity.

| Location | Authored scene action |
| --- | --- |
| Black Altar | Grounded approach over the two steps, selected ritual participant at the actual bowl, others stay on road. The actual painted mage remains until the committed rescue; then existing six recovery poses are sampled in reverse, feet anchored on table, supported scale calibrated to the ground below it, step down over the front edge, return through the left passage. Existing bowl / sacrifice / abandoned states exactly reused. |
| Chained Prisoner | Approach gate and acknowledge the actual release, chain/loot/mentor/abandon outcome. Existing open-gate painting replaces the closed one before a released Knight stands and crosses threshold. Retreat along real left corridor, rear direction frames as party recedes; no live Knight from the prisoner in abandonment/mentor/loot. |
| Jack | Ranger steps beside shelter, kneels and acknowledges the existing treatment layer. Actual post-treatment dog rises through previously authored poses, exits the shelter and follows Ranger on a separate ground lane; two other heroes wait farther along the road so the animal remains visible. Pass/token retain the original painted Jack and never grant a companion. Recruited state keeps only the real live animal and prepared treatment props. |

Shared 1280×720 ground projection; scene-owned paths, scale, foot contact, local camera movement, existing V3 candle/cloth masks, distance-based gait, actual D412 hero and Jack atlases, native painted source outcomes. Old recovery/crouch/cast poses reused in presentation only: no defeat or attack signal and no combat state is touched. The gate uses the approved exact open-state cut (not a bespoke swinging gate); treatment is a staged kneel and existing authored treatment layer, not a new hand-to-bandage sprite pack. No card art repaint or new asset/dependency intake. Nothing in existing production V4/V5 routes, rules, rewards or saves changes until approval.

## QA

- Actual Godot 4.7.2 isolated preview fixture (all relevant original project textures, direction atlases, same render scripts): **128 contexts / 15,723 checks / 0 failures**. All catalog actions, legal party compositions and both actual companion flags where applicable; actual outcome timing, no duplicate recruit, gate state, source pose/sole alignment, deterministic replay, camera coverage and actual F6 input cycling.
- Headless F6 launch completed; four ObjectDB instances warned at exit. Offline frame review composed the actual sampled Godot Sprite2D textures, transforms and alpha (not a native framebuffer or a published video). Refined after review: actual left passages instead of right-edge crowding, clear Ranger/dog interaction region, separate waiting and exit lanes, rear-facing holds. Native visual acceptance remains pending.
- No new or changed images, sound, shaders, addons or third-party media; the existing source rights audit remains open. No asset registration changes warranted in this code/data-only package.
- [Headless evidence](godot_smoke.log). Production remains **7/24 V5**; 3 more staged, 14 unconverted after this candidate.

## Provenance

All visual/audio assets reused byte-for-byte from the project at the baseline: `assets/pixel/travel/batch_03/scene_01_black_altar/`, `scene_02_chained_prisoner/`, `scene_03_jack/`; shared `assets/pixel/units/hero_c3_d412_polish/`, `assets/pixel/units/jack/`, `assets/pixel/travel/campfire_without_master/rear_walk/`, and existing registered Act I cues. New scene profiles and source scripts are original project work. No additional generation, external source or license assertion.
