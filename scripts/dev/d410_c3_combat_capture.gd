extends SceneTree

# Native framebuffer evidence from the production Battle and existing F6 scenes.
# Run WITHOUT --headless: --script ... -- <absolute-output-directory>
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
var destination := ""

func _initialize() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 1 or args.size() > 2 or not args[0].is_absolute_path():
		push_error("D410 requires an absolute output directory")
		quit(1)
		return
	destination = args[0]
	DirAccess.make_dir_recursive_absolute(destination)
	root.size = Vector2i(1280, 720)
	# Export exact active source textures as well as the framebuffer, for
	# inspection of facing/props without interpreting low-resolution captures.
	for role in ["knight", "ranger", "mage"]:
		var frames: SpriteFrames = LIBRARY.get_frames(role)
		var sheet := Image.create(576, 480, false, Image.FORMAT_RGBA8)
		var row := 0
		for state in ["idle", "walk", "attack", "hit", "death"]:
			for col in range(frames.get_frame_count(state)):
				var img := frames.get_frame_texture(state, col).get_image()
				sheet.blit_rect(img, Rect2i(0, 0, 96, 96), Vector2i(col * 96, row * 96))
			row += 1
		sheet.save_png(destination.path_join(role + "_active.png"))
	var gallery := load("res://scenes/dev/d398_c3_hero_animation_preview.tscn").instantiate() as Control
	root.add_child(gallery)
	gallery.call("_play_manual", "walk")
	await create_timer(0.35).timeout
	await _save("gallery_walk")
	root.remove_child(gallery)
	gallery.free()
	var walking := load("res://scenes/dev/d404_c3_walk_motion_preview.tscn").instantiate() as Control
	root.add_child(walking)
	await create_timer(0.65).timeout
	await _save("stride_right")
	await create_timer(2.0).timeout
	await _save("stride_left")
	root.remove_child(walking)
	walking.free()
	var state := root.get_node("RunState")
	state.call("reset_run")
	state.call("choose_protagonist", "knight")
	state.call("recruit_companion", "ranger", "D410 QA")
	state.call("recruit_companion", "mage", "D410 QA")
	state.set("active_card_id", "bone_patrol")
	state.call("select_encounter", "res://resources/encounters/bone_patrol.tres")
	seed(410)
	var battle := load("res://scenes/battle/battle.tscn").instantiate() as Control
	root.add_child(battle)
	await create_timer(0.3).timeout
	if args.size() == 2 and args[1] == "left":
		for actor: BattleUnit in battle.get("units"):
			actor.position.x = 1280.0 - actor.position.x
			actor.disable_placement()
	for actor: BattleUnit in battle.get("units"):
		actor.set_process(false)
	await _save("battle_preparation")
	battle.call("_on_fight_pressed")
	while not battle.get("combat_live"):
		await process_frame
	# Freeze the first real acquisition frame. No extra manual facing call:
	# this exposes the pre-D410 one-frame reverse-facing error reproducibly.
	var observations: Array[Dictionary] = []
	for actor: BattleUnit in battle.get("units"):
		actor._process(1.0 / 60.0)
		if actor.team == 0:
			observations.append({"role": actor.visual_role, "flip_h": actor.art_sprite.flip_h,
				"target_left": actor.target.position.x < actor.position.x,
				"rim_matches": actor.rim_sprite.texture == actor.art_sprite.texture})
	await _save("battle_first_acquisition")
	var report := FileAccess.open(destination.path_join("first_acquisition.json"), FileAccess.WRITE)
	report.store_string(JSON.stringify(observations, "\t"))
	report.close()
	for actor: BattleUnit in battle.get("units"):
		actor.set_process(true)
	var elapsed := 0.0
	var next_capture := 0.0
	while elapsed < 14.0:
		await process_frame
		elapsed += root.get_process_delta_time()
		if elapsed >= next_capture:
			await _save("battle_%03d" % int(next_capture * 10))
			next_capture += 0.35
	print("D410_NATIVE_CAPTURE_PASS: " + destination)
	quit()

func _save(label: String) -> void:
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(destination.path_join(label + ".png"))
	if error != OK:
		push_error("D410 capture failed: " + label)
		quit(1)
