extends SceneTree
var destination := ""
var number := 0
var times: Array[int] = []
var modal_samples: Array[Dictionary] = []
var images: Array[Image] = []

func _initialize() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].is_absolute_path():
		quit(1)
		return
	destination = args[0]
	DirAccess.make_dir_recursive_absolute(destination)
	root.size = Vector2i(1280, 720)
	var state := root.get_node("RunState")
	state.call("reset_run")
	state.call("choose_protagonist", "knight")
	var scene := load("res://scenes/table/table.tscn").instantiate() as Control
	root.add_child(scene)
	current_scene = scene
	await create_timer(1.0).timeout
	var before: Array = state.get("current_offer_ids").duplicate()
	await _record(0.15)
	var card := scene.get_node("Cards/BonePatrolCard") as Button
	card.mouse_entered.emit()
	await _record(0.30)
	card.mouse_exited.emit()
	await _record(0.25)
	var squad := scene.get_node("SquadButton") as Button
	squad.button_down.emit()
	await _record(0.10)
	squad.button_up.emit()
	squad.pressed.emit()
	await _record(0.40)
	scene.get("squad_status").call("_close")
	await _record(0.25)
	scene.get_node("FateSpreadButton").pressed.emit()
	await _record(0.45)
	scene.get("fate_spread_overlay").call("close")
	await _record(0.25)
	scene.call("_on_offer_inspect_requested", card)
	await _record(0.40)
	scene.get("card_lore_inspect").call("close")
	await _record(0.15)
	var saw_mid_entrance := false
	for sample in modal_samples:
		if sample.frame >= 16 and sample.frame < 24 and sample.alpha > 0.05 and sample.alpha < 0.95:
			saw_mid_entrance = true
	if not saw_mid_entrance:
		push_error("D417 entrance skipped its visible intermediate frames")
		quit(1)
		return
	if state.get("current_offer_ids") != before or state.call("has_active_card"):
		push_error("D417 feedback mutated card choice")
		quit(1)
		return
	for index in range(images.size()):
		if images[index].save_png(destination.path_join("%03d.png" % index)) != OK:
			push_error("D417 frame save failed")
			quit(1)
			return
	images.clear()
	var samples_file := FileAccess.open(destination.path_join("modal-samples.json"), FileAccess.WRITE)
	samples_file.store_string(JSON.stringify(modal_samples))
	samples_file.close()
	var timing_file := FileAccess.open(destination.path_join("timings.json"), FileAccess.WRITE)
	timing_file.store_string(JSON.stringify(times))
	timing_file.close()
	print("D417_UI_MOTION_CAPTURE_PASS: native hover/press/three popup recordings; offers unchanged")
	quit()

func _record(seconds: float) -> void:
	for i in range(roundi(seconds * 20.0)):
		await create_timer(0.05).timeout
		await RenderingServer.frame_post_draw
		times.append(Time.get_ticks_msec())
		var dossier = current_scene.get("squad_status")
		if is_instance_valid(dossier):
			var frame := dossier.get_node("Frame") as Control
			modal_samples.append({"frame": number, "alpha": frame.modulate.a, "y": frame.position.y})
		# Buffer first; PNG encoding during playback would stall short tweens.
		images.append(root.get_texture().get_image())
		number += 1
