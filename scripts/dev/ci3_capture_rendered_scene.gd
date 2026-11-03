extends SceneTree

# CI3: native Godot 4.7.2 framebuffer capture, NOT a constructed mockup.
# Requires an actual display (Xvfb in GitHub Actions), never --headless.
const SIZE := Vector2i(1280, 720)
const SCENES := {
	"class-select": "res://scenes/class_select/class_select.tscn",
	"table": "res://scenes/table/table.tscn",
	"fate-spread-four": "res://scenes/table/fate_spread_overlay.tscn",
	"fate-spread-eight": "res://scenes/table/fate_spread_overlay.tscn",
	"firing-square-break": "res://scenes/battle/battle.tscn",
	"firing-square-crossfire": "res://scenes/battle/battle.tscn",
	"wizard-prep": "res://scenes/dev/d308_wizard_panel_preview.tscn",
	"card-gallery": "res://scenes/dev/d315_card_ds3_gallery.tscn",
	"reward-upgrade": "res://scenes/reward/reward.tscn",
	"qa-hub": "res://scenes/dev/qa_hub.tscn",
}

func _initialize() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2:
		_fail("expected: -- <scene-key> <absolute-output-png>")
		return
	var scene_key := args[0]
	var output_path := args[1]
	if not SCENES.has(scene_key) or not output_path.begins_with("/"):
		_fail("unsupported key or non-absolute output path: " + scene_key)
		return

	root.size = SIZE
	if scene_key == "table" or scene_key == "class-select" or scene_key == "reward-upgrade" or scene_key.begins_with("fate-spread-") or scene_key.begins_with("firing-square-"):
		# --script does not always inject project autoloads in all execution
		# modes; register the real RunState the same way native smoke tests do.
		var state := root.get_node_or_null("RunState")
		if state == null:
			state = (load("res://scripts/core/run_state.gd") as Script).new() as Node
			state.name = "RunState"
			root.add_child(state)
		state.call("reset_run")
		if not state.call("choose_protagonist", "knight"):
			_fail("RunState failed to prepare a Knight")
			return
		if scene_key.begins_with("firing-square-"):
			# Exact RunState selection for a live D383 Battle, trio for visuals.
			state.call("recruit_companion", "ranger", "D383 native capture")
			state.call("recruit_companion", "mage", "D383 native capture")
			state.set("active_card_id", "firing_square")
			state.call("select_encounter", "res://resources/encounters/firing_square.tres")
			state.set("combat_formation_by_card", {"firing_square": 0})
		if scene_key.begins_with("fate-spread-"):
			# Render the actual production overlay in the exact four-card
			# screenshot state and in a later chapter. No fabricated UI scene.
			var completed_ids: Array[String] = [
				"moon_seal", "whispering_well", "bone_patrol", "bone_tax",
			]
			var discarded_ids: Array[String] = [
				"graveyard_ambush", "gallows_volley", "last_camp", "rattling_bridge",
			]
			if scene_key == "fate-spread-eight":
				completed_ids.append_array([
				"ash_rest", "grave_crossfire", "gravedigger_shop", "crypt_guard",
				])
				discarded_ids.append_array([
				"lost_purse", "echo_crypt", "black_altar", "curse_forge",
				])
			state.set("cards_resolved", completed_ids.size())
			state.set("resolved_card_ids", completed_ids)
			state.set("rejected_card_ids", discarded_ids)

	var packed := load(SCENES[scene_key]) as PackedScene
	if packed == null:
		_fail("scene resource not loadable: " + SCENES[scene_key])
		return
	var scene := packed.instantiate() as Control
	if scene == null:
		_fail("scene is not a Control: " + scene_key)
		return
	root.add_child(scene)
	await process_frame

	if scene_key == "class-select":
		# Show a meaningful live selected state, not three idle skeleton cards.
		scene.call("_select_role", "knight")
	elif scene_key == "table":
		var offer := scene.get_node_or_null("Cards/BonePatrolCard") as Button
		if offer == null or not offer.visible:
			_fail("live Table produced no visible first card")
			return
	elif scene_key.begins_with("fate-spread-"):
		var corrected := scene.get_node_or_null("Frame/SpreadArea/CorrectedSixthRoman") as Label
		var mask := scene.get_node_or_null("Frame/HeaderMask") as ColorRect
		if corrected == null or mask == null or mask.color.a < 0.999:
			_fail("Fate Spread correction label/fully opaque header missing")
			return
		if corrected.visible != (scene_key == "fate-spread-four"):
			_fail("sixth Roman must be corrected only while VI is a future card")
			return
	elif scene_key.begins_with("firing-square-"):
		# Real enemy death signals trigger the production intermission.
		# Capture the warning BEFORE wave II, then the true opposite-flank
		# enemy positions AFTER the intro; no mock sprites are constructed.
		scene.set("combat_started", true)
		scene.set("combat_live", true)
		var first_foes: Array[BattleUnit] = []
		for unit in scene.get("units"):
			if unit.team == 1 and unit.alive:
				first_foes.append(unit)
		if first_foes.size() != 3:
			_fail("Firing Square wave I must have three real enemies")
			return
		for foe in first_foes:
			foe.take_damage(foe.max_hp + 10000.0)
		if not scene.get("wave_intermission"):
			_fail("real Firing Square did not enter one intermission")
			return
		if scene_key == "firing-square-break":
			if not scene.get_node("PlacementHint").text.contains("СЛЕВА"):
				_fail("no left-rear telegraph on Firing Square intermission")
				return
			# D384: actually reposition two living heroes in the legal floor
			# strip and capture the SAME production intermission HUD; the
			# forecast must now name the corresponding nearest first targets.
			var survivors: Array[BattleUnit] = []
			for actor in scene.get("units"):
				if actor.team == 0 and actor.alive:
					survivors.append(actor)
			if survivors.size() < 2:
				_fail("D384 needs two surviving heroes for a real reposition capture")
				return
			survivors[0].position = Vector2(170.0, 355.0)
			survivors[1].position = Vector2(340.0, 355.0)
			if survivors.size() >= 3:
				survivors[2].position = Vector2(495.0, 355.0)
			scene.call("_refresh_wave_briefing")
			var description := scene.get_node("OrderDescription") as Label
			if not description.text.contains("ПЕРВЫЕ ЦЕЛИ: слева"):
				_fail("D384 missing future-target readout after hero reposition")
				return
			var left_expected := "слева — %s" % survivors[0].display_name
			var right_expected := "справа — %s" % survivors[survivors.size() - 1].display_name
			if not description.text.contains(left_expected) or not description.text.contains(right_expected):
				_fail("D384 readout does not match living heroes on left/right")
				return
		else:
			await scene._start_second_wave()
			var live_foes: Array[BattleUnit] = []
			for unit in scene.get("units"):
				if unit.team == 1 and unit.alive:
					live_foes.append(unit)
			if live_foes.size() != 2 or live_foes[0].position.x >= 145.0 or live_foes[1].position.x <= 530.0:
				_fail("real left/right archers not on opposite flanks")
				return
			# Freeze the true post-intro positions for deterministic art QA.
			scene.set("combat_live", false)
			for unit in scene.get("units"):
				if unit.alive:
					unit.combat_started = false
	elif scene_key == "wizard-prep":
		var plaque := scene.get_node_or_null("SideObjectivePanel/D307WizardArt") as Control
		if plaque == null:
			_fail("approved D311 Wizard artwork did not load")
			return
	elif scene_key == "card-gallery":
		if scene.get_node_or_null("CardScroll/CardGrid") == null:
			_fail("card DS3 gallery did not populate")
			return
	elif scene_key == "reward-upgrade":
		# Reproduce the second *actual* F5 screenshot: Knight + two Rangers.
		# Render the real scene and exact approved cards; no reward is granted.
		scene.get_node("Title").text = "РАЗВИТИЕ ОТРЯДА"
		scene.get_node("Summary").text = "Двое пережили этот этап. Выберите, чью судьбу переписать сильнее."
		scene.get_node("Hint").text = "Этап 1/3. Награда предлагает только тех, кто уже в отряде."
		var ids := ["knight_iron_oath", "ranger_arrowstorm", "ranger_beast_trail"]
		var buttons := ["BloodCoin", "IronWard", "TemperedSteel"]
		for index in range(ids.size()):
			var upgrade = root.get_node("RunState").call("get_hero_upgrade", ids[index])
			if upgrade == null:
				_fail("missing Knight reward upgrade: " + ids[index])
				return
			var card := scene.get_node("Rewards/" + buttons[index]) as Button
			card.visible = true
			scene.call("_set_upgrade_card", index, ids[index], upgrade)
	elif scene_key == "qa-hub":
		if scene.get_node_or_null("Categories") == null or scene.get_node_or_null("DetailPanel/LaunchButton") == null:
			_fail("OPT4 QA Hub categories or scene launcher missing")
			return

	# Godot docs: wait until rendering has finished; captures from _ready()
	# can be blank. Allow live cards, layout, GPU textures and tweens to settle.
	await create_timer(1.0).timeout
	await RenderingServer.frame_post_draw
	var frame := root.get_texture().get_image()
	if frame == null or frame.is_empty() or frame.get_size() != SIZE:
		_fail("empty or wrong-size framebuffer: " + scene_key)
		return

	# Catch blank framebuffer/Xvfb failures. These are deliberately lenient
	# for Misdeal's legitimately dark, shadow-heavy palette.
	var lit_pixels := 0
	var colors := {}
	for y in range(18, SIZE.y, 29):
		for x in range(18, SIZE.x, 29):
			var c := frame.get_pixel(x, y)
			if c.r + c.g + c.b > 0.12:
				lit_pixels += 1
			var bucket := Vector3i(int(c.r * 16.0), int(c.g * 16.0), int(c.b * 16.0))
			colors[bucket] = true
	if lit_pixels < 15 or colors.size() < 6:
		_fail("probably blank frame: " + scene_key + " lit=" + str(lit_pixels) + " colors=" + str(colors.size()))
		return

	var status := frame.save_png(output_path)
	if status != OK:
		_fail("PNG save error " + str(status) + ": " + output_path)
		return
	print("CI3_CAPTURE_PASS: " + scene_key + " 1280x720 lit=" + str(lit_pixels) + " colors=" + str(colors.size()) + " path=" + output_path)
	scene.queue_free()
	await process_frame
	quit(0)

func _fail(reason: String) -> void:
	push_error("CI3_CAPTURE_FAIL: " + reason)
	quit(1)
