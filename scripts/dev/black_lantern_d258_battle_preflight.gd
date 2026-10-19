extends Control

# D258 headless integration smoke: starts the REAL Battle for the unreleased
# five-role card through the D258 QA launcher, and inspects its instantiated
# BattleUnit sprites and D253 lanternlight. This deliberately stops BEFORE
# user Fight/reward, which still require native end-to-end QA.
const ROUTE_SCENE: PackedScene = preload("res://scenes/dev/black_lantern_d258_real_battle_route_qa.tscn")
const EXPECTED_ENEMIES := ["extinguished_guide", "lantern_bearer", "road_sentinel", "oil_acolyte", "lantern_archer"]
const STAGED_D257 := ["extinguished_guide", "oil_acolyte", "lantern_archer"]

func _ready() -> void:
	call_deferred("_test_real_battle")

func _test_real_battle() -> void:
	var launcher := ROUTE_SCENE.instantiate() as Control
	if launcher == null:
		_abort("launcher failed to instantiate")
		return
	add_child(launcher)
	await get_tree().process_frame
	var party_picker := launcher.get("party_picker") as OptionButton
	var formation_picker := launcher.get("formation_picker") as OptionButton
	if party_picker == null or formation_picker == null:
		_abort("real route selector missing")
		return
	party_picker.select(2) # 3 heroes
	formation_picker.select(1) # Crossroads, second authored formation
	launcher.call("_launch_real_battle")
	await get_tree().process_frame
	var battle: Control = null
	for child in launcher.get_children():
		if child is Control and child.scene_file_path == "res://scenes/battle/battle.tscn":
			battle = child as Control
			break
	if battle == null:
		_abort("genuine Battle was not added by D258 launcher")
		return
	var actual_units: Array = battle.get("units")
	if actual_units.size() != 8:
		_abort("expected 3 heroes + 5 enemies; found %d" % actual_units.size())
		return
	var seen: Array[String] = []
	var heroes: int = 0
	for entry in actual_units:
		var actor := entry as BattleUnit
		if actor == null:
			_abort("non-BattleUnit in real Battle")
			return
		if actor.team == 0:
			heroes += 1
			continue
		seen.append(actor.visual_role)
		if STAGED_D257.has(actor.visual_role):
			if actor.sprite_frames == null:
				_abort("D257 rich frames not injected: " + actor.visual_role)
				return
			for state in ["idle", "walk", "attack", "hit", "death"]:
				if not actor.sprite_frames.has_animation(state):
					_abort("missing " + state + " in " + actor.visual_role)
					return
			if actor.sprite_frames.get_frame_count("walk") != 6 or actor.sprite_frames.get_frame_count("attack") != 6:
				_abort("missing original walk/attack poses for " + actor.visual_role)
				return
	if heroes != 3:
		_abort("hero party size incorrect")
		return
	var ordered_expected: Array[String] = []
	ordered_expected.assign(EXPECTED_ENEMIES)
	seen.sort()
	ordered_expected.sort()
	if seen != ordered_expected:
		_abort("five original enemy roles mismatch")
		return
	var lantern: BlackLanternLightController = battle.get("black_lantern_light_controller") as BlackLanternLightController
	if lantern == null:
		_abort("real D253 lanternlight controller missing")
		return
	if RunState.ACT1_CARD_IDS.size() != 37 or RunState.ACT1_CARD_IDS.has("black_lantern_road"):
		_abort("test illegally released #38")
		return
	if int(RunState.combat_formation_by_card.get("black_lantern_road", -1)) != 1:
		_abort("second formation lost in real Battle")
		return
	print("D258_REAL_BATTLE_PREFLIGHT_PASS: actual Battle created, trio + five original D257/D244/D224 roles, formation 1, D253 light ready, live deck 37/45")
	get_tree().quit(0)

func _abort(reason: String) -> void:
	push_error("D258_REAL_BATTLE_PREFLIGHT_FAIL: " + reason)
	get_tree().quit(1)
