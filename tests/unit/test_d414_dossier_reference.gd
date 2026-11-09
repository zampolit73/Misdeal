extends GutTest

func after_each() -> void:
	RunState.reset_run()

func test_real_relic_art_tracks_selected_role_without_stale_icons_or_inventory_changes() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.add_artifact("dead_mans_shield")
	var inventory := RunState.artifact_ids.duplicate()
	var before := RunState.get_effective_hero_stats("knight")
	var scene := load("res://scenes/table/squad_status.tscn").instantiate() as Control
	add_child_autofree(scene)
	var slot := scene.get_node("Frame/RelicSlot1") as Panel
	var art := slot.get_node("D414ArtifactImage") as TextureRect
	assert_true(art.visible)
	assert_eq(scene.get_node("Frame/RelicCount").text, "1 / 3")
	assert_not_null(art.texture)
	assert_false(slot.get_node("Symbol").visible)
	assert_eq(slot.tooltip_text, "ЩИТ МЕРТВЕЦА\n" + RunState.get_artifact("dead_mans_shield").description)
	assert_true(scene.get_node("Frame/Stats").text.contains("heart.svg"))
	assert_true(scene.get_node("Frame/Specialization").has_theme_stylebox_override("normal"))
	scene.call("_select_role", "mage", false)
	assert_false(art.visible)
	assert_eq(scene.get_node("Frame/RelicCount").text, "—")
	assert_null(art.texture)
	assert_true(slot.get_node("Symbol").visible)
	for role in ["knight", "ranger", "mage"]:
		assert_eq(scene.get_node("Frame/" + role.capitalize() + "Button/D414SelectedBar").visible, role == "mage")
	scene.call("_select_role", "knight", false)
	assert_true(art.visible)
	assert_eq(RunState.artifact_ids, inventory)
	assert_eq(RunState.get_effective_hero_stats("knight"), before)
