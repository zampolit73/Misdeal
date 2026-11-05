extends GutTest

const MOTION := preload("res://scripts/dev/c3_motion_blocking.gd")
const PREVIEW := preload("res://scenes/dev/d395_c3_motion_preview.tscn")


func test_three_draft_atlases_have_25_distinct_frames_and_clear_spares() -> void:
	for role in ["knight", "ranger", "mage"]:
		var atlas: Image = MOTION.make_atlas(role)
		assert_not_null(atlas, "%s draft atlas must decode D392 still" % role)
		if atlas == null:
			continue
		assert_eq(atlas.get_size(), Vector2i(576, 480))
		var fingerprints := {}
		for row in range(5):
			var expected: int = [4, 6, 6, 3, 6][row]
			for col in range(6):
				var cell := atlas.get_region(Rect2i(col * 96, row * 96, 96, 96))
				var fingerprint := hash(cell.get_data())
				var visible := 0
				for y in range(0, 96, 4):
					for x in range(0, 96, 4):
						if cell.get_pixel(x, y).a > 0.4:
							visible += 1
				if col >= expected:
					assert_eq(visible, 0, "%s spare row %d col %d must be alpha clear" % [role, row, col])
					continue
				assert_gt(visible, 10, "%s row %d col %d requires a visible body" % [role, row, col])
				assert_false(fingerprints.has(fingerprint), "%s repeats draft frame row %d col %d" % [role, row, col])
				fingerprints[fingerprint] = true
		assert_eq(fingerprints.size(), 25)


func test_all_clips_play_in_qa_scene_without_live_unit_changes() -> void:
	var preview := PREVIEW.instantiate()
	add_child_autofree(preview)
	assert_eq(preview.actors.size(), 3)
	for role in ["knight", "ranger", "mage"]:
		var actor := preview.get_node("C3_%s" % role) as AnimatedSprite2D
		assert_not_null(actor)
		if actor == null:
			continue
		assert_eq(actor.texture_filter, CanvasItem.TEXTURE_FILTER_NEAREST)
		for row in range(5):
			var state: String = ["idle", "walk", "attack", "hit", "death"][row]
			assert_true(actor.sprite_frames.has_animation(state))
			assert_eq(actor.sprite_frames.get_frame_count(state), [4, 6, 6, 3, 6][row])
			assert_eq(actor.sprite_frames.get_animation_loop(state), row <= 1)
	preview.call("_play", "attack")
	assert_eq(preview.selected_state, "attack")
	for actor in preview.actors:
		assert_eq(actor.animation, "attack")
