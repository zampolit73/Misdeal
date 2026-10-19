extends Control

# D259: this preflight requires the genuine game library, not QA overrides.
# It instantiates actual Battle and verifies all five original 25-pose roles.
const ROUTE_SCENE: PackedScene = preload("res://scenes/dev/black_lantern_d259_real_battle_route_qa.tscn")
const EXPECTED_ENEMIES := ["extinguished_guide", "lantern_bearer", "road_sentinel", "oil_acolyte", "lantern_archer"]
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const COUNTS := {"idle": 4, "walk": 6, "attack": 6, "hit": 3, "death": 6}

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
		_abort("genuine Battle was not added by D259 launcher")
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
		# This comparison proves the NORMAL BattleUnit._ready loader, not a
		# temporary D258 post-ready replacement, supplied every one of five.
		if actor.sprite_frames == null or actor.sprite_frames != LIBRARY.get_frames(actor.visual_role):
			_abort("game library frames not loaded: " + actor.visual_role)
			return
		for state in COUNTS.keys():
			if not actor.sprite_frames.has_animation(state) or actor.sprite_frames.get_frame_count(state) != int(COUNTS[state]):
				_abort("wrong original frame count in " + actor.visual_role + ":" + state)
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
	print("D259_REAL_BATTLE_PREFLIGHT_PASS: actual Battle has all 5 shared-library original sprites without overrides, trio, crossroads formation, D253 light, live 37/45")
	get_tree().quit(0)

func _abort(reason: String) -> void:
	push_error("D259_REAL_BATTLE_PREFLIGHT_FAIL: " + reason)
	get_tree().quit(1)
