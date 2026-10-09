class_name ApprovedEventChoiceArt
extends RefCounted

const ATLAS_PATH := "res://assets/pixel/ui/approved_event_choice_polish/event_choice_atlas.bin"
const CELL_SIZE := Vector2i(384, 160)
const SHEET_SIZE := Vector2i(1152, 320)
const COLUMNS := 3
const RATTLING_BRIDGE_PATH := "res://assets/pixel/event/choice/rattling_bridge_choices.svg"
const RATTLING_BRIDGE_CELL_SIZE := Vector2i(384, 160)
const RATTLING_BRIDGE_COLUMNS := 3

static var _sheet_texture: Texture2D
static var _rattling_bridge_texture: Texture2D

static func get_whispering_well_texture(index: int) -> Texture2D:
	return _get_cell(index)

static func get_chained_prisoner_texture(index: int) -> Texture2D:
	return _get_cell(COLUMNS + index)


static func get_rattling_bridge_texture(index: int, recruitment_state: bool) -> Texture2D:
	if index < 0 or index >= 3:
		return null
	var sheet := _get_rattling_bridge_texture()
	if sheet == null:
		return null
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	var row := 0 if recruitment_state else 1
	atlas.region = Rect2(
		Vector2(float(index * RATTLING_BRIDGE_CELL_SIZE.x), float(row * RATTLING_BRIDGE_CELL_SIZE.y)),
		Vector2(float(RATTLING_BRIDGE_CELL_SIZE.x), float(RATTLING_BRIDGE_CELL_SIZE.y))
	)
	return atlas


static func _get_rattling_bridge_texture() -> Texture2D:
	if _rattling_bridge_texture != null:
		return _rattling_bridge_texture
	var loaded := ResourceLoader.load(RATTLING_BRIDGE_PATH)
	if loaded is Texture2D:
		_rattling_bridge_texture = loaded as Texture2D
	else:
		push_error("Could not load Rattling Bridge semantic choice art: %s" % RATTLING_BRIDGE_PATH)
	return _rattling_bridge_texture


static func _get_cell(index: int) -> Texture2D:
	if index < 0 or index >= 6:
		return null
	var sheet := _get_sheet_texture()
	if sheet == null:
		return null
	var column := index % COLUMNS
	var row := index / COLUMNS
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		Vector2(float(column * CELL_SIZE.x), float(row * CELL_SIZE.y)),
		Vector2(float(CELL_SIZE.x), float(CELL_SIZE.y))
	)
	return atlas

static func _get_sheet_texture() -> Texture2D:
	if _sheet_texture != null:
		return _sheet_texture
	if not FileAccess.file_exists(ATLAS_PATH):
		push_error("Missing approved event-choice atlas: %s" % ATLAS_PATH)
		return null

	var bytes := FileAccess.get_file_as_bytes(ATLAS_PATH)
	if bytes.is_empty():
		push_error("Approved event-choice atlas is empty.")
		return null

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode approved event-choice atlas: %s" % error_string(error))
		return null
	if image.get_width() != SHEET_SIZE.x or image.get_height() != SHEET_SIZE.y:
		push_error(
			"Approved event-choice atlas has unexpected size %dx%d; expected %dx%d." % [
				image.get_width(),
				image.get_height(),
				SHEET_SIZE.x,
				SHEET_SIZE.y,
			]
		)
		return null

	_sheet_texture = ImageTexture.create_from_image(image)
	return _sheet_texture
