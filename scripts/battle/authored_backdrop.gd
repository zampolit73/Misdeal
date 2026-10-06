extends TextureRect

const ARENA_CRYPT := "crypt"
const ARENA_GRAVEYARD := "graveyard"
const ARENA_OSSUARY := "ossuary"
const ARENA_WARDEN := "warden"

const BACKDROP_SIZE := Vector2i(1280, 720)

const SOURCE_TEXTURES := {
	ARENA_CRYPT: preload("res://assets/pixel/battle/arenas/crypt.webp"),
	ARENA_GRAVEYARD: preload("res://assets/pixel/battle/arenas/graveyard.webp"),
	ARENA_OSSUARY: preload("res://assets/pixel/battle/arenas/ossuary.webp"),
	ARENA_WARDEN: preload("res://assets/pixel/battle/arenas/warden.webp"),
}

var arena_id := ARENA_CRYPT
var runtime_textures: Dictionary = {}

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	set_arena_id(arena_id)

func set_arena_id(value: String) -> void:
	match value:
		ARENA_GRAVEYARD, ARENA_OSSUARY, ARENA_WARDEN:
			arena_id = value
		_:
			arena_id = ARENA_CRYPT

	texture = _get_runtime_texture(arena_id)

func _get_runtime_texture(value: String) -> Texture2D:
	if runtime_textures.has(value):
		return runtime_textures[value] as Texture2D

	var source := SOURCE_TEXTURES.get(value, SOURCE_TEXTURES[ARENA_CRYPT]) as Texture2D
	if source == null:
		push_error("Missing authored arena source for '%s'." % value)
		return null

	var image := source.get_image()
	if image == null or image.is_empty():
		push_error("Failed to read authored arena source for '%s'." % value)
		return source

	if image.get_width() != BACKDROP_SIZE.x or image.get_height() != BACKDROP_SIZE.y:
		image.resize(BACKDROP_SIZE.x, BACKDROP_SIZE.y, Image.INTERPOLATE_LANCZOS)

	var rendered := ImageTexture.create_from_image(image)
	runtime_textures[value] = rendered
	return rendered
