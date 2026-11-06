extends GutTest

# D404: technical sole evidence from real approved C3 atlas bytes.
# Do not confuse encoded RGB beneath alpha=0 with visible storyboard matte.
const SOURCES := [
	["knight", "res://assets/pixel/units/hero_c3_d402/knight.webp.b64"],
	["ranger", "res://assets/pixel/units/hero_c3_d401/ranger.webp.b64"],
	["mage", "res://assets/pixel/units/hero_c3_d401/mage.webp.b64"],
]


func _decode(path: String) -> Image:
	var bytes := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	var img := Image.new()
	if img.load_webp_from_buffer(bytes) != OK:
		return null
	img.convert(Image.FORMAT_RGBA8)
	return img


func test_all_eighteen_approved_c3_walk_poses_have_grounded_sole_pixels() -> void:
	for source in SOURCES:
		var role: String = source[0]
		var img := _decode(source[1])
		assert_not_null(img)
		if img == null:
			continue
		assert_eq(img.get_size(), Vector2i(576, 480))
		for col in range(6):
			# Search through the actual boot/robe footprint. Colored RGB in
			# alpha-clear source-matte pixels must never contribute to footing.
			var foot_row := -1
			for y in range(48, 96):
				for x in range(26, 68):
					var pixel: Color = img.get_pixel(col * 96 + x, 96 + y)
					if pixel.a > 0.5:
						foot_row = maxi(foot_row, y)
			assert_gte(foot_row, 86, "%s WALK %d should show feet near the 96px floor" % [role, col])
			assert_lte(foot_row, 91, "%s WALK %d must not cut off below the cell border" % [role, col])
