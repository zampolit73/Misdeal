class_name C3FrameFinish
extends RefCounted

# D397 C3 *retouch* of previously illustrated Pack1 v2 frames.
# This is not 75 new hand-drawn poses, and remains out of live combat.
# Original archived atlas bytes remain untouched for rollback.
const ORIGINAL := preload("res://scripts/dev/c3_authored_pose_study.gd")
const CELL := 96
const COLS := 6
const ROWS := 5
const STATES := ["idle", "walk", "attack", "hit", "death"]
const FPS := [2.7, 7.0, 14.0, 12.0, 10.0]
static var _atlas_cache: Dictionary = {}
static var _frame_cache: Dictionary = {}


static func make_atlas(role: String) -> Image:
	if _atlas_cache.has(role):
		return _atlas_cache[role] as Image
	var original: Image = ORIGINAL.make_atlas(role)
	if original == null:
		return null
	var output := Image.create(CELL * COLS, CELL * ROWS, false, Image.FORMAT_RGBA8)
	output.fill(Color.TRANSPARENT)
	for row in range(ROWS):
		var state: String = STATES[row]
		var cols: Array[int] = ORIGINAL.source_columns(role, state)
		for frame in range(cols.size()):
			var source_col: int = cols[frame]
			var cell := original.get_region(Rect2i(source_col * CELL, row * CELL, CELL, CELL))
			var cleaned := _finish_cell(cell, role)
			output.blit_rect(cleaned, Rect2i(0, 0, CELL, CELL), Vector2i(frame * CELL, row * CELL))
	# By construction, Mage attack column 5 (the only unused one) stays clear;
	# projectile-only source column 4 is NEVER written to the new atlas.
	_atlas_cache[role] = output
	return output


static func make_frames(role: String) -> SpriteFrames:
	if _frame_cache.has(role):
		return _frame_cache[role] as SpriteFrames
	var atlas := make_atlas(role)
	if atlas == null:
		return null
	var texture := ImageTexture.create_from_image(atlas)
	if texture == null:
		return null
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")
	for row in range(ROWS):
		var state: String = STATES[row]
		var count: int = ORIGINAL.source_columns(role, state).size()
		frames.add_animation(state)
		frames.set_animation_speed(state, FPS[row])
		frames.set_animation_loop(state, row < 2)
		for col in range(count):
			var tile := AtlasTexture.new()
			tile.atlas = texture
			tile.region = Rect2(col * CELL, row * CELL, CELL, CELL)
			frames.add_frame(state, tile)
	_frame_cache[role] = frames
	return frames


static func _finish_cell(source: Image, role: String) -> Image:
	var cleaned := Image.create(CELL, CELL, false, Image.FORMAT_RGBA8)
	cleaned.fill(Color.TRANSPARENT)
	for y in range(CELL):
		for x in range(CELL):
			var value := source.get_pixel(x, y)
			# Remove semi-transparent source-sheet halo/compression fog without
			# altering the painted actor's solid silhouette or weapon.
			if value.a < 0.13:
				continue
			if value.a < 0.26:
				value.a = clampf((value.a - 0.13) / 0.13, 0.0, 1.0) * 0.26
			# Preserve the material lighting of genuine painted source poses.
			# Knight has burgundy cloth/shield from D396, but is not yet a
			# newly illustrated torn-cloak final C3 character.
			match role:
				"knight":
					if (value.h < 0.07 or value.h > 0.93) and value.s > 0.22:
						value = Color.from_hsv(value.h, minf(0.9, value.s * 1.05), minf(1.0, value.v * 1.08), value.a)
				"ranger":
					# Lift olive cloth slightly off the dark grey stone while
					# leaving brown leather, hands and bow the original art.
					if value.h >= 0.15 and value.h <= 0.45 and value.s > 0.13:
						value = Color.from_hsv(value.h, minf(0.75, value.s * 1.05), minf(0.83, value.v * 1.11 + 0.012), value.a)
				"mage":
					# Recover violet robe separation but avoid neon/white bloom.
					if value.h >= 0.65 and value.h <= 0.90 and value.s > 0.20:
						value = Color.from_hsv(value.h, minf(0.80, value.s * 1.03), minf(0.9, value.v * 1.10), value.a)
			cleaned.set_pixel(x, y, value)
	return cleaned
