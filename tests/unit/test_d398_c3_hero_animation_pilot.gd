extends GutTest

const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const PREVIEW := preload("res://scenes/dev/d398_c3_hero_animation_preview.tscn")
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ROLES := ["knight", "ranger", "mage"]
const COUNTS := [4, 6, 6, 3, 6]


func test_d398_hero_atlases_are_rgba_valid_and_use_25_distinct_cels() -> void:
	assert_true(LIBRARY.C3_HERO_PILOT_ENABLED)
	for role in ROLES:
		var path: String = "%s%s.webp.b64" % [LIBRARY.C3_HERO_PILOT_DIR, role]
		assert_true(FileAccess.file_exists(path))
		var bytes := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
		assert_gt(bytes.size(), 50000)
		var atlas := Image.new()
		assert_eq(atlas.load_webp_from_buffer(bytes), OK)
		assert_eq(atlas.get_size(), Vector2i(576, 480))
		atlas.convert(Image.FORMAT_RGBA8)
		assert_true(LIBRARY._valid_c3_hero_atlas(atlas), role + " should pass 25-pose validity")
		var digests := {}
		for row in range(5):
			for col in range(6):
				var tile := atlas.get_region(Rect2i(col * 96, row * 96, 96, 96))
				var frame_opaque := 0
				for y in range(4, 96, 4):
					for x in range(4, 96, 4):
						if tile.get_pixel(x, y).a > 0.4:
							frame_opaque += 1
				if col >= COUNTS[row]:
					assert_eq(frame_opaque, 0, "%s spare %d:%d must have no alpha" % [role, row, col])
				else:
					assert_gt(frame_opaque, 15, "%s %d:%d must show the C3 actor" % [role, row, col])
					var hash_value := hash(tile.get_data())
					assert_false(digests.has(hash_value), "%s repeated frame %d:%d" % [role, row, col])
					digests[hash_value] = true
		assert_eq(digests.size(), 25, role + " must have 25 distinct raster outputs")


func test_invalid_pilot_image_rejected_before_live_use() -> void:
	var corrupt := Image.create(576, 480, false, Image.FORMAT_RGBA8)
	corrupt.fill(Color.TRANSPARENT)
	assert_false(LIBRARY._valid_c3_hero_atlas(corrupt))
	var wrong_size := Image.create(128, 128, false, Image.FORMAT_RGBA8)
	assert_false(LIBRARY._valid_c3_hero_atlas(wrong_size))


func test_live_battle_uses_d398_c3_for_heroes_and_keeps_other_roles() -> void:
	for role in ROLES:
		var frames: SpriteFrames = LIBRARY.get_frames(role)
		assert_not_null(frames)
		if frames == null:
			continue
		for row in range(5):
			var state: String = ["idle", "walk", "attack", "hit", "death"][row]
			assert_eq(frames.get_frame_count(state), COUNTS[row], role + " " + state)
			assert_eq(frames.get_animation_loop(state), row < 2)
			for col in range(COUNTS[row]):
				var tile := frames.get_frame_texture(state, col) as AtlasTexture
				assert_not_null(tile)
				if tile != null:
					assert_eq(tile.region.position, Vector2(col * 96, row * 96))
		var actor := UNIT_SCENE.instantiate() as BattleUnit
		actor.visual_role = role
		actor.team = 0
		add_child_autofree(actor)
		assert_not_null(actor.sprite_frames)
		if actor.sprite_frames != null:
			assert_eq(actor.sprite_frames.get_frame_count("attack"), 6)
	for role in ["skeleton", "bone_archer"]:
		var frames: SpriteFrames = LIBRARY.get_frames(role)
		assert_not_null(frames)
		if frames != null:
			assert_eq(frames.get_frame_count("attack"), 6)


func test_d398_f6_has_current_and_c3_full_playback() -> void:
	var preview := PREVIEW.instantiate()
	add_child_autofree(preview)
	assert_eq(preview.original_actors.size(), 3)
	assert_eq(preview.c3_actors.size(), 3)
	for role in ROLES:
		var original := preview.get_node("Original_%s" % role) as AnimatedSprite2D
		var c3 := preview.get_node("C3_%s" % role) as AnimatedSprite2D
		assert_not_null(original)
		assert_not_null(c3)
		if c3 != null:
			assert_eq(c3.sprite_frames.get_frame_count("attack"), 6)
		if original != null and role == "mage":
			assert_eq(original.sprite_frames.get_frame_count("attack"), 5)
	preview.call("_play_manual", "attack")
	assert_eq(preview.active_state, "attack")
	preview.call("_toggle_auto")
	assert_true(preview.autoplay)
	preview.call("_process", 1.5)
	assert_eq(preview.active_state, "walk")
	preview.call("_play_manual", "death")
	assert_false(preview.autoplay)
	assert_eq(preview.active_state, "death")
