extends SceneTree

# D285 tests the real live Godot dossier, not the approved static mockup.
# Load dynamically AFTER creating /root/RunState in script-mode test.
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
	# D288 opt-in style contract: DS3 is usable but does not globally override DS2.
	var kit := load("res://scripts/ui/misdeal_ds3.gd") as Script
	var reference_plate := kit.make_plate(Color(0.1, 0.2, 0.3, 0.9), Color(0.8, 0.6, 0.4, 1), 2, 7) as StyleBoxFlat
	if reference_plate == null or reference_plate.border_width_left != 2 or reference_plate.shadow_size != 7 or reference_plate.content_margin_left != 5.0:
		_fail("D288 native DS3 style helper contract invalid")
		return
	for surface in ["table", "dossier", "battle"]:
		var surface_plate := kit.make_surface(surface) as StyleBoxFlat
		if surface_plate == null or surface_plate.border_width_left < 1:
			_fail("D288 DS3 surface material missing: " + surface)
			return
	var test_button := Button.new()
	kit.apply_action(test_button, true)
	if test_button.get_theme_stylebox("normal") == null or test_button.get_theme_stylebox("disabled") == null:
		_fail("D288 DS3 button states missing")
		return
	test_button.free()
	var packed := load("res://scenes/table/squad_status.tscn") as PackedScene
	var dossier := packed.instantiate() as Control
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
	if main_portrait.texture == null or frame.size.y < 440 or main_portrait.size.y < 420 or main_portrait.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_COVERED or not frame.clip_contents:
		_fail("variant 3 portrait dimensions are not tall")
		return
	var stats := dossier.get_node("Frame/Stats") as RichTextLabel
	var role_caption := dossier.get_node("Frame/RoleDescription") as Label
	if stats.get_theme_font_size("normal_font_size") < 14 or stats.size.y < 210:
		_fail("D286 screenshot legibility regression: small or cramped stats")
		return
	# D287 visual-art contract: isolated ornamental images and interactive
	# real-state widgets. Full poster with baked statistics must never be used.
	for art_name in ["PortraitRubyCrest"]:
		var art := dossier.get_node_or_null("Frame/" + art_name) as TextureRect
		if art == null or art.texture == null or art.texture.get_size() != Vector2(103, 103):
			_fail("D287 approved hero crest absent or not decoded")
			return
	var relief := dossier.get_node_or_null("Frame/BuildPanel/DevelopmentStoneRelief") as TextureRect
	var filigree := dossier.get_node_or_null("Frame/BuildPanel/DevelopmentFiligree0") as TextureRect
	if relief == null or relief.texture == null or relief.texture.get_size() != Vector2(138, 91) or filigree == null or filigree.texture == null or filigree.texture.get_size() != Vector2(53, 53):
		_fail("D287 relief/filigree are missing or wrong size")
		return
	for idx in 3:
		var gem := dossier.get_node_or_null("Frame/UpgradeGem%d" % (idx + 1)) as Panel
		var slot := dossier.get_node_or_null("Frame/RelicSlot%d" % (idx + 1)) as Panel
		if gem == null or slot == null or slot.get_node_or_null("Medallion") == null:
			_fail("D287 decorated progression/relic slot hierarchy missing")
			return
	if not (dossier.get_node("Frame/UpgradeCount") as Label).text == "0 / 3":
		_fail("D287 decorative progression falsely unlocked a perk")
		return
	var relic_slot := dossier.get_node("Frame/RelicSlot1") as Panel
	if relic_slot.size.y < 70 or dossier.get_node_or_null("Frame/HeroInfoRule") == null:
		_fail("D286 screenshot panel hierarchy regression")
		return
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
