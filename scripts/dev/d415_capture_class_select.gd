extends SceneTree

# Native frames from the actual production scene; no compositing.
func _initialize() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].is_absolute_path():
		push_error("D415 requires an absolute output directory")
		quit(1)
		return
	DirAccess.make_dir_recursive_absolute(args[0])
	root.size = Vector2i(1280, 720)
	var state := root.get_node("RunState")
	state.call("reset_run")
	var screen := load("res://scenes/class_select/class_select.tscn").instantiate() as Control
	root.add_child(screen)
	current_scene = screen
	await create_timer(0.6).timeout
	await _save(args[0], "initial")
	for role in ["knight", "ranger", "mage"]:
		var button := screen.get_node("Frame/Cards/" + role.capitalize()) as Button
		button.pressed.emit()
		await process_frame
		await _save(args[0], role)
		if state.call("has_chosen_protagonist"):
			push_error("D415 preview committed the run before confirmation")
			quit(1)
			return
	(screen.get_node("Frame/ConfirmButton") as Button).pressed.emit()
	await create_timer(1.5).timeout
	if current_scene == null or current_scene.scene_file_path != "res://scenes/table/table.tscn" or state.get("party_roles") != ["mage"]:
		push_error("D415 confirmation did not reach the real Table with solo Mage")
		quit(1)
		return
	await _save(args[0], "confirmed_table")
	print("D415_CLASS_SELECT_CAPTURE_PASS: four native choice frames and confirmed solo Mage Table")
	quit()

func _save(destination: String, filename: String) -> void:
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png(destination.path_join(filename + ".png")) != OK:
		push_error("D415 image save failed")
		quit(1)
