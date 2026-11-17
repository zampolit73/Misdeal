extends SceneTree
const PILOT := "res://scenes/dev/combat_planning_pilot.tscn"
const PRESETS := preload("res://scripts/battle/planning/battle_plan_presets.gd")
var output := ""
var comparisons: Array[Dictionary]=[]
func _initialize() -> void: call_deferred("run")
func frame() -> void:
	await process_frame
	await RenderingServer.frame_post_draw

func capture(name: String) -> void:
	RenderingServer.render_loop_enabled=true
	await frame()
	root.get_texture().get_image().save_png(output+"/"+name+".png")

func simulate(pilot: Control, party_index: int, preset: String, planned: bool) -> Dictionary:
	pilot.party_choice.select(party_index)
	pilot.mode_choice.select(1 if planned else 0)
	pilot.open_battle()
	pilot.set_process(false)
	await process_frame
	PRESETS.apply(pilot.plans,preset)
	if planned: pilot.ui.refresh()
	var battle: Control=pilot.battle
	battle.set_process(false)
	for unit in battle.units: unit.set_process(false)
	var initial: Array=[]
	for unit in battle.units: initial.append([unit.team,unit.visual_role,unit.position.x,unit.position.y,unit.hp,unit.damage,unit.attack_interval])
	if planned: pilot.start_planned_battle()
	else: pilot.start_legacy_battle()
	for executor in pilot.executors.values(): assert(executor.clock==0 and executor.index==-1,"No preparation/intro clock")
	while not battle.combat_live: await process_frame
	var samples: Array=[]
	var wave_break_seen := false
	RenderingServer.render_loop_enabled=false
	for step in range(5400):
		var delta := 1.0/60.0
		battle._process(delta)
		for unit in battle.units: unit._process(delta)
		if battle.wave_intermission:
			pilot._process(0)
			assert(pilot.executors.is_empty() and pilot.ui.editor.visible)
			wave_break_seen=true
			var preserved_hp: Array=[]
			for unit in battle.units:
				if unit.team==0: preserved_hp.append(unit.hp)
			PRESETS.apply(pilot.plans,"assault")
			pilot.start_planned_battle()
			for unit in battle.units: unit.set_process(false)
			for executor in pilot.executors.values(): assert(executor.clock==0)
			while not battle.combat_live: await process_frame
			var n := 0
			for unit in battle.units:
				if unit.team==0:
					assert(unit.hp==preserved_hp[n],"Replanning must not restore HP")
					n+=1
		if step%120==0:
			var sample: Dictionary={"time":battle.combat_elapsed,"heroes":[]}
			for unit in battle.units:
				if unit.team==0: sample.heroes.append({"role":unit.visual_role,"x":unit.position.x,"y":unit.position.y,"hp":unit.hp,"target":unit.target.display_name if is_instance_valid(unit.target) else "—"})
			samples.append(sample)
		if step==240 and party_index==6 and planned:
			pilot.ui.update_live(0)
			await capture("live_"+battle.encounter.encounter_id+"_"+preset)
			RenderingServer.render_loop_enabled=false
		if battle.battle_finished: break
		await process_frame
	assert(battle.battle_finished,"The fixture must end naturally within 90 simulated seconds")
	var result: Dictionary={"party":party_index,"mode":"planning" if planned else "legacy","preset":preset,"seed":pilot.run_seed,"won":root.get_node("RunState").last_battle_won,"time":battle.combat_elapsed,"initial":initial,"samples":samples,"heroes":[],"journal":{}}
	result.wave_break_seen=wave_break_seen
	for unit in battle.units:
		if unit.team==0: result.heroes.append({"role":unit.visual_role,"hp":unit.hp,"kills":int(pilot.legacy_kills.get(unit.visual_role,0))})
	pilot._show_report()
	for role in pilot.executors: result.journal[role]=pilot.executors[role].journal.duplicate(true)
	if party_index==6 and planned: await capture("report_"+battle.encounter.encounter_id+"_"+preset)
	return result
func run() -> void:
	output=OS.get_cmdline_user_args()[0]
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	DirAccess.make_dir_recursive_absolute(output)
	change_scene_to_file(PILOT)
	await frame()
	await frame()
	var pilot: Control=current_scene
	assert(pilot.setup!=null)
	root.get_texture().get_image().save_png(output+"/setup.png")
	pilot.open_battle()
	await frame()
	await frame()
	assert(pilot.battle.encounter.encounter_id=="grave_bell")
	pilot.plans.knight.resize_orders(3)
	pilot.ui.refresh()
	pilot.arm_target()
	var enemy: BattleUnit=pilot.battle.units[-1]
	var motion := InputEventMouseMotion.new()
	motion.position=enemy.global_position+Vector2(0,-24)
	Input.parse_input_event(motion)
	await frame()
	var click := InputEventMouseButton.new()
	click.button_index=MOUSE_BUTTON_LEFT
	click.pressed=true
	click.position=motion.position
	Input.parse_input_event(click)
	await frame()
	assert(not pilot.picking_target and pilot.plans.knight.orders[0].target.get_ref()==enemy,"Actual arena click assigns existing enemy")
	pilot.ui.hero_choice.select(1)
	pilot.ui.hero_choice.item_selected.emit(1)
	pilot.ui.hero_choice.select(0)
	pilot.ui.hero_choice.item_selected.emit(0)
	assert(pilot.plans.knight.orders.size()==3 and pilot.plans.knight.orders[0].target.get_ref()==enemy)
	root.get_texture().get_image().save_png(output+"/editor.png")
	# Real wall-clock/engine-driven observation before controlled fixed-step comparisons.
	pilot.plans.knight.orders[0].condition="time"
	pilot.plans.knight.orders[0].limit=2
	pilot.plans.knight.orders[1].tactic="defense"
	pilot.plans.knight.orders[1].condition="time"
	pilot.plans.knight.orders[1].limit=2
	pilot.ui.refresh()
	pilot.start_planned_battle()
	await create_timer(0.15).timeout
	assert(pilot.executors.knight.clock==0,"Real intro does not run plan timers")
	while not pilot.battle.combat_live: await process_frame
	await create_timer(0.20).timeout
	var frozen_clock: float=pilot.executors.knight.clock
	var positions: Array=[]
	for unit in pilot.battle.units: positions.append(unit.position)
	paused=true
	await create_timer(0.12,true).timeout
	assert(pilot.executors.knight.clock==frozen_clock)
	for i in range(pilot.battle.units.size()): assert(pilot.battle.units[i].position==positions[i])
	paused=false
	var frozen_order: String=pilot.executors.knight.orders[0].tactic
	pilot.ui.tactic.select(1)
	pilot.ui.tactic.item_selected.emit(1)
	assert(pilot.executors.knight.orders[0].tactic==frozen_order,"Combat editor is locked")
	await create_timer(2.0).timeout
	assert(pilot.executors.knight.index==1,"Real engine clock advances the first stage")
	await capture("real_engine_live")
	for party_index in [0,3,6]:
		var legacy: Dictionary=await simulate(pilot,party_index,"assault",false)
		comparisons.append(legacy)
		for preset in ["assault","defense","hunt","staged"]:
			var result: Dictionary=await simulate(pilot,party_index,preset,true)
			assert(result.initial==legacy.initial,"Exact same composition, positions and base stats")
			if preset=="assault":
				assert(result.won==legacy.won and is_equal_approx(result.time,legacy.time) and result.heroes==legacy.heroes,"Pilot one-stage assault preserves the old battle baseline")
			comparisons.append(result)
			print("PLANNING_COMPARISON: ",party_index," ",preset," won=",result.won," time=",result.time," heroes=",result.heroes)
	var file := FileAccess.open(output+"/comparison.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(comparisons,"  "))
	file.close()
	var trio: Array=comparisons.filter(func(row: Dictionary):return row.party==6 and row.mode=="planning")
	assert(trio[0].samples!=trio[1].samples and trio[0].samples!=trio[2].samples,"Plans must actually change movement and targeting")
	pilot.encounter_path="res://resources/encounters/iron_wall.tres"
	var waves: Dictionary=await simulate(pilot,6,"assault",true)
	assert(waves.wave_break_seen,"Actual two-wave arena must allow survivor replanning")
	var wave_file := FileAccess.open(output+"/wave_check.json",FileAccess.WRITE)
	wave_file.store_string(JSON.stringify(waves,"  "))
	wave_file.close()
	print("COMBAT_PLANNING_NATIVE_PASS: live arena click/editor, real pause/intro/lock; 15 controlled Grave Bell battles + actual two-wave replanning; exact legacy baseline; natural outcomes and observed plan differences")
	pilot.show_setup()
	pilot.queue_free()
	await process_frame
	await process_frame
	var session: Node=root.get_node_or_null("QAHubSession")
	if session!=null: session.queue_free()
	await process_frame
	quit()
