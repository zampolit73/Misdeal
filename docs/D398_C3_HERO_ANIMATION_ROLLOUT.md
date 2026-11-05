# D398 — C3 hero animation artwork: reversible live pilot

Date: 2026-11-05

## Player decision and the previous failure

The player explicitly rejected D397 because its "new" figures were merely old Pack1 v2 drawings recolored. They asked to use the accepted richer C3 looks and then explicitly instructed integration. This D398 change **actually replaces the visual source** used by the three playable protagonists, while preserving the old content for rollback.

Costume contract: Knight dark scarred steel and burgundy shield/sword with **torn cape**; human Ranger's olive cloak must remain **whole**, with legible bow/quiver; male Mage layered violet garments and cape **whole**, staff and restrained purple light. No change to combat mechanics.

## Provenance: generated concept → RGBA game cels, not hand-drawn production-source pixel art

The new 25 visual frames for each hero come from a newly generated illustrated C3 multi-pose reference sheet. It was **not originally** a 576×480 transparent sprite atlas: the source had a black UI background, captions, headers, nonuniform pose positions, and some irregular animation spacing. The output was made by individually identifying and isolating **75 visible pose drawings**, using foreground masking, then resampling/padding each to 96×96 with true transparent alpha. The six unique attack poses per Mage include his BODY, not an isolated projectile like archived v2; separate combat spell FX continue untouched.

Assets committed:
- `assets/pixel/units/hero_c3_d398/knight.webp.b64` — 576×480 RGBA, 6×5, 25 distinct visible cels.
- `assets/pixel/units/hero_c3_d398/ranger.webp.b64` — same.
- `assets/pixel/units/hero_c3_d398/mage.webp.b64` — same.
- `assets/pixel/units/hero_c3_d398/source_storyboard.webp.b64` — original generated composition for provenance/artist correction, **not** runtime sprite art.

The asset format is image-derived, with some antialiasing from extraction. **It is not equivalent to 75 individually hand-pixel-painted native poses.** Technical distinctness and alpha validity do not imply perfect hand-to-weapon continuity, grounding or art quality. Treat this as a **player-directed visual rollout pilot** and inspect native motion. Do not quietly call it an approved final pixel art pack.

## Integration and rollback

`scripts/battle/unit_animation_library.gd` uses `C3_HERO_PILOT_ENABLED := true` to load C3 atlases for `knight/ranger/mage` only, with full transparent frame/edge/unique-cell validation before first use. It uses six real Mage attack body cels (0..5). If a source is missing/invalid, it falls back to unchanged `combat_units_anim_v2` and keeps D397's five-full-body Mage rule to prevent the projectile-only flicker. All legacy v2 atlases stay version-controlled.

No combat AI, damage, cooldown, hitbox, projectiles, party composition, Firing Square backdrop, card art, waves, DS3 or XIII modified. A regression in visual quality can be rolled back atomically by disabling `C3_HERO_PILOT_ENABLED` in the shared library (or reverting the PR). No user-side source edits should be required; report any bad F6/F5 motion for a GitHub fix.

## Local test

1. `git -c gc.auto=0 pull --ff-only origin main`.
2. In Godot 4.7.x run `res://scenes/dev/d398_c3_hero_animation_preview.tscn` via F6. Left is old v2 actual painted animation, right is the **new C3 image** that also appears in actual combat. Click AUTO or each of IDLE/WALK/ATTACK/HIT/DEATH.
3. Review all three heroes at 1280×720 for cropped swords/feet/cloaks, bow hand, staff grip, alpha fringes, height jitter and smooth deaths. This is the human artwork test; CI cannot pass it automatically.
4. F5 normal run: choose each protagonist in turn, enter a fight, watch attack and movement, see that Mage remains present through casting; victory/defeat and return to table unchanged.

## CI and tests

`tests/unit/test_d398_c3_hero_animation_pilot.gd` checks each packed atlas for size, 25 different visible frames, correct empty spare cells, native `BattleUnit` SpriteFrames, role isolation and F6 playback. The previous D397 Mage test now asserts six **new** C3 body attack frames for live combat (old v2 Mage reference still has five).

Final art verdict remains open until player F6/F5 motion feedback.
