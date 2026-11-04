extends GutTest

# D390: Three actually authored 96px STATIC miniatures; 25-frame animations
# and live BattleUnit sprite loading must remain untouched.
const SCENE := preload("res://scenes/dev/d390_hero_c3_native_preview.tscn")
const ASSET := "res://assets/pixel/units/hero_c3_keyposes_qa/c3_native_d390_96.webp.b64"


func test_three_native_96px_poses_are_distinct_transparent_and_padded() -> void:
	assert_true(FileAccess.file_exists(ASSET))
	var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(ASSET).strip_edges())
	assert_gt(raw.size(), 1000)
	var img := Image.new()
	assert_eq(img.load_webp_from_buffer(raw), OK)
	assert_eq(img.get_size(), Vector2i(288, 96))
	img.convert(Image.FORMAT_RGBA8)
	var fingerprints: Array[int] = []
	for index in range(3):
		var cell := img.get_region(Rect2i(index * 96, 0, 96, 96))
		var fingerprint: int = hash(cell.get_data())
		assert_false(fingerprints.has(fingerprint), "C3 heroes need distinct artwork")
		fingerprints.append(fingerprint)
		var visible := 0
		var bottom := -1
		for y in range(96):
			for x in range(96):
				if cell.get_pixel(x, y).a > 0.5:
					visible += 1
					bottom = y
		assert_gt(visible, 2400, "Hero must not be a small cutout")
		assert_lt(visible, 5000, "Hero must retain transparent negative space")
		assert_true(bottom >= 87, "Boots need real floor contact")
		assert_true(bottom <= 92, "Keep 3px of lower sprite padding")
		for x in range(96):
			assert_lt(cell.get_pixel(x, 0).a, 0.5, "Clear top edge")
			assert_lt(cell.get_pixel(x, 95).a, 0.5, "Clear lower edge")
		for y in range(96):
			assert_lt(cell.get_pixel(0, y).a, 0.5, "Clear left edge")
			assert_lt(cell.get_pixel(95, y).a, 0.5, "Clear right edge")


func test_native_one_to_one_art_on_same_floor_with_original_heroes() -> void:
	var scene := SCENE.instantiate()
	add_child_autofree(scene)
	var image: Image = scene.call("_decode_keyposes")
	assert_eq(image.get_size(), Vector2i(288, 96))
	for index in range(3):
		var role: String = ["knight", "ranger", "mage"][index]
		var original := scene.get_node("Current_%s" % role) as BattleUnit
		var candidate := scene.get_node("C3_%s" % role) as Sprite2D
		assert_not_null(original)
		assert_not_null(candidate)
		assert_eq(original.visual_role, role)
		assert_eq(candidate.texture_filter, CanvasItem.TEXTURE_FILTER_NEAREST)
		assert_almost_eq(original.position.y + BattleUnit.FLOOR_CONTACT_Y, 455.0, 0.01)
		assert_almost_eq(candidate.scale.x, 1.0, 0.01, "Default study is native 96px")
		var sole: float = scene.call("_candidate_sole_offset", image, index)
		assert_almost_eq(candidate.position.y + sole * candidate.scale.y, 455.0, 0.01)
	assert_eq((scene.get_node("CandidateScaleButton") as Button).text, "C3: ×1 (реальные 96px)")
	scene.call("_toggle_candidate_scale")
	for index in range(3):
		var role: String = ["knight", "ranger", "mage"][index]
		var candidate := scene.get_node("C3_%s" % role) as Sprite2D
		var sole: float = scene.call("_candidate_sole_offset", image, index)
		assert_almost_eq(candidate.scale.x, 1.3, 0.01)
		assert_almost_eq(candidate.position.y + sole * candidate.scale.y, 455.0, 0.01)
	assert_eq((scene.get_node("CandidateScaleButton") as Button).text, "C3: ×1.3 (сравнить рост)")
