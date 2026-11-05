class_name C3AuthoredPoseStudy
extends RefCounted

# D396: QA-ONLY comparison against legacy, genuinely drawn animation poses.
# Original v2 atlases predate C3 art direction. They are NOT new C3 frames,
# and this study never writes files or changes the production animation library.
const CELL := 96
const COLS := 6
const ROWS := 5
const ROLES := ["knight", "ranger", "mage"]
const STATES := ["idle", "walk", "attack", "hit", "death"]
const SPEEDS := [2.7, 7.0, 14.0, 12.0, 10.0]
const SOURCE_DIR := "res://assets/pixel/units/combat_units_anim_v2/"

static var _atlas_cache: Dictionary = {}
static var _frames_cache: Dictionary = {}


static func source_columns(role: String, state: String) -> Array[int]:
	if not ROLES.has(role) or not STATES.has(state):
		return []
	if state == "idle":
		return [0, 1, 2, 3]
	if state == "hit":
		return [0, 1, 2]
	# Pack1 source Mage attack col4 is an isolated projectile, NOT a full actor.
	# Keep only the five known full-body animation poses; never forge a 6th.
	if role == "mage" and state == "attack":
		return [0, 1, 2, 3, 5]
	return [0, 1, 2, 3, 4, 5]


static func load_reference_image(role: String) -> Image:
	if not ROLES.has(role):
		return null
	var path: String = "%s%s.webp.b64" % [SOURCE_DIR, role]
	if not FileAccess.file_exists(path):
		return null
	var bytes := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	if bytes.is_empty():
		return null
	var source := Image.new()
	if source.load_webp_from_buffer(bytes) != OK:
		return null
	if source.get_size() != Vector2i(CELL * COLS, CELL * ROWS):
		return null
	source.convert(Image.FORMAT_RGBA8)
	return source


static func make_atlas(role: String) -> Image:
	if _atlas_cache.has(role):
		return _atlas_cache[role] as Image
	var source := load_reference_image(role)
	if source == null:
		return null
	if role == "knight":
		# C3 PALETTE PROBE ONLY. Recolor strongly blue cloth/shield to worn
		# burgundy without painting over steel, gold or real authored poses.
		# This does not create the approved torn Knight cape silhouette.
		for y in range(source.get_height()):
			for x in range(source.get_width()):
				var pixel := source.get_pixel(x, y)
				if pixel.a < 0.06:
					continue
				if pixel.b > pixel.r * 1.18 and pixel.b > pixel.g * 1.13 and pixel.b > 0.19 and pixel.s > 0.26:
					var burgundy := Color.from_hsv(0.975, clampf(pixel.s * 0.82 + 0.17, 0.3, 0.85), pixel.v * 0.79, pixel.a)
					source.set_pixel(x, y, burgundy)
	_atlas_cache[role] = source
	return source


static func make_frames(role: String) -> SpriteFrames:
	if _frames_cache.has(role):
		return _frames_cache[role] as SpriteFrames
	var image := make_atlas(role)
	if image == null:
		return null
	var texture := ImageTexture.create_from_image(image)
	if texture == null:
		return null
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	for row in range(STATES.size()):
		var state: String = STATES[row]
		var columns := source_columns(role, state)
		frames.add_animation(state)
		frames.set_animation_speed(state, SPEEDS[row])
		frames.set_animation_loop(state, row <= 1)
		for col in columns:
			var tile := AtlasTexture.new()
			tile.atlas = texture
			tile.region = Rect2(col * CELL, row * CELL, CELL, CELL)
			frames.add_frame(state, tile)
	_frames_cache[role] = frames
	return frames
