class_name ApprovedEventDecor
extends RefCounted

const DECOR_PATH := "res://assets/pixel/ui/approved_event_character_decor.bin"
const CELL_SIZE := Vector2i(384, 220)

static var _atlas_texture: Texture2D

static func get_forge_texture() -> Texture2D:
	return _get_cell(0)

static func get_prisoner_texture() -> Texture2D:
	return _get_cell(1)

static func _get_cell(column: int) -> Texture2D:
	var atlas := _get_atlas()
	if atlas == null:
		return null

	var texture := AtlasTexture.new()
	texture.atlas = atlas
	texture.region = Rect2(
		Vector2(float(column * CELL_SIZE.x), 0.0),
		Vector2(float(CELL_SIZE.x), float(CELL_SIZE.y))
	)
	return texture

static func _get_atlas() -> Texture2D:
	if _atlas_texture != null:
		return _atlas_texture

	var file := FileAccess.open(DECOR_PATH, FileAccess.READ)
	if file == null:
		push_error("Could not open approved event decor: %s" % DECOR_PATH)
		return null

	var bytes := file.get_buffer(file.get_length())
	if bytes.is_empty():
		push_error("Approved event decor is empty: %s" % DECOR_PATH)
		return null

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode approved event decor: %s" % error_string(error))
		return null

	_atlas_texture = ImageTexture.create_from_image(image)
	return _atlas_texture
