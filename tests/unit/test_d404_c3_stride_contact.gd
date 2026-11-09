extends GutTest

# D404: real BattleUnit Sprite2D rows, not a mock walk timer.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const HEROES := ["knight", "ranger", "mage"]


func _actor(role: String, side: int = 0) -> BattleUnit:
	var arena := Node2D.new()
	add_child_autofree(arena)
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.visual_role = role
	unit.team = side
	unit.position = Vector2(260.0, 400.0)
	arena.add_child(unit)
	unit.set_process(false)
	unit.set_process_input(false)
	return unit


func test_walk_cels_advance_only_on_real_travel_for_each_live_c3_hero() -> void:
	for role in HEROES:
		var hero := _actor(role)
		assert_true(LIBRARY.is_live_c3_hero_frames(role, hero.sprite_frames))
		hero.combat_started = true
		hero.visual_moving = true
		hero._update_frame_animation(1.0 / 60.0)
		assert_eq(hero.frame_state, "walk")
		assert_eq(hero.art_sprite.texture, hero.sprite_frames.get_frame_texture("walk", 0),
			role + " initial walk pose starts planted, not time-skipped")

		hero.position.x += 13.0
		hero._update_frame_animation(1.0 / 60.0)
		assert_eq(hero.art_sprite.texture, hero.sprite_frames.get_frame_texture("walk", 1),
			role + " one authored footfall per roughly 12px of displacement")

		hero.visual_moving = false
		hero._update_frame_animation(0.05)
		assert_eq(hero.frame_state, "walk", "0.18s hysteresis keeps walk visible while stopping")
		assert_eq(hero.art_sprite.texture, hero.sprite_frames.get_frame_texture("walk", 1),
			role + " feet stop animating immediately if actual travel stops")
		hero._update_frame_animation(0.20)
		assert_eq(hero.frame_state, "idle", "walk hysteresis eventually returns to idle")


func test_c3_teleport_is_clamped_and_attack_one_shot_is_time_driven() -> void:
	var hero := _actor("knight")
	hero.combat_started = true
	hero.visual_moving = true
	hero._update_frame_animation(1.0 / 60.0)
	hero.position.x += 600.0
	hero._update_frame_animation(1.0 / 60.0)
	assert_eq(hero.frame_state, "walk")
	assert_eq(hero.art_sprite.texture, hero.sprite_frames.get_frame_texture("walk", 1),
		"One impossible displacement must never fast-forward all six walk cels")
	hero._play_frame_one_shot("attack")
	hero._update_frame_animation(0.10)
	assert_eq(hero.frame_state, "attack")
	assert_gt(hero.frame_time, 0.09, "Combat attack pose time is unchanged")
	assert_eq(hero.art_sprite.texture, hero.sprite_frames.get_frame_texture("attack", 1))


func test_enemy_walk_now_uses_distance_without_changing_attack_clock() -> void:
	var skeleton := _actor("skeleton", 1)
	assert_false(LIBRARY.is_live_c3_hero_frames("skeleton", skeleton.sprite_frames))
	skeleton.combat_started = true
	skeleton.visual_moving = true
	skeleton._update_frame_animation(0.18)
	assert_eq(skeleton.frame_state, "walk")
	assert_eq(skeleton.art_sprite.texture, skeleton.sprite_frames.get_frame_texture("walk", 0),
		"D420 extends planted distance sampling to enemies")
