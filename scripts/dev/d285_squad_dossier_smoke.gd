extends SceneTree

# D285 tests the real live Godot dossier, not the approved static mockup.
const SQUAD_SCENE := preload("res://scenes/table/squad_status.tscn")
const PORTRAITS := ["knight", "ranger", "mage"]

func _initialize() -> void:
	call_deferred("_verify")

func _verify() -> void:
	var state: Node = root.get_node_or_null("RunState")
	if state == null:
		state = (load("res://scripts/core/run_state.gd") as Script).new() as Node
		state.name = "RunState"
		root.add_child(state)
	state.call("reset_run")
	if not state.call("choose_protagonist", "knight"):
		_fail("cannot choose starting Knight")
		return
	var dossier := SQUAD_SCENE.instantiate() as Control
	if dossier == null:
		_fail("dossier scene invalid")
		return
	root.add_child(dossier)
	await process_frame
	for role in PORTRAITS:
		var btn := dossier.get_node_or_null("Frame/" + role.capitalize() + "Button") as Button
		if btn == null or btn.get_node_or_null("MiniPortrait") == null or btn.get_node_or_null("RoleStatus") == null:
			_fail("real portrait role card missing: " + role)
			return
		var pic := btn.get_node("MiniPortrait") as TextureRect
		if pic.texture == null or pic.texture.get_width() != 640:
			_fail("runtime class portrait failed: " + role)
			return
	var main_portrait := dossier.get_node("Frame/PortraitFrame/Portrait") as TextureRect
	var frame := dossier.get_node("Frame/PortraitFrame") as Panel
	if main_portrait.texture == null or frame.size.y < 440 or main_portrait.size.y < 420:
		_fail("variant 3 portrait dimensions are not tall")
		return
	var stats := dossier.get_node("Frame/Stats") as RichTextLabel
	var role_caption := dossier.get_node("Frame/RoleDescription") as Label
	if dossier.get_node("Frame/HeroName").text != "Рыцарь" or stats.text.is_empty():
		_fail("Knight/real stats absent")
		return
	if not stats.text.contains("330") or role_caption.text.is_empty():
		_fail("effective solo Knight stats or description not sourced")
		return
	if (dossier.get_node("Frame/UpgradeCount") as Label).text != "0 / 3":
		_fail("progress count differs from real RunState")
		return
	var footer := dossier.get_node("Frame/CommonPanel") as Panel
	if not (footer.get_node("Summary0") as Label).text.contains("1 / 3"):
		_fail("real party count not shown in segmented footer")
		return
	for role in ["ranger", "mage"]:
		dossier.call("_select_role", role, false)
		if dossier.get_node("Frame/HeroName").text.is_empty():
			_fail("role switch cleared name: " + role)
			return
		if not (dossier.get_node("Frame/Specialization") as Label).text.contains("НЕ РАЗЫГРАНА"):
			_fail("unavailable companion fate not preserved: " + role)
			return
		if (dossier.get_node("Frame/RelicCount") as Label).text != "—":
			_fail("unavailable companions got false relics")
			return
	dossier.call("_select_role", "knight", false)
	if not (dossier.get_node("Frame/CommonPanel/Strength") as Label).text.contains("ОДИНОЧКА"):
		_fail("solo party modifiers not displayed")
		return
	var source := dossier.get_node("Frame/BuildList") as RichTextLabel
	if not source.text.contains("Пока без личного развития"):
		_fail("real empty upgrades message missing")
		return
	(dossier.get_node("Frame/CloseButton") as Button).emit_signal("pressed")
	await create_timer(0.28).timeout
	if is_instance_valid(dossier):
		_fail("close button did not dismiss squad dossier")
		return
	print("D285_SQUAD_DOSSIER_NATIVE_PASS: three portrait cards, role fates, true solo stats, live upgrade/relic states, segmented footer and close")
	quit(0)

func _fail(reason: String) -> void:
	push_error("D285_SQUAD_DOSSIER_FAIL: " + reason)
	quit(1)
