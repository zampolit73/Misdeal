extends GutTest

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
