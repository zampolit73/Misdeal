extends SceneTree
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const PROFILE := preload("res://scripts/battle/living_arena_profile.gd")
const FLOOR := preload("res://scripts/battle/black_crossing_floor.gd")
var state: Node
var destination := ""
var metrics: Array[Dictionary] = []
var frame_manifest: Array[Dictionary] = []
var performance_only := false

func _initialize() -> void: call_deferred("run")

func fixture(id: String, party_size: int = 3, crowd: bool = false) -> Control:
	state.reset_run()
	state.choose_protagonist("knight")
	if party_size > 1: state.recruit_companion("ranger","Living QA")
	if party_size > 2: state.recruit_companion("mage","Living QA")
	state.active_card_id = id
	state.select_encounter("res://resources/encounters/"+id+".tres")
	seed(283)
	var battle := load("res://scenes/battle/battle.tscn").instantiate() as Control
	root.add_child(battle)
	if crowd:
		var data := load(battle.encounter.enemy_unit_paths[0]) as UnitData
		for i in range(5): battle._spawn_unit(data,1,Vector2(760+i*55,300+(i%2)*40),"QA crowd")
	return battle

func save_frame(label: String, lossless: bool = true) -> void:
	if performance_only: return
	await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	assert(image.get_size()==Vector2i(1280,720))
	assert(image.save_webp(destination.path_join(label+".webp"),not lossless,0.90)==OK)
	frame_manifest.append({"frame":label,"native_size":"1280x720"})

func measure(id: String, scenario: String, visual: TextureRect, enabled: bool) -> void:
	visual.set_living_enabled(enabled)
	# Exclude shader warm-up and the monitor's previous screenshot-encoding sample.
	await create_timer(1.1).timeout
	var times: Array[float] = []
	var cpu: Array[float] = []
	var prior := Time.get_ticks_usec()
	var start := prior
	while Time.get_ticks_usec()-start < 1500000 or times.size()<160:
		await RenderingServer.frame_post_draw
		await process_frame
		var now := Time.get_ticks_usec()
		times.append(float(now-prior)/1000.0)
		cpu.append(Performance.get_monitor(Performance.TIME_PROCESS)*1000.0)
		prior = now
	times.sort()
	cpu.sort()
	metrics.append({"arena":id,"scenario":scenario,"enabled":enabled,"samples":times.size(),"frame_median_ms":times[times.size()/2],"frame_p95_ms":times[int(times.size()*0.95)],"process_median_ms":cpu[cpu.size()/2],"objects":Performance.get_monitor(Performance.OBJECT_COUNT),"nodes":Performance.get_monitor(Performance.OBJECT_NODE_COUNT),"memory_bytes":Performance.get_monitor(Performance.MEMORY_STATIC),"video_memory_bytes":Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)})

func run() -> void:
	var args := OS.get_cmdline_user_args()
	assert(args.size()>=1)
	destination = args[0]
	performance_only = args.has("--perf-only")
	DirAccess.make_dir_recursive_absolute(destination)
	DirAccess.copy_absolute("res://scripts/dev/living_arenas_gallery.html",destination.path_join("index.html"))
	var hash_source := ProjectSettings.globalize_path("res://docs/qa/living_arenas/source_hashes.json")
	if hash_source.simplify_path()!=destination.path_join("source_hashes.json").simplify_path():
		DirAccess.copy_absolute(hash_source,destination.path_join("source_hashes.json"))
	root.size=Vector2i(1280,720)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 0
	state=root.get_node("RunState")
	var ids: Array = [args[1]] if args.size()>1 and args[1]!="--perf-only" else PROFILE.PILOTS
	for id: String in ids:
		var bare := BACKDROP.new()
		bare.size=Vector2(1280,720)
		bare.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
		root.add_child(bare)
		bare.set_arena_id(id)
		await measure(id,"empty",bare,false)
		await save_frame(id+"_before")
		await measure(id,"empty",bare,true)
		bare.set_living_paused(true)
		bare.living_material.set_shader_parameter("elapsed",0.0)
		await save_frame(id+"_after")
		# Real Godot shader frames at 12 samples/s, fixed timeline for comparison.
		for i in range(96):
			bare.living_material.set_shader_parameter("elapsed",float(i)/12.0)
			await save_frame(id+"_motion_%03d"%i)
		bare.queue_free()
		await process_frame
		var battle := fixture(id)
		await create_timer(0.35).timeout
		battle.battle_backdrop.set_living_enabled(false)
		await save_frame(id+"_prep_before")
		battle.battle_backdrop.set_living_enabled(true)
		await save_frame(id+"_prep_after")
		root.size=Vector2i(960,540)
		await process_frame
		await RenderingServer.frame_post_draw
		if not performance_only:
			assert(root.get_texture().get_image().save_webp(destination.path_join(id+"_resized.webp"),false)==OK)
		root.size=Vector2i(1280,720)
		await process_frame
		battle.fight_button.pressed.emit()
		while not battle.combat_live: await process_frame
		for frame in range(8):
			await create_timer(0.7).timeout
			if id=="black_crossing":
				for unit: BattleUnit in battle.units:
					if unit.alive: assert(FLOOR.contains_unit_origin(unit.position,unit.body_radius))
			await save_frame(id+"_combat_%02d"%frame)
		paused=true
		var clock_before: float = battle.battle_backdrop.living_elapsed
		await create_timer(0.1,true).timeout
		assert(battle.battle_backdrop.living_elapsed==clock_before)
		paused=false
		await create_timer(0.1).timeout
		# Slow software render/readback may let the real battle finish mid-capture.
		if battle.battle_finished:
			assert(battle.battle_backdrop.living_elapsed==clock_before)
		else:
			assert(battle.battle_backdrop.living_elapsed>clock_before)
		battle._finish_battle(true)
		clock_before=battle.battle_backdrop.living_elapsed
		await create_timer(0.15).timeout
		assert(battle.battle_backdrop.living_elapsed==clock_before)
		await save_frame(id+"_finished")
		battle.queue_free()
		await process_frame
		for scenario in ["solo","trio","crowd"]:
			for enabled in [false,true]:
				battle=fixture(id,1 if scenario=="solo" else 3,scenario=="crowd")
				battle.battle_backdrop.set_living_enabled(enabled)
				battle.fight_button.pressed.emit()
				while not battle.combat_live: await process_frame
				await measure(id,scenario,battle.battle_backdrop,enabled)
				battle.queue_free()
				await process_frame
		# Scene reopening after all textures are warm; record post-free plateaus.
		for repeat in range(5):
			battle=fixture(id)
			await process_frame
			battle.queue_free()
			for i in range(4): await process_frame
			metrics.append({"arena":id,"scenario":"reopen","iteration":repeat,"nodes":Performance.get_monitor(Performance.OBJECT_NODE_COUNT),"objects":Performance.get_monitor(Performance.OBJECT_COUNT),"memory_bytes":Performance.get_monitor(Performance.MEMORY_STATIC)})
		print("LIVING_NATIVE_ARENA_PASS: ",id)
	var file := FileAccess.open(destination.path_join("metrics.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"renderer":RenderingServer.get_video_adapter_name(),"frames":frame_manifest,"metrics":metrics},"\t"))
	file.close()
	print("LIVING_NATIVE_PASS: ",ids.size()," arenas; ",frame_manifest.size()," frames")
	quit()
