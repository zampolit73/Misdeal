extends GutTest

const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")

func test_approved_heroes_face_new_left_target_before_first_real_attack() -> void:
	for role in ["knight", "ranger", "mage"]:
		var arena := Node2D.new()
		add_child(arena)
		var hero := UNIT_SCENE.instantiate() as BattleUnit
		hero.visual_role = role
		hero.position = Vector2(600,350)
		arena.add_child(hero)
		var enemy := UNIT_SCENE.instantiate() as BattleUnit
		enemy.team = 1
		enemy.position = Vector2(540,350)
		arena.add_child(enemy)
		hero.set_process(false)
		enemy.set_process(false)
		hero.combat_started = true
		hero.minimum_range = 0
		hero.attack_range = 100
		hero.attack_cooldown = 0
		hero._set_facing_left(false)
		var facing: Array[bool] = []
		hero.diagnostic_attack.connect(func(actor: BattleUnit, _target: BattleUnit) -> void: facing.append(actor.art_sprite.flip_h))
		hero._process(1.0/60.0)
		assert_eq(facing, [true], "First attack must immediately face the left opponent")
		assert_eq(hero.rim_sprite.texture, hero.art_sprite.texture)
		arena.free()

func test_real_battle_units_use_exact_approved_75_frames_without_old_overrides() -> void:
	for role in ["knight", "ranger", "mage"]:
		var actor := UNIT_SCENE.instantiate() as BattleUnit
		actor.visual_role = role
		add_child_autofree(actor)
		actor.set_process(false)
		var frames := actor.sprite_frames
		assert_true(LIBRARY.is_approved_hero_frames(role, frames))
		assert_true(LIBRARY.is_live_c3_hero_frames(role, frames))
		var atlas := Image.new()
		atlas.load_webp_from_buffer(Marshalls.base64_to_raw(FileAccess.get_file_as_string(LIBRARY.D412_APPROVED_DIR + role + ".webp.b64")))
		for row in range(5):
			var state: String = ["idle", "walk", "attack", "hit", "death"][row]
			assert_eq(frames.get_frame_count(state), [4,6,6,3,6][row])
			for col in range(frames.get_frame_count(state)):
				assert_eq(hash(frames.get_frame_texture(state,col).get_image().get_data()), hash(atlas.get_region(Rect2i(col*96,row*96,96,96)).get_data()))
		var soles := actor.art_sprite.position.y + (90.0 - 48.0) * actor.base_sprite_scale.y
		assert_almost_eq(soles, actor.FLOOR_CONTACT_Y, 0.55)
		assert_eq(actor.C3_WALK_PIXELS_PER_FRAME, 12.0)
		var archived := LIBRARY.get_frames(role, false)
		assert_false(LIBRARY.is_approved_hero_frames(role, archived))
		assert_eq(LIBRARY.get_frames(role), frames, "Archive inspection must not replace live approved frames")

func test_three_complete_atlases_have_75_distinct_padded_poses_and_clear_spares() -> void:
	for role in ["knight", "ranger", "mage"]:
		var img := Image.new()
		assert_eq(img.load_webp_from_buffer(Marshalls.base64_to_raw(FileAccess.get_file_as_string("res://assets/pixel/units/hero_c3_d412_polish/%s.webp.b64" % role))), OK)
		assert_eq(img.get_size(), Vector2i(576, 480))
		var hashes := {}
		for row in range(5):
			for col in range(6):
				var cell := img.get_region(Rect2i(col * 96, row * 96, 96, 96))
				var used := cell.get_used_rect()
				if col >= [4, 6, 6, 3, 6][row]:
					assert_eq(used.size, Vector2i.ZERO)
					continue
				assert_gt(used.size.y, 0)
				assert_gte(used.position.x, 2)
				assert_gte(used.position.y, 2)
				assert_lte(used.end.x, 94)
				assert_lte(used.end.y, 91)
				var digest := hash(cell.get_data())
				assert_false(hashes.has(digest), role + " repeated cel")
				hashes[digest] = true
		assert_eq(hashes.size(), 25)

func test_polish_keeps_every_accepted_pose_alpha_pixel_and_source_layout() -> void:
	for role in ["knight", "ranger", "mage"]:
		var original := Image.new()
		var polished := Image.new()
		original.load_webp_from_buffer(Marshalls.base64_to_raw(FileAccess.get_file_as_string("res://assets/pixel/units/hero_c3_d412/%s.webp.b64" % role)))
		polished.load_webp_from_buffer(Marshalls.base64_to_raw(FileAccess.get_file_as_string("res://assets/pixel/units/hero_c3_d412_polish/%s.webp.b64" % role)))
		var before := original.get_data()
		var after := polished.get_data()
		var alpha_before := PackedByteArray()
		var alpha_after := PackedByteArray()
		for i in range(3, before.size(), 4):
			alpha_before.append(before[i])
			alpha_after.append(after[i])
		assert_eq(alpha_before, alpha_after, role + " approved poses and feet must not change")
		assert_ne(hash(before), hash(after), "Polish must actually recover source colour detail")
