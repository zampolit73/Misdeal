# D409 — Knight C3 walk posture correction (2026-11-08)

## Player bug and source evidence

The player shared a native Godot F6 comparison still in which C3 Knight looks noticeably stooped, pitched forward and less confident than old v2 while walking. The six live Knight D406 WALK cels were inspected at 1× and enlarged. The forward-tilted source character **is present in all six artwork poses**; adjusting `Sprite2D.position` for the whole sprite would move boots together with shoulders and create hovering, so a runtime per-frame offset is **not** an adequate geometric fix.

## Targeted D409 asset fix

Create six versioned, independently lossless 96×96 RGBA WALK cels in `assets/pixel/units/hero_c3_d409/knight_walk_{0..5}.webp.b64` from the actual approved Knight D406 illustrated poses. A gentle horizontal source-pixel correction draws the shoulders/head/cape slightly back toward the planted hips (max 5px left in the upper part, fading to zero before row67). The original entire y67–95 boot and contact raster is **pixel-identical** for each frame, and source alpha still touches row90. All six original timings/pose order are preserved; source D406 Knight full atlas remains byte unchanged for fallback. Sword, shield, torn burgundy cape and character color source remain the same. Ranger/Mage and all attack, hit, death cels remain byte/source unchanged.

`MisdealUnitAnimationLibrary._create_frames()` installs these six 96px art overrides only for the live C3 Knight `walk` state, falling back **per cel** to the original D406 AtlasTexture if any override is missing or invalid. No new runtime deformation, frame offsets, float/squash or pixel shader. `BattleUnit` D404 still advances a real C3 WALK frame per roughly 12 pixels traveled and freezes feet while stopped. No movement/hitbox/AI/damage/gameplay changes.

## QA

New `tests/unit/test_d409_knight_walk_posture.gd` decodes the six actual image sources, asserts each upper-shoulder raster center shifts about 4–5 px back while every pixel in the entire lower/boot region remains unchanged, verifies active SpriteFrames 6 frames at 7fps and actual D404 walk distance/stop behavior, and checks Ranger/Mage original walk atlas remains intact. Existing D398 test is updated to expect exactly six corrected Knight WALK ImageTextures. Native F6 `res://scenes/dev/d398_c3_hero_animation_preview.tscn` label now directs WALK review.

[PR #76 merged](https://github.com/zampolit73/Misdeal/pull/76), `caf2e4e6ce44c12378522218fe22a9266c5bb44d`, after [Godot 4.7.2 CI SUCCESS](https://github.com/zampolit73/Misdeal/actions/runs/42464688752), **202/202 real GUT** with D409 test collected, import and scene smokes green. Human F6/F5 aesthetics still pending. Human F6 and actual F5 combat look remain unapproved until user tests. Note the retained original source viewing angle still limits full 3D anatomical realism; this patch makes the upper-body posture more upright without replacing the approved C3 identity. If F5 exposes a more fundamental wrong-facing body orientation, address via a genuinely revised perspective source artwork, not sprite mirroring hacks.
