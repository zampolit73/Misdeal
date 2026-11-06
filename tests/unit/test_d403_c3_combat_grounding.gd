extends GutTest

# D403: F6 C3 atlases use a 92.5px boot baseline, but live BattleUnit
# previously added negative v2 role offsets and deformed those same poses.
# This checks the *actual* live unit and old-art fallback contract.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const HERO_ROLES := ["knight", "ranger", "mage"]
const OLD_FLOOR_OFFSETS := {"knight": -8.0, "ranger": -6.0, "mage": -4.0}


func _make_unit(role: String, side: int = 0) -> BattleUnit:
	var arena := Node2D.new()
	add_child_autofree(arena)
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.visual_role = role
	unit.team = side
	arena.add_child(unit)
	unit.set_process(false)
	unit.set_process_input(false)
	return unit


func test_live_c3_heroes_use_preview_sole_baseline_and_v2_fallback_keeps_old_offset() -> void:
	for role in HERO_ROLES:
		var hero := _make_unit(role)
		assert_not_null(hero.sprite_frames)
		assert_true(LIBRARY.is_live_c3_hero_frames(role, hero.sprite_frames), role + " must be genuine live C3")
		assert_eq(hero._get_role_floor_offset(), 0.0, role + " must not inherit the old floating v2 floor offset")
		var sole_y: float = hero.art_sprite.position.y + (hero.ANIM_SOLE_Y - hero.ANIM_CELL_HEIGHT * 0.5) * hero.base_sprite_scale.y
		assert_almost_eq(sole_y, hero.FLOOR_CONTACT_Y, 0.55, role + " boots should meet their combat floor ring")
		# A missing/invalid C3 atlas must still use v2's established placement.
		var actual_frames: SpriteFrames = hero.sprite_frames
		hero.sprite_frames = SpriteFrames.new()
		assert_false(LIBRARY.is_live_c3_hero_frames(role, hero.sprite_frames))
		assert_eq(hero._get_role_floor_offset(), float(OLD_FLOOR_OFFSETS[role]))
		hero.sprite_frames = actual_frames
	var skeleton := _make_unit("skeleton", 1)
	assert_false(LIBRARY.is_live_c3_hero_frames("skeleton", skeleton.sprite_frames))
	assert_eq(skeleton._get_role_floor_offset(), -7.0)


func test_live_c3_attacks_preserve_source_scale_orientation_color_and_floor() -> void:
	var enemy := _make_unit("skeleton", 1)
	enemy.position = Vector2(460.0, 350.0)
	for role in HERO_ROLES:
		var hero := _make_unit(role)
		hero.position = Vector2(260.0, 350.0)
		var rest := hero._art_rest_position()
		hero._play_attack_feedback(enemy)
		assert_eq(hero.frame_state, "attack")
		assert_eq(hero.art_sprite.scale, hero.base_sprite_scale, role + " source pose must not stretch")
		assert_almost_eq(hero.art_sprite.rotation, 0.0, 0.001, role + " source pose must not spin")
		assert_eq(hero.art_sprite.modulate, hero.base_art_modulate, role + " source costume must not flash-tint")
		assert_almost_eq(hero.art_sprite.position.y, rest.y, 0.001, role + " source boots must not lift on attack")
		assert_lte(absf(hero.art_sprite.position.x - rest.x), 2.01, role + " source pose must not lunge across the floor")
		if hero.attack_tween != null and hero.attack_tween.is_valid():
			hero.attack_tween.kill()
