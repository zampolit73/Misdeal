extends SceneTree

# D306: native regression for the ACTUAL Grave Bell side challenge with
# user-approved D303 painted Battle panels, no mock screen or fake objective.
const SCENE_PATH := "res://scenes/battle/battle.tscn"
const ENCOUNTER_PATH := "res://resources/encounters/grave_bell.tres"
const DS3_PASS := preload("res://scripts/battle/battle_ds3_pass.gd")


func _initialize() -> void:
	call_deferred("_check")


func _check() -> void:
	var state := root.get_node_or_null("RunState")
	if state == null:
		state = (load("res://scripts/core/run_state.gd") as Script).new() as Node
		state.name = "RunState"
		root.add_child(state)
	state.call("reset_run")
	if not state.call("choose_protagonist", "knight"):
		_fail("cannot choose protagonist")
		return
	state.call("select_encounter", ENCOUNTER_PATH)
	var scene := (load(SCENE_PATH) as PackedScene).instantiate() as Control
	if scene == null:
		_fail("cannot instantiate real Battle")
		return
	root.add_child(scene)
	await process_frame
	if scene.get("side_objective_id") != "bell_first":
		_fail("Grave Bell did not use actual bell-first objective")
		return
	var panel := scene.get_node("SideObjectivePanel") as Panel
	var objective := scene.get_node("SideObjectivePanel/ObjectiveLabel") as Label
	if not panel.visible or not objective.text.contains("Звонарь должен пасть первым"):
		_fail("authentic Wizard challenge is not present")
		return
	if panel.position != Vector2(22, 571) or panel.size != Vector2(216, 133):
		_fail("D312 preparation challenge displaced from left command margin")
		return
	var artwork := panel.get_node_or_null("D307WizardArt") as Control
	if artwork != null:
		var source_texture := artwork.get("art_texture") as Texture2D
		if source_texture == null or artwork.mouse_filter != Control.MOUSE_FILTER_IGNORE:
			_fail("D311 painted Wizard canvas missing art or intercepts controls")
			return
		if artwork.size != Vector2(258, 138) or artwork.position != Vector2(-16, -14):
			_fail("D311 Wizard asset is no longer rendered in the fixed compact bounds")
			return
		if artwork.custom_minimum_size != Vector2.ZERO or not artwork.has_method("_draw"):
			_fail("D311 compact art uses a texture-dependent minimum or has no explicit draw")
			return
		if not (panel.get_theme_stylebox("panel") is StyleBoxEmpty):
			_fail("D311 old plaque still displays behind approved image")
			return
		var art_bounds := Rect2(panel.position + artwork.position, artwork.size)
		if not source_texture.resource_path.contains("battle_ds3_d311/wizard_variant3_game.webp"):
			_fail("D311 active skin is not the approved third Wizard module")
			return
		if art_bounds.position.y < 0 or art_bounds.end.y > 720 or art_bounds.end.x > 1280:
			_fail("D311 wizard frame crops outside the 1280x720 preparation viewport")
			return
		var heading := panel.get_node("D307WizardHeading") as Label
		var body := panel.get_node("D307WizardBody") as Label
		if heading.text != "УСЛОВИЕ ВОЛШЕБНИКА" or not body.text.contains("Звонарь должен пасть"):
			_fail("D307 illustrated label wells do not reflect authentic live objective")
			return
		if heading.get_theme_font_size("font_size") < 11 or body.get_theme_font_size("font_size") < 11 or objective.visible:
			_fail("D307 original text overlaps painted module or derived copy is too small")
			return
		var reward := panel.get_node_or_null("D312WizardReward") as Label
		if reward == null or not reward.visible or reward.text != "+15 золота":
			_fail("D312 dynamic reward must be visible only in the lower inset")
			return
		if body.text.contains("+15 золота") or body.position != Vector2(56, 44) or reward.position != Vector2(65, 80):
			_fail("D312 Wizard rule/reward overlap or insets were lost")
			return
		if heading.position != Vector2(63, 9) or heading.size != Vector2(172, 29):
			_fail("D312 heading no longer centered in approved art")
			return
		# D313: pixel-bound checks complement state logic. The reward must be
		# INSIDE the black inset, not on the lower golden filigree.
		var rule_rect := Rect2(body.position, body.size)
		var reward_rect := Rect2(reward.position, reward.size)
		if rule_rect.intersects(reward_rect) or reward_rect.end.y > 96.0:
			_fail("D313 bonus overlaps the rule or engraved lower border: rule=" + str(rule_rect) + " reward=" + str(reward_rect))
			return
		if body.size.y < 32.0 or reward.size.y < 15.0:
			_fail("D313 rule or gold reward is too small for live readable text")
			return
		if reward.get_theme_color("font_color").r >= heading.get_theme_color("font_color").r:
			_fail("D312 reward hierarchy is too prominent")
			return
		if heading.z_index <= artwork.z_index or body.z_index <= artwork.z_index:
			_fail("D307 painted frame overlays live Wizard text")
			return
	else:
		# Safe readable fallback if the binary art has not imported yet.
		var style := panel.get_theme_stylebox("panel") as StyleBoxFlat
		if style == null or style.bg_color.a < 0.9 or style.border_width_top < 2:
			_fail("D306 fallback Wizard plaque missing")
			return
		if objective.z_index <= (panel.get_node("DS3EngravedRelief") as CanvasItem).z_index:
			_fail("D306 fallback text hidden by engraved overlay")
			return
		if objective.get_theme_font_size("font_size") < 13:
			_fail("D306 fallback Wizard text too small")
			return
	var original_text := objective.text
	var fight := scene.get_node("FightButton") as Button
	if fight.pressed.get_connections().is_empty():
		_fail("real Fight action lost its handler")
		return
	fight.pressed.emit()
	await process_frame
	if not scene.get("combat_started"):
		_fail("actual Fight button did not start combat")
		return
	if not panel.visible or panel.position != Vector2(98, 165):
		_fail("D306 optional challenge did not move to safe combat corner")
		return
	if artwork != null:
		var combat_art_bounds := Rect2(panel.position + artwork.position, artwork.size)
		if combat_art_bounds.position.y < 100 or combat_art_bounds.end.y > 320 or combat_art_bounds.end.x > 345:
			_fail("D311 Wizard art obscures units or returns to full source resolution in combat")
			return
	if objective.text != original_text:
		_fail("D306 movement mutated the reward rule")
		return
	if artwork != null:
		var reward_after := panel.get_node("D312WizardReward") as Label
		var body_after := panel.get_node("D307WizardBody") as Label
		if not reward_after.visible or reward_after.text != "+15 золота" or body_after.text.contains("+15 золота"):
			_fail("D312 combat no longer separates authentic gold reward from rule")
			return
		# A failed side wager must update both visible derived Labels.
		scene.call("_fail_side_objective", "УСЛОВИЕ ПРОВАЛЕНО • первым пал не звонарь")
		if (panel.get_node("D307WizardHeading") as Label).text != "УСЛОВИЕ ПРОВАЛЕНО":
			_fail("D307 failure title not reflected in painted module")
			return
		if not (panel.get_node("D307WizardBody") as Label).text.contains("первым пал не звонарь"):
			_fail("D307 failure explanation not reflected")
			return
		if reward_after.visible:
			_fail("D312 failed condition should not show a reward")
			return
	if (scene.get_node("BottomHudPanel") as Panel).visible or (scene.get_node("FightHudPanel") as Panel).visible:
		_fail("preparation-only panels remain over combat")
		return
	if (scene.get_node("FightButton") as Button).visible:
		_fail("Fight button remains visible after combat start")
		return
	print("D306_WIZARD_OBJECTIVE_NATIVE_PASS: D312 Wizard text hierarchy, dynamic reward, failure and Fight transition")
	scene.queue_free()
	await process_frame
	quit(0)


func _fail(message: String) -> void:
	push_error("D306_WIZARD_OBJECTIVE_FAIL: " + message)
	quit(1)
