extends GutTest

# D404 exploratory raster audit; prints real source-image pixel evidence.
# The approved C3 art stays untouched while we establish what is actually
# character silhouette and what is left-over storyboard-colour contamination.
const KNIGHT := "res://assets/pixel/units/hero_c3_d402/knight.webp.b64"
const RANGER := "res://assets/pixel/units/hero_c3_d401/ranger.webp.b64"
const MAGE := "res://assets/pixel/units/hero_c3_d401/mage.webp.b64"
const COUNTS := [4, 6, 6, 3, 6]

func _decode(path: String) -> Image:
	var bytes := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	var img := Image.new()
	if img.load_webp_from_buffer(bytes) != OK:
		return null
	img.convert(Image.FORMAT_RGBA8)
	return img

func _suspect(c: Color) -> bool:
	if c.a <= 0.5:
		return false
	# Luminous primary matte colors not used by the approved miniature art.
	return (c.r > 0.88 and c.g > 0.82 and c.b < 0.22) or (c.r > 0.88 and c.g < 0.16 and c.b < 0.16) or (c.b > 0.83 and c.r < 0.18 and c.g < 0.32) or (c.r > 0.9 and c.g > 0.9 and c.b > 0.87)

func test_audit_raw_c3_frame_mattes_and_walk_boot_rows() -> void:
	for entry in [["knight", KNIGHT], ["ranger", RANGER], ["mage", MAGE]]:
		var role: String = entry[0]
		var img := _decode(entry[1])
		assert_not_null(img)
		if img == null:
			continue
		for row in range(5):
			for col in range(COUNTS[row]):
				var suspect := 0
				var sample := ""
				var low := -1
				var x_low := -1
				for y in range(96):
					for x in range(96):
						var c: Color = img.get_pixel(col * 96 + x, row * 96 + y)
						if _suspect(c):
							suspect += 1
							if sample.is_empty():
								sample = "%d:%d[%d,%d,%d]" % [x, y, int(c.r * 255.0), int(c.g * 255.0), int(c.b * 255.0)]
						if x >= 26 and x <= 67 and y >= 48 and c.a > 0.5 and not _suspect(c):
							if y > low:
								low = y
								x_low = x
				print("D404_SCAN role=%s row=%d col=%d matte=%d sample=%s footY=%d footX=%d" % [role, row, col, suspect, sample, low, x_low])
		assert_eq(img.get_size(), Vector2i(576, 480))
