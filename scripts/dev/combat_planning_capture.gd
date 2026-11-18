extends SceneTree
const PILOT := "res://scenes/dev/combat_planning_pilot.tscn"
const PRESETS := preload("res://scripts/battle/planning/battle_plan_presets.gd")
const DATA := preload("res://scripts/battle/planning/hero_battle_plan.gd")
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

func click_at(point: Vector2) -> void:
	for pressed in [true, false]:
		var click := InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = pressed
		click.position = point
		Input.parse_input_event(click)
		await frame()

func click_control(control: Control) -> void:
	await click_at(control.get_global_rect().get_center())

func verify_editor(pilot: Control) -> void:
	var view: CanvasLayer = pilot.ui
	assert(view.tiles.size() == 3 and not view.detail.visible, "Overview shows three independent hero rows")
	for role in view.hero_roles:
		for index in range(pilot.plans[role].orders.size()):
			assert(not view.tile_headings[role][index].text.is_empty())
	await capture("ux_overview")
	await click_control(view.tiles.ranger[0])
	assert(view.current_role() == "ranger" and view.slot == 0 and view.detail.visible)
	for selected in range(3):
		view.tactic.select(selected)
		view.tactic.item_selected.emit(selected)
		assert(pilot.plans.ranger.orders[0].tactic == DATA.TACTICS[selected])
	for selected in range(4):
		view.priority.select(selected)
		view.priority.item_selected.emit(selected)
		assert(pilot.plans.ranger.orders[0].priority == DATA.PRIORITIES[selected])
	for selected in range(5):
		view.condition.select(selected)
		view.condition.item_selected.emit(selected)
		assert(pilot.plans.ranger.orders[0].condition == DATA.CONDITIONS[selected])
	view.limit.value = 9
	assert(pilot.plans.ranger.orders[0].limit == 9 and "9 с" in view.tile_endings.ranger[0].text)
	await capture("ux_order")
	await click_control(view.target_button)
	assert(pilot.picking_target and not view.editor.visible and view.pick_markers.size() == 3)
	var enemy: BattleUnit = pilot.battle.units[-1]
	var motion := InputEventMouseMotion.new()
	motion.position = enemy.global_position + Vector2(0, -35)
	Input.parse_input_event(motion)
	await frame()
	assert(enemy.display_name in view.hover_text.text)
	await capture("ux_target")
	await click_control(view.pick_markers[enemy])
	assert(not pilot.picking_target and pilot.plans.ranger.orders[0].target.get_ref() == enemy)
	assert(enemy.display_name in view.tile_headings.ranger[0].text)
	await click_control(view.target_button)
	var cancel := InputEventKey.new()
	cancel.keycode = KEY_ESCAPE
	cancel.pressed = true
	Input.parse_input_event(cancel)
	await frame()
	assert(not pilot.picking_target and pilot.plans.ranger.orders[0].target.get_ref() == enemy)
	await click_control(view.tiles.knight[1])
	assert(view.current_role() == "knight" and pilot.plans.ranger.orders[0].limit == 9)
	var spawn_index: int = pilot.plans.ranger.orders[0].spawn_slot
	pilot.edit_again()
	await frame()
	var rebound := DATA.target_of(pilot.plans.ranger.orders[0])
	assert(is_instance_valid(rebound) and rebound == pilot.first_wave_enemies[spawn_index] and not is_instance_valid(enemy))
	assert(pilot.plans.ranger.orders[0].limit == 9)
	await root.get_node("QAHubSession").replay()
	await frame()
	rebound = DATA.target_of(pilot.plans.ranger.orders[0])
	assert(rebound == pilot.first_wave_enemies[spawn_index], "F9 uses the same scoped retry")
	view = pilot.ui
	await click_control(view.tiles.ranger[0])
	await click_control(view.clear_button)
	assert(pilot.plans.ranger.orders[0].target == null and not pilot.plans.ranger.orders[0].has("spawn_slot"))
	await click_control(view.target_button)
	pilot.assign_target(rebound)
	var original_encounter: String = pilot.encounter_path
	pilot.encounter_path = "res://resources/encounters/iron_wall.tres"
	pilot.open_battle(true)
	await frame()
	assert(pilot.plans.ranger.orders[0].target == null and "сброшено" in pilot.ui.board_hint.text)
	pilot.encounter_path = original_encounter
	pilot.party_choice.select(3)
	pilot.open_battle()
	await frame()
	assert(pilot.ui.tiles.size() == 2 and not pilot.ui.tiles.has("mage"))
	pilot.party_choice.select(0)
	pilot.preset_choice.select(1)
	pilot.open_battle()
	await frame()
	view = pilot.ui
	assert(view.tiles.size() == 1 and not view.tiles.has("ranger"))
	await capture("ux_solo")
	await click_control(view.tiles.knight[1])
	assert(pilot.plans.knight.orders.size() == 2 and not view.limit.visible)
	await click_control(view.tiles.knight[2])
	assert(pilot.plans.knight.orders.size() == 3)
	await click_control(view.remove_buttons.knight)
	assert(pilot.plans.knight.orders.size() == 2 and not view.detail.visible)
	pilot.party_choice.select(6)
	pilot.preset_choice.select(4)
	pilot.open_battle()
	await frame()
	root.size = Vector2i(960, 540)
	await frame()
	await capture("ux_small_window")
	var small := root.get_texture().get_image()
	assert(small.get_width() == 960 and small.get_height() == 540)
	root.size = Vector2i(1280, 720)
	await frame()

func simulate(pilot: Control, party_index: int, preset: String, planned: bool) -> Dictionary:
	pilot.party_choice.select(party_index)
	pilot.mode_choice.select(1 if planned else 0)
	pilot.open_battle()
	pilot.set_process(false)
	await process_frame
	PRESETS.apply(pilot.plans,preset)
	if planned: pilot.ui.refresh()
	var battle: Control=pilot.battle
	if planned and battle.encounter.has_second_wave():
		pilot.ui.select_order("knight", 0)
		pilot.arm_target()
		pilot.assign_target(pilot.first_wave_enemies[0])
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
			assert(pilot.plans.knight.orders[0].target == null and not pilot.plans.knight.orders[0].has("spawn_slot"))
			assert("первой волны" in pilot.ui.board_hint.text)
			assert(pilot.first_wave_draft.knight[0].spawn_slot == 0, "First-wave assignments remain available for a full retry")
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
	assert(not battle.get_node("ResultOverlay").visible, "The QA report owns the result controls")
	for role in pilot.executors: result.journal[role]=pilot.executors[role].journal.duplicate(true)
	if party_index==6 and planned:
		var summary: String = pilot.ui.report_reading.text
		assert("Рыцарь" in summary and "Волна 1 · 0.00" not in summary)
		await capture("report_"+battle.encounter.encounter_id+"_"+preset)
		if preset == "staged":
			await click_control(pilot.ui.history_button)
			assert(pilot.ui.report_reading.text == pilot.report_text)
			await capture("ux_chronology")
			await click_control(pilot.ui.history_button)
			assert(pilot.ui.report_reading.text == summary)
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
	await verify_editor(pilot)
	pilot.ui.select_order("knight", 0)
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
