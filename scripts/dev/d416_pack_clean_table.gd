extends SceneTree

# Import recipe: keep all original pixels outside the restored tabletop.
# The replacement art is from built-in imagegen, not procedural painting.
const BASE := "res://assets/pixel/table/approved_variant_c/table_exact.webp"
const DIR := "res://assets/pixel/table/d416_clean_center/"
const PATCH := Rect2i(380, 316, 520, 340)

func _initialize() -> void:
	var original := Image.new()
	original.load_webp_from_buffer(FileAccess.get_file_as_bytes(BASE))
	original.convert(Image.FORMAT_RGBA8)
	var restored := Image.load_from_file(DIR + "source.png")
	restored.resize(1280, 720, Image.INTERPOLATE_LANCZOS)
	restored.convert(Image.FORMAT_RGBA8)
	var result := original.duplicate() as Image
	for y in range(PATCH.position.y, PATCH.end.y):
		for x in range(PATCH.position.x, PATCH.end.x):
			var edge := mini(mini(x - PATCH.position.x, PATCH.end.x - 1 - x), mini(y - PATCH.position.y, PATCH.end.y - 1 - y))
			var weight := clampf(float(edge) / 8.0, 0.0, 1.0)
			result.set_pixel(x, y, original.get_pixel(x, y).lerp(restored.get_pixel(x, y), weight))
	if result.save_webp(DIR + "table_clean.webp", false) != OK:
		quit(1)
		return
	print("D416_PACK_PASS: native1280x720 lossless center restoration; original surroundings preserved")
	quit()
