extends GutTest

# D401 is a weapon-IDENTITY art fix. Raster uniqueness/alpha alone missed
# a Knight axe appearing in sword poses and Ranger's vanished bow.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const CURRENT_DIR := "res://assets/pixel/units/hero_c3_d401/"
const OLD_DIR := "res://assets/pixel/units/hero_c3_d400/"


func _atlas(directory: String, role: String) -> Image:
	var path := "%s%s.webp.b64" % [directory, role]
	if not FileAccess.file_exists(path):
		return null
	var binary := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	var image := Image.new()
	if binary.is_empty() or image.load_webp_from_buffer(binary) != OK:
		return null
	image.convert(Image.FORMAT_RGBA8)
	return image


func _opaque_in(image: Image, row: int, col: int, region: Rect2i) -> int:
	var count := 0
	for y in range(region.position.y, region.end.y):
		for x in range(region.position.x, region.end.x):
			if image.get_pixel(col * 96 + x, row * 96 + y).a > 0.35:
				count += 1
	return count


func _changed_alpha_visible(a: Image, b: Image, row: int, col: int) -> bool:
	for y in range(0, 96, 2):
		for x in range(0, 96, 2):
			var before := a.get_pixel(col * 96 + x, row * 96 + y)
			var after := b.get_pixel(col * 96 + x, row * 96 + y)
			if absf(before.a - after.a) > 0.10:
				return true
	return false


func test_d401_stages_three_valid_25_pose_c3_atlases_with_legacy_rollback() -> void:
	assert_true(LIBRARY.C3_HERO_PILOT_ENABLED)
	assert_eq(LIBRARY.C3_HERO_PILOT_DIR, CURRENT_DIR)
	for role in ["knight", "ranger", "mage"]:
		var current := _atlas(CURRENT_DIR, role)
		var original := _atlas(OLD_DIR, role)
		assert_not_null(current, role + " needs staged D401 atlas")
		assert_not_null(original, role + " must keep D400 rollback")
		if current == null or original == null:
			continue
		assert_eq(current.get_size(), Vector2i(576, 480))
		assert_true(LIBRARY._valid_c3_hero_atlas(current), role + " keeps all 25 unique opaque and 5 alpha-clear cels")
		var frames := LIBRARY.get_frames(role)
		assert_not_null(frames)
		if frames != null:
			assert_eq(frames.get_frame_count("attack"), 6)


func test_knight_mid_swing_is_a_tapered_sword_not_an_axe_head() -> void:
	var after := _atlas(CURRENT_DIR, "knight")
	var before := _atlas(OLD_DIR, "knight")
	assert_not_null(after)
	assert_not_null(before)
	if after == null or before == null:
		return
	for col in [2, 3]:
		# Broad axe cap occupied more of this upper-right region.
		# The reauthored tapered sword leaves only narrow blade pixels.
		var region := Rect2i(75, 16, 20, 28)
		var old_head := _opaque_in(before, 2, col, region)
		var new_head := _opaque_in(after, 2, col, region)
		assert_lt(new_head, int(float(old_head) * 0.83), "Attack cel %d should lose broad axe head" % col)
		assert_gt(new_head, 10, "Sword must remain visible, not be deleted")
		assert_true(_changed_alpha_visible(before, after, 2, col), "Attack cel %d must have corrected weapon silhouette" % col)


func test_ranger_bow_is_present_in_final_attack_release_pose() -> void:
	var after := _atlas(CURRENT_DIR, "ranger")
	var before := _atlas(OLD_DIR, "ranger")
	assert_not_null(after)
	assert_not_null(before)
	if after == null or before == null:
		return
	var region := Rect2i(75, 5, 17, 25)
	assert_lt(_opaque_in(before, 2, 5, region), 4, "D400 reference really lacked a bow")
	assert_gt(_opaque_in(after, 2, 5, region), 20, "Restored curved bow must be visible during release")
	assert_true(_changed_alpha_visible(before, after, 2, 5))


func test_mage_animation_pixels_are_unchanged_in_d401() -> void:
	var old_file := FileAccess.get_file_as_string(OLD_DIR + "mage.webp.b64")
	var new_file := FileAccess.get_file_as_string(CURRENT_DIR + "mage.webp.b64")
	assert_eq(new_file, old_file, "Mage unchanged in weapon-only D401 repair")
