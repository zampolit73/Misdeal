extends Node

# D268 QA ONLY: direct setup of unreleased #39, NOT an ordinary dealt card.
# Exercises the real Battle Fight -> Continue -> Reward claim -> Table route.
# Does not change or release ACT1_CARD_IDS or the card resource's target_path.
const BATTLE_SCENE := preload("res://scenes/battle/battle.tscn")
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const COURT_FLOOR := preload("res://scripts/battle/court_of_the_mute_floor.gd")
const CARD := "court_of_the_mute"
const ENCOUNTER_PATH := "res://resources/encounters/court_of_the_mute.tres"

# The headless renderer does not emit frame_post_draw. Emit ONLY in this
# external diagnostic; no changes to normal SceneRouter or gameplay.
func _process(_delta: float) -> void:
	if DisplayServer.get_name() == "headless":
		RenderingServer.frame_post_draw.emit()

func _ready() -> void:
	call_deferred("_exercise")

func _exercise() -> void:
	if RunState.ACT1_CARD_IDS.size() != 38 or RunState.ACT1_CARD_IDS.has(CARD):
		_fail("Court #39 must remain outside the 38/45 live card pool")
		return
	var card: RunCardData = RunState.get_card(CARD)
	if card == null or not card.target_path.is_empty():
		_fail("unreleased QA card missing or target_path prematurely enabled")
		return
	RunState.reset_run()
	if not RunState.choose_protagonist("knight"):
		_fail("could not set up Knight")
		return
	RunState.recruit_companion("ranger", "D268 Court QA route")
	RunState.recruit_companion("mage", "D268 Court QA route")
	RunState.active_card_id = CARD
	RunState.select_encounter(ENCOUNTER_PATH)
	RunState.combat_formation_by_card[CARD] = 1
	if RunState.selected_encounter_path != ENCOUNTER_PATH or RunState.get_active_card() == null:
		_fail("Court QA route failed to select authored encounter")
		return
	var host := get_tree().current_scene
	if host == null:
		_fail("current scene missing")
		return
	var battle := BATTLE_SCENE.instantiate() as Control
	if battle == null:
		_fail("real Battle packed scene missing")
		return
	host.add_child(battle)
	await get_tree().process_frame
	var court: CourtVerdictController = battle.get("court_verdict_controller") as CourtVerdictController
	if court == null or battle.get("black_lantern_light_controller") != null:
		_fail("missing Court verdict or leaked Black Lantern controller")
		return
	var plate := battle.get_node_or_null("BattleBackdrop")
	if plate == null or str(plate.get("arena_id")) != CARD:
		_fail("real Court battle did not select its unique QA tribunal plate")
		return
	var roles: Array[String] = []
	var actors: Array = battle.get("units")
	if actors.size() != 7:
		_fail("expected 3 heroes and 4 Court actors")
		return
	for item in actors:
		var actor := item as BattleUnit
		if actor == null or actor.combat_bounds != COURT_FLOOR.COMBAT_BOUNDS:
			_fail("non-BattleUnit or combat floor left locked D264 rectangle")
			return
		if actor.team == 1:
			roles.append(actor.visual_role)
			if actor.sprite_frames == null or actor.sprite_frames != LIBRARY.get_frames(actor.visual_role):
				_fail("Court enemy did not use actual D267 rich atlas: " + actor.visual_role)
				return
			for state in ["idle", "walk", "attack", "hit", "death"]:
				if not actor.sprite_frames.has_animation(state):
					_fail("missing Court original sprite state " + actor.visual_role + "/" + state)
					return
	roles.sort()
	if roles != ["ash_scrivener", "bone_bailiff", "bone_bailiff", "mute_magistrate"]:
		_fail("Court did not spawn original 3-role/4-actor encounter: %s" % [roles])
		return
	print("D268_COURT_QA_ROUTE_READY: unreleased card39; 4 rich original Court enemies, verdict, lower floor and QA backdrop")
	var fight := battle.get_node_or_null("FightButton") as Button
	if fight == null:
		_fail("FightButton missing")
		return
	fight.emit_signal("pressed")
	if not await _battle_result(battle):
		return
	var advance := battle.get_node_or_null("ContinueButton") as Button
	if advance == null or not advance.visible:
		_fail("Battle win did not expose Continue")
		return
	advance.emit_signal("pressed")
	var reward := await _wait_for_scene("res://scenes/reward/reward.tscn", 30.0)
	if reward == null:
		_fail("Court Battle did not navigate to actual Reward")
		return
	var chosen := 0
	var elapsed := 0.0
	while elapsed < 35.0:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
		if get_tree().current_scene != reward:
			break
		if chosen >= 3:
			continue
		var buttons: Array = reward.get("reward_buttons")
		var ids: Array = reward.get("option_ids")
		if buttons.is_empty() or ids.is_empty():
			continue
		var first := buttons[0] as Button
		if first != null and first.visible and not first.disabled and not str(ids[0]).is_empty():
			first.emit_signal("pressed")
			chosen += 1
			for _frame in range(35):
				await get_tree().process_frame
	var table := get_tree().current_scene
	if table == null or table.scene_file_path != "res://scenes/table/table.tscn":
		_fail("Court Reward claim failed to return to Table, claims %d" % chosen)
		return
	if not RunState.resolved_card_ids.has(CARD):
		_fail("QA Court card was not resolved by real reward route")
		return
	if RunState.ACT1_CARD_IDS.size() != 38 or RunState.ACT1_CARD_IDS.has(CARD):
		_fail("Court QA route unexpectedly released card #39")
		return
	print("D268_COURT_QA_ROUTE_PASS: direct QA card #39 -> real Battle Fight -> Reward -> Table; unchanged 38/45 live")
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
				_fail("Court trio/second formation lost QA smoke; not yet ready for release")
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
	push_error("D268_COURT_QA_ROUTE_FAIL: " + message)
	get_tree().quit(1)
