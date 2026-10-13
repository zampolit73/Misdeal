class_name MisdealUnitAnimationLibrary
extends RefCounted

# Grounded Animation Pack 1 v2: transparent 576x480 WebP, 6x5 cells of
# 96x96. They are stored as Base64 text for Godot export compatibility.
# Existing v4 still provides all fallback static units.
const CELL_SIZE := 96
const COLUMNS := 6
const ROWS := 5
const BASE_DIR := "res://assets/pixel/units/combat_units_anim_v2/"
const PACK2_DIR := "res://assets/pixel/units/combat_units_anim_pack2_candidates/"
const DECK_EXPANSION_DIR := "res://assets/pixel/units/deck_expansion_v1/"
const NEW_ENEMY_ROLES := ["bone_shepherd", "ossuary_lamb"]
const ROLES := ["knight", "ranger", "mage", "skeleton", "bone_archer", "bone_thrall", "grave_bellkeeper", "crypt_guard", "bone_warden", "bone_shepherd", "ossuary_lamb"]

static var _frames_cache: Dictionary = {}
static var _unavailable: Dictionary = {}


static func get_frames(role: String) -> SpriteFrames:
	if not ROLES.has(role):
		return null
	if _frames_cache.has(role):
		return _frames_cache[role] as SpriteFrames
	if _unavailable.has(role):
		return null

	if NEW_ENEMY_ROLES.has(role):
		var svg_path := "%s%s_frames.svg" % [DECK_EXPANSION_DIR, role]
		var svg_texture := load(svg_path) as Texture2D
		if svg_texture == null or svg_texture.get_size() != Vector2(CELL_SIZE * COLUMNS, CELL_SIZE * ROWS):
			push_error("Original Deck Expansion SVG animation atlas missing/invalid: %s" % svg_path)
			_unavailable[role] = true
			return null
		return _create_frames(role, svg_texture)

	var directory := PACK2_DIR if role in ["bone_thrall", "grave_bellkeeper", "crypt_guard", "bone_warden"] else BASE_DIR
	var path := "%s%s.webp.b64" % [directory, role]
	if not FileAccess.file_exists(path):
		_unavailable[role] = true
		push_warning("Animation atlas missing: %s (using static v4 art)" % path)
		return null

	var encoded := FileAccess.get_file_as_string(path).strip_edges()
	var bytes := Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		_unavailable[role] = true
		push_warning("Cannot decode animation atlas: %s" % path)
		return null

	var img := Image.new()
	if img.load_webp_from_buffer(bytes) != OK or img.get_width() != CELL_SIZE * COLUMNS or img.get_height() != CELL_SIZE * ROWS:
		_unavailable[role] = true
		push_warning("Animation atlas format or dimensions invalid: %s" % path)
		return null

	var atlas := ImageTexture.create_from_image(img)
	if atlas == null:
		_unavailable[role] = true
		return null

	return _create_frames(role, atlas)

static func get_static_texture(role: String) -> Texture2D:
	var frames := get_frames(role)
	if frames == null or frames.get_frame_count("idle") == 0:
		return null
	return frames.get_frame_texture("idle", 0)

static func _create_frames(role: String, atlas: Texture2D) -> SpriteFrames:
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	_add_row(frames, atlas, "idle", 0, 4, 2.7, true)
	_add_row(frames, atlas, "walk", 1, 6, 7.0, true)
	_add_row(frames, atlas, "attack", 2, 6, 14.0 if role == "mage" else 16.0, false, role)
	_add_row(frames, atlas, "hit", 3, 3, 12.0, false)
	_add_row(frames, atlas, "death", 4, 6, 10.0, false)
	_frames_cache[role] = frames
	return frames


static func _add_row(frames: SpriteFrames, atlas: Texture2D, name: String, row: int, count: int, fps: float, looping: bool, role: String = "") -> void:
	frames.add_animation(name)
	frames.set_animation_speed(name, fps)
	frames.set_animation_loop(name, looping)
	for x in range(count):
		var frame_column := x
		var tile := AtlasTexture.new()
		tile.atlas = atlas
		tile.region = Rect2(float(frame_column * CELL_SIZE), float(row * CELL_SIZE), float(CELL_SIZE), float(CELL_SIZE))
		frames.add_frame(name, tile)
