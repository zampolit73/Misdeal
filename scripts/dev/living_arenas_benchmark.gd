extends "res://scripts/dev/living_arenas_capture.gd"
## Isolate the noisy solo-pier measurement with balanced A/B/B/A ordering.
func run() -> void:
	destination = OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(destination)
	root.size = Vector2i(1280,720)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 0
	state = root.get_node("RunState")
	for repeat in range(3):
		for enabled in [false,true,true,false]:
			var battle := fixture("black_crossing",1)
			battle.battle_backdrop.set_living_enabled(enabled)
			battle.fight_button.pressed.emit()
			while not battle.combat_live: await process_frame
			await measure("black_crossing","solo_abba",battle.battle_backdrop,enabled)
			metrics[-1]["round"] = repeat
			battle.queue_free()
			await process_frame
	var file := FileAccess.open(destination.path_join("abba.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"renderer":RenderingServer.get_video_adapter_name(),"metrics":metrics},"\t"))
	print("LIVING_ABBA_PASS: ",metrics.size()," measurements")
	quit()
