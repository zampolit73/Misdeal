# D395 — C3 hero motion-blocking QA (2026-11-05)

## Scope

The user requested moving on to animation after D392/D394 art investigations. D395 creates a Godot F6 playback scene for Knight, Ranger and male Mage, all five canonical states: idle4, walk6, attack6, hit3, death6. The independent blocking generator reads existing D392 128px alpha reference poses, deforms regions for preliminary rhythm studies, rasterizes to 96px cells, builds 576×480 atlas images with transparent spare cells and exposes SpriteFrames to AnimatedSprite2D.

**Quality label:** This is procedural motion-blocking from ONE still per hero, not 75 individually painted original animation cels. It cannot prove truly authored gait/attack grip/fall. Do NOT call the result game-ready or replace BattleUnit art with it. The generated knight walk-only board shown in chat is a visual study with baked labels/background, not an imported source.

## Godot F6

1. Pull main and open res://scenes/dev/d395_c3_motion_preview.tscn.
2. Press F6 at 1280x720.
3. Click IDLE, WALK, ATTACK, HIT, DEATH; see all three moving on the original Firing Square floor.
4. Inspect foot contact, class silhouettes, sword/shield, Ranger bow grip, Mage staff and robes, cloth motion, impact and death. Playback video is more informative than a single screenshot.
5. Use failed motion as reference for real authored pose replacements, not as a production acceptance.

## Automatic QA

tests/unit/test_d395_c3_motion_blocking.gd checks three 576x480 atlases, 25 different raster results each, alpha-clear spare cells and actual clip playback/loop/count settings. This is a TECHNICAL uniqueness and loading gate, not a claim that the art is independently hand-painted or excellent.

## Safety

No production BattleUnit, unit_animation_library, encounters, waves, DS3 or XIII changes. Existing animation and static fallback continue normally. To finish the approved C3 art: paint 25 genuinely distinct poses per role, stable leg ground and grip, keeping only the Knight's cape torn; Ranger and Mage garments intact; then native F6 and production opt-in.
