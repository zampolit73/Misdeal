extends TextureRect

const ARENA_CRYPT := "crypt"
const ARENA_GRAVEYARD := "graveyard"
const ARENA_GALLOWS := "gallows"
const ARENA_OSSUARY := "ossuary"
const ARENA_WARDEN := "warden"
const ARENA_BONE_CRUSH := "bone_crush"
const ARENA_BONE_SWARM := "bone_swarm"
const ARENA_GRAVE_CROSSFIRE := "grave_crossfire"
const ARENA_IRON_WALL := "iron_wall"
const ARENA_LAST_BELL := "last_bell"
const ARENA_FIRING_SQUARE := "firing_square"
const ARENA_BONE_RITUAL := "bone_ritual"
const ARENA_THREADBARE_THEATRE := "threadbare_theatre"
const ARENA_BLACK_CROSSING := "black_crossing"
const ARENA_BLACK_LANTERN_ROAD := "black_lantern_road"
# D268: QA battle renders Court geometry, not fallback crypt; #39 remains unreleased.
const ARENA_COURT_OF_THE_MUTE := "court_of_the_mute"

const BACKDROP_SIZE := Vector2i(1280, 720)

const ARENA_PATHS := {
	ARENA_CRYPT: "res://assets/pixel/battle/arenas/arena_redraw_v2/crypt.webp",
	ARENA_GRAVEYARD: "res://assets/pixel/battle/arenas/arena_redraw_v2/graveyard.webp",
	ARENA_GALLOWS: "res://assets/pixel/battle/arenas/arena_redraw_v2/gallows.webp",
	ARENA_OSSUARY: "res://assets/pixel/battle/arenas/arena_redraw_v2/ossuary.webp",
	ARENA_WARDEN: "res://assets/pixel/battle/arenas/arena_redraw_v2/warden.webp",
	ARENA_BONE_CRUSH: "res://assets/pixel/battle/arenas/arena_redraw_v2/bone_crush.webp",
	ARENA_BONE_SWARM: "res://assets/pixel/battle/arenas/arena_redraw_v2/bone_swarm.webp",
	ARENA_GRAVE_CROSSFIRE: "res://assets/pixel/battle/arenas/arena_redraw_v2/grave_crossfire.webp",
	ARENA_IRON_WALL: "res://assets/pixel/battle/arenas/arena_redraw_v2/iron_wall.webp",
	ARENA_LAST_BELL: "res://assets/pixel/battle/arenas/arena_redraw_v2/last_bell.webp",
	ARENA_FIRING_SQUARE: "res://assets/pixel/battle/arenas/arena_redraw_v1/firing_square.webp.b64",
	ARENA_BONE_RITUAL: "res://assets/pixel/battle/arenas/arena_redraw_v1/bone_ritual.webp.b64",
	ARENA_THREADBARE_THEATRE: "res://assets/pixel/battle/arenas/threadbare_theatre_approved_v1.webp.b64",
	ARENA_BLACK_CROSSING: "res://assets/pixel/battle/arenas/black_crossing_storm_pier_approved_v1.webp.b64",
	ARENA_BLACK_LANTERN_ROAD: "res://assets/pixel/battle/arenas/black_lantern_road_arena_selected_v1.webp.b64",
	# D265 art still QA-only; register solely to preview the unreleased Court real Battle.
	ARENA_COURT_OF_THE_MUTE: "res://assets/pixel/battle/arenas/court_of_the_mute_d265_rich_qa.webp.b64",
}

var arena_id := ARENA_CRYPT
var runtime_textures: Dictionary = {}

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	set_arena_id(arena_id)

func set_arena_id(value: String) -> void:
	match value:
		ARENA_GRAVEYARD, ARENA_GALLOWS, ARENA_OSSUARY, ARENA_WARDEN, ARENA_BONE_CRUSH, ARENA_BONE_SWARM, ARENA_GRAVE_CROSSFIRE, ARENA_IRON_WALL, ARENA_LAST_BELL, ARENA_FIRING_SQUARE, ARENA_BONE_RITUAL, ARENA_THREADBARE_THEATRE, ARENA_BLACK_CROSSING, ARENA_BLACK_LANTERN_ROAD, ARENA_COURT_OF_THE_MUTE:
			arena_id = value
		_:
			arena_id = ARENA_CRYPT

	material = null
	texture = _get_runtime_texture(arena_id)

func _get_runtime_texture(value: String) -> Texture2D:
	if runtime_textures.has(value):
		return runtime_textures[value] as Texture2D

	var path := str(ARENA_PATHS.get(value, ARENA_PATHS[ARENA_CRYPT]))
	var bytes := PackedByteArray()
	if path.ends_with(".webp.b64"):
		var encoded := FileAccess.get_file_as_string(path).strip_edges()
		if encoded.is_empty():
			push_error("Authored arena payload is empty: %s" % path)
			return null
		bytes = Marshalls.base64_to_raw(encoded)
	else:
		bytes = FileAccess.get_file_as_bytes(path)

	if bytes.is_empty():
		push_error("Could not read or decode authored arena WebP: %s" % path)
		return null

	var image := Image.new()
	var error := image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode authored arena WebP '%s': %s" % [path, error_string(error)])
		return null

	if image.get_width() != BACKDROP_SIZE.x or image.get_height() != BACKDROP_SIZE.y:
		# These are pixel-art production plates. If a fallback asset ever has the
		# wrong dimensions, keep edges crisp instead of smearing them with Lanczos.
		image.resize(BACKDROP_SIZE.x, BACKDROP_SIZE.y, Image.INTERPOLATE_NEAREST)

	var rendered := ImageTexture.create_from_image(image)
	runtime_textures[value] = rendered
	return rendered
