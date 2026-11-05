extends GutTest

const STUDY := preload("res://scripts/dev/c3_authored_pose_study.gd")
const PREVIEW := preload("res://scenes/dev/d396_c3_pose_compare.tscn")

func test_real_v2_animation_pose_contract_is_read_without_production_mutation() -> void:
	for role in ["knight", "ranger", "mage"]:
		var art: Image = STUDY.make_atlas(role)
		assert_not_null(art, "%s genuine source atlas exists" % role)
		if art == null:
			continue
		assert_eq(art.get_size(), Vector2i(576, 480))
		var frames: SpriteFrames = STUDY.make_frames(role)
		assert_not_null(frames)
		if frames == null:
			continue
		var expected_total := 0
		for state in ["idle", "walk", "attack", "hit", "death"]:
			var columns: Array[int] = STUDY.source_columns(role, state)
			expected_total += columns.size()
			assert_true(frames.has_animation(state))
			assert_eq(frames.get_frame_count(state), columns.size(), "%s/%s frame source" % [role, state])
			for i in range(columns.size()):
				assert_not_null(frames.get_frame_texture(state, i))
		assert_eq(expected_total, 24 if role == "mage" else 25)


func test_mage_source_drops_projectile_only_attack_cell() -> void:
	assert_eq(STUDY.source_columns("mage", "attack"), [0, 1, 2, 3, 5])
	assert_eq(STUDY.source_columns("ranger", "attack"), [0, 1, 2, 3, 4, 5])
	assert_eq(STUDY.source_columns("knight", "attack"), [0, 1, 2, 3, 4, 5])


func test_knight_palette_study_changes_blue_without_touching_archived_file() -> void:
	var reference: Image = STUDY.load_reference_image("knight")
	var tinted: Image = STUDY.make_atlas("knight")
	assert_not_null(reference)
	assert_not_null(tinted)
	if reference == null or tinted == null:
		return
	var changed := 0
	for y in range(0, 480, 3):
		for x in range(0, 576, 3):
			var before: Color = reference.get_pixel(x, y)
			var after: Color = tinted.get_pixel(x, y)
			if before.distance_to(after) > 0.08 and before.a > 0.3:
				changed += 1
	assert_gt(changed, 30, "The optional Knight study must be visibly different from blue v2")
	assert_eq(reference.get_size(), tinted.get_size())
	for role in ["ranger", "mage"]:
		var neutral: Image = STUDY.load_reference_image(role)
		var staged: Image = STUDY.make_atlas(role)
		assert_eq(neutral.get_pixel(40, 40), staged.get_pixel(40, 40), "Other classes retain genuine original palette")


func test_d396_preview_can_play_five_states_for_six_qa_miniatures() -> void:
	var preview := PREVIEW.instantiate()
	add_child_autofree(preview)
	assert_eq(preview.draft_actors.size(), 3)
	assert_eq(preview.authored_actors.size(), 3)
	for role in ["knight", "ranger", "mage"]:
		var original := preview.get_node("Authored_%s" % role) as AnimatedSprite2D
		var blocking := preview.get_node("Blocking_%s" % role) as AnimatedSprite2D
		assert_not_null(original)
		assert_not_null(blocking)
		if original != null:
			assert_eq(original.texture_filter, CanvasItem.TEXTURE_FILTER_NEAREST)
			assert_eq(original.sprite_frames.get_frame_count("attack"), 5 if role == "mage" else 6)
	preview.call("_play", "death")
	assert_eq(preview.active_state, "death")
	for actor in preview.draft_actors + preview.authored_actors:
		assert_eq(actor.animation, "death")
