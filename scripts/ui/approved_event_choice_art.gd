class_name ApprovedEventChoiceArt
extends RefCounted

const LEGACY_ATLAS_PATH := "res://assets/pixel/ui/approved_event_choice_polish/event_choice_atlas.bin"
const LEGACY_CELL_SIZE := Vector2i(384, 160)
const LEGACY_SHEET_SIZE := Vector2i(1152, 320)
const LEGACY_COLUMNS := 3

const APPROVED_SHEET_PARTS: Array[String] = [
	"res://assets/pixel/event/choice/approved_choice_sheet_v2/part_00.txt",
	"res://assets/pixel/event/choice/approved_choice_sheet_v2/part_01a.txt",
	"res://assets/pixel/event/choice/approved_choice_sheet_v2/part_01b.txt",
	"res://assets/pixel/event/choice/approved_choice_sheet_v2/part_01c.txt",
	"res://assets/pixel/event/choice/approved_choice_sheet_v2/part_02.txt",
	"res://assets/pixel/event/choice/approved_choice_sheet_v2/part_03.txt",
	"res://assets/pixel/event/choice/approved_choice_sheet_v2/part_04.txt",
]
const APPROVED_CELL_SIZE := Vector2i(192, 80)
const APPROVED_SHEET_SIZE := Vector2i(576, 320)
const APPROVED_COLUMNS := 3

const ROW_RATTLING_BRIDGE := 0
const ROW_WHISPERING_WELL := 1
const ROW_CHAINED_PRISONER_RECRUITMENT := 2
const ROW_BLACK_ALTAR_RECRUITMENT := 3

static var _legacy_sheet_texture: Texture2D
static var _approved_sheet_texture: Texture2D


static func get_rattling_bridge_texture(index: int) -> Texture2D:
	return _get_approved_cell(ROW_RATTLING_BRIDGE, index)


static func get_whispering_well_texture(index: int) -> Texture2D:
	return _get_approved_cell(ROW_WHISPERING_WELL, index)


static func get_chained_prisoner_recruitment_texture(index: int) -> Texture2D:
	return _get_approved_cell(ROW_CHAINED_PRISONER_RECRUITMENT, index)


static func get_black_altar_texture(index: int) -> Texture2D:
	return _get_approved_cell(ROW_BLACK_ALTAR_RECRUITMENT, index)


static func get_chained_prisoner_texture(index: int) -> Texture2D:
	return _get_legacy_cell(LEGACY_COLUMNS + index)


static func _get_approved_cell(row: int, index: int) -> Texture2D:
	if index < 0 or index >= APPROVED_COLUMNS:
		return null
	var sheet := _get_approved_sheet_texture()
	if sheet == null:
		return null
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		Vector2(float(index * APPROVED_CELL_SIZE.x), float(row * APPROVED_CELL_SIZE.y)),
		Vector2(float(APPROVED_CELL_SIZE.x), float(APPROVED_CELL_SIZE.y))
	)
	return atlas


static func _get_approved_sheet_texture() -> Texture2D:
	if _approved_sheet_texture != null:
		return _approved_sheet_texture

	var encoded := ""
	for part_path: String in APPROVED_SHEET_PARTS:
		if not FileAccess.file_exists(part_path):
			push_error("Missing approved event-choice sheet part: %s" % part_path)
			return null
		encoded += FileAccess.get_file_as_string(part_path).strip_edges()

	var bytes := Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("Approved event-choice sheet decoded to an empty buffer.")
		return null

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode approved event-choice sheet: %s" % error_string(error))
		return null
	if image.get_width() != APPROVED_SHEET_SIZE.x or image.get_height() != APPROVED_SHEET_SIZE.y:
		push_error(
			"Approved event-choice sheet has unexpected size %dx%d; expected %dx%d." % [
				image.get_width(),
				image.get_height(),
				APPROVED_SHEET_SIZE.x,
				APPROVED_SHEET_SIZE.y,
			]
		)
		return null

	_approved_sheet_texture = ImageTexture.create_from_image(image)
	return _approved_sheet_texture


static func _get_legacy_cell(index: int) -> Texture2D:
	if index < 0 or index >= 6:
		return null
	var sheet := _get_legacy_sheet_texture()
	if sheet == null:
		return null
	var column := index % LEGACY_COLUMNS
	var row := index / LEGACY_COLUMNS
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		Vector2(float(column * LEGACY_CELL_SIZE.x), float(row * LEGACY_CELL_SIZE.y)),
		Vector2(float(LEGACY_CELL_SIZE.x), float(LEGACY_CELL_SIZE.y))
	)
	return atlas


static func _get_legacy_sheet_texture() -> Texture2D:
	if _legacy_sheet_texture != null:
		return _legacy_sheet_texture
	if not FileAccess.file_exists(LEGACY_ATLAS_PATH):
		push_error("Missing legacy event-choice atlas: %s" % LEGACY_ATLAS_PATH)
		return null

	var bytes := FileAccess.get_file_as_bytes(LEGACY_ATLAS_PATH)
	if bytes.is_empty():
		push_error("Legacy event-choice atlas is empty.")
		return null

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode legacy event-choice atlas: %s" % error_string(error))
		return null
	if image.get_width() != LEGACY_SHEET_SIZE.x or image.get_height() != LEGACY_SHEET_SIZE.y:
		push_error(
			"Legacy event-choice atlas has unexpected size %dx%d; expected %dx%d." % [
				image.get_width(),
				image.get_height(),
				LEGACY_SHEET_SIZE.x,
				LEGACY_SHEET_SIZE.y,
			]
		)
		return null

	_legacy_sheet_texture = ImageTexture.create_from_image(image)
	return _legacy_sheet_texture
