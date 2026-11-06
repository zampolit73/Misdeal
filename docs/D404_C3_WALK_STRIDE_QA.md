# D404 — real C3 walk footfall pacing (2026-11-06)

## Evidence

D403 grounded live C3 Knight/Ranger/Mage positions and removed duplicated attack sprite stretching. It did **not** modify the source images. At D404 start, inspected the three actual GitHub C3 WebP alpha atlases: Knight uses D402, Ranger and Mage use D401. The raw previews can show bright underlying RGB mattes if alpha is not composited, but the native Godot pixel audit counted no comparable opaque primary rectangles (Ranger 0 for all WALK cells). **Do not delete alpha-clear RGB pixels as if they were in-game artifacts.** 75 actual native pose scans showed all 18 WALK cels contain grounded foreground alpha at Y87–90 in a 96px tile. This does not certify artistic quality; it does establish a stable source-foot baseline.

The real `BattleUnit` advanced WALK at 7fps by elapsed time regardless of real traveled distance. Enemies use the same behavior; C3 does not need to. A blocked character could animate stepping while stopped during the intentional 0.18s walk-to-idle hysteresis; faster movement could look like sliding feet.

## Shipped scope

- **C3 heroes ONLY:** `BattleUnit._update_frame_animation()` accumulates WALK pose phase from displacement since the preceding animation update: approximately one frame per 12 pixels moved. At nominal 84px/s this matches the existing 7fps original animation cadence. Position is sampled even during idle/attack so the first footfall never inherits a teleport or a stationary pause. A single outlier travel sample is limited to 18px to prevent six-frame jumps on remote movement/poor frame cadence.
- Once a hero stops, WALK frame advance halts immediately during the same 0.18s hysteresis; then regular idle resumes. Animated walking still loops all six genuine C3 source frames. Do not translate the unit itself, change collision, floor correction, damage, attack speed or combat time. Attack, hit, death and idle retain the prior time-based clip clocks.
- Older v2 hero fallback and **all enemies** retain their wall-clock walk timing.
- New F6 `res://scenes/dev/d404_c3_walk_motion_preview.tscn` shows three **real BattleUnit** sprites from active C3 and a real Firing Square arena, with controllable PAUSE/RESTART and authored walking speeds 72/84/108px/s. It invokes the same live `_update_frame_animation()` after actual movement; it is not a fake interpolated image or a replacement for F5 combat. The D398 F6 pair-comparison scene remains intact.
- GUT on real units checks walk from distance, 0-distance freeze, idle hysteresis, 600px teleport clamp, attack time integrity, enemy legacy clock, and new F6 window-fit/pause.
- Source atlases D401/D402 are **byte unchanged**; there are **no 75 new hand-authored painted frames** in this release.

## Tests and remaining artistic work

Native Godot 4.7.2 CI must run project import, GUT tests, relevant smoke. User local after merge: `git -c gc.auto=0 pull --ff-only origin main`, open new F6 D404 walk preview at 1280×720 or their narrow window, observe steps genuinely stop when the hero stops; optionally run F5 encounter to judge sliding at real combat speed. A separate F5 check remains needed for attack shield-hand grip, Ranger bow and Mage staff/glow and natural death motion; source-frame artist repaint remains open. No game design rework.

Do not pretend walk phase driven by distance is a replacement for painted 25-pose animation. The approved C3 wardrobe locks still hold: **only Knight's burgundy cape torn**, Ranger olive and Mage violet garments intact.
