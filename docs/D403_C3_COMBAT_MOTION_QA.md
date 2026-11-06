# D403 — C3 hero ground contact and attack presentation (2026-11-06)

## Evidence and fault

D402's Knight sword/shield and D401 Ranger bow are already live. The last player video `01-07-47.mp4` was a **Godot F6 atlas preview**, not F5 battle. Static inspection of actual `scripts/battle/unit.gd` identified a definite discrepancy: the live `_art_rest_position()` still added legacy v2 floor offsets (Knight -8, Ranger -6, Mage -4) to new C3 heroes. The C3 F6 preview placed the authored 96px feet at source sole Y=92.5 on its floor, without those old offsets. As a result the real C3 live boots could float above the existing ground-contact ring even when the F6 preview looked grounded.

A second duplication affected attack readability: live `_play_attack_feedback()` applies a whole-sprite lunge, rotation and nonuniform squash/stretch on top of the C3 atlas's existing sword swing / bow draw / Mage cast frames. The Mage robe was also tinted heavily purple. That visual deformation is not represented in the F6 comparison and can obscure the approved costume/weapon details.

## D403 change scope

- Record the **actual** decoded live C3 `SpriteFrames` identity in `MisdealUnitAnimationLibrary`. This remains false for every enemy and for an archived v2 fallback even when the role name is Knight/Ranger/Mage.
- Apply **zero legacy role floor offset only to those active C3 frames**. Keep the 92.5px existing sole anchor and 36px combat shadow contact; all three live C3 heroes now match the floor logic used by the F6 stage. Other 24+ roles, original v2 fallback, combat movement positions/hitboxes unchanged.
- For those three C3 actors, prefer their already-authored six attack poses: no whole-sprite stretch or tilt, no transient Mage costume recolour; retain a tiny <=2px horizontal recoil, the existing Mage attack trace, class attack visuals/audio, and exactly the same 0.14s tween and **instant** combat damage timing. All archived v2 and enemy feedback untouched.
- F6 scene remains `res://scenes/dev/d398_c3_hero_animation_preview.tscn` and still displays the **raw atlas** (F6 does not simulate the live attack tween); its caption explains that F5 must be checked independently. No new art bitmap, no redraw/clone of 75 frames.

## Regression and release gate

`tests/unit/test_d403_c3_combat_grounding.gd` instantiates **real BattleUnit scenes** and checks: (1) three actual C3 `SpriteFrames` identities; (2) actual hero sole/shadow alignment; (3) fake v2 fallback still uses -8/-6/-4 and Skeleton still -7; (4) each C3 attack preserves whole-sprite scale, orientation, costume tint, and Y contact. Existing D398–D402 art identity tests should remain green.

Run Godot 4.7.x native CI (GDScript import, GUT and scene smoke) before merge. F6 confirms the C3 texture and all 25 pose cels, but it **cannot** validate the motion feedback code. A human **F5 Knight/Ranger/Mage fight** must verify planted feet and reduced attack wobble at real arena size. There is **no human aesthetic sign-off yet**. Future honest art task is still 75 independently finished C3 poses, offhand shield articulation, staff/glow cadence and walking/death anatomy.

No changes to attack rates, health/damage, waves, DS3, card effects, Bone Warden, sound timing, or pixel source atlases.
