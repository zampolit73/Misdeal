extends SceneTree

# CI3: native Godot 4.7.2 framebuffer capture, NOT a constructed mockup.
# Requires an actual display (Xvfb in GitHub Actions), never --headless.
const SIZE := Vector2i(1280, 720)
const SCENES := {
	"class-select": "res://scenes/class_select/class_select.tscn",
	"table": "res://scenes/table/table.tscn",
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
	if scene_key == "table" or scene_key == "class-select" or scene_key == "reward-upgrade":
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
		# Deterministic three-Knight preview of the reported F5 reward layout.
		# The scene and actual card data are used; no rewards are granted.
		scene.get_node("Title").text = "РАЗВИТИЕ ОТРЯДА"
		scene.get_node("Summary").text = "Вы пока один. Выберите, какой версией себя станете дальше."
		scene.get_node("Hint").text = "Этап 1/3. Все доступные пути принадлежат вашему герою."
		var ids := ["knight_iron_oath", "knight_executioner", "knight_cleaver"]
		var buttons := ["BloodCoin", "IronWard", "TemperedSteel"]
		for index in range(ids.size()):
			var upgrade := root.get_node("RunState").call("get_hero_upgrade", ids[index])
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
