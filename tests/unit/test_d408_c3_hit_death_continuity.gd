extends GutTest

# D412: source-image assertions below guard ARCHIVED C3 fallback art.
# Active approved D412 BattleUnit coverage is in test_d412_full_hero_pack.gd.

# D408: verify real original C3 body paintings + recovered existing
# source-weapon artwork during HIT, and an unwarped death transition.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ROLES := ["knight", "ranger", "mage"]
const OVERRIDES := {"ranger": [0, 1, 2], "mage": [1, 2]}
const ORIGINAL_SOURCE := "res://assets/pixel/units/hero_c3_d401/"


func _actor(role: String, side: int = 0) -> BattleUnit:
	var stage := Node2D.new()
	add_child_autofree(stage)
	var actor := UNIT_SCENE.instantiate() as BattleUnit
	actor.visual_role = role
	actor.team = side
	stage.add_child(actor)
	actor.set_process(false)
	actor.set_process_input(false)
	return actor


func _image_from_b64(path: String) -> Image:
	var img := Image.new()
	var raw := Marshalls.base64_to_raw(FileAccess.get_file_as_string(path).strip_edges())
	if raw.is_empty() or img.load_webp_from_buffer(raw) != OK:
		return null
	img.convert(Image.FORMAT_RGBA8)
	return img


func test_d408_ranger_and_mage_hit_art_uses_real_96px_weapon_corrections() -> void:
	for role in ["ranger", "mage"]:
		var frames: SpriteFrames = LIBRARY.get_frames(role, false)
		assert_true(LIBRARY.is_live_c3_hero_frames(role, frames))
		assert_eq(frames.get_frame_count("hit"), 3)
		assert_eq(frames.get_animation_speed("hit"), 12.0)
		var source := _image_from_b64(ORIGINAL_SOURCE + role + ".webp.b64")
		assert_not_null(source)
		if source == null:
			continue
		for i in range(3):
			var current: Texture2D = frames.get_frame_texture("hit", i)
			if OVERRIDES[role].has(i):
				assert_true(current is ImageTexture, role + " HIT %d must use an actual edited 96px sprite" % i)
				var path: String = "res://assets/pixel/units/hero_c3_d408/%s_hit_%d.webp.b64" % [role, i]
				var expected := _image_from_b64(path)
				assert_not_null(expected)
				if expected == null:
					continue
				assert_eq(expected.get_size(), Vector2i(96, 96))
				assert_eq(hash(current.get_image().get_data()), hash(expected.get_data()),
					"BattleUnit HIT sprite must use the exact restored source-art weapon pixels")
				# Existing source subject (face/cloak/boots) must remain; the
				# newly added weapon comes from an existing approved pose.
				var original_cell := source.get_region(Rect2i(i * 96, 3 * 96, 96, 96))
				var shared_visible := 0
				for y in range(96):
					for x in range(96):
						var before: Color = original_cell.get_pixel(x, y)
						var after: Color = expected.get_pixel(x, y)
						if before.a > 0.5 and after.a > 0.5:
							shared_visible += 1
				assert_gt(shared_visible, 220, "Must preserve original whole-body illustration rather than replacing with a prop cutout")
			else:
				assert_true(current is AtlasTexture, role + " original unedited HIT cel should be untouched")
	for role in ["knight", "ranger", "mage"]:
		var hero: SpriteFrames = LIBRARY.get_frames(role, false)
		assert_eq(hero.get_frame_count("death"), 6)
		assert_eq(hero.get_animation_speed("death"), 10.0)
		assert_eq(hero.get_frame_count("walk"), 6)


func test_d408_c3_hit_keeps_source_scale_color_and_preserves_authored_death() -> void:
	for role in ROLES:
		var hero := _actor(role)
		hero._play_hit_feedback(Vector2(-100.0, 0.0), "skeleton", true)
		assert_eq(hero.frame_state, "hit")
		assert_eq(hero.scale, Vector2.ONE, role + " must not rubber-enlarge authored full-body HIT cels")
		assert_eq(hero.art_sprite.modulate, hero.base_art_modulate, role + " must not recolour approved costume")
		assert_lte(hero.hit_kick_offset.length(), 4.5, role + " hit displacement should stay small")
		# Lethal damage can occur on exactly the same frame as impact.
		# This must not carry over a transient zoom, rotation or robe tint.
		hero.scale = Vector2(1.16, 1.16)
		hero.art_sprite.rotation = 0.2
		hero.art_sprite.modulate = Color.RED
		hero._die()
		assert_false(hero.alive)
		assert_eq(hero.frame_state, "death")
		assert_eq(hero.scale, Vector2.ONE)
		assert_almost_eq(hero.art_sprite.rotation, 0.0, 0.001)
		assert_eq(hero.art_sprite.modulate, hero.base_art_modulate)
		assert_eq(hero.art_sprite.position, hero._art_rest_position())
		assert_eq(hero.hit_flash_time, 0.0)
		assert_eq(hero.art_sprite.texture, hero.sprite_frames.get_frame_texture("death", 0))


func test_d408_enemy_hit_feedback_remains_original() -> void:
	var enemy := _actor("skeleton", 1)
	enemy._play_hit_feedback(Vector2(-100.0, 0.0), "knight", true)
	assert_gt(enemy.scale.x, 1.10, "Enemy retains previously authored hit response")
	assert_eq(enemy.frame_state, "hit")
