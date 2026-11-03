extends GutTest

# D387: concept-derived single keyposes must load without changing the real
# animation library. The test does NOT approve sprite artistry or animation.
const PREVIEW := preload("res://scenes/dev/d387_hero_c3_keypose_preview.tscn")
const ASSET := "res://assets/pixel/units/hero_c3_keyposes_qa/c3_keyposes_48.webp.b64"

func test_c3_qa_asset_has_three_transparent_isolated_cells() -> void:
	assert_true(FileAccess.file_exists(ASSET))
	var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(ASSET).strip_edges())
	assert_gt(raw.size(), 1000)
	var image := Image.new()
	assert_eq(image.load_webp_from_buffer(raw), OK)
	assert_eq(image.get_size(), Vector2i(144, 48))
	image.convert(Image.FORMAT_RGBA8)
	for i in range(3):
		var visible := 0
		for y in range(48):
			for x in range(i * 48, (i + 1) * 48):
				if image.get_pixel(x, y).a > 0.5:
					visible += 1
		assert_gt(visible, 80, "Each hero has visible silhouette pixels")
		assert_lt(visible, 48 * 48 / 2, "Transparent frame background is required")

func test_c3_preview_scene_is_separate_from_production_battle() -> void:
	var scene := PREVIEW.instantiate()
	add_child_autofree(scene)
	assert_true(scene.get_node_or_null("BattleBackdrop") == null)
	assert_eq(scene.call("_decode_keyposes").get_size(), Vector2i(144, 48))


func test_d388_both_studies_stand_on_the_same_physical_stone_floor() -> void:
	var scene := PREVIEW.instantiate()
	add_child_autofree(scene)
	var image: Image = scene.call("_decode_keyposes")
	var roles := ["knight", "ranger", "mage"]
	for index in range(roles.size()):
		var original := scene.get_node("Current_%s" % roles[index]) as BattleUnit
		var candidate := scene.get_node("C3_%s" % roles[index]) as Sprite2D
		assert_not_null(original)
		assert_not_null(candidate)
		assert_gte(original.position.y, 390.0, "Current fighters must not hover at the old y=296")
		assert_almost_eq(original.position.y + BattleUnit.FLOOR_CONTACT_Y, 455.0, 0.01)
		var sole_offset: float = scene.call("_candidate_sole_offset", image, index)
		assert_almost_eq(candidate.position.y + sole_offset * candidate.scale.y, 455.0, 0.01,
			"C3 visible feet must share the current hero floor")
		assert_eq(candidate.texture_filter, CanvasItem.TEXTURE_FILTER_NEAREST)
		assert_eq(candidate.scale, Vector2.ONE * 3.0, "Default comparison scale is clearly marked")
		assert_eq(original.visual_role, roles[index])

	# Scale comparison must change only the concept stills and NOT move their feet.
	scene.call("_toggle_candidate_scale")
	for index in range(roles.size()):
		var candidate := scene.get_node("C3_%s" % roles[index]) as Sprite2D
		var sole_offset: float = scene.call("_candidate_sole_offset", image, index)
		assert_eq(candidate.scale, Vector2.ONE * 2.0)
		assert_almost_eq(candidate.position.y + sole_offset * candidate.scale.y, 455.0, 0.01)
	assert_eq((scene.get_node("CandidateScaleButton") as Button).text, "C3: ×2 (96px)")

