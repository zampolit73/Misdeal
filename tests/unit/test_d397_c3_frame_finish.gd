extends GutTest

const RETOUCH := preload("res://scripts/dev/c3_frame_finish.gd")
const SOURCE := preload("res://scripts/dev/c3_authored_pose_study.gd")
const PREVIEW := preload("res://scenes/dev/d397_c3_animation_pass_preview.tscn")

func test_original_pose_retouch_has_valid_alpha_cells_and_original_frame_counts() -> void:
	for role in ["knight", "ranger", "mage"]:
		var image: Image = RETOUCH.make_atlas(role)
		assert_not_null(image)
		if image == null:
			continue
		assert_eq(image.get_size(), Vector2i(576, 480))
		var frames: SpriteFrames = RETOUCH.make_frames(role)
		assert_not_null(frames)
		if frames == null:
			continue
		var total := 0
		for row in range(5):
			var state: String = ["idle", "walk", "attack", "hit", "death"][row]
			var expected: int = (5 if role == "mage" else 6) if state == "attack" else [4, 6, 6, 3, 6][row]
			assert_eq(frames.get_frame_count(state), expected)
			assert_eq(frames.get_animation_loop(state), row < 2)
			total += expected
			for col in range(6):
				var occupied := 0
				for y in range(4, 96, 5):
					for x in range(4, 96, 5):
						if image.get_pixel(col * 96 + x, row * 96 + y).a > 0.3:
							occupied += 1
				if col < expected:
					assert_gt(occupied, 6, "%s %s frame %d must contain visible actor" % [role, state, col])
				else:
					assert_eq(occupied, 0, "Every unused frame must be empty")
		assert_eq(total, 24 if role == "mage" else 25)


func test_c3_frame_pass_is_distinct_from_source_without_mutating_source() -> void:
	for role in ["knight", "ranger", "mage"]:
		var original: Image = SOURCE.make_atlas(role)
		var revised: Image = RETOUCH.make_atlas(role)
		assert_not_null(original)
		assert_not_null(revised)
		if original == null or revised == null:
			continue
		var changed := 0
		for y in range(0, 480, 3):
			for x in range(0, 576, 3):
				var before: Color = original.get_pixel(x, y)
				var after: Color = revised.get_pixel(x, y)
				if before.a > 0.40 and after.a > 0.35:
					var diff := absf(before.r - after.r) + absf(before.g - after.g) + absf(before.b - after.b)
					if diff > 0.02:
						changed += 1
		assert_gt(changed, 10, "%s art retouch must modify material values, not copy old atlas" % role)


func test_d397_can_switch_states_and_run_auto_with_full_actor_attacks() -> void:
	var preview := PREVIEW.instantiate()
	add_child_autofree(preview)
	assert_eq(preview.current_actors.size(), 3)
	assert_eq(preview.candidate_actors.size(), 3)
	preview.call("_set_state_manual", "attack")
	assert_eq(preview.active_state, "attack")
	for sprite in preview.current_actors + preview.candidate_actors:
		assert_eq(sprite.animation, "attack")
	for name in ["Current_mage", "Candidate_mage"]:
		var sprite := preview.get_node(name) as AnimatedSprite2D
		assert_not_null(sprite)
		if sprite != null:
			# D398 live "Current" Mage now uses six new C3 body cels;
			# the old D397 retouch candidate still has five v2 body poses.
			assert_eq(sprite.sprite_frames.get_frame_count("attack"), 6 if name == "Current_mage" else 5)
	preview.call("_toggle_auto")
	assert_true(preview.autoplay)
	preview.call("_process", 1.4)
	assert_eq(preview.active_state, "walk")
	preview.call("_set_state_manual", "death")
	assert_false(preview.autoplay)
	assert_eq(preview.active_state, "death")
