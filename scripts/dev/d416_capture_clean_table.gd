extends SceneTree

func _initialize() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].is_absolute_path():
		push_error("D416 requires an absolute output directory")
		quit(1)
		return
	DirAccess.make_dir_recursive_absolute(args[0])
	root.size = Vector2i(1280, 720)
	var state := root.get_node("RunState")
	state.call("reset_run")
	state.call("choose_protagonist", "knight")
	var offers: Array[String] = ["lost_purse", "whispering_well"]
	state.set("current_offer_ids", offers)
	var table := load("res://scenes/table/table.tscn").instantiate() as Control
	root.add_child(table)
	current_scene = table
	await create_timer(1.0).timeout
	await _save(args[0], "two_offers")
	var cards := table.get_node("Cards") as Control
	cards.visible = false
	await _save(args[0], "exposed_table")
	cards.visible = true
	var button := table.get_node("Cards/BonePatrolCard") as Button
	button.mouse_entered.emit()
	await create_timer(0.2).timeout
	await _save(args[0], "hover")
	button.mouse_exited.emit()
	button.pressed.emit()
	await create_timer(0.22).timeout
	await _save(args[0], "choice_motion")
	await create_timer(1.2).timeout
	if current_scene == table or not state.call("has_active_card"):
		push_error("D416 choice did not navigate to the actual selected card")
		quit(1)
		return
	await _save(args[0], "selected_event")
	print("D416_CLEAN_TABLE_CAPTURE_PASS: exposed table, two real offers, hover, choice motion and actual event route")
	quit()

func _save(destination: String, filename: String) -> void:
	await RenderingServer.frame_post_draw
	if root.get_texture().get_image().save_png(destination.path_join(filename + ".png")) != OK:
		push_error("D416 image save failed")
		quit(1)
