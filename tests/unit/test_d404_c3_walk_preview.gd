extends GutTest

# D404 motion F6 uses real BattleUnit nodes, never a procedural-looking sprite.
const PREVIEW := preload("res://scenes/dev/d404_c3_walk_motion_preview.tscn")
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const HEROES := ["knight", "ranger", "mage"]


func test_f6_d404_uses_three_live_c3_battle_units_with_true_walk_frames() -> void:
	var preview := PREVIEW.instantiate()
	add_child_autofree(preview)
	assert_eq(preview.heroes.size(), 3)
	for i in range(HEROES.size()):
		var role: String = HEROES[i]
		var hero := preview.get_node("Stage/LiveC3_%s" % role) as BattleUnit
		assert_not_null(hero)
		if hero != null:
			assert_true(LIBRARY.is_live_c3_hero_frames(role, hero.sprite_frames), role + " is live C3, not a substitute")
			assert_false(hero.is_processing(), role + " F6 script must control actor once only")
			assert_eq(hero.sprite_frames.get_frame_count("walk"), 6)
			assert_almost_eq(hero.position.y, 407.0, 0.001)
	assert_eq(preview._path_x(0, 0.0), preview.CENTERS[0] - preview.HALF_TRAVEL)
	preview._process(0.16)
	preview._process(0.16)
	preview._process(0.16)
	var knight := preview.heroes[0]
	assert_eq(knight.frame_state, "walk")
	assert_gt(knight.frame_time, 0.1, "Knight animation uses actual traveled distance")


func test_f6_d404_pause_restart_and_scaled_capture() -> void:
	var preview := PREVIEW.instantiate()
	add_child_autofree(preview)
	preview._fit_stage_size(Vector2(952.0, 596.0))
	var stage := preview.get_node("Stage") as Control
	assert_almost_eq(stage.scale.x, 952.0 / 1280.0, 0.0001)
	assert_almost_eq(stage.scale.y, 952.0 / 1280.0, 0.0001)
	assert_not_null(stage.get_node("PauseMotion"))
	assert_not_null(stage.get_node("RestartMotion"))
	preview._process(0.15)
	var last_x: float = preview.heroes[1].position.x
	preview._toggle_pause()
	assert_false(preview.running)
	preview._process(0.4)
	assert_eq(preview.heroes[1].position.x, last_x, "Paused QA does not silently step sprites")
	preview._restart()
	assert_true(preview.running)
	assert_eq(preview.play_time, 0.0)
	for hero in preview.heroes:
		assert_false(hero.visual_moving)
		assert_eq(hero.frame_state, "idle")
		assert_false(hero.c3_walk_has_sample == false, "Restart primes the animation sample safely")
