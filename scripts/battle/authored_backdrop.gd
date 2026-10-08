extends TextureRect

const ARENA_CRYPT := "crypt"
const ARENA_GRAVEYARD := "graveyard"
const ARENA_OSSUARY := "ossuary"
const ARENA_WARDEN := "warden"
const ARENA_BONE_CRUSH := "bone_crush"
const ENVIRONMENT_ART_GRADE := preload("res://materials/ui/misdeal_environment_grade.tres")

const BACKDROP_SIZE := Vector2i(1280, 720)

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

	material = null if arena_id == ARENA_BONE_CRUSH else ENVIRONMENT_ART_GRADE
	texture = _get_runtime_texture(arena_id)

func _get_runtime_texture(value: String) -> Texture2D:
	if runtime_textures.has(value):
		return runtime_textures[value] as Texture2D

	if value == ARENA_BONE_CRUSH:
		return _load_split_webp(value, BONE_CRUSH_PARTS)

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
