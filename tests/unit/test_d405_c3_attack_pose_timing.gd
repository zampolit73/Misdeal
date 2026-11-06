extends GutTest

# D405: all tests use the actual active C3 SpriteFrames and BattleUnit.
# This is a timing/art presentation pass, never a new raster sprite source.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ROLES := ["knight", "ranger", "mage"]


func _actor(role: String, side: int = 0) -> BattleUnit:
	var arena := Node2D.new()
	add_child_autofree(arena)
	var hero := UNIT_SCENE.instantiate() as BattleUnit
	hero.visual_role = role
	hero.team = side
	arena.add_child(hero)
	hero.set_process(false)
	hero.set_process_input(false)
	return hero


func test_d405_source_attack_hold_weights_cover_each_cel_once_and_keep_clip_duration() -> void:
	for role in ROLES:
		var frames: SpriteFrames = LIBRARY.get_frames(role)
		assert_not_null(frames)
		assert_true(LIBRARY.is_live_c3_hero_frames(role, frames))
		assert_eq(frames.get_frame_count("attack"), 6)
		var speed: float = frames.get_animation_speed("attack")
		var weights: Array = LIBRARY.C3_ATTACK_POSE_WEIGHTS[role]
		assert_eq(weights.size(), 6)
		var total := 0.0
		for col in range(6):
			var duration: float = float(weights[col])
			assert_gt(duration, 0.0)
			var at_midpoint: float = (total + duration * 0.5) / speed
			assert_eq(LIBRARY.c3_attack_frame_index(role, at_midpoint, speed), col,
				"%s should really display source attack cel %d" % [role, col])
			total += duration
		assert_almost_eq(total, 6.0, 0.0001, role + " attack clip must retain original 6/fps total")
		assert_eq(LIBRARY.c3_attack_frame_index(role, 1000.0, speed), 5)


func test_d405_in_game_unit_uses_actual_key_pose_not_duplicate_or_tweened_art() -> void:
	for role in ROLES:
		var hero := _actor(role)
		var frames: SpriteFrames = hero.sprite_frames
		assert_not_null(frames)
		var speed: float = frames.get_animation_speed("attack")
		var weights: Array = LIBRARY.C3_ATTACK_POSE_WEIGHTS[role]
		var begin := float(weights[0] + weights[1]) / speed
		var midpoint := begin + float(weights[2]) * 0.5 / speed
		hero._play_frame_one_shot("attack")
		hero._update_frame_animation(midpoint)
		assert_eq(hero.frame_state, "attack")
		assert_eq(hero.art_sprite.texture, frames.get_frame_texture("attack", 2),
			role + " must display its real source key pose at held phase")
		assert_eq(hero.art_sprite.scale, hero.base_sprite_scale)
		assert_eq(hero.art_sprite.position, hero._art_rest_position())
		assert_almost_eq(hero.frame_one_shot_time, 6.0 / speed - midpoint, 0.002)


func test_d405_has_no_effect_on_accepted_d404_walk_or_legacy_enemies() -> void:
	for role in ROLES:
		var hero := _actor(role)
		assert_eq(hero.sprite_frames.get_frame_count("walk"), 6)
		hero.combat_started = true
		hero.visual_moving = true
		hero._update_frame_animation(1.0 / 60.0)
		hero.position.x += 12.0
		hero._update_frame_animation(1.0 / 60.0)
		assert_eq(hero.frame_state, "walk")
		assert_eq(hero.art_sprite.texture, hero.sprite_frames.get_frame_texture("walk", 1))
	var enemy := _actor("skeleton", 1)
	assert_false(LIBRARY.is_live_c3_hero_frames("skeleton", enemy.sprite_frames))
	enemy._play_frame_one_shot("attack")
	enemy._update_frame_animation(1.0 / enemy.sprite_frames.get_animation_speed("attack") * 2.1)
	assert_eq(enemy.art_sprite.texture, enemy.sprite_frames.get_frame_texture("attack", 2))
