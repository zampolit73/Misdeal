extends GutTest

# D405 F6 preview compares *the same* current C3 source pixels via genuine
# BattleUnit SpriteFrames: no recolor, clones or synthetic in-between images.
const PREVIEW := preload("res://scenes/dev/d405_c3_attack_timing_preview.tscn")
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const ROLES := ["knight", "ranger", "mage"]


func test_preview_has_three_live_c3_pairs_with_unchanged_source_texture() -> void:
	var scene := PREVIEW.instantiate()
	add_child_autofree(scene)
	assert_eq(scene.even_actors.size(), 3)
	assert_eq(scene.staged_actors.size(), 3)
	for role in ROLES:
		var even := scene.get_node("Stage/Even_%s" % role) as BattleUnit
		var staged := scene.get_node("Stage/Staged_%s" % role) as BattleUnit
		assert_not_null(even)
		assert_not_null(staged)
		if even == null or staged == null:
			continue
		assert_false(even.is_processing())
		assert_false(staged.is_processing())
		assert_true(LIBRARY.is_live_c3_hero_frames(role, staged.sprite_frames))
		assert_same(even.sprite_frames, staged.sprite_frames)
		assert_eq(staged.sprite_frames.get_frame_count("attack"), 6)
		assert_eq(even.base_sprite_scale, staged.base_sprite_scale)
	assert_not_null(scene.get_node("Stage/SingleStep"))
	assert_not_null(scene.get_node("Stage/SpeedToggle"))


func test_knight_anticipation_key_pose_gets_hold_without_replacing_image() -> void:
	var scene := PREVIEW.instantiate()
	add_child_autofree(scene)
	var even := scene.get_node("Stage/Even_knight") as BattleUnit
	var staged := scene.get_node("Stage/Staged_knight") as BattleUnit
	scene.cycle_time = 0.070
	scene._apply_poses()
	assert_eq(even.art_sprite.texture, even.sprite_frames.get_frame_texture("attack", 1))
	assert_eq(staged.art_sprite.texture, staged.sprite_frames.get_frame_texture("attack", 0))
	assert_eq(staged.frame_state, "attack")
	assert_eq(staged.base_sprite_scale, staged.art_sprite.scale)
	assert_eq(staged.art_sprite.position, staged._art_rest_position())


func test_preview_pause_step_restart_and_narrow_player_viewport() -> void:
	var scene := PREVIEW.instantiate()
	add_child_autofree(scene)
	scene._fit_stage_size(Vector2(952.0, 596.0))
	var stage := scene.get_node("Stage") as Control
	assert_almost_eq(stage.scale.x, 952.0 / 1280.0, 0.0001)
	assert_almost_eq(stage.scale.y, 952.0 / 1280.0, 0.0001)
	scene._toggle_play()
	assert_false(scene.playing)
	var before: float = scene.cycle_time
	scene._process(0.5)
	assert_eq(scene.cycle_time, before)
	scene._step()
	assert_false(scene.playing)
	assert_almost_eq(scene.cycle_time, before + scene.STEP_SECONDS, 0.0001)
	scene._toggle_speed()
	assert_true(scene.half_speed)
	scene._reset()
	assert_true(scene.playing)
	assert_almost_eq(scene.cycle_time, 0.0, 0.0001)
	var mage := scene.get_node("Stage/Staged_mage") as BattleUnit
	assert_not_null(mage)
	if mage != null:
		var right: float = stage.position.x + (mage.position.x + 50.0 * mage.base_sprite_scale.x) * stage.scale.x
		assert_lte(right, 952.0, "Mage actor must fit user's narrow viewport")


func test_preview_resets_to_idle_only_after_the_real_attack_clip_duration() -> void:
	var scene := PREVIEW.instantiate()
	add_child_autofree(scene)
	scene.cycle_time = 0.5
	scene._apply_poses()
	for i in range(ROLES.size()):
		assert_eq(scene.even_actors[i].frame_state, "idle")
		assert_eq(scene.staged_actors[i].frame_state, "idle")
		assert_eq(scene.staged_actors[i].art_sprite.texture,
			scene.staged_actors[i].sprite_frames.get_frame_texture("idle", 0))
