extends GutTest

# D412: source-image assertions below guard ARCHIVED C3 fallback art.
# Active approved D412 BattleUnit coverage is in test_d412_full_hero_pack.gd.

# D406 changes ONE image-derived C3 Knight ATTACK cel at native 96px:
# reconnect the sword hilt to the gauntlet without damaging the D402 shield.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const PREVIOUS := "res://assets/pixel/units/hero_c3_d402/knight.webp.b64"
const UPDATED := "res://assets/pixel/units/hero_c3_d406/knight.webp.b64"
const CELL := 96


func _image(path: String) -> Image:
	if not FileAccess.file_exists(path):
		return null
	var b64 := FileAccess.get_file_as_string(path).strip_edges()
	var raw := Marshalls.base64_to_raw(b64)
	if raw.is_empty():
		return null
	var result := Image.new()
	if result.load_webp_from_buffer(raw) != OK:
		return null
	result.convert(Image.FORMAT_RGBA8)
	return result


func test_d406_native_knight_source_is_one_local_gauntlet_retouch() -> void:
	assert_eq(LIBRARY.C3_KNIGHT_D406_PATH, UPDATED)
	var prior := _image(PREVIOUS)
	var current := _image(UPDATED)
	assert_not_null(prior)
	assert_not_null(current)
	if prior == null or current == null:
		return
	assert_eq(current.get_size(), Vector2i(576, 480))
	assert_true(LIBRARY._valid_c3_hero_atlas(current))
	for row in range(5):
		for col in range(6):
			var area := Rect2i(col * CELL, row * CELL, CELL, CELL)
			var old_tile := prior.get_region(area)
			var new_tile := current.get_region(area)
			if row == 2 and col == 3:
				assert_ne(hash(old_tile.get_data()), hash(new_tile.get_data()), "Knight must have authored gauntlet contact")
			else:
				assert_eq(hash(old_tile.get_data()), hash(new_tile.get_data()),
					"D406 must preserve every other approved cel %d:%d, especially WALK" % [row, col])
	var old_attack := prior.get_region(Rect2i(3 * CELL, 2 * CELL, CELL, CELL))
	var new_attack := current.get_region(Rect2i(3 * CELL, 2 * CELL, CELL, CELL))
	var changes := 0
	var visible_gains := 0
	for y in range(CELL):
		for x in range(CELL):
			var before := old_attack.get_pixel(x, y)
			var after := new_attack.get_pixel(x, y)
			if before != after:
				changes += 1
				assert_true(x >= 48 and x <= 63 and y >= 40 and y <= 51,
					"All brushwork must stay in the gauntlet/hilt contact box, not the shield or cape")
				if before.a < 0.4 and after.a > 0.8:
					visible_gains += 1
	assert_gt(changes, 14, "Repair needs material gauntlet pixels, not a token color dot")
	assert_gt(visible_gains, 2, "Repair bridges previously transparent wrist/hilt space")
	assert_lt(changes, 140, "Do not overpaint entire approved sword or shield")


func test_d406_live_knight_uses_corrected_source_and_unchanged_attack_clock() -> void:
	var current := _image(UPDATED)
	assert_not_null(current)
	var frames: SpriteFrames = LIBRARY.get_frames("knight", false)
	assert_not_null(frames)
	if current == null or frames == null:
		return
	var live_tex := frames.get_frame_texture("attack", 3) as AtlasTexture
	assert_not_null(live_tex)
	if live_tex == null:
		return
	var live := live_tex.atlas.get_image()
	live.convert(Image.FORMAT_RGBA8)
	assert_eq(hash(live.get_data()), hash(current.get_data()))
	assert_eq(frames.get_frame_count("attack"), 6)
	assert_eq(frames.get_frame_count("walk"), 6)
	assert_eq(frames.get_animation_speed("attack"), 16.0)
	for role in ["ranger", "mage"]:
		var other: SpriteFrames = LIBRARY.get_frames(role, false)
		assert_not_null(other)
		if other != null:
			assert_eq(other.get_frame_count("attack"), 6)
