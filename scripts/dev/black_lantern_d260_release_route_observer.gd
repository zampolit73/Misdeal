extends Node

# D260: release smoke observer rooted OUTSIDE current_scene, so the normal
# SceneRouter is free to destroy Battle and Reward during actual navigation.
# No gameplay logic modified; all actions are real UI Button signals.
const BATTLE_SCENE := preload("res://scenes/battle/battle.tscn")
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const CARD := "black_lantern_road"

# A headless Godot run has no real frame_post_draw signal. The normal
# SceneTransition awaits a real rendered frame before scene replacement.
# Drive that signal ONLY in this external QA observer to exercise navigation
# semantics without changing the production router. NOT a visual render test.
func _process(_delta: float) -> void:
	if DisplayServer.get_name() == "headless":
		RenderingServer.frame_post_draw.emit()

func _ready() -> void:
	call_deferred("_exercise")

func _exercise() -> void:
	# Check the released ACT1 catalog, not the unreleased test card registry.
	if RunState.ACT1_CARD_IDS.size() != 38 or not RunState.ACT1_CARD_IDS.has(CARD):
		_fail("card #38 is not in the regular 38-card pool")
		return
	var card := RunState.get_card(CARD)
	if card == null or card.resolution_type != "combat" or card.tier != 1:
		_fail("card resource missing or no longer Tier 1 combat")
		return
	if card.target_path != "res://resources/encounters/black_lantern_road.tres":
		_fail("card has wrong encounter path")
		return

	# Set up a legitimate Tier 1 deal through RunState.get_offer_cards()
	# rather than manually assigning active_card_id / selected_encounter_path.
	# Limit the Tier 1 candidate subset to two combat cards (the others
	# remain in the deck by tier), making #38 discoverable deterministically.
	RunState.reset_run()
	if not RunState.choose_protagonist("knight"):
		_fail("protagonist setup failed")
		return
	RunState.recruit_companion("ranger", "D260 release route QA")
	RunState.recruit_companion("mage", "D260 release route QA")
	RunState.cards_resolved = 4
	RunState.forced_combat_slots.clear()
	RunState.wizard_meddling_slots.clear()
	RunState.wizard_wager_slots.clear()
	RunState.wizard_mark_slots.clear()
	var comparison := ""
	for id in RunState.remaining_card_ids:
		var candidate := RunState.get_card(id)
		if id != CARD and candidate != null and candidate.tier == 1 and candidate.resolution_type == "combat":
			comparison = id
			break
	if comparison.is_empty():
		_fail("no other authentic Tier 1 combat candidate to compare in dealt hand")
		return
	var filtered: Array[String] = []
	for id in RunState.remaining_card_ids:
		var candidate := RunState.get_card(id)
		if candidate == null:
			continue
		if candidate.tier != 1 or id == CARD or id == comparison:
			filtered.append(id)
	RunState.remaining_card_ids = filtered
	var dealt := RunState.get_offer_cards()
	var offered_ids: Array[String] = []
	for offered in dealt:
		offered_ids.append(offered.card_id)
	if not offered_ids.has(CARD):
		_fail("ordinary Tier 1 deal did not contain #38: %s" % [offered_ids])
		return
	if not RunState.choose_card(CARD):
		_fail("ordinary RunState.choose_card rejected released #38")
		return
	if RunState.active_card_id != CARD or RunState.selected_encounter_path != card.target_path:
		_fail("ordinary dealt combat card did not select real encounter")
		return
	RunState.combat_formation_by_card[CARD] = 1 # Crossroads, second original layout
	var host := get_tree().current_scene
	if host == null:
		_fail("no current release-test scene")
		return
	var battle := BATTLE_SCENE.instantiate() as Control
	if battle == null:
		_fail("real Battle PackedScene not created")
		return
	host.add_child(battle)
	await get_tree().process_frame
	var units: Array = battle.get("units")
	if units.size() != 8 or battle.get("black_lantern_light_controller") == null:
		_fail("normal Battle did not configure 3 heroes, 5 enemies and D253 light")
		return
	var enemy_roles: Array[String] = []
	for candidate_unit in units:
		var actor := candidate_unit as BattleUnit
		if actor == null:
			_fail("non-BattleUnit in real encounter")
			return
		if actor.team != 1:
			continue
		enemy_roles.append(actor.visual_role)
		if actor.sprite_frames == null or actor.sprite_frames != LIBRARY.get_frames(actor.visual_role):
			_fail("enemy not using canonical original art: " + actor.visual_role)
			return
		for state in ["idle", "walk", "attack", "hit", "death"]:
			if not actor.sprite_frames.has_animation(state):
				_fail("missing original animation " + state + " for " + actor.visual_role)
				return
	enemy_roles.sort()
	var expected := ["extinguished_guide", "lantern_bearer", "road_sentinel", "oil_acolyte", "lantern_archer"]
	expected.sort()
	if enemy_roles != expected:
		_fail("not five distinct skeleton enemies: %s" % [enemy_roles])
		return
	print("D260_REAL_DEAL_PASS: release catalog 38/45, genuine Tier1 RunState dealt and selected card #38, real Battle has 5 original sprites")
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
	print("D260_RELEASE_ROUTE: Battle win; triggering Continue -> Reward")
	continue_button.emit_signal("pressed")
	var reward := await _wait_for_scene("res://scenes/reward/reward.tscn", 30.0)
	if reward == null:
		_fail("real Battle did not navigate to Reward")
		return
	print("D260_RELEASE_ROUTE: Reward loaded")
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
		_fail("Reward-to-Table did not resolve released card #38")
		return
	if RunState.ACT1_CARD_IDS.size() != 38 or not RunState.ACT1_CARD_IDS.has(CARD):
		_fail("release disappeared from ordinary draw pool")
		return
	print("D260_RELEASE_ROUTE_PASS: released ordinary deal → original Battle Fight → win → Reward → Table, 38/45 LIVE")
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
	push_error("D260_RELEASE_ROUTE_FAIL: " + message)
	get_tree().quit(1)
