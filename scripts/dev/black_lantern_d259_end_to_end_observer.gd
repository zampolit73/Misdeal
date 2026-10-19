extends Node

# D259: persistent test observer rooted OUTSIDE current_scene, so the normal
# SceneRouter is free to destroy Battle and Reward during actual navigation.
# No gameplay logic modified; all actions are real UI Button signals.
const ROUTE := preload("res://scenes/dev/black_lantern_d259_real_battle_route_qa.tscn")
const CARD := "black_lantern_road"

func _ready() -> void:
	call_deferred("_exercise")

func _exercise() -> void:
	var host := get_tree().current_scene
	if host == null:
		_fail("no headless test root")
		return
	var launcher := ROUTE.instantiate() as Control
	if launcher == null:
		_fail("no real Battle QA launcher")
		return
	host.add_child(launcher)
	await get_tree().process_frame
	var party := launcher.get("party_picker") as OptionButton
	var formation := launcher.get("formation_picker") as OptionButton
	if party == null or formation == null:
		_fail("unable to select party/formation")
		return
	party.select(2) # Trio
	formation.select(1) # Crossroads
	launcher.call("_launch_real_battle")
	await get_tree().process_frame
	var battle: Control
	for child in launcher.get_children():
		if child.scene_file_path == "res://scenes/battle/battle.tscn":
			battle = child as Control
	if battle == null:
		_fail("actual Battle scene not created")
		return
	var combat_units: Array = battle.get("units")
	if combat_units.size() != 8 or battle.get("black_lantern_light_controller") == null:
		_fail("expected eight BattleUnits and one D253 lanternlight controller")
		return
	var start_button := battle.get_node_or_null("FightButton") as Button
	if start_button == null:
		_fail("real fight button absent")
		return
	start_button.emit_signal("pressed")
	if not await _battle_result(battle):
		return
	var continue_button := battle.get_node_or_null("ContinueButton") as Button
	if continue_button == null or not continue_button.visible:
		_fail("real battle did not expose ContinueButton after win")
		return
	continue_button.emit_signal("pressed")
	var reward := await _wait_for_scene("res://scenes/reward/reward.tscn", 30.0)
	if reward == null:
		_fail("real Battle did not navigate to Reward")
		return
	var rewards_chosen := 0
	var passed_time := 0.0
	while passed_time < 35.0:
		await get_tree().process_frame
		passed_time += get_process_delta_time()
		var active := get_tree().current_scene
		if active != reward:
			break
		if rewards_chosen >= 3:
			continue
		var buttons: Array = reward.get("reward_buttons")
		var ids: Array = reward.get("option_ids")
		if buttons.size() == 0 or ids.size() == 0:
			continue
		var btn := buttons[0] as Button
		if btn != null and btn.visible and not btn.disabled and not str(ids[0]).is_empty():
			btn.emit_signal("pressed")
			rewards_chosen += 1
			for _step in range(35):
				await get_tree().process_frame
	var table := get_tree().current_scene
	if table == null or table.scene_file_path != "res://scenes/table/table.tscn":
		_fail("Reward did not return to Table (scene %s; claims %d)" % [
			table.scene_file_path if table != null else "<null>", rewards_chosen
		])
		return
	if not RunState.resolved_card_ids.has(CARD):
		_fail("Reward-to-Table did not resolve card #38 in QA")
		return
	if RunState.ACT1_CARD_IDS.size() != 37 or RunState.ACT1_CARD_IDS.has(CARD):
		_fail("full-route test unexpectedly released #38")
		return
	print("D259_END_TO_END_PASS: normal Battle Fight -> win -> Reward -> Table, five original staged sprites, card #38 QA only")
	get_tree().quit(0)

func _battle_result(battle: Control) -> bool:
	var elapsed := 0.0
	while elapsed < 55.0:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
		if not is_instance_valid(battle):
			_fail("Battle unexpectedly freed before result")
			return false
		if bool(battle.get("battle_finished")):
			if not RunState.last_battle_won:
				_fail("Trio/Crossroads lost this functional smoke; not a release PASS")
				return false
			return true
	_fail("real Fight did not finish within 55 seconds")
	return false

func _wait_for_scene(path: String, seconds: float) -> Node:
	var elapsed := 0.0
	while elapsed < seconds:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
		var scene := get_tree().current_scene
		if scene != null and scene.scene_file_path == path:
			return scene
	return null

func _fail(message: String) -> void:
	push_error("D259_END_TO_END_FAIL: " + message)
	get_tree().quit(1)
