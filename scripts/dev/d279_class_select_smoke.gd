extends SceneTree

# D279: production ClassSelect first selects, then explicitly commits. Test
# actual Godot scene/RunState rather than deriving results from mockup text.
func _initialize() -> void:
	call_deferred("_verify")


func _verify() -> void:
	RunState.reset_run()
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
	var valid := confirm.disabled and not RunState.has_chosen_protagonist()
	valid = valid and selection.get_node("WizardBackdrop").get("webp_path") == "res://assets/pixel/table/approved_variant_c/table_exact.webp"
	valid = valid and selection.get_node("Frame") is Control
	for i in range(buttons.size()):
		var b: Button = buttons[i]
		var stats := b.get_node("Stats") as Label
		var unit: Resource = load(RunState.HERO_UNIT_PATHS[RunState.HERO_ROLES[i]]) as Resource
		valid = valid and b.size == Vector2(272.0, 338.0)
		valid = valid and b.has_node("Parchment") and b.has_node("IllustratedFrame")
		var overlay := b.get_node("IllustratedFrame") as TextureRect
		valid = valid and overlay.texture != null and overlay.mouse_filter == Control.MOUSE_FILTER_IGNORE
		valid = valid and stats.text.contains(str(roundi(float(unit.get("max_hp")))))
		valid = valid and stats.text.contains(str(roundi(float(unit.get("damage")))))
		valid = valid and not stats.visible
		valid = valid and (b.get_node("Description") as Label).visible

	buttons[0].mouse_entered.emit()
	valid = valid and (buttons[0].get_node("Stats") as Label).visible
	valid = valid and not (buttons[0].get_node("Description") as Label).visible
	valid = valid and confirm.disabled and not RunState.has_chosen_protagonist()
	buttons[0].mouse_exited.emit()
	valid = valid and not (buttons[0].get_node("Stats") as Label).visible
	buttons[1].pressed.emit()
	valid = valid and selection.get("selected_role") == "ranger"
	valid = valid and not confirm.disabled
	valid = valid and (buttons[1].get_node("Stats") as Label).visible
	valid = valid and not RunState.has_chosen_protagonist()
	# Switching to a different choice must still be reversible.
	buttons[2].pressed.emit()
	valid = valid and selection.get("selected_role") == "mage"
	valid = valid and not RunState.has_chosen_protagonist()
	# Existing game state API remains the only commit path.
	if not valid:
		push_error("D279_CLASS_SELECT_FAIL: class table, hover, live stats or two-step selection")
		selection.queue_free()
		quit(1)
		return
	print("D279_CLASS_SELECT_PASS: actual table backdrop, 3 framed cards, source hero stats on hover, two-step choice without early RunState mutation")
	selection.queue_free()
	quit(0)
