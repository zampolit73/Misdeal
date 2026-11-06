extends GutTest

# D407 responds to the player's actual 17-13-13.mp4 F6 death footage.
# Only the C3 Mage final DEATH pose has a dormant staff crystal overlay.
# The D401 illustrated atlas must not be re-encoded or recoloured.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ORIGINAL_PATH := "res://assets/pixel/units/hero_c3_d401/mage.webp.b64"
const FINAL_PATH := "res://assets/pixel/units/hero_c3_d407/mage_death_final.webp.b64"


func _image(path: String) -> Image:
	var result := Image.new()
	var data := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	if data.is_empty() or result.load_webp_from_buffer(data) != OK:
		return null
	result.convert(Image.FORMAT_RGBA8)
	return result


func _glow_intensity(image: Image) -> float:
	var result := 0.0
	for y in range(77, 90):
		for x in range(76, 90):
			var c: Color = image.get_pixel(x, y)
			result += maxf(c.r, maxf(c.g, c.b)) * c.a
	return result


func test_d407_dormant_crystal_keeps_death_body_and_staff_source_pixels() -> void:
	var original := _image(ORIGINAL_PATH)
	var final_image := _image(FINAL_PATH)
	assert_not_null(original)
	assert_not_null(final_image)
	if original == null or final_image == null:
		return
	assert_eq(original.get_size(), Vector2i(576, 480))
	assert_eq(final_image.get_size(), Vector2i(96, 96))
	var original_final := original.get_region(Rect2i(5 * 96, 4 * 96, 96, 96))
	var changed := 0
	for y in range(96):
		for x in range(96):
			var before := original_final.get_pixel(x, y)
			var after := final_image.get_pixel(x, y)
			# Lossless WebP strips irrelevant hidden RGB from transparent areas.
			if before.a <= 0.01 and after.a <= 0.01:
				continue
			if before != after:
				changed += 1
				assert_true(x >= 76 and x <= 89 and y >= 77 and y <= 89,
					"Only dormant crystal and local glow may be retouched")
				assert_almost_eq(before.a, after.a, 0.005,
					"Do not delete staff, death-pose silhouette or crystal material")
	assert_gt(changed, 45, "The glow actually changes, not a token pixel")
	assert_lt(changed, 180, "Do not repaint the body or staff")
	var before_light := _glow_intensity(original_final)
	var after_light := _glow_intensity(final_image)
	assert_gt(before_light, 1.0)
	assert_lt(after_light, before_light * 0.65,
		"The final-death crystal should no longer look like an active cast")


func test_d407_only_final_mage_death_frame_is_overridden_in_real_battle_unit() -> void:
	assert_eq(LIBRARY.C3_MAGE_D407_DEATH_FINAL_PATH, FINAL_PATH)
	var actor := UNIT_SCENE.instantiate() as BattleUnit
	actor.visual_role = "mage"
	add_child_autofree(actor)
	var mage_frames: SpriteFrames = actor.sprite_frames
	assert_not_null(mage_frames)
	if mage_frames == null:
		return
	assert_true(LIBRARY.is_live_c3_hero_frames("mage", mage_frames))
	assert_eq(mage_frames.get_frame_count("death"), 6)
	assert_eq(mage_frames.get_animation_speed("death"), 10.0)
	var final_texture: Texture2D = mage_frames.get_frame_texture("death", 5)
	assert_true(final_texture is ImageTexture, "D407 must load one standalone 96px alpha sprite")
	assert_eq(final_texture.get_size(), Vector2(96, 96))
	var final_image := _image(FINAL_PATH)
	assert_eq(hash(final_texture.get_image().get_data()), hash(final_image.get_data()),
		"The live Mage must use the new final death source image")
	for state in ["idle", "walk", "attack", "hit", "death"]:
		var source_row: int = ["idle", "walk", "attack", "hit", "death"].find(state)
		for i in range(mage_frames.get_frame_count(state)):
			if (state == "death" and i == 5) or (state == "hit" and i >= 1):
				continue
			var current: Texture2D = mage_frames.get_frame_texture(state, i)
			assert_true(current is AtlasTexture, "All unchanged Mage poses keep D401 atlas references")
			if current is AtlasTexture:
				var current_tile := current as AtlasTexture
				assert_eq(current_tile.region.position, Vector2(i * 96, source_row * 96))
	var knight: SpriteFrames = LIBRARY.get_frames("knight")
	var ranger: SpriteFrames = LIBRARY.get_frames("ranger")
	assert_true(knight.get_frame_texture("death", 5) is AtlasTexture)
	assert_true(ranger.get_frame_texture("death", 5) is AtlasTexture)
