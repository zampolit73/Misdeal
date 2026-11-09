extends GutTest

func after_each() -> void:
	RunState.reset_run()

func _snapshot() -> Dictionary:
	return {"gold": RunState.gold, "party": RunState.party_roles.duplicate(),
		"artifacts": RunState.artifact_ids.duplicate(), "upgrades": RunState.hero_upgrade_ids.duplicate(),
		"resolved": RunState.cards_resolved, "hp": RunState.party_hp_bonus,
		"knight": RunState.get_effective_hero_stats("knight"),
		"ranger": RunState.get_effective_hero_stats("ranger"),
		"mage": RunState.get_effective_hero_stats("mage")}

func _open() -> Control:
	var scene := load("res://scenes/table/squad_status.tscn").instantiate() as Control
	add_child_autofree(scene)
	return scene

func test_real_dossier_switching_preserves_stats_upgrades_relics_and_run() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.recruit_companion("ranger", "D413 QA")
	RunState.recruit_companion("mage", "D413 QA")
	for id in ["knight_executioner", "knight_iron_oath", "knight_cleaver", "ranger_longshot", "mage_glass_heart"]:
		assert_true(RunState.add_hero_upgrade(id))
	for id in ["dead_mans_shield", "cracked_focus", "blind_quiver", "broken_crown"]:
		assert_true(RunState.add_artifact(id))
	var before := _snapshot()
	var scene := _open()
	for role in ["knight", "ranger", "mage", "knight"]:
		scene.call("_select_role", role, false)
		assert_eq(scene.get("current_role"), role)
		var portrait := scene.get_node("Frame/PortraitFrame/Portrait") as TextureRect
		assert_eq(portrait.texture.get_size(), Vector2(640, 960))
		assert_true(str(portrait.get("webp_path")).contains("squad_dossier_d413/" + role))
		assert_eq(scene.get_node("Frame/UpgradeCount").text, "%d / 3" % RunState.get_role_upgrade_count(role))
		assert_eq(scene.get_node("Frame/RelicCount").text, str(RunState.get_artifacts_for_role(role).size()))
		assert_eq(_snapshot(), before, "Viewing/switching must never modify the game")
	assert_true(scene.get_node("Frame/Stats").text.contains("[table=3]"))
	assert_true((scene.get_node("Frame") as Panel).get_theme_stylebox("panel") is StyleBoxTexture)
	assert_eq(scene.get_node("Frame/PortraitFrame/D413PortraitBorder").mouse_filter, Control.MOUSE_FILTER_IGNORE)

func test_unavailable_and_lost_companions_remain_unavailable_and_tab_closes() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	var scene := _open()
	scene.call("_select_role", "mage", false)
	assert_eq(scene.get_node("Frame/UpgradeCount").text, "—")
	assert_eq(scene.get_node("Frame/RelicCount").text, "—")
	assert_lt(scene.get_node("Frame/PortraitFrame/Portrait").modulate.a, 0.5)
	RunState.lose_companion("mage", "D413 QA")
	scene.call("_select_role", "mage", false)
	assert_eq(scene.get_node("Frame/Specialization").text, "ПОТЕРЯН")
	var key := InputEventKey.new()
	key.keycode = KEY_TAB
	key.pressed = true
	scene.get_node("Frame/KnightButton").grab_focus()
	assert_true(scene.is_processing_input(), "TAB is handled before GUI focus traversal")
	scene.call("_input", key)
	await get_tree().create_timer(0.25).timeout
	assert_false(is_instance_valid(scene), "Advertised TAB close works")
