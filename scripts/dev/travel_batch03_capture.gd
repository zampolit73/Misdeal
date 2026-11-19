extends SceneTree
## Uses the live events and the real SceneRouter. The output is review evidence.
const BATCH := preload("res://scripts/travel/batch_03_catalog.gd")
const QA := preload("res://scripts/dev/travel_batch03_playtest.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const HUB := preload("res://scripts/dev/qa_hub_catalog.gd")
const EVENT := "res://scenes/event/act_choice.tscn"
const WELL := "res://scenes/event/whispering_well.tscn"
const TABLE := "res://scenes/table/table.tscn"
const RECRUIT := {"black_altar": "mage", "last_camp": "knight", "chained_prisoner": "knight",
	"ash_rest": "ranger", "whispering_well": "mage"}
const FILL_RELICS := ["chains_empty", "reveal_relic_empty", "scarred_empty", "empty_kept", "empty_plain", "pay_upgrade", "pay_refund"]
const FILL_UPGRADES := ["reveal_upgrade_empty", "riskbound_empty", "pay_refund"]

var _state: Node
var _dest := ""
var _render := false

func _initialize() -> void:
	call_deferred("run")

func _prepare(id: String, action: String, party: String, index: int) -> void:
	_state.reset_run()
	var recruit: String = RECRUIT.get(id, "")
	var wants_recruit := party.begins_with("+") or party.ends_with(" lost")
	var protagonist: String = "ranger" if id == "jack" else BATCH.ROLES[index % 3]
	if wants_recruit and protagonist == recruit:
		protagonist = "mage" if recruit == "knight" else "knight"
	_state.choose_protagonist(protagonist)
	if not recruit.is_empty() and not wants_recruit:
		if index % 2 == 0 or action == recruit or id == "whispering_well":
			_state.recruit_companion(recruit, "QA")
		else:
			_state.lose_companion(recruit, "QA")
	if action in BATCH.ROLES and action not in _state.party_roles:
		_state.recruit_companion(action, "QA")
	_state.gold = 200
	_state.active_card_id = id
	if action == "witnessless":
		for role in BATCH.ROLES:
			_state.lose_companion(role, "QA")
	if action.begins_with("scarred"):
		_state.add_rescue_scar("knight")
		_state.add_rescue_scar("ranger")
	if action.begins_with("riskbound"):
		_state.wizard_wagers_accepted = 2
	if action == "bribe_scar":
		_state.add_rescue_scar("ranger")
	if action == "scar":
		_state.add_rescue_scar("knight")
	if action == "burn_debt":
		_state.wizard_debt_active = true
	if action.ends_with("_kept"):
		_state.set_event_outcome("moon_seal", "kept")
	if id == "last_camp" and action == "rescue_gold":
		_state.record_castle_fact(_state.CASTLE_FACT_MARCH, "ash_rest")
	if id == "bone_tax" and action == "gold":
		_state.record_castle_fact(_state.CASTLE_FACT_RATIONS, "dead_rations")
	if action != "pay_refund":
		_fill_pools(action)

func _fill_pools(action: String) -> void:
	if action in FILL_RELICS:
		for id in _state.get_available_artifact_ids():
			_state.add_artifact(id)
	if action in FILL_UPGRADES:
		while not _state.add_extra_upgrade_to_least_developed_role().is_empty():
			pass

func _button(event: Node, id: String, choice: String) -> Button:
	if id == "whispering_well":
		return {"accept": event.accept_button, "pay": event.pay_button, "leave": event.leave_button}[choice]
	if choice == "leave":
		return event.leave_button
	for button in event.find_children("*", "Button", true, false):
		for connection in button.get_signal_connection_list("pressed"):
			var call: Callable = connection.callable
			if call.get_method() == "_resolve_" + id and call.get_bound_arguments() == [choice]:
				return button
	return null

func _seed_reveal(action: String) -> void:
	var target := 0 if action == "reveal_gold" else (1 if action.begins_with("reveal_relic") else 2)
	for candidate in range(100):
		seed(candidate)
		if randi_range(0, 2) == target:
			seed(candidate)
			return
	assert(false, "RNG fixture missing")

func _wait_for(path: String, overlay: bool) -> CanvasLayer:
	var deadline := Time.get_ticks_msec() + 15000
	while Time.get_ticks_msec() < deadline:
		var view := root.get_node_or_null("TravelTransition") as CanvasLayer
		if overlay and view != null:
			return view
		if not overlay and current_scene != null and current_scene.scene_file_path == path and view == null:
			var transition := root.get_node_or_null("SceneTransition")
			if transition == null or not bool(transition.get("_busy")):
				return null
		await process_frame
	push_error("Batch 03 route timed out: " + path)
	quit(1)
	return null

func _economy() -> Array:
	return [_state.gold, _state.party_hp_bonus, _state.party_damage_bonus,
		_state.party_roles.duplicate(), _state.artifact_ids.duplicate(), _state.hero_upgrade_ids.duplicate(),
		_state.wizard_debt_active, _state.cards_resolved, _state.whispering_well_resolved,
		_state.rescue_scar_roles.duplicate()]

func _check_effect(id: String, action: String, before: Array, after: Array) -> void:
	var gold := {
		"black_altar": {"rescue_gold": -35, "abandon_loot": 40},
		"chained_prisoner": {"loot_recruitment": 25, "mentor": -25, "chains_empty": 35, "loot": 25},
		"jack": {"recruited": -25},
		"whispering_well": {"rescue_gold": -25, "pay_relic": -25, "pay_upgrade": -25},
		"last_camp": {"rescue_gold": -30, "abandon_loot": 40},
		"ash_rest": {"loot": 20},
		"bone_tax": {"gold": -20},
		"faceless_card": {"reveal_gold": 60, "reveal_relic_empty": 35, "reveal_upgrade_empty": 35,
			"bribe": -30, "bribe_scar": -15, "burn_gold": 20, "witnessless": 50, "scarred_empty": 35, "riskbound_empty": 35},
		"moon_seal": {"keep": 10, "sell": 30},
		"echo_crypt": {"empty_kept": 35, "empty_plain": 35, "gold_kept": 40, "gold_plain": 25},
	}
	var hp := {
		"black_altar": {"knight": -20, "ranger": -15, "mage": -20},
		"chained_prisoner": {"chains_relic": -15, "chains_empty": -15, "loot": -10},
		"whispering_well": {"gift_upgrade": -15},
		"bone_tax": {"blood": -15, "force": -25},
		"moon_seal": {"burn": -10},
		"echo_crypt": {"relic_forced": -15, "listen_kept": -5, "listen_plain": -15},
	}
	assert(int(after[0]) - int(before[0]) == int(gold.get(id, {}).get(action, 0)), id + ":" + action + " gold")
	assert(is_equal_approx(float(after[1]) - float(before[1]), float(hp.get(id, {}).get(action, 0))), id + ":" + action + " HP")
	var damage := 1.5 if id == "echo_crypt" and action.begins_with("listen") else (1.0 if id == "moon_seal" and action == "burn" else 0.0)
	assert(is_equal_approx(float(after[2]) - float(before[2]), damage))
	var expected_artifact := action in ["chains_relic", "pay_relic", "reveal_relic", "scarred_relic", "relic_kept", "relic_forced"]
	assert(after[4].size() == before[4].size() + int(expected_artifact))
	var expected_upgrade := action in BATCH.ROLES or action in ["mentor", "gift_upgrade", "pay_upgrade", "force", "bribe", "bribe_scar", "reveal_upgrade", "riskbound_upgrade"]
	assert(after[5].size() == before[5].size() + int(expected_upgrade))
	assert(not after[6] and int(after[7]) == 1)
	assert(bool(after[8]) == (id == "whispering_well"))
	var scars := action == "rescue_blood" or (action == "recruit" and id in ["ash_rest", "chained_prisoner"])
	assert(after[9].size() == before[9].size() + int(scars))

func _check_frame(view: CanvasLayer, context: Dictionary, time: float) -> void:
	view.elapsed = time
	view.update_frame()
	var state := BATCH.action_for(context.resolved_card_id, context.visual_action, context.party_roles)
	var scene := BATCH.scene_for(context.resolved_card_id)
	var has_join: bool = str(state.party).begins_with("+")
	var waiting: bool = has_join and time < float(scene.handoff[1])
	var expected_count: int = context.party_roles.size() + int(context.jack_companion) - int(waiting)
	assert(view.role_ids == context.party_roles)
	assert(view.panorama.actor_metrics.size() == expected_count)
	for i in range(view.actors.size()):
		var actor: AnimatedSprite2D = view.actors[i]
		if actor.visible:
			var sole: float = view.panorama.soles[view.role_ids[i]][actor.frame]
			assert(is_equal_approx(actor.position.y + (sole - 48.0) * actor.scale.y, view.contacts[i].y))
			assert(actor.get_index() > view.ground_fx.get_index() and actor.get_index() < view.panorama.planes.Foreground.get_index())

func run() -> void:
	_render = DisplayServer.get_name() != "headless"
	_dest = OS.get_cmdline_user_args()[0] if not OS.get_cmdline_user_args().is_empty() else "res://.tmp/batch03"
	DirAccess.make_dir_recursive_absolute(_dest)
	Engine.time_scale = 10.0
	_state = root.get_node("RunState")
	var cases := QA.cases()
	var counted := 0
	for entry in HUB.entries():
		if entry.get("batch") == 3:
			counted += int(entry.case_count)
	assert(counted == 72 and cases.size() == 72)
	for index in range(cases.size()):
		var id: String = cases[index][0]
		var action: String = cases[index][1]
		var state: Dictionary = BATCH.scene_for(id).states[action]
		_prepare(id, action, state.party, index)
		var event_path := WELL if id == "whispering_well" else EVENT
		change_scene_to_file(event_path)
		await _wait_for(event_path, false)
		var event := current_scene
		var button := _button(event, id, state.choice)
		assert(button != null and not button.disabled, id + ":" + action + " button unavailable")
		if action == "pay_refund":
			_fill_pools(action)
		var before := _economy()
		if action.begins_with("reveal_"):
			_seed_reveal(action)
		button.pressed.emit()
		var result := _economy()
		button.pressed.emit()
		assert(_economy() == result, "Repeated button must preserve result")
		if id != "whispering_well":
			assert(event.travel_context.get("visual_action") == action, id + ":" + action)
			event.continue_button.pressed.emit()
			event.continue_button.pressed.emit()
		var view := await _wait_for("", true)
		assert(view != null and view.available, id + ":" + action + " panorama unavailable")
		view.set_process(false)
		assert(view.context.visual_action == action)
		assert(view.context.party_roles == _state.party_roles)
		assert(bool(view.context.jack_companion) == _state.has_jack_companion())
		var after := _economy()
		_check_effect(id, action, before, after)
		for time in [0.65, 1.15, 2.50, 3.55]:
			_check_frame(view, view.context, time)
			if _render:
				await RenderingServer.frame_post_draw
				if time in [0.65, 1.15, 2.50]:
					var file := _dest.path_join("%02d_%s_%s_%03d.jpg" % [index + 1, id, action, roundi(time * 100)])
					assert(root.get_texture().get_image().save_jpg(file, 0.91) == OK)
			assert(_economy() == after)
		paused = true
		var clock: float = view.elapsed
		view._process(0.9)
		assert(view.elapsed == clock)
		paused = false
		if index % 3 == 0:
			var skip := InputEventKey.new()
			skip.pressed = true
			skip.keycode = KEY_ESCAPE
			view._input(skip)
			view._input(skip)
		elif index % 3 == 1:
			view.skip_button.pressed.emit()
			view.skip_button.pressed.emit()
		else:
			view.elapsed = 3.97
			view.set_process(true)
		await _wait_for(TABLE, false)
		assert(_economy() == after)
		var save := SAVE.new()
		var snapshot: Dictionary = save.snapshot(_state)
		assert(save.validate(snapshot, _state))
		assert(not snapshot.state.has("visual_action") and not snapshot.state.has("batch_03_action"))
		assert(save.apply_slot(_state, snapshot))
		change_scene_to_file(TABLE)
		await process_frame
		await process_frame
		assert(not root.has_node("TravelTransition") and _economy() == after)
		print("BATCH03_ROUTE_PASS: " + id + ":" + action)
	print("BATCH03_NATIVE_PASS: %d/%d live Event → Travel → Table routes" % [cases.size(), cases.size()])
	quit(0)
