## D408 release evidence (2026-11-06)

[PR #75](https://github.com/zampolit73/Misdeal/pull/75) squash merged `f572cb06e7d94e7a690c6fc07b9e244acaeb2e3a` after [Godot 4.7.2 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/42231056235): **200/200 real GUT** (new tests collected), import and scene smoke passed. Initial attempt exposed a GDScript type-inference parse error in historical D398 test, fixed and full suite rerun clean. Human F6/F5 art approval remains open.

# D408 — C3 hero HIT and DEATH continuity batch (2026-11-06)

## Source and constraints

Three approved C3 heroes (Knight D406 full atlas, Ranger D401 atlas, Mage D401 atlas with D407 Mage final DEATH cell) were examined at native 96px through all HIT3+DEATH6 source poses. No new style direction is authorized. Knight retains its sword, shield and torn burgundy cape; Ranger its intact olive clothing with original curved bow and quiver; male Mage retains intact violet robe, staff and D407's *dormant* final-DEATH crystal. User already approved D404 walk and D405 attacks; never change those states/cadences, combat damage, AI or physics. Do not replace the illustrated C3 style with a primitive drawn polygon.

## Verified original-art defects and D408 images

The three Ranger HIT poses depicted a bare forward hand without the curved wooden bow, while Ranger ATTACK row2 col1 already shows the approved bow. Mage HIT index1/2 lost his long staff though Mage IDLE col0 shows the approved crystal-tipped original. Knight HIT0–2 already retains its sword and shield, so no unnecessary Knight image redrawing. The six DEATH frames for all roles already show coherent staged collapse; the previous D407 correction stays for Mage final crystal.

D408 restores approved prop art by selectively recomposing **existing source RGB/alpha brushwork** onto the **existing** appropriate HIT body drawings: three Ranger HIT cels receive their own bow silhouettes; Mage HIT1/2 receive their staff silhouettes (Mage HIT0 was already intact). These are five individual **lossless 96×96 RGBA** override files under `assets/pixel/units/hero_c3_d408/`, not procedurally drawn runtime props nor a new generated illustration board. The hands/poses and backdrop-free transparency are preserved. Original D401 and D406 576×480 C3 atlases are byte untouched. A missing/invalid individual override safely falls back to its original `AtlasTexture` frame. Original Mage D407 DEATH5 isolated image remains active.

## Actual battle motion correction

`BattleUnit._play_hit_feedback()` used to apply a 10–16% whole-body zoom and heavy one-shot costume recolor on top of *authored* HIT poses. For **active C3 heroes only**, preserve original authored body scale and costume colors; retain a reduced, very small impact displacement, 0.12/0.15s hit feedback and existing weapon/impact audio. All enemies and archived v2 fallback retain original hit bounce/tint.

When a hit kills a C3 hero, the `_die()` branch previously canceled the impact tween without resetting that scale/color/offset. D408 restores the exact base scale, sprite angle/position/color and clears hit-flash immediately before showing source DEATH0. This removes the unnatural zoom/pop between HIT and the authored collapse. Enemy death/physics, actual hit/damage timing and original six DEATH frames remain unchanged. The D407 dormant Mage staff remains the last DEATH cel.

## QA / release gate

`tests/unit/test_d408_c3_hit_death_continuity.gd` exercises **real BattleUnit** sprite resources for five newly restored true image cels, exact source-image association, inherited body pixels, unchanged other cels, hit-scale/color source preservation, lethal HIT→DEATH reset, and Skeleton old hit feedback. Historical D398/D407 sprite-type tests updated to recognize the five standalone HIT overrides while protecting the other frames.

Require Godot 4.7.2 import, real GUT (no GUT file silently skipped) and scene smoke green before merge. User after merge only: git pull; F6 `res://scenes/dev/d398_c3_hero_animation_preview.tscn` HIT and DEATH, especially Ranger bow and Mage staff; F5 a live actual encounter to judge the reduced pop at lethal hits. Passing static/native tests does **not** mean all 75 source-image cels have been hand-repainted or that the human has accepted F5 combat visuals.
