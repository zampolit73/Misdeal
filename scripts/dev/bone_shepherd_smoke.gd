extends Control

# F6-only authentic Bone Shepherd art/ability/combat verification.
# Does NOT alter production run history or certify real Act 1 balance.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/bone_shepherd.tres")
const WHISTLE_DATA: BoneShepherdWhistleData = preload("res://resources/encounters/bone_shepherd_whistle.tres")
const CONTROLLER := preload("res://scripts/battle/bone_shepherd_whistle.gd")
const ART_LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")

const ROLES: Array[String] = ["knight", "ranger", "mage"]
const ORDERS: Array[String] = ["assault", "hunt", "formation"]
const STEP := 1.0 / 30.0
const MAX_TIME := 75.0
const COMBAT_BOUNDS := Rect2(Vector2(90, 284), Vector2(1080, 158))
const EXPECTED_PATHS: Array[String] = [
	"res://resources/units/bone_shepherd.tres",
	"res://resources/units/ossuary_lamb.tres",
	"res://resources/units/ossuary_lamb.tres",
]

var status: Label
var title_label: Label
var errors: Array[String] = []
var ended := 0
var wins := 0
var losses := 0
var whistle_activations := 0

func _ready() -> void:
	title_label = Label.new()
	title_label.text = "DECK EXPANSION 01 — RUNNING"
	title_label.position = Vector2(62, 110)
	title_label.size = Vector2(1156, 110)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 29)
	add_child(title_label)

	status = Label.new()
	status.position = Vector2(86, 208)
	status.size = Vector2(1108, 360)
	status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status.add_theme_font_size_override("font_size", 19)
	add_child(status)
	status.text = "Проверяем новые спрайты, свист и 54 реальных боя..."
	await _run_validation()

func _run_validation() -> void:
	_validate_resources()
	if errors.is_empty():
		await _verify_whistle_lifecycle(false)
	if errors.is_empty():
		await _verify_whistle_lifecycle(true)
	if errors.is_empty():
		for formation in range(2):
			for protagonist_idx in range(3):
				for size in range(1, 4):
					for order_id in ORDERS:
						seed(31000 + formation * 1000 + protagonist_idx * 100 + size * 10)
						var battle: Dictionary = await _fight_one(formation, protagonist_idx, size, order_id)
						if battle.is_empty():
							break
						ended += 1
						if battle["outcome"] == "win":
							wins += 1
						else:
							losses += 1
						whistle_activations += int(battle["whistles"])
						status.text = ("%d/54 боёв • %s • %d героя • %s\n"
							+ "Побед: %d | Поражений: %d\n"
							+ "Проверяем только завершение и механику, не идеальный баланс.") % [
							ended, ROLES[protagonist_idx], size, order_id, wins, losses
						]
						if not errors.is_empty():
							break
					if not errors.is_empty():
						break
				if not errors.is_empty():
					break
			if not errors.is_empty():
				break

	RunState.reset_run()
	if errors.is_empty() and ended != 54:
		errors.append("Expected 54 combats; completed %d" % ended)
	if errors.is_empty() and whistle_activations <= 0:
		errors.append("No real Shepherd's Whistles occurred in the 54 bouts")
	if errors.is_empty():
		title_label.text = "DECK EXPANSION 01 — PASS"
		status.text = ("%d/54 боёв завершено, %d побед / %d поражений.\n"
			+ "Новые враги и оригинальная карта загрузились.\n"
			+ "Свист: предупреждение, общий рывок, прекращение, смерть лидера — OK.\n"
			+ "Срабатываний в боях: %d.\n"
			+ "PASS не гарантирует баланс или готовность арта без визуальной проверки.") % [
			ended, wins, losses, whistle_activations
		]
		status.add_theme_color_override("font_color", Color(0.58, 0.85, 0.68))
	else:
		title_label.text = "DECK EXPANSION 01 — FAIL"
		status.text = "\n".join(errors.slice(0, 8))
		status.add_theme_color_override("font_color", Color(0.94, 0.38, 0.34))
		push_error(status.text)

func _validate_resources() -> void:
	var card := load("res://resources/cards/bone_shepherd.tres") as RunCardData
	if card == null or card.card_id != "bone_shepherd" or card.tier != 0:
		errors.append("New card data invalid")
		return
	if card.resolution_type != "combat" or card.target_path != "res://resources/encounters/bone_shepherd.tres":
		errors.append("New card must refer to original Shepherd encounter")
	if ENCOUNTER.enemy_unit_paths != PackedStringArray(EXPECTED_PATHS) or ENCOUNTER.reinforcement_unit_paths.size() != 0:
		errors.append("Original 1+2 roster is not preserved")
	if ENCOUNTER.get_formation_count() != 2 or ENCOUNTER.alternate_enemy_positions.size() != 3:
		errors.append("Expected two authored formations with the same roster")
	if RunState.ACT1_CARD_IDS.size() != 33 or not RunState.ACT1_CARD_IDS.has("bone_shepherd"):
		errors.append("Act 1 card registration should be 33 with both D149 events included")
	var art := ART_CATALOG.get_run_card_texture("bone_shepherd")
	if art == null or art.get_size() != Vector2(448, 274):
		errors.append("Original card illustration is missing/incorrect")
	for enemy_role in ["bone_shepherd", "ossuary_lamb"]:
		var frames := ART_LIBRARY.get_frames(enemy_role)
		if frames == null:
			errors.append("Missing original animation sheet: " + enemy_role)
			continue
		for pair in [["idle", 4], ["walk", 6], ["attack", 6], ["hit", 3], ["death", 6]]:
			if frames.get_frame_count(String(pair[0])) != int(pair[1]):
				errors.append("Sprite frame count invalid for %s %s" % [enemy_role, pair[0]])

func _make_unit(arena: Node2D, data: UnitData, team: int, pos: Vector2, order_id: String) -> BattleUnit:
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.configure(data, team, pos)
	if team == 0:
		unit.max_hp *= RunState.get_party_hp_multiplier()
		unit.damage *= RunState.get_party_damage_multiplier()
		unit.attack_interval *= RunState.get_party_attack_interval_multiplier()
		unit.move_speed *= RunState.get_party_move_speed_multiplier()
		unit.set_tactical_order(order_id)
	else:
		unit.max_hp *= RunState.get_enemy_hp_multiplier()
		unit.damage *= RunState.get_enemy_damage_multiplier()
	unit.set_combat_bounds(COMBAT_BOUNDS)
	unit.set_process(false)
	arena.add_child(unit)
	return unit

func _setup_fixture(formation: int, protagonist_idx: int, size: int, order_id: String) -> Dictionary:
	RunState.reset_run()
	RunState.choose_protagonist(ROLES[protagonist_idx])
	for teammate in range(1, size):
		var role: String = ROLES[(protagonist_idx + teammate) % 3]
		RunState.recruit_companion(role, "dev smoke")
	var arena := Node2D.new()
	# Test-only battlefield: no miniatures over the PASS/FAIL readout.
	arena.visible = false
	add_child(arena)
	var heroes: Array[BattleUnit] = []
	var enemies: Array[BattleUnit] = []
	var player_spawns := [Vector2(280, 340), Vector2(320, 411), Vector2(335, 305)]
	for i in range(RunState.party_roles.size()):
		var hero_data := RunState.get_hero_unit_data(RunState.party_roles[i])
		heroes.append(_make_unit(arena, hero_data, 0, player_spawns[i], order_id))
	var positions := ENCOUNTER.get_enemy_positions_for_formation(formation)
	for i in range(3):
		var enemy_data := load(ENCOUNTER.enemy_unit_paths[i]) as UnitData
		var depth: float = clampf((positions[i].y - 130.0) / 275.0, 0.0, 1.0)
		var projected := Vector2(positions[i].x, lerpf(316.0, 410.0, depth))
		enemies.append(_make_unit(arena, enemy_data, 1, projected, order_id))
	var lambs: Array[BattleUnit] = [enemies[1], enemies[2]]
	var controller := CONTROLLER.new() as BoneShepherdWhistleController
	arena.add_child(controller)
	controller.configure(enemies[0], lambs, WHISTLE_DATA)
	controller.set_process(false)
	return {"arena": arena, "heroes": heroes, "enemies": enemies, "controller": controller}

func _verify_whistle_lifecycle(kill_during_rush: bool) -> void:
	var scene := _setup_fixture(0, 0, 3, "assault")
	var leader: BattleUnit = scene["enemies"][0]
	var lamb: BattleUnit = scene["enemies"][1]
	var controller: BoneShepherdWhistleController = scene["controller"]
	controller.start_whistle()
	controller.set_process(false)
	controller.advance_battle(5.49)
	if controller.phase != controller.WAITING or controller.warning_count != 0:
		errors.append("Whistle started before 5.5 active seconds")
	controller.advance_battle(0.02)
	if controller.phase != controller.TELEGRAPH or controller.warning_count != 1:
		errors.append("Whistle warning missing at 5.5 seconds")
	controller.advance_battle(0.66)
	if controller.phase != controller.RUSH or controller.rush_count != 1 or lamb.shepherd_rush_speed_multiplier < 1.34:
		errors.append("Whistle did not order both lambs into 1.35x rush")
	if kill_during_rush:
		leader.take_damage(9999)
		if controller.phase != controller.RUSH:
			errors.append("Issued rush stopped instantly when Shepherd died")
		controller.advance_battle(1.26)
		if controller.phase != controller.IDLE or controller.expiry_count != 1:
			errors.append("Issued rush did not expire after Shepherd death")
	else:
		controller.advance_battle(1.26)
		if controller.phase != controller.WAITING or lamb.shepherd_rush_speed_multiplier != 1.0:
			errors.append("Whistle did not reset target and speed after 1.25 seconds")
		controller.advance_battle(6.76)
		if controller.warning_count != 2 or controller.phase != controller.TELEGRAPH:
			errors.append("Whistle cooldown failed to repeat after 8s from rush")
		leader.take_damage(9999)
		if controller.phase != controller.IDLE:
			errors.append("Leader death during warning did not cancel charge")
	controller.stop_whistle()
	(scene["arena"] as Node2D).queue_free()
	await get_tree().process_frame

func _fight_one(formation: int, protagonist_idx: int, size: int, order_id: String) -> Dictionary:
	var scene := _setup_fixture(formation, protagonist_idx, size, order_id)
	var heroes: Array[BattleUnit] = scene["heroes"]
	var enemies: Array[BattleUnit] = scene["enemies"]
	var controller: BoneShepherdWhistleController = scene["controller"]
	var all_units: Array[BattleUnit] = []
	all_units.append_array(heroes)
	all_units.append_array(enemies)
	for unit in all_units:
		unit.start_combat()
	controller.start_whistle()
	controller.set_process(false)
	var elapsed := 0.0
	var frames := 0
	var verdict := ""
	while elapsed < MAX_TIME:
		for unit in all_units:
			if unit.alive:
				unit._process(STEP)
		controller.advance_battle(STEP)
		elapsed += STEP
		frames += 1
		var living_heroes := 0
		var living_enemies := 0
		for unit in all_units:
			if unit.alive:
				if unit.team == 0:
					living_heroes += 1
				else:
					living_enemies += 1
		if living_enemies == 0:
			verdict = "win"
			break
		if living_heroes == 0:
			verdict = "loss"
			break
		if frames % 90 == 0:
			await get_tree().process_frame
	if verdict.is_empty():
		errors.append("Timeout: formation %d / %s / %d heroes / %s" % [formation, ROLES[protagonist_idx], size, order_id])
	var activations: int = controller.rush_count
	controller.stop_whistle()
	(scene["arena"] as Node2D).queue_free()
	await get_tree().process_frame
	if verdict.is_empty():
		return {}
	return {"outcome": verdict, "whistles": activations}
