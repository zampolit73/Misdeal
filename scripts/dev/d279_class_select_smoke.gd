extends SceneTree

# D279: production ClassSelect first selects, then explicitly commits. Test
# actual Godot scene/RunState rather than deriving results from mockup text.
func _initialize() -> void:
	call_deferred("_verify")


func _verify() -> void:
	var game_state: Node = root.get_node_or_null("RunState")
	if game_state == null:
		var state_script := load("res://scripts/core/run_state.gd") as Script
		game_state = state_script.new() as Node
		game_state.name = "RunState"
		root.add_child(game_state)
	game_state.call("reset_run")
	var packed := load("res://scenes/class_select/class_select.tscn") as PackedScene
	if packed == null:
		push_error("D279_CLASS_SELECT_FAIL: scene missing")
		quit(1)
		return
	var selection := packed.instantiate() as Control
	root.add_child(selection)
	var buttons: Array[Button] = [
		selection.get_node("Frame/Cards/Knight") as Button,
		selection.get_node("Frame/Cards/Ranger") as Button,
		selection.get_node("Frame/Cards/Mage") as Button
	]
	var confirm := selection.get_node("Frame/ConfirmButton") as Button
	var valid := confirm.disabled and not bool(game_state.call("has_chosen_protagonist"))
	var backdrop := selection.get_node("WizardBackdrop") as TextureRect
	valid = valid and backdrop.texture != null
	if backdrop.texture != null:
		valid = valid and backdrop.texture.get_size() == Vector2(1280, 720)
		valid = valid and backdrop.texture.resource_path == "res://assets/pixel/class_select/visual_v2/plate.webp"
	var title := selection.get_node("Frame/Title") as Label
	var wizard := selection.get_node("Frame/WizardLine") as Label
	var cards := selection.get_node("Frame/Cards") as Control
	valid = valid and title.get_rect().end.y <= wizard.position.y
	valid = valid and wizard.get_rect().end.y <= cards.position.y
	valid = valid and cards.get_rect().end.y < confirm.position.y
	for i in range(buttons.size()):
		var b: Button = buttons[i]
		var portrait := b.get_node("Portrait") as TextureRect
		var expected_path := "res://assets/pixel/ui/squad_dossier_d413/%s_thumb.webp" % ["knight", "ranger", "mage"][i]
		valid = valid and portrait.get("webp_path") == expected_path
		valid = valid and portrait.texture != null and portrait.texture.get_size() == Vector2(640, 480)
		valid = valid and portrait.texture_filter == CanvasItem.TEXTURE_FILTER_LINEAR
		if portrait.texture != null:
			var source := Image.new()
			source.load_webp_from_buffer(FileAccess.get_file_as_bytes(expected_path))
			valid = valid and portrait.texture.get_image().get_data() == source.get_data()
		valid = valid and b.has_node("ChosenSeal") and not b.get_node("ChosenSeal").visible
		var stats := b.get_node("Stats") as Label
		var unit: Resource = load(["res://resources/units/knight.tres", "res://resources/units/ranger.tres", "res://resources/units/mage.tres"][i]) as Resource
		valid = valid and b.custom_minimum_size == Vector2(282, 308)
		valid = valid and b.has_node("SelectionRim") and not (b.get_node("SelectionRim") as Panel).visible
		valid = valid and Rect2(Vector2.ZERO, b.custom_minimum_size).encloses(portrait.get_rect())
		valid = valid and stats.text.contains(str(roundi(float(unit.get("max_hp")))))
		valid = valid and stats.text.contains(str(roundi(float(unit.get("damage")))))
		valid = valid and not stats.visible
		valid = valid and (b.get_node("Description") as Label).visible

	buttons[0].mouse_entered.emit()
	valid = valid and (buttons[0].get_node("SelectionRim") as Panel).visible
	valid = valid and (buttons[0].get_node("Stats") as Label).visible
	valid = valid and not (buttons[0].get_node("Description") as Label).visible
	valid = valid and confirm.disabled and not bool(game_state.call("has_chosen_protagonist"))
	buttons[0].mouse_exited.emit()
	valid = valid and not (buttons[0].get_node("SelectionRim") as Panel).visible
	valid = valid and not (buttons[0].get_node("Stats") as Label).visible
	buttons[1].pressed.emit()
	valid = valid and (buttons[1].get_node("SelectionRim") as Panel).visible
	valid = valid and selection.get("selected_role") == "ranger"
	valid = valid and not confirm.disabled
	valid = valid and (buttons[1].get_node("Stats") as Label).visible
	valid = valid and not bool(game_state.call("has_chosen_protagonist"))
	# Switching to a different choice must still be reversible.
	buttons[1].mouse_exited.emit()
	valid = valid and buttons[1].get_node("ChosenSeal").visible
	buttons[2].pressed.emit()
	valid = valid and not (buttons[1].get_node("SelectionRim") as Panel).visible
	valid = valid and (buttons[2].get_node("SelectionRim") as Panel).visible
	valid = valid and selection.get("selected_role") == "mage"
	valid = valid and buttons[2].get_node("ChosenSeal").visible and not buttons[1].get_node("ChosenSeal").visible
	valid = valid and not bool(game_state.call("has_chosen_protagonist"))
	var arrow := InputEventKey.new()
	arrow.pressed = true
	arrow.keycode = KEY_LEFT
	selection.call("_input", arrow)
	valid = valid and selection.get("selected_role") == "ranger" and not bool(game_state.call("has_chosen_protagonist"))
	arrow.keycode = KEY_RIGHT
	selection.call("_input", arrow)
	valid = valid and selection.get("selected_role") == "mage" and buttons[2].get_node("ChosenSeal").visible
	# ONLY explicit confirmation mutates the run and retains a SOLO hero.
	confirm.pressed.emit()
	valid = valid and bool(game_state.call("has_chosen_protagonist"))
	valid = valid and str(game_state.get("protagonist_role")) == "mage"
	var starters: Array = game_state.get("party_roles")
	valid = valid and starters.size() == 1 and str(starters[0]) == "mage"
	valid = valid and confirm.disabled
	# Existing game state API remains the only commit path.
	if not valid:
		push_error("D279_CLASS_SELECT_FAIL: class table, hover, live stats or two-step selection")
		selection.queue_free()
		quit(1)
		return
	print("D282_CLASS_SELECT_PASS: native V2 plate, original portraits, live stats, selected seal and solo Mage")
	selection.queue_free()
	quit(0)
