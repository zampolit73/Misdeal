extends GutTest

# C3 source art in D389 is exactly three stills, NOT a 25-pose animation.
const SCENE := preload("res://scenes/dev/d389_hero_c3_96_preview.tscn")
const ASSET := "res://assets/pixel/units/hero_c3_keyposes_qa/c3_keyposes_96.webp.b64"

func test_d389_alpha_keyposes_are_three_valid_96px_cells() -> void:
	assert_true(FileAccess.file_exists(ASSET))
	var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(ASSET).strip_edges())
	assert_gt(raw.size(), 4000)
	var image := Image.new()
	assert_eq(image.load_webp_from_buffer(raw), OK)
	assert_eq(image.get_size(), Vector2i(288, 96))
	image.convert(Image.FORMAT_RGBA8)
	for index in range(3):
		var pixels := 0
		for y in range(96):
			for x in range(index * 96, (index + 1) * 96):
				if image.get_pixel(x, y).a > 0.5:
					pixels += 1
		assert_gt(pixels, 1200, "C3 still has meaningful nonempty silhouette")
		assert_lt(pixels, 96 * 96 / 2, "C3 still is transparent, not a matte rectangle")

func test_d389_still_comparison_uses_the_real_floor_and_native_scale() -> void:
	var scene := SCENE.instantiate()
	add_child_autofree(scene)
	var img: Image = scene.call("_decode_keyposes")
	assert_eq(img.get_size(), Vector2i(288, 96))
	for index in range(3):
		var role: String = ["knight", "ranger", "mage"][index]
		var actual := scene.get_node("Current_%s" % role) as BattleUnit
		var candidate := scene.get_node("C3_%s" % role) as Sprite2D
		assert_not_null(actual)
		assert_not_null(candidate)
		assert_eq(candidate.texture_filter, CanvasItem.TEXTURE_FILTER_NEAREST)
		assert_almost_eq(actual.position.y + BattleUnit.FLOOR_CONTACT_Y, 455.0, 0.01)
		var sole: float = scene.call("_candidate_sole_offset", img, index)
		assert_almost_eq(candidate.position.y + sole * candidate.scale.y, 455.0, 0.01)
	scene.call("_toggle_candidate_scale")
	for index in range(3):
		var role: String = ["knight", "ranger", "mage"][index]
		var candidate := scene.get_node("C3_%s" % role) as Sprite2D
		var sole: float = scene.call("_candidate_sole_offset", img, index)
		assert_almost_eq(candidate.scale.x, 1.0, 0.01)
		assert_almost_eq(candidate.position.y + sole * candidate.scale.y, 455.0, 0.01)
	assert_eq((scene.get_node("CandidateScaleButton") as Button).text, "C3: ×1 (нативный 96px)")
