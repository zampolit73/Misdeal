# D397 — C3 animation refinement / Mage projectile-only attack fix

2026-11-05. User asked to improve D396 animation, not another concept-board pass.

## Shipped gameplay fix (if CI passes)

Actual Battle Mage (and shared SpriteFrames gallery) previously played all six Pack1 v2 attack tiles, including source attack row/column 4, which contains an isolated projectile without the Mage actor. The result is one-frame disappearance during casting. Library now plays exactly the FIVE real full-body poses in columns 0,1,2,3,5. This matches the existing Pack1 art contract; the projectile/impact continues to be rendered by the separate battle attack visual system. `tests/unit/test_d397_mage_attack_frame_integrity.gd` asserts exact atlas coordinates and confirms a real BattleUnit uses five actor frames. Knight, Ranger and enemies stay on their existing attack counts. Actual combat damage, frame-triggered impact timing and AI are untouched.

## C3 animation visual retouch (QA-only)

The newest generated in-chat material was another **decorated storyboard**, with numbers, text and background, not an alpha 6x5 game atlas; its claims of final status/frame counts were ignored. We instead base this opt-in pass on actual old individually illustrated full-body Pack1 v2 animation cells, preserving movements and the original source files.

- `scripts/dev/c3_frame_finish.gd`: stage a reversible 96px animation atlas of real earlier drawn poses per role. Knight uses D396 desaturated burgundy colorway; minor material contrast retouches for Knight/Ranger/male Mage and a transparent-edge/halo cleanup retain silhouettes. 576x480, real 25 older distinct pose positions for Knight and Ranger; Mage contains 24 real actor poses, with source column 5 mapped to the fifth attack position. Unused image cells are truly empty.
- `res://scenes/dev/d397_c3_animation_pass_preview.tscn`: F6 scene at 1280×720. Per-class pairs share arena floor, original actual production animation on left, retouched old-pose candidate on right. Select IDLE/WALK/ATTACK/HIT/DEATH or AUTO; Mage attack both sides use five full-body cels. No move to live art loader.
- `tests/unit/test_d397_c3_frame_finish.gd`: verify dimensions/alpha/role-specific counts/different color values/auto state switching.

**Art limitation:** D397 did NOT paint 75 new individually authored C3 poses. Knight's physically torn cloak silhouette, Ranger's approved intact hem, Mage's approved intact robe and a sixth NEW Mage body attack need genuine per-cel original artwork before switching live battle graphics. Color and matte cleanup are a readability prototype, not proof of high-quality replacement. Retain all 96px animation and live art rollback.

## How to check

1. Pull main once merged.
2. Open `res://scenes/dev/d397_c3_animation_pass_preview.tscn` → F6.
3. Press AUTO and watch all five states; manually select ATTACK and confirm Mage never flashes out of existence. Inspect Knight sword/shield and cape, Ranger bow grip, Mage staff and grounding.
4. In actual F5 gameplay, choose Mage and fight a normal encounter; check repeated spellcasts remain actor-visible. Test Knight/Ranger and one enemy attack for regressions.
5. Visual quality acceptance still requires a player-native F6 assessment, not just CI import/GUT. If the retouch does not materially improve the figures, revert candidate only; production Mage bug fix remains valid.

## Scope

No unit stats/attacks/hitboxes/FX strength, mechanics, waves, DS3, XIII, card art or sound changed. The only production-side modification is Mage actor-frame selection. The C3 palette candidate is isolated to developer preview.
