extends TextureRect

const LIVING_PROFILE := preload("res://scripts/battle/living_arena_profile.gd")
const LIVING_SHADER := preload("res://shaders/living_arena.gdshader")
var living_enabled := true
var living_paused := false
var living_finished := false
var living_elapsed := 0.0
var living_material: ShaderMaterial
var living_profile_id := ""
var living_phase_mix := 0.0
var _living_phase_target := 0.0
var _living_reacts_to_phase := false
var _living_reacts_to_wave := false
var _living_wave_age := 3.0

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
const ARENA_COURT_OF_THE_MUTE := "court_of_the_mute"

const COURT_QA_LEGACY_PATH := "res://assets/pixel/battle/arenas/court_of_the_mute_d265_rich_qa.webp.b64"
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
	ARENA_FIRING_SQUARE: "res://assets/pixel/battle/arenas/approved_d283/firing_square.webp",
	ARENA_BONE_RITUAL: "res://assets/pixel/battle/arenas/approved_d283/bone_ritual.webp",
	ARENA_THREADBARE_THEATRE: "res://assets/pixel/battle/arenas/threadbare_theatre_approved_v1.webp.b64",
	ARENA_BLACK_CROSSING: "res://assets/pixel/battle/arenas/black_crossing_storm_pier_approved_v1.webp.b64",
	ARENA_BLACK_LANTERN_ROAD: "res://assets/pixel/battle/arenas/black_lantern_road_arena_selected_v1.webp.b64",
	# D271: the painted tribunal used by the released Court encounter.
	# Source input verified pixel-identical and encoded to real WebP SHA256
	# 1eb45164d9c7418fb9c459d18c0640935452266aeecbb04d1e9d7bd527af8784.
	# D270 rejected SVG and D265 prior QA WebP remain versioned for rollback.
	ARENA_COURT_OF_THE_MUTE: "res://assets/pixel/battle/arenas/court_of_the_mute_d271_painted_qa.webp.b64",
}

var arena_id := ARENA_CRYPT
var runtime_textures: Dictionary = {}
var court_qa_show_legacy := false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	set_arena_id(arena_id)

func set_arena_id(value: String, encounter_id: String = "") -> void:
	match value:
		ARENA_GRAVEYARD, ARENA_GALLOWS, ARENA_OSSUARY, ARENA_WARDEN, ARENA_BONE_CRUSH, ARENA_BONE_SWARM, ARENA_GRAVE_CROSSFIRE, ARENA_IRON_WALL, ARENA_LAST_BELL, ARENA_FIRING_SQUARE, ARENA_BONE_RITUAL, ARENA_THREADBARE_THEATRE, ARENA_BLACK_CROSSING, ARENA_BLACK_LANTERN_ROAD, ARENA_COURT_OF_THE_MUTE:
			arena_id = value
		_:
			arena_id = ARENA_CRYPT

	material = null
	texture = _get_runtime_texture(arena_id)
	living_profile_id = LIVING_PROFILE.for_encounter(arena_id, encounter_id)
	_configure_living_arena()

func _configure_living_arena() -> void:
	living_elapsed = 0.0
	living_finished = false
	living_paused = false
	living_material = null
	living_phase_mix = 0.0
	_living_phase_target = 0.0
	_living_reacts_to_phase = false
	_living_reacts_to_wave = false
	_living_wave_age = 3.0
	if not living_profile_id.is_empty():
		var profile: Dictionary = LIVING_PROFILE.PROFILES[living_profile_id]
		living_material = ShaderMaterial.new()
		living_material.shader = LIVING_SHADER
		living_material.set_shader_parameter("source_plate", texture)
		living_material.set_shader_parameter("region_mask", LIVING_PROFILE.mask_for(living_profile_id))
		living_material.set_shader_parameter("arena_mode", profile.mode)
		if profile.has("haze"):
			living_material.set_shader_parameter("haze_style", profile.haze)
			living_material.set_shader_parameter("mote_area", profile.motes)
			living_material.set_shader_parameter("mote_strength", profile.dust_strength)
		_living_reacts_to_phase = profile.get("phase_response", false)
		_living_reacts_to_wave = profile.get("wave_response", false)
		if profile.has("cycle_seconds"):
			living_material.set_shader_parameter("cycle_seconds", profile.cycle_seconds)
			living_material.set_shader_parameter("local_motion", profile.motion)
	set_living_enabled(living_enabled)

func set_living_phase_two(active: bool) -> void:
	if _living_reacts_to_phase and not living_finished:
		_living_phase_target = 1.0 if active else 0.0

func start_living_wave_two() -> void:
	if _living_reacts_to_wave and not living_finished:
		_living_wave_age = 0.0

func set_living_enabled(enabled: bool) -> void:
	living_enabled = enabled
	var use_living := enabled and not (arena_id == ARENA_COURT_OF_THE_MUTE and court_qa_show_legacy)
	material = living_material if use_living else null
	set_process(material != null and not living_finished and not living_paused)

func set_living_paused(paused: bool) -> void:
	living_paused = paused
	set_living_enabled(living_enabled)

func finish_living_arena() -> void:
	living_finished = true
	set_process(false)

func advance_living(delta: float) -> void:
	if not living_enabled or living_paused or living_finished or material == null: return
	if is_inside_tree() and get_tree().paused: return
	living_elapsed += maxf(0.0, delta)
	living_material.set_shader_parameter("elapsed", living_elapsed)
	if living_phase_mix != _living_phase_target:
		living_phase_mix = move_toward(living_phase_mix, _living_phase_target, maxf(delta, 0.0) / 1.2)
		living_material.set_shader_parameter("phase_strength", smoothstep(0.0, 1.0, living_phase_mix))
	if _living_wave_age < 3.0:
		_living_wave_age = minf(3.0, _living_wave_age + maxf(0.0, delta))
		var strength := smoothstep(0.0, 0.5, _living_wave_age) * (1.0 - smoothstep(0.5, 3.0, _living_wave_age))
		living_material.set_shader_parameter("wave_strength", strength)

func _process(delta: float) -> void:
	advance_living(delta)

# D271 QA-only visual comparison: switch between D265 rollback and the
# actual D271 painted tribunal in the exact same real Battle.
func set_court_qa_legacy_art(enabled: bool) -> void:
	if arena_id != ARENA_COURT_OF_THE_MUTE:
		return
	court_qa_show_legacy = enabled
	texture = _get_runtime_texture(ARENA_COURT_OF_THE_MUTE)
	set_living_enabled(living_enabled)


func _get_runtime_texture(value: String) -> Texture2D:
	var path := str(ARENA_PATHS.get(value, ARENA_PATHS[ARENA_CRYPT]))
	if value == ARENA_COURT_OF_THE_MUTE and court_qa_show_legacy:
		path = COURT_QA_LEGACY_PATH
	if runtime_textures.has(path):
		return runtime_textures[path] as Texture2D
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
	# Old D270 SVG is retained for archival QA, whereas the new D271 final-size
	# painted raster is decoded from WebP b64; normal 1280×720 avoids resizing.
	var error := image.load_svg_from_buffer(bytes) if path.ends_with(".svg") else image.load_webp_from_buffer(bytes)
	if error != OK:
		push_error("Could not decode authored arena image '%s': %s" % [path, error_string(error)])
		return null

	if image.get_width() != BACKDROP_SIZE.x or image.get_height() != BACKDROP_SIZE.y:
		# These are pixel-art production plates. If a fallback asset ever has the
		# wrong dimensions, keep edges crisp instead of smearing them with Lanczos.
		image.resize(BACKDROP_SIZE.x, BACKDROP_SIZE.y, Image.INTERPOLATE_NEAREST)

	var rendered := ImageTexture.create_from_image(image)
	runtime_textures[path] = rendered
	return rendered
