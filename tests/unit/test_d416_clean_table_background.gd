extends GutTest

func test_live_table_uses_clean_center_without_redrawing_approved_surroundings() -> void:
	var packed := load("res://scenes/table/table.tscn") as PackedScene
	var table := packed.instantiate() as Control
	var backdrop := table.get_node("WizardBackdrop") as TextureRect
	assert_eq(backdrop.get("webp_path"), "res://assets/pixel/table/d416_clean_center/table_clean.webp")
	assert_eq(backdrop.get("expected_size"), Vector2i(1280, 720))
	var original := Image.new()
	var clean := Image.new()
	assert_eq(original.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://assets/pixel/table/approved_variant_c/table_exact.webp")), OK)
	assert_eq(clean.load_webp_from_buffer(FileAccess.get_file_as_bytes(backdrop.get("webp_path"))), OK)
	original.convert(Image.FORMAT_RGBA8)
	clean.convert(Image.FORMAT_RGBA8)
	assert_eq(clean.get_size(), Vector2i(1280, 720))
	for area in [Rect2i(0, 0, 1280, 316), Rect2i(0, 656, 1280, 64), Rect2i(0, 316, 380, 340), Rect2i(900, 316, 380, 340)]:
		assert_eq(_digest(clean, area), _digest(original, area), "Wizard, hands, piles and UI outside the restoration stay pixel-identical")
	assert_ne(_digest(clean, Rect2i(400, 365, 485, 275)), _digest(original, Rect2i(400, 365, 485, 275)))
	table.free()

func _digest(image: Image, area: Rect2i) -> String:
	var context := HashingContext.new()
	context.start(HashingContext.HASH_SHA256)
	context.update(image.get_region(area).get_data())
	return context.finish().hex_encode()
