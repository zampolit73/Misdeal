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

Original staging was preview only. See partial approval and correction below.

## Player screenshot correction and partial approval

Player accepted Last Camp and Ash Rest but reported the Boots repair frame at 2.5 s (Knight/Ranger/Mage). The previous Boot projection put party at 313–409px nominal projected body heights, magnifying the 288px cel art too far. Preserve the painted close foreground Squire and boot rack; project the walking heroes on the middle road plane behind that foreground, rather than at the viewer's feet. At the action beat the trio is now approximately 152/173/181px nominal height; no new art. Boot road/profile owns its approach/wait slots, all three outcomes use the revised path, same 0.95m dog stature, camera peak 1.047 versus 1.122; original repair strap/local lighting remain. Offline sampled Sprite2D compositing inspected at 2.5s and departure; no native framebuffer capture here. Boots still requires player recheck.

Production allowlist activates **only Last Camp and Ash Rest**, using exact committed batch03 action and post-choice party/Jack, accepted audio cues, 6.6s clock, existing caption, pause/skip and one-shot Table return. Borrowed Boots and earlier rescue preview remain V4 in normal play. 9/24 V5 live, four staged, eleven unstaged.

- Updated isolated Godot 4.7.2 fixture: 122 F6 contexts / 19,138 checks (including projected stature, middle-plane soles and camera bound); 58 production contexts / 1,284 checks, 6 fallback checks; previous live V5 regressions 200 contexts / 3,902 checks; zero failures. [Log](boots_fix_and_live.log).
- F6 path unchanged. X twice, repair/hobnails/pass with trio, J companion, R repeat. Native visual approval of revised Boots and integrated F5 camp playback pending. No asset, rules or save changes.


## Source-registered cobbler animation (28 Nov 2026)

Player requested that the seated Squire move like the accepted Curse Forge smith. Four newly authored poses show strap pull, buckle threading, glance and leather press, returning to the original seated frame between work cycles. A local 470×515 lossless RGBA patch is registered exactly at (230,145) in the 1672×941 original artwork; the fixed source face in the working cels, insignia, original twin-bone shaft (remapped to wrist), legs, seat and environment are retained. Alpha is clear outside the local action region and crop edges. Source-space projection matches the original layered camp, drawn above outcome layers and below near foreground. No duplicated sprite, whole-painting movement or changed boot rack state. Passing uses normal work and a brief glance; repair resumes the strap task; hobnails uses glance/press reaction. Existing prop commit occurs at 3.22 s, untouched. No new audio or gameplay state. One missing/corrupt optional cel leaves the static original rather than a partial actor.

- Pinned source: `assets/pixel/travel/campfire_without_master/approved_reference.png` at `cee3327fe66cda5bafc216b7d3da68d2e02f7cae`, SHA-256 `ea21184b5a2792ce5ac3d4226f95656a5b812caab6bd345d19ef6d138d94a53a`.
- Generation: 2026-11-28, project-only original source crop (230,145) to (700,660); 1198×1313, 2×2 sheet, SHA-256 `01d2f68d183c2bf6c122237f8b8b820eedd85c17aafe509476b9ab2a062e1edf`. Brief: same dark-fantasy painted character, exact costume and skeletal right forearm; four close work poses pulling/threading strap, lifting gaze and pressing worn boot, locked viewpoint and consistent lighting. No outside reference. Offline packing script `scripts/dev/pack_squire_v5.py` uses the original image and this generation sheet; editor/runtime uses only final cels. Generated sheet receipt recorded, not duplicated in runtime.
- Committed cels:
  - `assets/pixel/travel/cinematic_v5/squire/glance.webp`: `b80a4b86284b0c5e3129b7c027a72859d3e0c1fb24b7833d53d3e4d22e395404`.
  - `assets/pixel/travel/cinematic_v5/squire/press.webp`: `2a3c79fa696f4004b9aae9dedbd19c5c26f545e99e6d60d813a11ce343fd59bf`.
  - `assets/pixel/travel/cinematic_v5/squire/pull.webp`: `c6465f525976504c46c3447dbcbeb0b888173e124a9e7746eff54a57a5ac4eaf`.
  - `assets/pixel/travel/cinematic_v5/squire/thread.webp`: `5e930e39ec7259f9d0d92fc999e5b6ad195c7193245963947d6b3733501125f2`.
- Godot 4.7.2 isolated fixture: **122 / 19,975 checks / 0 failures**, including source registration, phase uniqueness/native dimensions, deterministic replay and Boots-only scope; production accepted camp regression 58 / 1,284 / 0 failures; 12 checks all three outcomes with one cel missing, original painting retained. [Log](squire_animation.log).
- Offline composites of seven sampled times in all three outcomes generated from actual Godot texture/transform data; inspected source cels and the six repair action frames for pose registration, unchanged environment and grounded heroes (does not render GPU shaders). License inventory 39/39 registered paths / 0 errors / 8 existing legacy release-review warnings.
- Native F6 visual acceptance remains pending. Launch existing `scenes/dev/travel_camp_v5_preview.tscn`, X twice, arrows repair/hobnails/pass, R repeat; keep all approved production scenes unchanged (9/24 live). Rollback: hide/remove the optional Squire node/pack; original source art and state layers were not altered.
