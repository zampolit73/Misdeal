extends GutTest

# D402: D401 fixed a sword→axe substitution but the Knight still lost the
# approved shield in four attack cels. This test checks the actual alpha art,
# not just that there are 25 non-empty distinct images.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const OLD_KNIGHT := "res://assets/pixel/units/hero_c3_d401/knight.webp.b64"
const NEW_KNIGHT := "res://assets/pixel/units/hero_c3_d402/knight.webp.b64"
const CELL := 96


func _decode(path: String) -> Image:
	if not FileAccess.file_exists(path):
		return null
	var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	if raw.is_empty():
		return null
	var image := Image.new()
	if image.load_webp_from_buffer(raw) != OK:
		return null
	image.convert(Image.FORMAT_RGBA8)
	return image


func test_d402_knight_shield_restored_in_four_mid_attack_cels_only() -> void:
	assert_eq(LIBRARY.C3_KNIGHT_D402_PATH, NEW_KNIGHT)
	var prior := _decode(OLD_KNIGHT)
	var updated := _decode(NEW_KNIGHT)
	assert_not_null(prior)
	assert_not_null(updated)
	if prior == null or updated == null:
		return
	assert_eq(updated.get_size(), Vector2i(576, 480))
	assert_true(LIBRARY._valid_c3_hero_atlas(updated), "Must keep 25 distinct visible cels and 5 transparent spares")
	for row in range(5):
		for col in range(6):
			var region := Rect2i(col * CELL, row * CELL, CELL, CELL)
			var before := prior.get_region(region)
			var after := updated.get_region(region)
			if row != 2 or col < 2:
				assert_eq(hash(before.get_data()), hash(after.get_data()),
					"Unrelated cel %d:%d must remain pixel-identical to approved D401" % [row, col])
				continue
			assert_ne(hash(before.get_data()), hash(after.get_data()),
				"Knight attack %d should gain an attached shield" % col)
			var gained := 0
			var removed := 0
			for y in range(25, 85):
				for x in range(38, 76):
					var old_alpha: float = before.get_pixel(x, y).a
					var new_alpha: float = after.get_pixel(x, y).a
					if old_alpha <= 0.36 and new_alpha > 0.36:
						gained += 1
					if old_alpha > 0.36 and new_alpha <= 0.36:
						removed += 1
			assert_gt(gained, 30, "A proper Knight shield needs visible new surface on attack %d" % col)
			assert_lte(removed, 5, "Sword/body/cape must not be erased on attack %d" % col)


func test_d402_live_knight_uses_new_art_without_changing_other_hero_roles() -> void:
	var image := _decode(NEW_KNIGHT)
	assert_not_null(image)
	var frames: SpriteFrames = LIBRARY.get_frames("knight")
	assert_not_null(frames)
	if image == null or frames == null:
		return
	assert_eq(frames.get_frame_count("attack"), 6)
	var tile := frames.get_frame_texture("attack", 2) as AtlasTexture
	assert_not_null(tile)
	if tile == null:
		return
	var atlas_image: Image = tile.atlas.get_image()
	assert_not_null(atlas_image)
	if atlas_image != null:
		atlas_image.convert(Image.FORMAT_RGBA8)
		assert_eq(hash(atlas_image.get_data()), hash(image.get_data()),
			"Live Knight SpriteFrames must load the D402 atlas, not D401 or old v2")
	for role in ["ranger", "mage"]:
		var hero_frames: SpriteFrames = LIBRARY.get_frames(role)
		assert_not_null(hero_frames)
		if hero_frames != null:
			assert_eq(hero_frames.get_frame_count("attack"), 6)
