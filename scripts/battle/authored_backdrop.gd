extends TextureRect

const ARENA_CRYPT := "crypt"
const ARENA_GRAVEYARD := "graveyard"
const ARENA_OSSUARY := "ossuary"
const ARENA_WARDEN := "warden"
const ARENA_BONE_CRUSH := "bone_crush"
const ENVIRONMENT_ART_GRADE := preload("res://materials/ui/misdeal_environment_grade.tres")

const BACKDROP_SIZE := Vector2i(1280, 720)
const REDRAW_ARENA_CELL_SIZE := Vector2i(320, 180)
const REDRAW_ARENA_SHEET_SIZE := Vector2i(640, 360)
const REDRAW_ARENA_COLUMNS := 2

const REDRAW_ARENA_PARTS: Array[String] = [
	"res://assets/pixel/battle/arenas/visual_pass_v3/part_00.txt",
	"res://assets/pixel/battle/arenas/visual_pass_v3/part_01.txt",
	"res://assets/pixel/battle/arenas/visual_pass_v3/part_02.txt",
	"res://assets/pixel/battle/arenas/visual_pass_v3/part_03.txt",
]

const REDRAW_ARENA_INDEX := {
	ARENA_CRYPT: 0,
	ARENA_GRAVEYARD: 1,
	ARENA_OSSUARY: 2,
	ARENA_WARDEN: 3,
}

const ARENA_PATHS := {
	ARENA_CRYPT: "res://assets/pixel/battle/arenas/crypt.webp",
	ARENA_GRAVEYARD: "res://assets/pixel/battle/arenas/graveyard.webp",
	ARENA_OSSUARY: "res://assets/pixel/battle/arenas/ossuary.webp",
	ARENA_WARDEN: "res://assets/pixel/battle/arenas/warden.webp",
}

const BONE_CRUSH_PARTS: Array[String] = [
	"res://assets/pixel/battle/arenas/bone_crush_v2/part_00.txt",
	"res://assets/pixel/battle/arenas/bone_crush_v2/part_01.txt",
	"res://assets/pixel/battle/arenas/bone_crush_v2/part_02.txt",
	"res://assets/pixel/battle/arenas/bone_crush_v2/part_03.txt",
	"res://assets/pixel/battle/arenas/bone_crush_v2/part_04.txt",
	"res://assets/pixel/battle/arenas/bone_crush_v2/part_05.txt",
	"res://assets/pixel/battle/arenas/bone_crush_v2/part_06.txt",
	"res://assets/pixel/battle/arenas/bone_crush_v2/part_07.txt",
]

var arena_id := ARENA_CRYPT
var runtime_textures: Dictionary = {}
var redraw_arena_sheet: Texture2D

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	material = ENVIRONMENT_ART_GRADE
	set_arena_id(arena_id)

func set_arena_id(value: String) -> void:
	match value:
		ARENA_GRAVEYARD, ARENA_OSSUARY, ARENA_WARDEN, ARENA_BONE_CRUSH:
			arena_id = value
		_:
			arena_id = ARENA_CRYPT

	material = ENVIRONMENT_ART_GRADE
	if arena_id == ARENA_BONE_CRUSH or REDRAW_ARENA_INDEX.has(arena_id):
		material = null
	texture = _get_runtime_texture(arena_id)

func _get_runtime_texture(value: String) -> Texture2D:
	if runtime_textures.has(value):
		return runtime_textures[value] as Texture2D

	if value == ARENA_BONE_CRUSH:
		return _load_split_webp(value, BONE_CRUSH_PARTS)

	if REDRAW_ARENA_INDEX.has(value):
		var redraw_sheet: Texture2D = _get_redraw_arena_sheet()
		if redraw_sheet != null:
			var redraw_cell: Texture2D = _get_atlas_cell(
				redraw_sheet,
				int(REDRAW_ARENA_INDEX[value]),
				REDRAW_ARENA_CELL_SIZE,
				REDRAW_ARENA_COLUMNS
			)
			runtime_textures[value] = redraw_cell
			return redraw_cell

	var path := str(ARENA_PATHS.get(value, ARENA_PATHS[ARENA_CRYPT]))
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Could not open authored arena WebP: %s" % path)
		return null

	var bytes := file.get_buffer(file.get_length())
	if bytes.is_empty():
		push_error("Authored arena WebP is empty: %s" % path)
		return null

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode authored arena WebP '%s': %s" % [path, error_string(error)])
		return null

	if image.get_width() != BACKDROP_SIZE.x or image.get_height() != BACKDROP_SIZE.y:
		image.resize(BACKDROP_SIZE.x, BACKDROP_SIZE.y, Image.INTERPOLATE_NEAREST)

	var rendered := ImageTexture.create_from_image(image)
	runtime_textures[value] = rendered
	return rendered


func _get_redraw_arena_sheet() -> Texture2D:
	if redraw_arena_sheet != null:
		return redraw_arena_sheet

	var encoded: String = ""
	for part_path in REDRAW_ARENA_PARTS:
		if not FileAccess.file_exists(part_path):
			push_error("Missing visual-redraw arena atlas part: %s" % part_path)
			return null
		encoded += FileAccess.get_file_as_string(part_path).strip_edges()

	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("Visual-redraw arena atlas decoded to an empty buffer.")
		return null

	var image := Image.new()
	var error: Error = image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode visual-redraw arena atlas: %s" % error_string(error))
		return null

	if image.get_width() != REDRAW_ARENA_SHEET_SIZE.x or image.get_height() != REDRAW_ARENA_SHEET_SIZE.y:
		push_error(
			"Visual-redraw arena atlas has unexpected size %dx%d; expected %dx%d." % [
				image.get_width(),
				image.get_height(),
				REDRAW_ARENA_SHEET_SIZE.x,
				REDRAW_ARENA_SHEET_SIZE.y,
			]
		)
		return null

	redraw_arena_sheet = ImageTexture.create_from_image(image)
	return redraw_arena_sheet


func _get_atlas_cell(
	sheet: Texture2D,
	index: int,
	cell_size: Vector2i,
	columns: int
) -> Texture2D:
	var column: int = index % columns
	var row: int = int(index / columns)
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		Vector2(float(column * cell_size.x), float(row * cell_size.y)),
		Vector2(float(cell_size.x), float(cell_size.y))
	)
	return atlas


func _load_split_webp(cache_key: String, part_paths: Array[String]) -> Texture2D:
	var encoded := ""
	for part_path in part_paths:
		if not FileAccess.file_exists(part_path):
			push_error("Missing authored arena part: %s" % part_path)
			return null
		encoded += FileAccess.get_file_as_string(part_path).strip_edges()

	var bytes: PackedByteArray = Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("Authored arena base64 decode failed: %s" % cache_key)
		return null

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode authored split WebP '%s': %s" % [cache_key, error_string(error)])
		return null

	if image.get_width() != BACKDROP_SIZE.x or image.get_height() != BACKDROP_SIZE.y:
		image.resize(BACKDROP_SIZE.x, BACKDROP_SIZE.y, Image.INTERPOLATE_NEAREST)

	var rendered := ImageTexture.create_from_image(image)
	runtime_textures[cache_key] = rendered
	return rendered
