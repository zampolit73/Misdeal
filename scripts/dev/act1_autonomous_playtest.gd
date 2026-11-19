extends SceneTree
## Runs one isolated Act 1 attempt through production scenes. See the QA report.

const POLICY := preload("res://scripts/dev/act1_playtest_policy.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const MEMORY := preload("res://scripts/memory/memory_profile.gd")
const MAIN := "res://scenes/main/main.tscn"
const BATTLE := "res://scenes/battle/battle.tscn"
const END := "res://scenes/run_end/run_end.tscn"
const ROLES := ["knight", "ranger", "mage"]

var state: Node
var transition: Node
var output: String
var role: String
var strategy: String
var run_seed: int
var fixture := ""
var fixture_size := 1
var verdict := ""
var result: Dictionary
var started_ms: int
var frame := 0
var scene_id := 0
var scene_frame := 0
var action_frame := 0
var known_meddles := 0
var pending_save: Dictionary = {}
var clicked: Dictionary = {}
var fight: Dictionary = {}
var connected: Dictionary = {}
var loaded_scenes: Array[PackedScene] = []
var battle_live_s := 0.0
var travel_id := 0
var travel_frame := 0
var fixture_finished := false


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 4 or not args[1] in ROLES or not args[2] in ["aggressive", "defensive", "adaptive", "assault", "hunt"]:
		push_error("Usage: -- <new output directory> <role> <strategy> <seed> [encounter] [party size] [verdict]")
		quit(2)
		return
	output = args[0]
	role = args[1]
	strategy = args[2]
	run_seed = args[3].to_int()
	if args.size() > 4:
		fixture = args[4]
		fixture_size = clampi(args[5].to_int(), 1, 3) if args.size() > 5 else 1
		verdict = args[6] if args.size() > 6 else ""
	DirAccess.make_dir_recursive_absolute(output)
	if FileAccess.file_exists(output.path_join("slot.json")) or FileAccess.file_exists(output.path_join("result.json")):
		push_error("Act 1 QA requires a fresh per-attempt output directory.")
		quit(2)
		return
	SAVE.shared = SAVE.new()
	SAVE.shared.path = output.path_join("slot.json")
	MEMORY.shared = MEMORY.new()
	MEMORY.shared.open_profile(output.path_join("memory.json"))
	state = root.get_node("RunState")
	transition = root.get_node("SceneTransition")
	root.size = Vector2i(1280, 720)
	root.content_scale_size = Vector2i(1280, 720)
	# Hold the normal PackedScenes so fast headless frames cannot exhaust the
	# frame budget while the production router waits on background disk I/O.
	for path: String in [MAIN, "res://scenes/intro/intro.tscn", "res://scenes/class_select/class_select.tscn",
			SAVE.TABLE, "res://scenes/event/act_choice.tscn", "res://scenes/event/whispering_well.tscn",
			BATTLE, SAVE.REWARD, END, "res://scenes/travel/travel_transition.tscn"]:
		loaded_scenes.append(load(path) as PackedScene)
	seed(run_seed)
	started_ms = Time.get_ticks_msec()
	result = {"role": role, "strategy": strategy, "seed": run_seed, "fixture": fixture,
		"fixture_size": fixture_size, "fixture_verdict": verdict, "engine": Engine.get_version_info().string,
		"fixed_fps": Engine.physics_ticks_per_second, "actions": [], "battles": [], "travels": []}
	if loaded_scenes.has(null):
		_finish("technical_blocker", "Missing production scene; import the Godot project before running")
		return
	if fixture.is_empty():
		change_scene_to_file(MAIN)
	elif not _prepare_fixture():
		_finish("technical_blocker", "Could not prepare the isolated encounter")
		return

	while frame < 60 * 1200 and Time.get_ticks_msec() - started_ms < 240000:
		await process_frame
		frame += 1
		# Headless cannot draw the production veil. Supply only its render acknowledgement.
		if DisplayServer.get_name() == "headless":
			RenderingServer.frame_post_draw.emit()
		var scene := current_scene
		if not is_instance_valid(scene):
			continue
		_observe_travel()
		if scene.get_instance_id() != scene_id:
			scene_id = scene.get_instance_id()
			scene_frame = frame
			clicked.clear()
			if scene.scene_file_path == BATTLE:
				_begin_battle_log(scene)
			print("ACT1 ", role, "/", strategy, "/", run_seed, " slot=", state.cards_resolved, " ", scene.scene_file_path)
		if scene.scene_file_path == BATTLE:
			_observe_units(scene)
			if scene.combat_live:
				fight.live_frames += 1
				battle_live_s = scene.combat_elapsed
		if frame % 6 != 0 or transition.get("_busy"):
			continue
		if _act(scene):
			return
		if frame - maxi(scene_frame, action_frame) > 60 * 160:
			_finish("technical_blocker", "No progress at %s after 160 simulation seconds" % scene.scene_file_path)
			return
	_finish("time_limit", "Attempt exceeded its wall or frame limit")


func _act(scene: Node) -> bool:
	match scene.scene_file_path:
		MAIN:
			if pending_save.is_empty():
				_press(scene.get_node("StartButton"), "new_game")
			else:
				_press(scene.get_node("ContinueButton"), "continue")
		"res://scenes/intro/intro.tscn":
			_press(scene.skip_button, "intro_skip")
		"res://scenes/class_select/class_select.tscn":
			_press(scene.card_buttons[role], "select_class")
			_press(scene.confirm_button, "confirm_class")
		SAVE.TABLE:
			if fixture_finished:
				_finish("victory", "")
				return true
			return _table(scene)
		BATTLE:
			_battle(scene)
		SAVE.REWARD:
			_reward(scene)
		END:
			if not state.run_failed and not state.boss_defeated:
				_finish("technical_blocker", "RunEnd without a real defeat or boss victory")
			else:
				_finish("defeat" if state.run_failed else "victory", state.run_end_reason)
			return true
		_:
			if scene.scene_file_path.begins_with("res://scenes/event/"):
				_event(scene)
			else:
				_finish("technical_blocker", "Unrecognized production route: " + scene.scene_file_path)
				return true
	return false


func _table(scene: Control) -> bool:
	if is_instance_valid(scene.fate_spread_overlay):
		_press(scene.fate_spread_overlay.close_button, "fate_milestone")
		return false
	if _is_enabled(scene.wager_accept_button):
		var accept: bool = strategy == "aggressive" or (strategy == "adaptive" and state.get_party_size() == 1 and state.cards_resolved > 4)
		_press(scene.wager_accept_button if accept else scene.wager_refuse_button, "wager", {"accepted": accept})
		return false
	if scene.selection_locked or scene.deal_in_progress:
		return false
	if state.wizard_meddling_consumed_slots.size() > known_meddles:
		known_meddles = state.wizard_meddling_consumed_slots.size()
		_log("meddling", {"slots": state.wizard_meddling_consumed_slots.duplicate(), "offers": state.current_offer_ids.duplicate()})
	if not pending_save.is_empty():
		var equal := pending_save == _snapshot()
		_log("save_continue_verified", {"equal": equal})
		pending_save.clear()
		if not equal:
			_finish("technical_blocker", "Continue changed the saved party, build, offers or progress")
			return true
	elif not result.get("resume_checked", false) and state.cards_resolved >= 1:
		var menu := root.get_node_or_null("RunMenu")
		var saved: bool = menu.checkpoint() if menu != null else SAVE.shared.write_slot(state, SAVE.TABLE)
		if not saved:
			_finish("technical_blocker", "Safe Table checkpoint failed")
			return true
		result.resume_checked = true
		pending_save = _snapshot()
		transition.call("change_to", MAIN)
		return false
	var offers: Array[Button] = scene.offer_buttons
	var chosen: Button
	var score := -10000
	for button in offers:
		if not _is_enabled(button):
			continue
		var card: RunCardData = scene._get_button_card(button)
		if card == null or state.is_card_held(card.card_id):
			continue
		var value := POLICY.card_score(card, strategy, state)
		if value > score:
			chosen = button
			score = value
	if chosen == null:
		return false
	var card: RunCardData = scene._get_button_card(chosen)
	if not state.fate_hold_used and state.cards_resolved in [1, 2, 3, 4] and offers.size() == 2:
		var other := offers[1 - offers.find(chosen)]
		var held: RunCardData = scene._get_button_card(other)
		if held != null and state.can_hold_offer_card(held.card_id):
			var button: Button = scene.hold_a_button if other == offers[0] else scene.hold_b_button
			if _press(button, "hold", {"card": held.card_id}):
				return false
	_press(chosen, "choose_card", {"card": card.card_id, "kind": card.resolution_type,
		"offers": state.current_offer_ids.duplicate(), "marked": state.wizard_mark_card_id})
	return false


func _event(scene: Node) -> void:
	var done := scene.get("continue_button") as Button
	if _is_enabled(done):
		_press(done, "continue_event", {"outcome": scene.get("presentation_action"),
			"roll_success": scene.get("presentation_roll_success")})
		return
	var options: Array[Button] = []
	var properties := ["accept_button", "pay_button", "leave_button"] if scene.has_method("_on_accept_gift") else ["choice_a", "choice_b", "choice_c", "leave_button"]
	for property: String in properties:
		var button := scene.get(property) as Button
		if _is_enabled(button):
			options.append(button)
	if options.is_empty():
		return
	var best: Button = options[0]
	var texts: Array[String] = []
	for button in options:
		var copy := _button_copy(button)
		texts.append(copy)
		if POLICY.event_score(copy, strategy, state) > POLICY.event_score(_button_copy(best), strategy, state):
			best = button
	_press(best, "event_choice", {"choice": _button_copy(best), "options": texts})


func _reward(scene: Control) -> void:
	var options: Array[String] = []
	var best: Button
	var best_score := -10000
	for i in range(scene.reward_buttons.size()):
		var button: Button = scene.reward_buttons[i]
		if not _is_enabled(button) or str(scene.option_ids[i]).is_empty():
			continue
		var id: String = scene.option_ids[i]
		options.append(id)
		var score := POLICY.reward_score(id, _button_copy(button), strategy, state)
		if score > best_score:
			best = button
			best_score = score
	if best != null:
		# Each reward stage may reuse the same buttons in the same scene.
		var mode: String = scene.reward_mode
		_press(best, "reward_" + mode, {"option": scene.option_ids[scene.reward_buttons.find(best)], "options": options})


func _begin_battle_log(battle: Control) -> void:
	connected.clear()
	battle_live_s = 0.0
	fight = {"encounter": battle.encounter.encounter_id, "slot": state.cards_resolved + 1, "start": _snapshot(),
		"damage_out": 0.0, "damage_in": 0.0, "hero_damage": {}, "deaths": [], "live_frames": 0,
		"plans": [], "phase_two": {}, "verdict": state.get_act1_reckoning_profile() if battle.encounter.encounter_id == "bone_warden" else ""}
	result.battles.append(fight)
	if battle.encounter.encounter_id == "bone_warden":
		result.boss_reached = true
		fight.opening_enemies = []
		for unit: BattleUnit in battle.units:
			if unit.team == 1:
				fight.opening_enemies.append({"role": unit.visual_role, "hp": unit.max_hp,
					"damage": unit.damage, "attack_interval": unit.attack_interval, "speed": unit.move_speed, "boss": unit.is_boss})


func _observe_units(battle: Control) -> void:
	for unit: BattleUnit in battle.units:
		if connected.has(unit.get_instance_id()):
			continue
		connected[unit.get_instance_id()] = true
		unit.diagnostic_damage.connect(_damage.bind(fight))
		unit.damage_received.connect(_received.bind(fight))
		unit.died.connect(_death.bind(fight))
		if unit.is_boss:
			unit.boss_enraged.connect(_phase_two.bind(fight, battle))


func _damage(attacker: BattleUnit, victim: BattleUnit, amount: float, log: Dictionary) -> void:
	if attacker.team == 0 and victim.team == 1:
		log.damage_out += amount
		var source := attacker.visual_role
		log.hero_damage[source] = log.hero_damage.get(source, 0.0) + amount


func _received(unit: BattleUnit, amount: float, log: Dictionary) -> void:
	if unit.team == 0:
		log.damage_in += amount


func _death(unit: BattleUnit, log: Dictionary) -> void:
	log.deaths.append({"role": unit.visual_role, "team": unit.team, "s": log.live_frames / 60.0})


func _phase_two(boss: BattleUnit, log: Dictionary, battle: Control) -> void:
	var enemies: Array[String] = []
	for unit: BattleUnit in battle.units:
		if unit.team == 1:
			enemies.append(unit.display_name)
	log.phase_two = {"hp_fraction": boss.hp / boss.max_hp, "attack_interval": boss.attack_interval,
		"damage": boss.damage, "speed": boss.move_speed, "actors": enemies,
		"reinforcements": enemies.slice(log.opening_enemies.size()), "at_s": battle.combat_elapsed}


func _battle(battle: Control) -> void:
	var controller: Node = battle.combat_plan_controller
	if battle.battle_finished:
		if not fight.has("won"):
			fight.won = state.last_battle_won
			fight.combat_s = maxf(battle_live_s, battle.combat_elapsed)
			fight.wave_count = battle.battle_wave_index
			fight.objective = battle.side_objective_id
			fight.objective_completed = not battle.side_objective_id.is_empty() and state.last_battle_won and not battle.side_objective_failed and (battle.side_objective_id != "bell_first" or battle.first_enemy_death_seen)
			fight.survivors = {}
			for unit: BattleUnit in battle.units:
				if unit.team == 0:
					fight.survivors[unit.visual_role] = [unit.hp, unit.max_hp]
			fight.journal = controller.histories.duplicate(true)
			for hero in controller.executors:
				fight.journal[hero] = fight.journal.get(hero, []) + controller.executors[hero].journal.duplicate(true)
			action_frame = frame
		if state.last_battle_won:
			_press(battle.continue_button, "battle_reward")
			fixture_finished = not fixture.is_empty()
		elif fixture.is_empty() and strategy != "defensive" and _is_enabled(battle.last_deal_accept_button):
			_press(battle.last_deal_accept_button, "last_deal_accept", {"price": state.get_last_deal_price_text()})
		else:
			_press(battle.last_deal_refuse_button, "last_deal_end", {"offered": state.last_deal_pending})
		return
	if controller == null or not controller.editable() or battle.fight_button.disabled:
		return
	var wave: int = battle.battle_wave_index + int(battle.wave_intermission)
	if fight.plans.size() >= wave:
		return
	var prep_ms := Time.get_ticks_msec()
	var recorded := {"wave": wave, "heroes": {}}
	for unit: BattleUnit in battle.units:
		if unit.team != 0 or not unit.alive or not controller.plans.has(unit.visual_role):
			continue
		POLICY.deploy(strategy, unit)
		var orders := POLICY.orders(strategy, unit, battle)
		controller.plans[unit.visual_role].orders.assign(orders)
		recorded.heroes[unit.visual_role] = {"orders": orders, "position": [unit.position.x, unit.position.y],
			"hp": unit.hp, "max_hp": unit.max_hp, "damage": unit.damage}
	recorded.preparation_ms = Time.get_ticks_msec() - prep_ms
	recorded.scene_frames = frame - scene_frame
	fight.plans.append(recorded)
	controller.start_planned_battle()
	action_frame = frame


func _observe_travel() -> void:
	var view := root.get_node_or_null("TravelTransition")
	if view == null or not view.get("available"):
		return
	if travel_id != view.get_instance_id():
		travel_id = view.get_instance_id()
		travel_frame = frame
		result.travels.append({"slot": state.cards_resolved, "context": view.context.duplicate(true), "skipped": false})
		action_frame = frame
	if strategy == "aggressive" and frame - travel_frame == 60 and _is_enabled(view.skip_button):
		_press(view.skip_button, "travel_skip")
		result.travels[-1].skipped = true


func _prepare_fixture() -> bool:
	state.reset_run()
	if not state.choose_protagonist(role):
		return false
	for candidate: String in ROLES:
		if candidate != role and state.get_party_size() < fixture_size:
			state.recruit_companion(candidate, "isolated Act 1 QA fixture")
	if fixture == "bone_warden":
		state.cards_resolved = 12
		match verdict:
			"witnessless":
				for candidate: String in ROLES:
					if candidate != role:
						state.lose_companion(candidate, "isolated Act 1 QA fixture")
			"scarred":
				for candidate: String in ROLES:
					if candidate != role:
						state.add_rescue_scar(candidate)
			"riskbound":
				state.wizard_wagers_accepted = 2
	# This is a labelled fixture. The campaign path never seeds offers or progression.
	state.active_card_id = fixture
	var card: RunCardData = state.get_card(fixture)
	if card == null or card.resolution_type != "combat":
		return false
	state.selected_encounter_path = card.target_path
	return change_scene_to_file(BATTLE) == OK


func _is_enabled(button: Button) -> bool:
	return is_instance_valid(button) and button.is_visible_in_tree() and not button.disabled


func _button_copy(button: Button) -> String:
	# Parchment presentation moves native Button text into a tooltip and labels.
	return button.tooltip_text if not button.tooltip_text.is_empty() else button.text


func _press(button: Button, action: String, details: Dictionary = {}) -> bool:
	if not _is_enabled(button):
		return false
	var key := "%s:%s:%s" % [button.get_instance_id(), action, _button_copy(button)]
	if clicked.has(key):
		return false
	clicked[key] = true
	_log(action, details)
	button.pressed.emit()
	return true


func _log(action: String, details: Dictionary = {}) -> void:
	result.actions.append({"action": action, "frame": frame, "state": _snapshot(), "details": details})
	action_frame = frame


func _snapshot() -> Dictionary:
	return {"slot": state.cards_resolved, "card": state.active_card_id, "party": state.party_roles.duplicate(),
		"gold": state.gold, "upgrades": state.hero_upgrade_ids.duplicate(), "extra_upgrades": state.extra_hero_upgrade_ids.duplicate(),
		"artifacts": state.artifact_ids.duplicate(), "events": state.event_outcomes.duplicate(true),
		"offers": state.current_offer_ids.duplicate(), "hp_bonus": state.party_hp_bonus, "damage_bonus": state.party_damage_bonus,
		"last_deal": state.last_deal_used, "jack": state.has_jack_companion(), "wizard_debt": state.wizard_debt_active,
		"fate_hold_used": state.fate_hold_used, "companions": {
			"knight": state.get_companion_fate("knight"), "ranger": state.get_companion_fate("ranger"),
			"mage": state.get_companion_fate("mage")}}


func _finish(outcome: String, reason: String) -> void:
	result.outcome = outcome
	result.reason = reason
	result.wall_s = (Time.get_ticks_msec() - started_ms) / 1000.0
	result.frames = frame
	result.final = _snapshot()
	result.final_scene = current_scene.scene_file_path if is_instance_valid(current_scene) else ""
	result.boss_defeated = state.boss_defeated
	result.final_slot_finished = SAVE.shared.read_slot(state).get("finished", false)
	var file := FileAccess.open(output.path_join("result.json"), FileAccess.WRITE)
	if file == null:
		push_error("Act 1 QA could not write result.json")
		quit(2)
		return
	file.store_string(JSON.stringify(result) + "\n")
	file.close()
	print("ACT1_QA_RESULT ", role, "/", strategy, "/", run_seed, " ", outcome, " slots=", state.cards_resolved, " battles=", result.battles.size())
	quit(1 if outcome in ["technical_blocker", "time_limit"] else 0)
