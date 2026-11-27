# Cinematic Travel V5 — camp and equipment (review batch)

Baseline `25c8654b1fec5af6f29a001cdd117cde6f4b491f`, 2026-11-27. F6 `scenes/dev/travel_camp_v5_preview.tscn`. Z/X location, arrows legal outcome, 1/2/3 party size, Q/E composition, J companion, R/Space replay, P pause, H hide, M mute. 6.6 seconds, deterministic seek.

| Location | Staging |
| --- | --- |
| Last Camp | Approach the wounded Knight at the shelter (blood or equipment-loot) or the real side table (gold or training). Original painted Knight remains until the outcome. On recruitment, a dedicated living kneel/rise at the shelter replaces him exactly once; he steps onto the road and follows the party. Training uses the selected existing hero, and the actual equipment state changes. Abandonment retains the authored aftermath. |
| Ash Rest | Approach the seated Ranger or the actual training kit/embers. On recruitment, the Ranger rises at the stone, then joins on the open ground; abandonment and looting retain the existing exact seated outcome. Mage uses the living staff-cast, not a death pose. |
| Borrowed Boots / Костёр без хозяина | Compose the existing registered underpaint/gate/road/camp/foreground at the same full-plate projection. The lead kneels near the equipment, then returns to the winding gate road. Original repair/hobnails layers switch only at the action beat; existing repair strap, lamp and canopy motion retained. Passing never switches a layer or grants anything. |

Shared native-detail 288px cels (96px logical geometry), actual role or original post-choice recruit, living recovery poses, scene-owned physical scale and foot contacts, path-distance gait, true rear poses and bounded camera. Jack retains the shared 0.95m / 56px standing reference, independently spaced on the ground. No changed paintings or audio bytes; camp actions are existing painted state changes accompanied by authored gestures, not bespoke shoe grasp or animated Squire replacement. All production rules, save data, 7 live V5 IDs, existing three staged rescue films and V4 fallback remain unchanged.

## Validation

- Godot 4.7.2 isolated fixture using actual scripts and project assets: **122 legal contexts, 18,418 checks, 0 failures**. All party compositions, valid action IDs, optional real Ranger companion, exact state cut/one recruit, HD living cels, actual trainee, anchored soles, adult dog scale, ground movement, camera coverage, deterministic replay, negative cases and actual F6 keyboard controls.
- Headless F6 launch succeeded; the existing preview audio lifecycle produced four ObjectDB instances warned at exit. Offline composites of sampled Godot textures and transforms inspected for approach, kneel/rise, departure and party spacing; not native framebuffer or user visual acceptance.
- License inventory: 35 registered resource paths, 0 errors, 8 pre-existing legacy audit warnings. No new image/audio or third-party asset registration needed.
- [Smoke log](godot_smoke.log). Run in Godot: `godot --headless --path . --script res://scripts/dev/travel_camp_v5_smoke.gd`.

## Source and integration

All existing art from `assets/pixel/travel/batch_03/scene_05_last_camp/`, `scene_06_ash_rest/`, `assets/pixel/travel/campfire_without_master/`; shared source-detail and living-pose atlases previously registered; original Act I audio cues from `assets/audio/act1/`. The new JSON scene profiles and scripts are original Misdeal presentation code and data. No media changes, no new external dependency.

Preview only: before activating camp IDs in production, inspect F6 natively and receive player acceptance. Preserve the approved seven live films; six additional scenes are staged, eleven not yet staged.
