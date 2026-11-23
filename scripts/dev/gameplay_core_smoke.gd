extends SceneTree
## Native fixture using the real Battle AI, Reward buttons, Table stop and save slot.

var state: Node
var save: RefCounted
var output := ""


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	state = root.get_node("RunState")
	save = load("res://scripts/core/run_save_service.gd").instance()
	output = OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else ""
	if not output.is_empty():
		DirAccess.make_dir_recursive_absolute(output)
		save.path = output.path_join("gameplay_core_slot.json")
	seed(31017)
	state.reset_run()
	state.choose_protagonist("knight")
	state.change_hero_hp("knight", -35.0)
	state.cards_resolved = 3
	var battle := await _open_battle("grave_bell")
	var hero: Node = battle.units[0]
	var starting_hp: float = hero.hp
	battle.combat_plan_controller.start_planned_battle()
	if not await _wait_for_result(battle): return
	if not _check(state.last_battle_won and hero.hp < starting_hp and hero.hp > 0, "Grave Bell must be a wounded victory"): return
	var won_hp: float = hero.hp
	var expected_hp := minf(hero.max_hp, won_hp + hero.max_hp * 0.25)
	if not _check(expected_hp < hero.max_hp and is_equal_approx(state.get_hero_current_hp("knight"), expected_hp), "Victory heals one quarter of max HP"): return
	if not output.is_empty():
		var checkpoint: Dictionary = save.read_slot(state)
		if not _check(is_equal_approx(checkpoint.state.hero_current_hp.knight, expected_hp), "Reward checkpoint includes victory healing once"): return
	battle.continue_button.pressed.emit()
	if not await _at_scene("/reward/reward.tscn"): return
	var reward := current_scene
	for attempt in range(3):
		if reward.get("reward_mode") == "normal_loot":
			reward.reward_buttons[0].pressed.emit()
			break
		for index in range(reward.reward_buttons.size()):
			var button: Button = reward.reward_buttons[index]
			if not button.visible or button.disabled:
				continue
			# An Executioner offer can cap the Knight's HP before the rest.
			var upgrade: HeroUpgradeData = state.get_hero_upgrade(reward.option_ids[index])
			if upgrade != null and upgrade.hp_bonus >= 0.0:
				button.pressed.emit()
				break
		await create_timer(0.25).timeout
	if not await _at_scene("/table/table.tscn"): return
	if not _check(state.cards_resolved == 4 and state.camp_stop.slot == 4, "Reward leads to IV rest"): return
	await _capture("first_rest.png")
	var stop := current_scene.get_node("CampStop")
	var before_rest: float = state.get_hero_current_hp("knight")
	var maximum: float = state.get_hero_max_hp("knight")
	if not _check(before_rest < maximum, "The reward must leave wounds for the rest fixture"): return
	stop._action_buttons[0].pressed.emit()
	var after_rest: float = state.get_hero_current_hp("knight")
	if not _check(state.camp_stop.is_empty() and is_equal_approx(after_rest, minf(before_rest + maximum * 0.4, maximum)),
		"Rest heals once by up to 40% of maximum HP"): return
	if not output.is_empty():
		var checkpoint: Dictionary = save.read_slot(state)
		if not _check(save.apply_slot(state, checkpoint) and is_equal_approx(state.get_hero_current_hp("knight"), after_rest), "Continue after rest"): return
	print("GAMEPLAY_CORE_VICTORY: battle_hp=%0.2f after_victory=%0.2f rest_hp=%0.2f gold=%d" % [won_hp, expected_hp, after_rest, state.gold])

	# The VIII fixture exercises the longest possible list of goods.
	state.cards_resolved = 7
	state.gold = 95
	state.recruit_companion("ranger", "QA")
	state.recruit_companion("mage", "QA")
	state.change_hero_hp("knight", -60.0)
	state.active_card_id = "moon_seal"
	state.complete_active_card()
	await _swap("res://scenes/table/table.tscn")
	await _capture("gate_merchant.png")
	stop = current_scene.get_node("CampStop")
	var stock: Array = state.camp_stop.stock.duplicate()
	var healing_index: int = stock.find("heal")
	stop._action_buttons[healing_index].pressed.emit()
	if not _check(state.gold == 70 and state.camp_stop.stock == stock and state.camp_stop.sold.has("heal"), "Shop buys exactly once"): return
	stop._action_buttons[healing_index].pressed.emit()
	if not _check(state.gold == 70, "Duplicate shop click is ignored"): return
	stop._choose("leave")
	if not _check(state.cards_resolved == 8 and state.camp_stop.is_empty(), "Shop does not spend a card"): return

	# Use a genuine loss, then reload the paid Last Deal retry from disk.
	state.reset_run()
	state.choose_protagonist("ranger")
	state.change_hero_hp("ranger", -state.get_hero_max_hp("ranger") + 6.0)
	battle = await _open_battle("bone_warden")
	battle.combat_plan_controller.start_planned_battle()
	if not await _wait_for_result(battle): return
	if not _check(not state.last_battle_won and state.last_deal_pending, "Real defeat offers Last Deal"): return
	if not output.is_empty():
		var checkpoint: Dictionary = save.read_slot(state)
		if not _check(save.apply_slot(state, checkpoint) and state.last_deal_pending, "Defeat checkpoint"): return
		await _swap("res://scenes/battle/battle.tscn")
		battle = current_scene
		if not _check(battle.warden_intro == null and battle.last_deal_accept_button.visible,
			"Restored defeat opens the existing Last Deal directly"): return
	battle.last_deal_accept_button.pressed.emit()
	for frame in range(900):
		await process_frame
		if current_scene != battle:
			break
	if not _check(current_scene != battle and state.last_deal_used and not state.last_deal_pending, "Paid retry"): return
	battle = current_scene
	if not _check(battle.warden_intro != null, "Paid XIII retry opens with the boss intro"): return
	battle.warden_intro.skip()
	if not _check(battle.units[0].hp == 6.0, "Last Deal starts with entry wounds"): return
	battle.combat_plan_controller.start_planned_battle()
	if not await _wait_for_result(battle): return
	if not _check(state.run_failed and not battle.last_deal_accept_button.visible, "Second defeat ends the run"): return
	battle.last_deal_refuse_button.pressed.emit()
	if not await _at_scene("/run_end/run_end.tscn"): return
	print("GAMEPLAY_CORE_NATIVE_PASS")
	await create_timer(1.0).timeout
	quit()


func _check(condition: bool, message: String) -> bool:
	if not condition:
		push_error("GAMEPLAY_CORE_FAIL: " + message)
		quit(1)
	return condition


func _open_battle(card_id: String) -> Control:
	state.active_card_id = card_id
	state.select_encounter(state.get_card(card_id).target_path)
	await _swap("res://scenes/battle/battle.tscn")
	if current_scene.warden_intro != null:
		current_scene.warden_intro.skip()
	return current_scene


func _swap(path: String) -> void:
	change_scene_to_file(path)
	await scene_changed
	await process_frame


func _wait_for_result(battle: Control) -> bool:
	for frame in range(5400):
		await process_frame
		if battle.battle_finished:
			return true
	return _check(false, "Battle result timed out")


func _at_scene(suffix: String) -> bool:
	for frame in range(1200):
		await process_frame
		if current_scene != null and current_scene.scene_file_path.ends_with(suffix):
			var transition := root.get_node("SceneTransition")
			if not transition.get("_busy"):
				return true
	return _check(false, "Could not reach " + suffix)


func _capture(filename: String) -> void:
	if output.is_empty(): return
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output.path_join(filename))
