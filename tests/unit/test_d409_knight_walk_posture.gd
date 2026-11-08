extends GutTest

# D412: source-image assertions below guard ARCHIVED C3 fallback art.
# Active approved D412 BattleUnit coverage is in test_d412_full_hero_pack.gd.

# D409: fix the visible C3 Knight forward-hunched WALK silhouette
# using SIX source-art cel changes; the approved D404 distance cadence and
# all foot-contact pixels are identical to D406.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ORIGINAL := "res://assets/pixel/units/hero_c3_d406/knight.webp.b64"


func _image(path: String) -> Image:
	if not FileAccess.file_exists(path):
		return null
	var encoded := FileAccess.get_file_as_string(path).strip_edges()
	var raw := Marshalls.base64_to_raw(encoded)
	if raw.is_empty():
		return null
	var img := Image.new()
	if img.load_webp_from_buffer(raw) != OK:
		return null
	img.convert(Image.FORMAT_RGBA8)
	return img


func _upper_center_x(img: Image) -> float:
	var total := 0.0
	var weighted_x := 0.0
	for y in range(10, 35):
		for x in range(96):
			var alpha: float = img.get_pixel(x, y).a
			if alpha > 0.35:
				weighted_x += float(x) * alpha
				total += alpha
	return weighted_x / maxf(total, 0.01)


func test_d409_all_six_knight_walk_poses_stand_upright_with_original_boot_positions() -> void:
	var atlas := _image(ORIGINAL)
	assert_not_null(atlas)
	if atlas == null:
		return
	assert_eq(atlas.get_size(), Vector2i(576, 480))
	var frames: SpriteFrames = LIBRARY.get_frames("knight", false)
	assert_not_null(frames)
	assert_true(LIBRARY.is_live_c3_hero_frames("knight", frames))
	if frames == null:
		return
	assert_eq(frames.get_frame_count("walk"), 6)
	assert_eq(frames.get_animation_speed("walk"), 7.0)
	for i in range(6):
		var path: String = "%sknight_walk_%d.webp.b64" % [LIBRARY.C3_KNIGHT_D409_WALK_DIR, i]
		var updated := _image(path)
		assert_not_null(updated)
		if updated == null:
			continue
		assert_eq(updated.get_size(), Vector2i(96, 96))
		var baseline := atlas.get_region(Rect2i(i * 96, 96, 96, 96))
		var shift: float = _upper_center_x(updated) - _upper_center_x(baseline)
		assert_lt(shift, -3.8, "Knight upper body should sit behind the source forward lean")
		assert_gt(shift, -5.8, "Do not displace the entire character dramatically")
		for y in range(67, 96):
			for x in range(96):
				var old_c := baseline.get_pixel(x, y)
				var new_c := updated.get_pixel(x, y)
				assert_almost_eq(new_c.a, old_c.a, 0.005,
					"Foot/ground alpha must remain fixed in source cel %d" % i)
				if old_c.a > 0.01 or new_c.a > 0.01:
					assert_almost_eq(new_c.r, old_c.r, 0.005)
					assert_almost_eq(new_c.g, old_c.g, 0.005)
					assert_almost_eq(new_c.b, old_c.b, 0.005)
		var texture: Texture2D = frames.get_frame_texture("walk", i)
		assert_true(texture is ImageTexture, "Knight WALK should use native corrected cel")
		assert_eq(hash(texture.get_image().get_data()), hash(updated.get_data()))


func test_d409_actual_battle_unit_retains_d404_stride_and_other_c3_heroes() -> void:
	var parent := Node2D.new()
	add_child_autofree(parent)
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.visual_role = "knight"
	parent.add_child(unit)
	unit.set_process(false)
	unit.set_process_input(false)
	assert_eq(unit.C3_WALK_PIXELS_PER_FRAME, 12.0)
	assert_eq(unit.C3_WALK_MAX_PIXELS_PER_SAMPLE, 18.0)
	unit.combat_started = true
	unit.visual_moving = true
	unit._update_frame_animation(1.0 / 60.0)
	assert_eq(unit.frame_state, "walk")
	assert_eq(unit.art_sprite.texture, unit.sprite_frames.get_frame_texture("walk", 0))
	unit.position.x += 13.0
	unit._update_frame_animation(1.0 / 60.0)
	assert_eq(unit.art_sprite.texture, unit.sprite_frames.get_frame_texture("walk", 1))
	unit.visual_moving = false
	unit._update_frame_animation(0.05)
	assert_eq(unit.art_sprite.texture, unit.sprite_frames.get_frame_texture("walk", 1),
		"Knight's accepted stop/hold behavior must remain unchanged")
	for role in ["ranger", "mage"]:
		var other_frames: SpriteFrames = LIBRARY.get_frames(role, false)
		assert_true(other_frames.get_frame_texture("walk", 0) is AtlasTexture,
			role + " retains original D401 source and cadence")
