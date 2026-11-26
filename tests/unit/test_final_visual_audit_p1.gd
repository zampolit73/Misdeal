extends GutTest

const PILOT := preload("res://scripts/dev/travel_pilot_batch01_playtest.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const CARD := preload("res://scripts/ui/card_unification_v1.gd")
const ACT := preload("res://scenes/event/act_choice.tscn")
const BATTLE := preload("res://scenes/battle/battle.tscn")

func after_each() -> void:
	get_tree().paused = false
	RunState.reset_run()

func test_lost_purse_all_outcomes_share_local_grade_without_state_writes() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	var snapshot: Dictionary = SAVE.new().snapshot(RunState).state
	for index in range(7, 11):
		var view: CanvasLayer = load("res://scenes/travel/travel_transition.tscn").instantiate()
		view.context = PILOT.context_for_case(index, ["knight", "ranger", "mage"])
		add_child(view)
		view.set_process(false)
		assert_true(view.available)
		for time in [0.6, 1.3, 2.5, 3.8]:
			view.elapsed = time
			view.update_frame()
			assert_true(view.panorama.available)
			for material in view.panorama.mats:
				assert_true(material.get_shader_parameter("mute_lost_purse_sunset"))
			assert_eq(SAVE.new().snapshot(RunState).state, snapshot)
		view.free()

func test_card_grade_preserves_foreground_and_mutes_distant_red() -> void:
	var original := Image.new()
	assert_eq(original.load_webp_from_buffer(FileAccess.get_file_as_bytes("res://assets/pixel/card_unification_v1/run/lost_purse_d343_approved_headless_corpse.webp")), OK)
	var graded := original.duplicate() as Image
	CARD._grade_lost_purse_card(graded)
	assert_eq(graded.get_size(), original.get_size())
	var left := Rect2i(0, 0, int(original.get_width() * 0.42), original.get_height())
	assert_eq(graded.get_region(left).get_data(), original.get_region(left).get_data())
	assert_ne(graded.get_data(), original.get_data())
	var old_red := 0.0
	var new_red := 0.0
	for y in range(int(original.get_height() * 0.4)):
		for x in range(int(original.get_width() * 0.67), original.get_width()):
			var a := original.get_pixel(x, y)
			var b := graded.get_pixel(x, y)
			old_red += maxf(0, a.r - a.g)
			new_red += maxf(0, b.r - b.g)
	assert_lt(new_red, old_red)
	var original_reflection := 0.0
	var graded_reflection := 0.0
	for y in range(int(original.get_height() * 0.78), original.get_height()):
		for x in range(int(original.get_width() * 0.79), original.get_width()):
			var a := original.get_pixel(x, y)
			var b := graded.get_pixel(x, y)
			original_reflection += maxf(0, a.r - a.g)
			graded_reflection += maxf(0, b.r - b.g)
	assert_lt(graded_reflection, original_reflection)
	original.save_webp("user://final_audit_lost_purse_before.webp", true)
	graded.save_webp("user://final_audit_lost_purse_after.webp", true)

func test_action_art_is_distinct_and_choice_effects_remain_live() -> void:
	for fixture in [
		["debtor_bones", "ChoiceA", "dice.webp", "БРОСИТЬ"],
		["last_camp", "ChoiceA", "wounded_knight.webp", "ПОДНЯТЬ"],
		["faceless_card", "ChoiceC", "burning_card.webp", "СЖЕЧЬ"],
	]:
		RunState.reset_run()
		RunState.choose_protagonist("ranger")
		RunState.active_card_id = fixture[0]
		RunState.gold = 0
		var event := ACT.instantiate()
		add_child(event)
		await get_tree().process_frame
		var target: Button = event.get_node("Panel/Choices/" + fixture[1])
		assert_true(target.get_node("ChoiceArt").texture.resource_path.ends_with(fixture[2]))
		assert_string_contains(target.get_node("Copy/Action").text.to_upper(), fixture[3])
		assert_false(target.disabled)
		if fixture[0] == "last_camp":
			assert_true(event.choice_b.disabled)
			assert_false(event.choice_b.get_node("Copy/Availability").text.is_empty())
			target.pressed.emit()
			assert_true(RunState.is_role_in_party("knight"))
		elif fixture[0] == "faceless_card":
			assert_true(event.choice_b.disabled)
			var before: int = RunState.gold
			target.pressed.emit()
			assert_eq(RunState.gold, before + 20)
		else:
			event.choice_b.pressed.emit()
			assert_eq(RunState.gold, 15)
			assert_eq(RunState.get_event_outcome("debtor_bones"), "safe")
		event.queue_free()
		await get_tree().process_frame

func test_battle_captions_preserve_positions_hp_and_separate_dense_labels() -> void:
	for encounter in ["ossuary_gate", "bone_warden"]:
		RunState.reset_run()
		RunState.choose_protagonist("knight")
		RunState.recruit_companion("ranger", "QA")
		RunState.recruit_companion("mage", "QA")
		RunState.active_card_id = encounter
		RunState.select_encounter("res://resources/encounters/" + encounter + ".tres")
		var battle := BATTLE.instantiate()
		add_child(battle)
		await get_tree().process_frame
		if battle.warden_intro != null:
			battle.warden_intro.skip()
			await get_tree().process_frame
		battle.set_process(false)
		assert_gt(battle.units.size(), 3)
		if encounter == "ossuary_gate":
			var controller = battle.combat_plan_controller
			controller.ui.select_order("knight", 0)
			controller.arm_target()
			assert_true(controller.picking_target)
			var enemy: BattleUnit = controller.first_wave_enemies[0]
			var click := InputEventMouseButton.new()
			click.button_index = MOUSE_BUTTON_LEFT
			click.pressed = true
			click.position = controller.ui.pick_markers[enemy].get_global_rect().get_center()
			controller._input(click)
			assert_false(controller.picking_target)
			assert_eq(controller.plans.knight.orders[0].target.get_ref(), enemy)
		if encounter == "bone_warden":
			for unit in battle.units:
				if unit.is_boss:
					var boss: BattleUnit = unit
					boss.take_damage(boss.max_hp * 0.5)
					break
			assert_true(battle.boss_reinforcements_spawned)
		var named: Array[BattleUnit] = []
		for unit in battle.units:
			unit.set_process(false)
			if unit.alive and unit.name_label.is_visible_in_tree():
				named.append(unit)
		assert_gt(named.size(), 1)
		# Stress collision without changing any game logic.
		for unit in named:
			unit.global_position = Vector2(600, 390)
		var health: Array = named.map(func(unit): return unit.hp)
		battle._layout_unit_captions()
		var rectangles: Array[Rect2] = []
		for unit in named:
			assert_eq(unit.global_position, Vector2(600, 390))
			var label := unit.name_label
			assert_eq(label.z_index, 1800)
			assert_false(label.z_as_relative)
			assert_eq(label.mouse_filter, Control.MOUSE_FILTER_IGNORE)
			var rect := label.get_global_rect()
			for previous in rectangles:
				assert_false(rect.intersects(previous), "%s: %s vs %s" % [encounter, rect, previous])
			rectangles.append(rect)
		assert_eq(named.map(func(unit): return unit.hp), health)
		battle.queue_free()
		await get_tree().process_frame

func test_run_end_summary_is_clipped_and_scrollable() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.run_failed = true
	var screen: Control = load("res://scenes/run_end/run_end.tscn").instantiate()
	add_child_autofree(screen)
	await get_tree().process_frame
	var scroll: ScrollContainer = screen.get_node("SummaryScroll")
	var label: Label = scroll.get_node("Summary")
	assert_true(scroll.clip_contents)
	assert_lte(scroll.size.y, float(label.get_line_height()))
	label.text = ("Длинная сводка развития отряда для проверки прокрутки. ").repeat(15)
	await get_tree().process_frame
	await get_tree().process_frame
	assert_gt(scroll.get_v_scroll_bar().max_value, scroll.get_v_scroll_bar().page)
	assert_true(screen.find_child("LastDeal", true, false).visible)

func test_merchant_empty_offer_is_readable_and_leave_remains_live() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.camp_stop = {"slot": 8, "stock": [], "sold": []}
	var merchant := preload("res://scripts/table/merchant_view.gd").new()
	add_child_autofree(merchant)
	merchant.build("Торговец", "Проверка пустых слотов")
	var count := 0
	for child in merchant.get_children():
		if child is Label and child.text == "НЕТ В ПРОДАЖЕ":
			count += 1
			assert_eq(child.get_theme_color("font_color"), merchant.INK)
	assert_eq(count, 4)
	watch_signals(merchant)
	merchant._leave.pressed.emit()
	assert_signal_emitted_with_parameters(merchant, "action_requested", ["leave"])
