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
	var encounter_id := PROFILE.encounter_for(id)
	state.active_card_id = encounter_id
	if id == "warden": state.cards_resolved = 12
	state.select_encounter("res://resources/encounters/"+encounter_id+".tres")
	seed(283)
	var battle := load("res://scenes/battle/battle.tscn").instantiate() as Control
	root.add_child(battle)
	if battle.warden_intro != null:
		battle.warden_intro.skip()
	if crowd:
		var data := load(battle.encounter.enemy_unit_paths[0]) as UnitData
		for i in range(5): battle._spawn_unit(data,1,Vector2(760+i*55,300+(i%2)*40),"QA crowd")
	return battle

func start_battle(battle: Control, v2: bool) -> void:
	if v2:
		battle.combat_plan_controller.start_planned_battle()
	else:
		battle.fight_button.pressed.emit()

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
	var v2 := args.has("--v2")
	var v3 := args.has("--v3")
	var visual_only := args.has("--visual-only")
	DirAccess.make_dir_recursive_absolute(destination)
	if not v2 and not v3:
		DirAccess.copy_absolute("res://scripts/dev/living_arenas_gallery.html",destination.path_join("index.html"))
	var hash_source := ProjectSettings.globalize_path("res://docs/qa/"+("living_arenas_v2" if v2 else "living_arenas")+"/source_hashes.json")
	if not v3 and hash_source.simplify_path()!=destination.path_join("source_hashes.json").simplify_path():
		DirAccess.copy_absolute(hash_source,destination.path_join("source_hashes.json"))
	root.size=Vector2i(1280,720)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 0
	state=root.get_node("RunState")
	var ids: Array = PROFILE.V2_ARENAS if v2 else PROFILE.PILOTS
	if v3:
		ids = PROFILE.V3_ARENAS
		for batch in range(PROFILE.V3_BATCHES.size()):
			if args.has("--batch-"+str(batch+1)):
				ids = PROFILE.V3_BATCHES[batch]
	for arg in args.slice(1):
		if not arg.begins_with("--"):
			ids = [arg]
			break
	for id: String in ids:
		var bare := BACKDROP.new()
		bare.size=Vector2(1280,720)
		bare.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
		root.add_child(bare)
		bare.set_arena_id(PROFILE.arena_for(id), PROFILE.encounter_for(id))
		bare.set_living_enabled(false)
		if not visual_only: await measure(id,"empty",bare,false)
		await save_frame(id+"_before")
		bare.set_living_enabled(true)
		if not visual_only: await measure(id,"empty",bare,true)
		bare.set_living_paused(true)
		bare.living_material.set_shader_parameter("elapsed",0.0)
		await save_frame(id+"_after")
		# Sample eight seconds of motion with a fixed timeline.
		var frame_count := 12 if v3 else (36 if v2 else 96)
		for i in range(frame_count):
			bare.living_material.set_shader_parameter("elapsed", float(i)*8.0/frame_count)
			await save_frame(id+"_motion_%03d"%i)
		if v2 and id == "warden":
			await save_frame("warden_phase_i")
			bare.living_material.set_shader_parameter("phase_strength", 1.0)
			await save_frame("warden_phase_ii")
		bare.queue_free()
		await process_frame
		var party := 1 if id=="warden" else 3
		if v3 and id in ["crypt", "bone_swarm", "black_lantern_road"]: party = 2
		if v3 and id in ["gallows", "grave_crossfire", "bone_ritual"]: party = 1
		var battle := fixture(id,party)
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
		start_battle(battle,v2 or v3)
		while not battle.combat_live: await process_frame
		for frame in range(3 if v3 else 8):
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
		if v2 or v3:
			var deadline := Time.get_ticks_msec()+65000
			var phase_captured := false
			var wave_captured := false
			while not battle.battle_finished and Time.get_ticks_msec()<deadline:
				if id == "warden" and not phase_captured and battle.battle_backdrop.living_phase_mix > 0.9:
					await save_frame("warden_live_phase_ii")
					phase_captured = true
				if v3 and battle.wave_intermission:
					await save_frame(id+"_intermission")
					battle.combat_plan_controller.start_planned_battle()
				if v3 and id == "iron_wall" and not wave_captured and battle.battle_wave_index == 2:
					await create_timer(0.55).timeout
					await save_frame(id+"_wave_two")
					wave_captured = true
				await process_frame
			assert(battle.battle_finished and battle.result_label.visible, id+" reached the real result screen")
			metrics.append({"arena":id,"scenario":"result","won":state.last_battle_won,
				"party_size":party,"wave":battle.battle_wave_index,
				"boss_phase_two":battle.boss_reinforcements_spawned,"phase_mix":battle.battle_backdrop.living_phase_mix})
		else:
			battle._finish_battle(true)
		clock_before=battle.battle_backdrop.living_elapsed
		await create_timer(0.15).timeout
		assert(battle.battle_backdrop.living_elapsed==clock_before)
		await save_frame(id+"_finished")
		battle.queue_free()
		await process_frame
		if visual_only:
			print("LIVING_NATIVE_ARENA_PASS: ",id)
			continue
		for scenario in (["trio"] if v3 else ["solo","trio","crowd"]):
			for enabled in ([false,true,true,false] if v3 else [false,true]):
				var measure_party := party if v3 else (1 if scenario=="solo" else 3)
				battle=fixture(id,measure_party,scenario=="crowd")
				battle.battle_backdrop.set_living_enabled(enabled)
				start_battle(battle,v2 or v3)
				while not battle.combat_live: await process_frame
				await measure(id,"battle_abba" if v3 else scenario,battle.battle_backdrop,enabled)
				metrics[-1]["party_size"] = measure_party
				battle.queue_free()
				await process_frame
		# Scene reopening after all textures are warm; record post-free plateaus.
		for repeat in range(5):
			battle=fixture(id)
			await process_frame
			battle.queue_free()
			for i in range(4): await process_frame
			metrics.append({"arena":id,"scenario":"reopen","iteration":repeat,"nodes":Performance.get_monitor(Performance.OBJECT_NODE_COUNT),"objects":Performance.get_monitor(Performance.OBJECT_COUNT),"memory_bytes":Performance.get_monitor(Performance.MEMORY_STATIC)})
		if v3:
			assert(metrics[-1].nodes == metrics[-5].nodes, id+" leaked nodes")
			assert(metrics[-1].objects == metrics[-5].objects, id+" leaked objects")
		print("LIVING_NATIVE_ARENA_PASS: ",id)
	var file := FileAccess.open(destination.path_join("metrics.json"),FileAccess.WRITE)
	file.store_string(JSON.stringify({"renderer":RenderingServer.get_video_adapter_name(),"frames":frame_manifest,"metrics":metrics},"\t"))
	file.close()
	print("LIVING_NATIVE_PASS: ",ids.size()," arenas; ",frame_manifest.size()," frames")
	quit()
