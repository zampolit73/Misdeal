extends Control

const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const HAZARDS := preload("res://scripts/battle/laboratory_hazards.gd")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/defiled_laboratory.tres")

var errors: Array[String] = []


func _ready() -> void:
	var headline := Label.new()
	headline.position = Vector2(80, 105)
	headline.size = Vector2(1120, 72)
	headline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	headline.add_theme_font_size_override("font_size", 27)
	add_child(headline)
	var details := Label.new()
	details.position = Vector2(110, 200)
	details.size = Vector2(1060, 400)
	details.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	details.add_theme_font_size_override("font_size", 20)
	add_child(details)
	_run_test()
	if errors.is_empty():
		_validate_dense_group_target()
	headline.text = "D152 / LAB HAZARDS — PASS" if errors.is_empty() else "D152 / LAB HAZARDS — FAIL"
	details.text = ("Телеграф, химические зоны, урон герою, гибель гомункула и очистка: PASS.\n"
		+ "Это изолированная логика, не боевой баланс и не проверка артов.\n"		+ "Проверен выбор химической зоны по плотной группе героев.\n"
		+ "Карта ещё не в колоде.") if errors.is_empty() else "\n".join(errors)
	details.add_theme_color_override("font_color", Color(0.65, 0.88, 0.65) if errors.is_empty() else Color(1.0, 0.4, 0.4))


func _make_unit(arena: Node2D, path: String, team_id: int, pos: Vector2) -> BattleUnit:
	var data := load(path) as UnitData
	if data == null:
		errors.append("Missing unit: " + path)
		return null
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.configure(data, team_id, pos)
	unit.set_process(false)
	arena.add_child(unit)
	return unit


func _run_test() -> void:
	if ENCOUNTER.encounter_id != "defiled_laboratory" or ENCOUNTER.get_formation_count() != 2:
		errors.append("Expected original two-formation laboratory encounter")
		return
	if RunState.ACT1_CARD_IDS.has("defiled_laboratory"):
		errors.append("D152 must remain outside production deck until original artwork and QA")
		return
	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var leader := _make_unit(arena, "res://resources/units/plague_alchemist.tres", 1, Vector2(700, 350))
	var minion := _make_unit(arena, "res://resources/units/unstable_homunculus.tres", 1, Vector2(350, 350))
	var hero := _make_unit(arena, "res://resources/units/knight.tres", 0, Vector2(350, 350))
	if leader == null or minion == null or hero == null:
		arena.free()
		return
	var controller := HAZARDS.new() as LaboratoryHazardController
	arena.add_child(controller)
	controller.configure(leader, [minion], [hero, leader, minion])
	controller.start_hazards()
	controller.set_process(false)
	controller.advance_battle(5.1)
	if controller.warnings != 1 or controller.phase != LaboratoryHazardController.WARNING:
		errors.append("First telegraph not emitted")
	controller.advance_battle(1.3)
	if controller.zones.size() != 1:
		errors.append("Warning did not create a timed hazard")
	var starting_hp := hero.hp
	controller.advance_battle(0.7)
	if hero.hp >= starting_hp or controller.pulses == 0:
		errors.append("Hero in area did not take hazard damage")
	minion.take_damage(10000.0)
	if controller.spills != 1:
		errors.append("Minion death did not create chemical spill")
	controller.stop_hazards()
	if controller.running or not controller.zones.is_empty():
		errors.append("Hazards not cleared after stop")
	arena.free()


# D152 local balance regression: clustered heroes, not merely the first
# party member, should be selected as a warning target.
func _validate_dense_group_target() -> void:
	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var leader: BattleUnit = _make_unit(arena, "res://resources/units/plague_alchemist.tres", 1, Vector2(900, 350))
	var isolated: BattleUnit = _make_unit(arena, "res://resources/units/knight.tres", 0, Vector2(750, 350))
	var grouped_a: BattleUnit = _make_unit(arena, "res://resources/units/ranger.tres", 0, Vector2(350, 350))
	var grouped_b: BattleUnit = _make_unit(arena, "res://resources/units/mage.tres", 0, Vector2(390, 350))
	if leader == null or isolated == null or grouped_a == null or grouped_b == null:
		errors.append("Could not load grouped heroes for target-regression fixture")
		arena.free()
		return
	var controller := HAZARDS.new() as LaboratoryHazardController
	arena.add_child(controller)
	controller.configure(leader, [], [isolated, grouped_a, grouped_b, leader])
	var target_position: Vector2 = controller._choose_target_position()
	if target_position.distance_to(grouped_a.position) > 0.1 and target_position.distance_to(grouped_b.position) > 0.1:
		errors.append("Lab hazard failed to prioritize clustered heroes over the isolated frontline hero")
	controller.stop_hazards()
	arena.free()
