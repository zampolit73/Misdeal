extends "res://scripts/dev/living_arenas_capture.gd"
## Reuse the native frame-time sampler with the two atlas variants in the same battle.
func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 2 or not args.has("--benchmark"):
		push_error("Usage: -- <absolute-output-directory> --benchmark")
		quit(1)
		return
	destination = args[0]
	DirAccess.make_dir_recursive_absolute(destination)
	root.size = Vector2i(1280,720)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 0
	var review := (load("res://scenes/dev/enemy_visual_review.tscn") as PackedScene).instantiate()
	root.add_child(review)
	for role in ["lantern_bearer","bone_warden","mute_magistrate"]:
		review._select_role(review.roles.find(role))
		for round_index in range(3):
			for polished in [false,true,true,false]:
				review._open_battle(polished)
				var match_scene: Control = review.battle
				start_battle(match_scene,true)
				while not match_scene.combat_live: await process_frame
				await measure(str(match_scene.encounter.encounter_id),"trio_abba",match_scene.battle_backdrop,true)
				metrics[-1].erase("enabled")
				metrics[-1]["polished"] = polished
				metrics[-1]["round"] = round_index
				review._close_battle()
				await process_frame
				await process_frame
	var result := FileAccess.open(destination.path_join("benchmark.json"),FileAccess.WRITE)
	result.store_string(JSON.stringify({"renderer":RenderingServer.get_video_adapter_name(),"metrics":metrics}, "\t")+"\n")
	result.close()
	print("ENEMY_BENCHMARK_PASS: ",metrics.size()," real combat samples")
	quit()
