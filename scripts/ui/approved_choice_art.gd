extends RefCounted

const CELL_SIZE := Vector2i(160, 80)
const SHEET_SIZE := Vector2i(480, 240)
const PART_PATHS: Array[String] = [
	"res://assets/pixel/ui/approved_choice_atlas/part_00.txt",
	"res://assets/pixel/ui/approved_choice_atlas/part_01.txt",
]

static var sheet_texture: Texture2D

static func get_cell(column: int, row: int) -> Texture2D:
	if column < 0 or column >= 3 or row < 0 or row >= 3:
		return null
	var sheet := _get_sheet_texture()
	if sheet == null:
		return null
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		Vector2(float(column * CELL_SIZE.x), float(row * CELL_SIZE.y)),
		Vector2(float(CELL_SIZE.x), float(CELL_SIZE.y))
	)
	return atlas

static func get_upgrade_texture(upgrade_id: String) -> Texture2D:
	match upgrade_id:
		"knight_iron_oath":
			return get_cell(0, 0)
		"mage_glass_heart":
			return get_cell(1, 0)
		"knight_executioner":
			return get_cell(2, 0)
		_:
			return null

static func _get_sheet_texture() -> Texture2D:
	if sheet_texture != null:
		return sheet_texture
	var encoded := ""
	for part_path in PART_PATHS:
		if not FileAccess.file_exists(part_path):
			push_error("Missing approved choice-art atlas part: %s" % part_path)
			return null
		encoded += FileAccess.get_file_as_string(part_path).strip_edges()
	var bytes := Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("Approved choice-art atlas base64 decoded to an empty buffer.")
		return null
	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode approved choice-art WebP: %s" % error_string(error))
		return null
	if image.get_width() != SHEET_SIZE.x or image.get_height() != SHEET_SIZE.y:
		push_error("Approved choice-art atlas has unexpected size %dx%d." % [image.get_width(), image.get_height()])
		return null
	sheet_texture = ImageTexture.create_from_image(image)
	return sheet_texture
