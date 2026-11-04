extends GutTest

# D392 is a three-still art study, NOT a new animation source.
const PREVIEW := preload("res://scenes/dev/d392_c3_hero_art_preview.tscn")
const ART := "res://assets/pixel/units/hero_c3_keyposes_qa/c3_d392_rich_128.webp.b64"

func test_approved_style_trio_is_real_alpha_and_separate_128px_stills() -> void:
	assert_true(FileAccess.file_exists(ART))
	var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(ART).strip_edges())
	assert_gt(raw.size(), 10000)
	var image := Image.new()
	assert_eq(image.load_webp_from_buffer(raw), OK)
	assert_eq(image.get_size(), Vector2i(384, 128))
	image.convert(Image.FORMAT_RGBA8)
	for index in range(3):
		var opaque := 0
		var bottom := -1
		for y in range(128):
			for x in range(index * 128, (index + 1) * 128):
				var alpha: float = image.get_pixel(x, y).a
				if alpha > 0.5:
					opaque += 1
					bottom = y
		assert_gt(opaque, 4000, "Each role must have real distinct body mass")
		assert_lt(opaque, 9000, "Only figures, no opaque scene rectangles")
		assert_gte(bottom, 118, "Visible boots must almost reach the baseline")
		assert_lte(bottom, 125, "Bottom has clear cell padding")
		for x in range(index * 128, (index + 1) * 128):
			assert_lt(image.get_pixel(x, 0).a, 0.5)
			assert_lt(image.get_pixel(x, 127).a, 0.5)
		for y in range(128):
			assert_lt(image.get_pixel(index * 128, y).a, 0.5)
			assert_lt(image.get_pixel(index * 128 + 127, y).a, 0.5)

func test_d392_uses_same_floor_and_switches_real_128_to_simulated_96() -> void:
	var preview := PREVIEW.instantiate()
	add_child_autofree(preview)
	var source: Image = preview.call("_decode_keyposes")
	assert_not_null(source)
	assert_eq(source.get_size(), Vector2i(384, 128))
	for index in range(3):
		var role: String = ["knight", "ranger", "mage"][index]
		var current := preview.get_node("Current_%s" % role) as BattleUnit
		var candidate := preview.get_node("C3_%s" % role) as Sprite2D
		assert_not_null(current)
		assert_not_null(candidate)
		assert_eq(current.visual_role, role)
		assert_eq(candidate.texture_filter, CanvasItem.TEXTURE_FILTER_NEAREST)
		assert_almost_eq(current.position.y + BattleUnit.FLOOR_CONTACT_Y, 455.0, 0.01)
		var sole: float = preview.call("_candidate_sole_offset", source, index)
		assert_almost_eq(candidate.position.y + sole * candidate.scale.y, 455.0, 0.01)
		assert_eq(candidate.scale, Vector2.ONE)
	assert_eq((preview.get_node("CandidateScaleButton") as Button).text, "C3: 128px (источник)")
	preview.call("_toggle_candidate_scale")
	for index in range(3):
		var role: String = ["knight", "ranger", "mage"][index]
		var candidate := preview.get_node("C3_%s" % role) as Sprite2D
		var sole: float = preview.call("_candidate_sole_offset", source, index)
		assert_almost_eq(candidate.scale.x, 0.75, 0.01)
		assert_almost_eq(candidate.position.y + sole * candidate.scale.y, 455.0, 0.01)
	assert_eq((preview.get_node("CandidateScaleButton") as Button).text, "C3: 96px (проба)")
