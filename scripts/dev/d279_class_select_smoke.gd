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
	# D280: actual clean original tabletop, no old baked HUD/offer overlays.
	var backdrop := selection.get_node("WizardBackdrop") as TextureRect
	valid = valid and backdrop.texture != null
	if backdrop.texture != null:
		valid = valid and backdrop.texture.get_size() == Vector2(1280.0, 720.0)
	valid = valid and backdrop.get("webp_path") == "res://assets/pixel/class_select/d281_clean_table_hd.webp"
	valid = valid and selection.get_node("Logo").material is ShaderMaterial
	valid = valid and not selection.has_node("OldOfferObscurer")
	valid = valid and not selection.has_node("FateSpreadCover")
	valid = valid and not selection.has_node("TopHeaderPlate")
	valid = valid and not selection.has_node("TopRightCover")
	valid = valid and not selection.has_node("FateTitle")
	valid = valid and selection.has_node("TitleVeil") and selection.has_node("Logo")
	# D282 native chrome acceptance: restrained header/caption, readable footer
	# and a real active gold rim above the D278 illustrated card frame.
	var title_veil := selection.get_node("TitleVeil") as Panel
	var title_style := title_veil.get_theme_stylebox("panel") as StyleBoxFlat
	valid = valid and title_style.bg_color.a < 0.40
	valid = valid and title_style.border_width_top == 1
	valid = valid and selection.has_node("WizardCaption") and selection.has_node("FooterHintPlate")
	valid = valid and selection.get_node("Frame/WizardLine").position.y >= 100.0
	valid = valid and selection.get_node("Frame/WizardLine").position.y < 145.0
	valid = valid and selection.get_node("Frame/Title").position.y < 90.0
	var hint := selection.get_node("Frame/Rule") as Label
	valid = valid and hint.position.y >= 684.0 and hint.position.y + hint.size.y < 715.0
	valid = valid and hint.get_theme_font_size("font_size") >= 13
	valid = valid and confirm.has_node("GildedTopEdge") and confirm.has_node("PressedLowerEdge")
	valid = valid and selection.get_node("Frame") is Control
	for i in range(buttons.size()):
		var b: Button = buttons[i]
		var stats := b.get_node("Stats") as Label
		var unit: Resource = load(["res://resources/units/knight.tres", "res://resources/units/ranger.tres", "res://resources/units/mage.tres"][i]) as Resource
		valid = valid and b.size == Vector2(272.0, 338.0)
		valid = valid and b.has_node("Parchment") and b.has_node("IllustratedFrame")
		valid = valid and b.has_node("SelectionRim") and not (b.get_node("SelectionRim") as Panel).visible
		var overlay := b.get_node("IllustratedFrame") as TextureRect
		valid = valid and overlay.texture != null and overlay.mouse_filter == Control.MOUSE_FILTER_IGNORE
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
	buttons[2].pressed.emit()
	valid = valid and not (buttons[1].get_node("SelectionRim") as Panel).visible
	valid = valid and (buttons[2].get_node("SelectionRim") as Panel).visible
	valid = valid and selection.get("selected_role") == "mage"
	valid = valid and not bool(game_state.call("has_chosen_protagonist"))
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
	print("D282_CLASS_SELECT_PASS: native 1280x720 art, restrained title, lifted wizard caption, readable footer, brass CTA, gold selected rim and solo Mage")
	selection.queue_free()
	quit(0)
