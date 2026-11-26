extends GutTest

const DIALOG := preload("res://scripts/ui/system_dialog.gd")
var choices: Array[bool] = []


func test_new_game_layout_focus_and_exact_action_binding() -> void:
	for reset_memory in [false, true]:
		choices.clear()
		var parent := Control.new()
		add_child_autofree(parent)
		parent.size = Vector2(1280, 720)
		var source := Button.new()
		parent.add_child(source)
		source.grab_focus()
		var dialog := DIALOG.new()
		parent.add_child(dialog)
		dialog.present_new_game(func(reset: bool): choices.append(reset))
		var panel: Panel = dialog.get_node("Panel")
		assert_eq(panel.size, Vector2(620, 454))
		assert_eq(panel.position, Vector2(330, 133))
		var cancel: Button = panel.get_node("CancelButton")
		assert_eq(get_viewport().gui_get_focus_owner(), cancel)
		assert_eq(cancel.get_node(cancel.focus_neighbor_bottom), panel.get_node("NextRunButton"))
		assert_eq(cancel.get_node(cancel.focus_neighbor_top), panel.get_node("ResetButton"))
		for name in ["NextRunButton", "ResetButton", "CancelButton"]:
			var button: Button = panel.get_node(name)
			assert_true(panel.get_global_rect().encloses(button.get_global_rect()))
			assert_true(button.get_theme_stylebox("normal") is StyleBoxTexture)
			assert_true(button.get_theme_font("font").get_string_size(button.text, HORIZONTAL_ALIGNMENT_LEFT, -1, button.get_theme_font_size("font_size")).x <= button.size.x - 36)
		var button: Button = panel.get_node("ResetButton" if reset_memory else "NextRunButton")
		button.pressed.emit()
		button.pressed.emit()
		assert_eq(choices, [reset_memory])
		assert_false(dialog.visible)
		assert_eq(get_viewport().gui_get_focus_owner(), source)
		await get_tree().process_frame


func test_return_cancel_and_confirm_are_distinct() -> void:
	choices.clear()
	var parent := Control.new()
	add_child_autofree(parent)
	parent.size = Vector2(1280, 720)
	var dialog := DIALOG.new()
	parent.add_child(dialog)
	dialog.present_return_to_menu(func(): choices.append(true))
	assert_eq(get_viewport().gui_get_focus_owner(), dialog.get_node("Panel/CancelButton"))
	dialog.get_node("Panel/CancelButton").pressed.emit()
	assert_eq(choices.size(), 0)
	await get_tree().process_frame
	dialog = DIALOG.new()
	parent.add_child(dialog)
	dialog.present_return_to_menu(func(): choices.append(true))
	dialog.get_node("Panel/ReturnButton").pressed.emit()
	assert_eq(choices, [true])
