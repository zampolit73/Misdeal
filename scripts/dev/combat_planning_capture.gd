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

func move_pointer(point: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = point
	root.push_input(motion, true)
	await frame()

func verify_preparation(pilot: Control, expected: String) -> void:
	var view: CanvasLayer = pilot.ui
	var active: Array[String] = []
	for name in ["overview", "detail", "picker"]:
		var page: Control = view.get(name)
		assert(page.get_parent() == view.preparation, "All preparation content shares one panel")
		if page.is_visible_in_tree():
			active.append(name)
	assert(active == ([] if expected.is_empty() else [expected]), "Only the expected preparation mode is visible")
	assert(view.preparation.visible == not expected.is_empty())
	if expected != "overview":
		assert(not view.plan_marker.visible, "The planning hover marker only appears in the overview")
	if not view.preparation.visible:
		return
	var bounds: Rect2 = view.preparation.get_global_rect()
	assert(bounds.position.y >= 560.0 and bounds.end.y <= 720.0, "Preparation stays in the lower strip")
	for unit in pilot.battle.units:
		if unit.alive:
			assert(unit.global_position.y + 20.0 <= bounds.position.y, "Preparation leaves room below living units")

func verify_editor(pilot: Control) -> void:
	var view: CanvasLayer = pilot.ui
	verify_preparation(pilot, "overview")
	assert(view.tiles.size() == 3, "Overview shows three independent hero rows")
	for role in view.hero_roles:
		for index in range(pilot.plans[role].orders.size()):
			var tile: Button = view.tiles[role][index]
			assert(not view.tile_headings[role][index].text.is_empty())
			assert(tile.get_theme_stylebox("normal") is StyleBoxTexture)
			assert(view.tile_stages[role][index].is_visible_in_tree())
	assert(view.tiles.mage[2].get_theme_stylebox("normal").texture.region != view.tiles.mage[0].get_theme_stylebox("normal").texture.region, "Unused slot keeps its own metal material")
	await capture("visual_v4_overview_trio")
	var start: Button = view.start_button
	var idle: StyleBoxTexture = start.get_theme_stylebox("normal")
	var hover: StyleBoxTexture = start.get_theme_stylebox("hover")
	var pressed: StyleBoxTexture = start.get_theme_stylebox("pressed")
	assert(idle.modulate_color != hover.modulate_color and pressed.modulate_color != hover.modulate_color)
	var knight: BattleUnit = pilot.battle.units[0]
	var knight_tint := knight.modulate
	await move_pointer(view.hero_caption.knight.get_global_rect().get_center())
	assert(view.plan_marker.visible and view.hovered_plan_unit == knight)
	assert(knight.modulate == knight_tint)
	await capture("visual_v4_hero_hover")
	await move_pointer(Vector2(640, 410))
	assert(not view.plan_marker.visible)
	var order_button: Button = view.tiles.ranger[1]
	var order_point := order_button.get_global_rect().get_center()
	await move_pointer(order_point)
	assert(order_button.is_hovered())
	var press := InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_LEFT
	press.position = order_point
	press.pressed = true
	root.push_input(press, true)
	await frame()
	assert(order_button.is_pressed())
	var release := press.duplicate() as InputEventMouseButton
	release.pressed = false
	root.push_input(release, true)
	await frame()
	verify_preparation(pilot, "detail")
	assert(view.current_role() == "ranger" and view.slot == 1)
	for selected in range(3):
		view.tactic.select(selected)
		view.tactic.item_selected.emit(selected)
		assert(pilot.plans.ranger.orders[1].tactic == DATA.TACTICS[selected])
	for selected in range(4):
		view.priority.select(selected)
		view.priority.item_selected.emit(selected)
		assert(pilot.plans.ranger.orders[1].priority == DATA.PRIORITIES[selected])
	for selected in range(5):
		view.condition.select(selected)
		view.condition.item_selected.emit(selected)
		assert(pilot.plans.ranger.orders[1].condition == DATA.CONDITIONS[selected])
		assert(view.limit_label.text == ("Длительность" if selected == 0 else "Если не выполнено"))
	view.condition.select(0)
	view.condition.item_selected.emit(0)
	view.limit.value = 5
	assert("Через 5 секунд перейти к следующему приказу" in view.explanation.text)
	view.condition.select(3)
	view.condition.item_selected.emit(3)
	view.limit.value = 8
	assert("После личного убийства или через 8 секунд" in view.explanation.text)
	await frame()
	assert(view.limit.get_line_edit().text == "8 сек.", "Displayed seconds: %s" % view.limit.get_line_edit().text)
	await capture("visual_v4_edit_order")
	# Type without pressing Enter, then return to the plan. The value must commit.
	var limit_input: LineEdit = view.limit.get_line_edit()
	limit_input.grab_focus()
	await frame()
	limit_input.select_all()
	var digit := InputEventKey.new()
	digit.keycode = KEY_9
	digit.unicode = 57
	digit.pressed = true
	root.push_input(digit, true)
	await frame()
	assert(limit_input.text == "9", "Numeric input reached the active limit field: %s (focused: %s)" % [limit_input.text, limit_input.has_focus()])
	await click_control(view.back_button)
	verify_preparation(pilot, "overview")
	assert(pilot.plans.ranger.orders[1].limit == 9 and "9 с" in view.tile_endings.ranger[1].text,
		"Returning saves the typed limit: widget %s, order %s" % [view.limit.value, pilot.plans.ranger.orders[1].limit])
	assert("Охота" in view.tile_headings.ranger[1].text)
	await click_control(view.tiles.ranger[1])
	assert(view.limit.value == 9)
	await capture("ux_v3_edit_order")
	await click_control(view.back_button)
	await click_control(view.tiles.mage[0])
	await click_control(view.target_button)
	verify_preparation(pilot, "picker")
	assert(pilot.picking_target and view.pick_markers.size() == 3 and view.preparation.size.y <= 48.0)
	var enemy: BattleUnit = pilot.battle.units[-1]
	var motion := InputEventMouseMotion.new()
	motion.position = enemy.global_position + Vector2(0, -35)
	Input.parse_input_event(motion)
	await frame()
	assert(enemy.display_name in view.hover_text.text)
	await capture("visual_v4_target_select")
	await click_control(view.pick_markers[enemy])
	verify_preparation(pilot, "detail")
	assert(not pilot.picking_target and pilot.plans.mage.orders[0].target.get_ref() == enemy)
	assert(view.current_role() == "mage" and view.slot == 0 and enemy.display_name in view.target_button.text)
	assert(view.pick_markers.is_empty())
	await click_control(view.target_button)
	var cancel := InputEventKey.new()
	cancel.keycode = KEY_ESCAPE
	cancel.pressed = true
	Input.parse_input_event(cancel)
	await frame()
	verify_preparation(pilot, "detail")
	assert(not pilot.picking_target and pilot.plans.mage.orders[0].target.get_ref() == enemy)
	await click_control(view.target_button)
	await click_control(view.cancel_button)
	verify_preparation(pilot, "detail")
	assert(pilot.plans.mage.orders[0].target.get_ref() == enemy)
	await click_control(view.back_button)
	verify_preparation(pilot, "overview")
	assert(enemy.display_name in view.tile_endings.mage[0].text and pilot.plans.ranger.orders[1].limit == 9)
	var enemy_tint := enemy.modulate
	var sprite_tint := enemy.art_sprite.modulate
	await move_pointer(view.tiles.mage[0].get_global_rect().get_center())
	assert(view.plan_marker.visible and view.hovered_plan_unit == enemy)
	assert(view.plan_marker.position.is_equal_approx(enemy.get_global_transform_with_canvas() * Vector2(0, 36)))
	assert(enemy.modulate == enemy_tint and enemy.art_sprite.modulate == sprite_tint)
	var assigned_label: Label = view.tile_endings.mage[0]
	var assigned_font := assigned_label.get_theme_font("font")
	assert(assigned_font.get_string_size(assigned_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1,
		assigned_label.get_theme_font_size("font_size")).x <= assigned_label.size.x, "Named target remains readable")
	await capture("visual_v4_target_highlight")
	await move_pointer(view.tiles.mage[1].get_global_rect().get_center())
	assert(not view.plan_marker.visible and enemy.modulate == enemy_tint)
	var spawn_index: int = pilot.plans.mage.orders[0].spawn_slot
	pilot.edit_again()
	await frame()
	verify_preparation(pilot, "overview")
	assert(pilot.ui.current_role() == "mage" and pilot.ui.slot == 0)
	var rebound := DATA.target_of(pilot.plans.mage.orders[0])
	assert(is_instance_valid(rebound) and rebound == pilot.first_wave_enemies[spawn_index] and not is_instance_valid(enemy))
	assert(pilot.plans.ranger.orders[1].limit == 9)
	await root.get_node("QAHubSession").replay()
	await frame()
	rebound = DATA.target_of(pilot.plans.mage.orders[0])
	assert(rebound == pilot.first_wave_enemies[spawn_index], "F9 uses the same scoped retry")
	view = pilot.ui
	await click_control(view.tiles.mage[0])
	await click_control(view.clear_button)
	assert(pilot.plans.mage.orders[0].target == null and not pilot.plans.mage.orders[0].has("spawn_slot"))
	await click_control(view.back_button)
	await move_pointer(view.tiles.mage[0].get_global_rect().get_center())
	assert(not view.plan_marker.visible, "A cleared assignment must not leave a stale hover marker")
	await click_control(view.tiles.mage[0])
	await click_control(view.target_button)
	pilot.assign_target(rebound)
	var original_encounter: String = pilot.encounter_path
	pilot.encounter_path = "res://resources/encounters/iron_wall.tres"
	pilot.open_battle(true)
	await frame()
	assert(pilot.plans.mage.orders[0].target == null and "сброшено" in pilot.ui.board_hint.text)
	pilot.encounter_path = original_encounter
	pilot.party_choice.select(3)
	pilot.open_battle()
	await frame()
	verify_preparation(pilot, "overview")
	assert(pilot.ui.tiles.size() == 2 and not pilot.ui.tiles.has("mage"))
	await capture("visual_v4_overview_duo")
	pilot.party_choice.select(0)
	pilot.preset_choice.select(1)
	pilot.open_battle()
	await frame()
	view = pilot.ui
	assert(view.tiles.size() == 1 and not view.tiles.has("ranger"))
	assert(not view.remove_buttons.knight.visible and pilot.plans.knight.orders.size() == 1)
	verify_preparation(pilot, "overview")
	await capture("visual_v4_overview_solo")
	await click_control(view.tiles.knight[1])
	verify_preparation(pilot, "detail")
	assert(pilot.plans.knight.orders.size() == 2 and not view.limit.visible and not view.condition.visible)
	await click_control(view.back_button)
	await click_control(view.tiles.knight[2])
	assert(pilot.plans.knight.orders.size() == 3)
	await click_control(view.back_button)
	assert(view.remove_buttons.knight.tooltip_text == "Убрать приказ III" and view.slot == 2)
	await click_control(view.remove_buttons.knight)
	assert(pilot.plans.knight.orders.size() == 2 and not view.detail.visible and view.slot == 1)
	assert(view.remove_buttons.knight.tooltip_text == "Убрать приказ II")
	await click_control(view.remove_buttons.knight)
	assert(pilot.plans.knight.orders.size() == 1 and view.slot == 0 and not view.remove_buttons.knight.visible)
	pilot.party_choice.select(6)
	pilot.preset_choice.select(4)
	pilot.open_battle()
	await frame()
	root.size = Vector2i(960, 540)
	await frame()
	await capture("ux_v3_small_window")
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
		pilot.ui.close_detail()
	battle.set_process(false)
	for unit in battle.units: unit.set_process(false)
	var initial: Array=[]
	for unit in battle.units: initial.append([unit.team,unit.visual_role,unit.position.x,unit.position.y,unit.hp,unit.damage,unit.attack_interval])
	if planned: pilot.start_planned_battle()
	else: pilot.start_legacy_battle()
	verify_preparation(pilot, "")
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
			verify_preparation(pilot, "overview")
			assert(pilot.executors.is_empty())
			assert(pilot.plans.knight.orders[0].target == null and not pilot.plans.knight.orders[0].has("spawn_slot"))
			assert("первой волны" in pilot.ui.board_hint.text)
			assert(pilot.first_wave_draft.knight[0].spawn_slot == 0, "First-wave assignments remain available for a full retry")
			wave_break_seen=true
			var preserved_hp: Array=[]
			for unit in battle.units:
				if unit.team==0: preserved_hp.append(unit.hp)
			PRESETS.apply(pilot.plans,"assault")
			RenderingServer.render_loop_enabled = true
			var survivor: String = pilot.ui.hero_roles[0]
			await click_control(pilot.ui.tiles[survivor][0])
			verify_preparation(pilot, "detail")
			assert(pilot.ui.target_button.disabled)
			await click_control(pilot.ui.back_button)
			verify_preparation(pilot, "overview")
			await capture("ux_v3_intermission")
			RenderingServer.render_loop_enabled = false
			pilot.start_planned_battle()
			verify_preparation(pilot, "")
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
	verify_preparation(pilot, "")
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
			if battle.encounter.encounter_id == "grave_bell" and not result.won:
				var saved := DATA.describe(pilot.plans.ranger.orders[1])
				for child in pilot.ui.report_panel.get_children():
					if child is Button and child.text == "Изменить план":
						await click_control(child)
						break
				verify_preparation(pilot, "overview")
				assert(DATA.describe(pilot.plans.ranger.orders[1]) == saved)
				await click_control(pilot.ui.tiles.ranger[1])
				verify_preparation(pilot, "detail")
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
	await click_control(pilot.ui.back_button)
	verify_preparation(pilot, "overview")
	await move_pointer(pilot.ui.hero_caption.knight.get_global_rect().get_center())
	assert(pilot.ui.plan_marker.visible)
	await click_control(pilot.ui.start_button)
	verify_preparation(pilot, "")
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
	assert(not pilot.ui.plan_marker.visible)
	await capture("visual_v4_combat")
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
	await capture_campaign_report()
	quit()

func capture_campaign_report() -> void:
	# Real production campaign, not the independent pilot report.
	RenderingServer.render_loop_enabled = true
	root.size = Vector2i(1280, 720)
	var state := root.get_node("RunState")
	state.reset_run()
	state.choose_protagonist("knight")
	state.recruit_companion("ranger", "Combat Report QA")
	state.recruit_companion("mage", "Combat Report QA")
	state.select_encounter("res://resources/encounters/grave_bell.tres")
	change_scene_to_file("res://scenes/battle/battle.tscn")
	await frame()
	await frame()
	var battle: Control = current_scene
	var driver: Node = battle.combat_plan_controller
	PRESETS.apply(driver.plans, "staged")
	driver.start_planned_battle()
	await create_timer(0.30).timeout
	assert(battle.intro_plate.visible and not battle.combat_live)
	await capture("campaign_combat_intro_v1")
	var previous_scale := Engine.time_scale
	Engine.time_scale = 4.0
	var deadline := Time.get_ticks_msec() + 30000
	while not battle.battle_finished and Time.get_ticks_msec() < deadline:
		await process_frame
	Engine.time_scale = previous_scale
	assert(battle.battle_finished, "Campaign report must follow a natural result")
	assert(driver.review_button.visible)
	await click_control(driver.review_button)
	assert(is_instance_valid(driver.review_dialog))
	var report: CanvasLayer = driver.review_dialog
	assert(report.journal.get_child_count() == 3)
	await move_pointer(Vector2(30, 700))
	await capture("campaign_combat_report_v1")
	var captured := root.get_texture().get_image()
	assert(captured.get_size() == Vector2i(1280, 720))
	assert(FileAccess.file_exists(output + "/campaign_combat_report_v1.png"))
	report.scroll.scroll_vertical = int(report.scroll.get_v_scroll_bar().max_value)
	await capture("campaign_combat_report_v1_scrolled")
	await click_control(report.close_button)
	assert(not is_instance_valid(driver.review_dialog))
	print("COMBAT_REPORT_NATIVE_PASS: production outcome, grouped executor history, scroll and close")
