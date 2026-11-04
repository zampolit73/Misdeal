extends GutTest

# D389 QA only: validates the isolated 96px C3 candidate art, not its aesthetic quality.
const PREVIEW := preload("res://scenes/dev/d389_hero_c3_96px_preview.tscn")
const ASSET_DIR := "res://assets/pixel/units/hero_c3_keyposes_qa/"
const ROLES: Array[String] = ["knight", "ranger", "mage"]

func test_d389_three_candidates_decode_as_transparent_96px_cells() -> void:
	var fingerprints: Array[int] = []
	for role in ROLES:
		var path := "%s%s_96.webp.b64" % [ASSET_DIR, role]
		assert_true(FileAccess.file_exists(path), "Missing C3 candidate: " + role)
		var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
		assert_gt(raw.size(), 500)
		var image := Image.new()
		assert_eq(image.load_webp_from_buffer(raw), OK)
		assert_eq(image.get_size(), Vector2i(96, 96))
		image.convert(Image.FORMAT_RGBA8)
		assert_eq(image.get_pixel(0, 0).a, 0.0, "Transparent canvas corner: " + role)
		var visible := 0
		var min_y := 96
		var max_y := -1
		for y in range(96):
			for x in range(96):
				if image.get_pixel(x, y).a > 0.5:
					visible += 1
					min_y = mini(min_y, y)
					max_y = maxi(max_y, y)
		assert_gt(visible, 1800, "Candidate must have a complete full-body silhouette: " + role)
		assert_lt(visible, 6500, "Candidate must not have an opaque background: " + role)
		assert_lt(min_y, 10, "Character should use the upper part of the 96px cell: " + role)
		assert_gt(max_y, 88, "Character soles must reach the lower cell region: " + role)
		fingerprints.append(hash(raw))
	assert_ne(fingerprints[0], fingerprints[1])
	assert_ne(fingerprints[0], fingerprints[2])
	assert_ne(fingerprints[1], fingerprints[2])


func test_d389_preview_keeps_candidates_out_of_production_battle() -> void:
	var scene := PREVIEW.instantiate()
	add_child_autofree(scene)
	for role in ROLES:
		var original := scene.get_node_or_null("Current_%s" % role) as BattleUnit
		var candidate := scene.get_node_or_null("C3_%s" % role) as Sprite2D
		assert_not_null(original)
		assert_not_null(candidate)
		assert_eq(candidate.texture.get_size(), Vector2i(96, 96))
		assert_eq(candidate.texture_filter, CanvasItem.TEXTURE_FILTER_NEAREST)
		assert_eq(candidate.scale, Vector2.ONE * 0.85)
		var bounds: Rect2i = scene.call("_alpha_bounds", candidate.texture.get_image())
		var sole_offset := float(bounds.position.y + bounds.size.y) - 0.5 - 48.0
		assert_almost_eq(candidate.position.y + sole_offset * candidate.scale.y, 455.0, 0.02)
		assert_eq(original.visual_role, role)
		assert_true(original.alive)
