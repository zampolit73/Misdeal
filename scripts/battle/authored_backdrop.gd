extends TextureRect

const ARENA_CRYPT := "crypt"
const ARENA_GRAVEYARD := "graveyard"
const ARENA_OSSUARY := "ossuary"
const ARENA_WARDEN := "warden"

const ARENA_TEXTURES := {
	ARENA_CRYPT: preload("res://assets/pixel/battle/arenas/crypt.webp"),
	ARENA_GRAVEYARD: preload("res://assets/pixel/battle/arenas/graveyard.webp"),
	ARENA_OSSUARY: preload("res://assets/pixel/battle/arenas/ossuary.webp"),
	ARENA_WARDEN: preload("res://assets/pixel/battle/arenas/warden.webp"),
}

var arena_id := ARENA_CRYPT

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	set_arena_id(arena_id)

func set_arena_id(value: String) -> void:
	arena_id = value if ARENA_TEXTURES.has(value) else ARENA_CRYPT
	texture = ARENA_TEXTURES[arena_id]
