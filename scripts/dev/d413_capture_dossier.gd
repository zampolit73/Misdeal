extends SceneTree

# Capture the production Table's actual dossier, not a composited mockup.
func _initialize() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].is_absolute_path():
		push_error("D413 requires an absolute output directory")
		quit(1)
		return
	var destination := args[0]
	DirAccess.make_dir_recursive_absolute(destination)
	root.size = Vector2i(1280,720)
	var fixture := load("res://scenes/dev/d413_squad_dossier_preview.tscn").instantiate() as Control
	root.add_child(fixture)
	var table := fixture.get_child(0)
	var deadline := Time.get_ticks_msec() + 5000
	while table.get("squad_status") == null and Time.get_ticks_msec() < deadline:
		await process_frame
	var dossier := table.get("squad_status") as Control
	if dossier == null:
		push_error("D413 Table did not open its real dossier")
		quit(1)
		return
	await create_timer(0.3).timeout
	for role in ["knight", "ranger", "mage"]:
		dossier.call("_select_role", role, false)
		await RenderingServer.frame_post_draw
		if root.get_texture().get_image().save_png(destination.path_join(role + ".png")) != OK:
			push_error("D413 image save failed")
			quit(1)
			return
	print("D413_DOSSIER_CAPTURE_PASS: 3 actual dossier screens")
	quit()
