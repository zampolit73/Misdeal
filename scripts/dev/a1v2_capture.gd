extends SceneTree
const P := preload("res://scripts/memory/memory_profile.gd")
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	P.shared=P.new()
	root.size=Vector2i(1280,720)
	var args := OS.get_cmdline_user_args()
	var out := args[0] if not args.is_empty() else "res://docs/qa/a1v2"
	DirAccess.make_dir_recursive_absolute(out)
	var state := root.get_node("RunState")
	for count in [0,7,24]:
		state.reset_run()
		state.choose_protagonist("knight")
		P.shared.unlocked.clear()
		for index in range(count):
			P.shared.unlocked.append("SG%02d"%(index+1))
		var table := load("res://scenes/table/table.tscn").instantiate() as Control
		root.add_child(table)
		await create_timer(1.8).timeout
		var offers: Array = state.current_offer_ids.duplicate()
		await snap(out,"table_%d"%count)
		var memory := table.get_node("MemoryTable")
		await RenderingServer.frame_post_draw
		var after := root.get_texture().get_image()
		memory.hide()
		await RenderingServer.frame_post_draw
		var before := root.get_texture().get_image()
		before.save_png(out.path_join("baseline_%d.png"%count))
		var differences := 0
		for y in range(720):
			for x in range(1280):
				if Rect2i(1090,70,190,55).has_point(Vector2i(x,y)) or Rect2i(310,140,14,105).has_point(Vector2i(x,y)) or Rect2i(950,140,14,105).has_point(Vector2i(x,y)):
					continue
				if before.get_pixel(x,y) != after.get_pixel(x,y):
					differences += 1
		assert(differences == 0, "Approved Table pixels changed outside apertures/control: " + str(differences))
		memory.show()
		memory.open_viewer()
		await create_timer(0.3).timeout
		await snap(out,"viewer_%d"%count)
		memory.viewer._select(P.catalog()[0])
		await snap(out,"selected_%d"%count)
		if count==24:
			memory.viewer._select(P.catalog()[12])
			await snap(out,"knight_variant3")
			assert(memory.viewer.group=="knight")
			memory.viewer._group("chronicle")
			memory.viewer._turn_page(1)
			memory.viewer._turn_page(1)
			assert(memory.viewer.fragments.has("SG12"))
			memory.viewer.fragments["SG12"].pressed.emit()
			await snap(out,"chronicle_last_page")
			memory.viewer._closure()
			await snap(out,"chronicle_complete")
			memory.viewer._full_closure()
			await snap(out,"full_realization")
		if count==0:
			memory.viewer._select(P.catalog()[11])
			assert(memory.viewer.title_label.text=="Нераскрытая память")
			assert(not memory.viewer.reader.text.contains("Канцлер"))
			assert(not memory.viewer.full_button.visible)
		var escape := InputEventKey.new()
		escape.keycode=KEY_ESCAPE
		escape.pressed=true
		Input.parse_input_event(escape)
		await process_frame
		assert(state.current_offer_ids==offers)
		table.queue_free()
		await process_frame
	print("A1V2_NATIVE_PASS: 0/7/24 production table/viewer, selection, ESC and offers")
	quit()
func snap(out: String, label: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out.path_join(label+".png"))
