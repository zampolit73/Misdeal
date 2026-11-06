# D405 — C3 attack key-pose staging (2026-11-06)

## Starting point and player acceptance

The player accepted D404 walking («по ходьбе все ок»). Lock the real 12px-per-source-frame movement gait, stop/reverse behavior, boot baseline and all current live C3 source bitmaps. The Knight still uses exact D402 art and Ranger/Mage exact D401 art. Combat mechanics including instant damage and cooldowns are out of scope.

D401/D402 healed class-weapon disappearances but the six C3 source attack images for each role were still presented with **equal per-frame holds** at 16fps Knight/Ranger and 14fps Mage. This gives the same visual weight to windup, contact and recovery regardless of what the original image shows. The current source frames are illustration-derived; no claims that they are 18 newly hand-painted frames or that all hand/weapon anatomy is fixed.

## D405 staged attack visual playback

`MisdealUnitAnimationLibrary.C3_ATTACK_POSE_WEIGHTS` is a role-authored data table of six positive weights per Knight/Ranger/Mage. Each array sums to exactly **6**. `c3_attack_frame_index(role, elapsed_seconds, fps)` maps the elapsed visual time to one of the **six original, independently authored attack image cells**. `BattleUnit._update_frame_animation()` uses the mapping only when `frame_state == "attack"` and the role is using an *actual decoded live C3 SpriteFrames resource*. Every other state, enemy and legacy-v2 fallback uses its original frame index.

Interpretation (visual only): Knight's guarded windup gets a little more readability; Ranger's drawn-bow key pose holds; Mage's spell channel/crest lasts slightly longer without any extra fake FX. The clip total remains exactly **6 / source_fps** for each hero: Knight/Ranger 0.375s; Mage ~0.429s. The actual instant hit, same attack cooldown, attack sound, trace, game damage and one-shot timer are untouched. No extra scale/rotation/smears, no new colors, pixel artwork or additional gameplay states.

## Actual preview and regressions

- Native F6: `res://scenes/dev/d405_c3_attack_timing_preview.tscn`. Real `BattleUnit` nodes and the painted Firing Square backdrop. Three 2-up comparisons at original battlefield scale: **left = old uniform clip**, **right = D405 held key poses** using exact same C3 SpriteFrames atlas. PAUSE / 0.5× / STEP / RESTART controls, stage fits 952×596 and 1280×720. This compares sprite playback; it is not a full F5 attack-damage simulation.
- `tests/unit/test_d405_c3_attack_pose_timing.gd`: six distinct source cells reachable per role; positive hold durations total exactly six nominal frames; live actual BattleUnit samples correct third pose; verified D404 distance-WALK and enemy v2-like timing unaffected.
- `tests/unit/test_d405_c3_attack_timing_preview.gd`: real C3 paired actors, source texture identity, key-pose difference, pause/step/restart and narrow-window fit.
- [PR #72](https://github.com/zampolit73/Misdeal/pull/72) squash-merged `dae09d71b733739c58dc1347a0874380f1ed4c43` after [Godot 4.7.2 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/42218204484), **193/193 GUT**, no missing/skipped test scripts, import and relevant scene smokes green. Actual human F6/F5 visual acceptance remains open.

## Visual acceptance and next art work

User: after successful merge, `git -c gc.auto=0 pull --ff-only origin main`; open D405 F6 (ATTACK timing compare/slow/step), then F5 actual fight to judge attack realism at gameplay size.

Native CI cannot sign off on shield-hand articulation, Ranger bow-string grip, Mage staff source quality or realistic attack→idle transition. **D405 does not redraw source art.** The next genuine artistic task is retouch/re-author actual chosen C3 attack key-poses on **new versioned** 96×96 alpha atlases, preserving the explicitly approved silhouettes: sword+burgundy shield+torn cape Knight, intact olive Ranger with bow, intact violet male Mage with staff. Do not revert to old v2 or ship fake infographic boards as sprites.
