class_name C3MotionBlocking
extends RefCounted

# D395: QA-only procedural MOTION BLOCKING from the D392 single-pose reference.
# These 25 draft frames/role are NOT 25 independently authored poses.
# Never replace the live BattleUnit animation library with this preview.
const SOURCE_PATH := "res://assets/pixel/units/hero_c3_keyposes_qa/c3_d392_rich_128.webp.b64"
const SOURCE_CELL := 128
const CELL := 96
const COLS := 6
const ROWS := 5
const ROLES := ["knight", "ranger", "mage"]
const STATES := ["idle", "walk", "attack", "hit", "death"]
const COUNTS := [4, 6, 6, 3, 6]
const SPEEDS := [2.7, 7.0, 12.0, 10.0, 8.0]


static func make_atlas(role: String) -> Image:
	if not ROLES.has(role) or not FileAccess.file_exists(SOURCE_PATH):
		return null
	var encoded := FileAccess.get_file_as_string(SOURCE_PATH).strip_edges()
	var bytes := Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		return null
	var source := Image.new()
	if source.load_webp_from_buffer(bytes) != OK:
		return null
	if source.get_size() != Vector2i(384, 128):
		return null
	source.convert(Image.FORMAT_RGBA8)
	var atlas := Image.create(CELL * COLS, CELL * ROWS, false, Image.FORMAT_RGBA8)
	atlas.fill(Color.TRANSPARENT)
	var role_index: int = ROLES.find(role)
	for state_index in range(STATES.size()):
		for frame in range(COUNTS[state_index]):
			var painted := _pose(source, role_index, state_index, frame, COUNTS[state_index])
			atlas.blit_rect(painted, Rect2i(0, 0, CELL, CELL), Vector2i(frame * CELL, state_index * CELL))
	return atlas


static func make_frames(role: String) -> SpriteFrames:
	var atlas := make_atlas(role)
	if atlas == null:
		return null
	var texture := ImageTexture.create_from_image(atlas)
	if texture == null:
		return null
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	for row in range(STATES.size()):
		var state: String = STATES[row]
		frames.add_animation(state)
		frames.set_animation_speed(state, SPEEDS[row])
		frames.set_animation_loop(state, row < 2)
		for col in range(COUNTS[row]):
			var tile := AtlasTexture.new()
			tile.atlas = texture
			tile.region = Rect2(col * CELL, row * CELL, CELL, CELL)
			frames.add_frame(state, tile)
	return frames


# Motion-blocking warps preserve source material for motion readability studies.
# The final animation artwork must be drawn individually; this isn't it.
static func _pose(source: Image, role_index: int, state: int, frame: int, count: int) -> Image:
	var output := Image.create(CELL, CELL, false, Image.FORMAT_RGBA8)
	output.fill(Color.TRANSPARENT)
	var phase := float(frame) * TAU / float(count)
	var stride := sin(phase)
	var beat := float(frame) / float(maxi(1, count - 1))
	var recoil := [-2.0, -7.0, 4.0]
	var sweep := [-2.0, -5.0, -8.0, 6.0, 9.0, 2.0]
	for y in range(CELL):
		for x in range(CELL):
			var px := (float(x) + 0.5) * float(SOURCE_CELL) / float(CELL)
			var py := (float(y) + 0.5) * float(SOURCE_CELL) / float(CELL)
			var upper := clampf((101.0 - py) / 75.0, 0.0, 1.0)
			var cape_zone := clampf((65.0 - px) / 32.0, 0.0, 1.0) * clampf((py - 43.0) / 38.0, 0.0, 1.0)
			match state:
				0: # Quiet breathing with feet planted.
					py -= sin(phase) * 1.6 * upper
					px -= cos(phase) * (0.75 * upper + 1.1 * cape_zone)
				1: # Alternating lower legs, gait bob and cloth delay.
					var lower := clampf((py - 76.0) / 38.0, 0.0, 1.0)
					var leg_side := -1.0 if px < 65.0 else 1.0
					px -= stride * (3.8 * lower * leg_side + 2.0 * cape_zone) + cos(phase) * 1.3 * upper
					py -= absf(stride) * (2.0 * lower + 1.5 * upper) + (1.0 - cos(phase)) * 0.7 * upper
				2: # Body/weapon timing differs from the walk cycle.
					var drive: float = sweep[frame]
					var weapon_right := px > 73.0 if role_index != 0 else px < 67.0
					var weapon_zone := 1.0 if weapon_right else 0.0
					px -= drive * (0.42 * upper + 0.58 * weapon_zone)
					py += absf(drive) * (0.23 * weapon_zone - 0.16 * upper)
					if role_index == 2:
						py += sin(phase) * 2.0 * upper
				3: # Impact recoil only; no gameplay/hitbox change.
					px -= recoil[frame] * upper
					py += absf(recoil[frame]) * 0.23 * upper
				4: # Continuous falling tilt: not final hand-drawn death.
					var angle := deg_to_rad(-4.0 - 71.0 * beat)
					var pivot := Vector2(64.0 + beat * 18.0, 120.0)
					var offset := Vector2(px, py) - pivot
					var inverse := -angle
					var cs := cos(inverse)
					var sn := sin(inverse)
					var rotated := Vector2(offset.x * cs - offset.y * sn, offset.x * sn + offset.y * cs)
					px = rotated.x + 64.0
					py = rotated.y + 120.0
			if px < 0.0 or px >= 128.0 or py < 0.0 or py >= 128.0:
				continue
			var tint := source.get_pixel(role_index * SOURCE_CELL + int(px), int(py))
			if tint.a < 0.13:
				continue
			if state == 3 and frame == 1:
				tint = tint.lerp(Color(0.95, 0.60, 0.53, tint.a), 0.27)
			output.set_pixel(x, y, tint)
	return output
