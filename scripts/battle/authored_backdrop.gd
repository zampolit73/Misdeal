extends TextureRect

const ARENA_CRYPT := "crypt"
const ARENA_GRAVEYARD := "graveyard"
const ARENA_OSSUARY := "ossuary"
const ARENA_WARDEN := "warden"

const BACKDROP_SIZE := Vector2i(1280, 720)

const ARENA_TEXTURES := {
	ARENA_CRYPT: preload("res://assets/pixel/battle/arenas/crypt.webp"),
	ARENA_GRAVEYARD: preload("res://assets/pixel/battle/arenas/graveyard.webp"),
	ARENA_OSSUARY: preload("res://assets/pixel/battle/arenas/ossuary.webp"),
}

const WARDEN_SOURCE_TEXTURE: Texture2D = preload("res://assets/pixel/battle/arenas/warden.webp")

var arena_id := ARENA_CRYPT
var warden_runtime_texture: Texture2D

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

	if arena_id == ARENA_WARDEN:
		texture = _get_warden_runtime_texture()
	else:
		texture = ARENA_TEXTURES[arena_id]

func _get_warden_runtime_texture() -> Texture2D:
	if warden_runtime_texture != null:
		return warden_runtime_texture

	var image := WARDEN_SOURCE_TEXTURE.get_image()
	if image == null or image.is_empty():
		push_error("Failed to read Warden arena texture; using imported source.")
		return WARDEN_SOURCE_TEXTURE

	if image.get_width() != BACKDROP_SIZE.x or image.get_height() != BACKDROP_SIZE.y:
		image.resize(BACKDROP_SIZE.x, BACKDROP_SIZE.y, Image.INTERPOLATE_LANCZOS)

	warden_runtime_texture = ImageTexture.create_from_image(image)
	return warden_runtime_texture
