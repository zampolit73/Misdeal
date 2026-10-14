extends Control

# D151 source-only Grave Toll regression: no registration in Act1 pool.
# Uses real BattleUnit instances and the real ritual controller, not mocks.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const LEADER: UnitData = preload("res://resources/units/mourning_sexton.tres")
const BEARER: UnitData = preload("res://resources/units/pallbearer.tres")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/mourning_bell.tres")
const TOLL: GraveTollData = preload("res://resources/encounters/grave_toll.tres")
const CONTROLLER := preload("res://scripts/battle/grave_toll.gd")

var title_label: Label
var status_label: Label
var failures: Array[String] = []


func _ready() -> void:
	title_label = Label.new()
	title_label.text = "DECK EXPANSION 03 / GRAVE TOLL — TESTING"
	title_label.position = Vector2(82.0, 120.0)
	title_label.size = Vector2(1110.0, 72.0)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 28)
	add_child(title_label)
	status_label = Label.new()
	status_label.position = Vector2(100.0, 240.0)
	status_label.size = Vector2(1080.0, 300.0)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size", 19)
	add_child(status_label)
	call_deferred("_check_all")


func _check_all() -> void:
	if RunState.ACT1_CARD_IDS.size() != 33 or RunState.ACT1_CARD_IDS.has("mourning_bell"):
		failures.append("Unfinished card must not be in the Act1 deal pool")
	var card := load("res://resources/cards/mourning_bell.tres") as RunCardData
	if card == null or card.card_id != "mourning_bell" or card.tier != 1 or card.resolution_type != "combat":
		failures.append("Missing unregistered D151 card Resource")
	if ENCOUNTER.get_formation_count() != 2 or ENCOUNTER.enemy_unit_paths.size() != 3:
		failures.append("Expected two formations with one original leader + two original bearers")
	if ENCOUNTER.enemy_unit_paths != PackedStringArray([
		"res://resources/units/mourning_sexton.tres",
		"res://resources/units/pallbearer.tres",
		"res://resources/units/pallbearer.tres",
	]):
		failures.append("D151 encounter roster unexpectedly changed")
	if failures.is_empty():
		await _case_revival_once()
	if failures.is_empty():
		await _case_cancelled_warning()
	if failures.is_empty():
		await _case_fury_restore()

	if failures.is_empty():
		title_label.text = "DECK EXPANSION 03 / GRAVE TOLL — PASS"
		status_label.text = ("Ресурсы и состав 1+2 — OK.\\n"
			+ "Первое воскрешение с 40% HP — OK.\\n"
			+ "Повторного воскрешения нет — OK.\\n"
			+ "Смерть лидера отменяет предупреждение — OK.\\n"
			+ "Временный баф снимается без накопления — OK.\\n"
			+ "Карта НЕ включена в обычную колоду до готовности артов.\\n"
			+ "Это тест механики, НЕ сертификат игрового баланса.")
		status_label.add_theme_color_override("font_color", Color(0.56, 0.85, 0.66))
	else:
		title_label.text = "DECK EXPANSION 03 / GRAVE TOLL — FAIL"
		status_label.text = "\\n".join(failures)
		status_label.add_theme_color_override("font_color", Color(0.94, 0.33, 0.30))
		push_error(status_label.text)


func _fixture() -> Dictionary:
	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var leader := _unit(arena, LEADER, Vector2(800, 300))
	var a := _unit(arena, BEARER, Vector2(700, 270))
	var b := _unit(arena, BEARER, Vector2(710, 360))
	var controller := CONTROLLER.new() as GraveTollController
	arena.add_child(controller)
	var bearers: Array[BattleUnit] = [a, b]
	controller.configure(leader, bearers, TOLL)
	return {"arena": arena, "leader": leader, "a": a, "b": b, "controller": controller}


func _unit(arena: Node2D, data: UnitData, pos: Vector2) -> BattleUnit:
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.configure(data, 1, pos)
	unit.set_process(false)
	arena.add_child(unit)
	return unit


func _close(fixture: Dictionary) -> void:
	(fixture["controller"] as GraveTollController).stop_toll()
	(fixture["arena"] as Node2D).queue_free()


func _case_revival_once() -> void:
	var f := _fixture()
	var leader := f["leader"] as BattleUnit
	var a := f["a"] as BattleUnit
	var b := f["b"] as BattleUnit
	var toll := f["controller"] as GraveTollController
	a.take_damage(a.max_hp + 10.0)
	toll.start_toll()
	toll.advance_battle(TOLL.initial_delay + 0.1)
	if toll.phase != GraveTollController.TELEGRAPH or toll.warning_count != 1:
		failures.append("Ritual telegraph did not start")
	toll.advance_battle(TOLL.telegraph_seconds + 0.1)
	if not a.alive or toll.revive_count != 1 or not toll.revival_spent:
		failures.append("First Pallbearer was not revived once")
	if absf(a.hp - a.max_hp * TOLL.revive_hp_fraction) > 0.1:
		failures.append("Revive HP was not data-driven 40%")
	a.take_damage(a.max_hp + 10.0)
	toll.advance_battle(TOLL.cooldown_seconds + 0.1)
	toll.advance_battle(TOLL.telegraph_seconds + 0.1)
	if a.alive or toll.revive_count != 1:
		failures.append("Revive triggered twice; one-time limit broken")
	if not b.alive or not leader.alive or toll.fury_count < 1:
		failures.append("Subsequent bell did not empower remaining bearer")
	_close(f)
	await get_tree().process_frame


func _case_cancelled_warning() -> void:
	var f := _fixture()
	var leader := f["leader"] as BattleUnit
	var a := f["a"] as BattleUnit
	var toll := f["controller"] as GraveTollController
	a.take_damage(a.max_hp + 10.0)
	toll.start_toll()
	toll.advance_battle(TOLL.initial_delay + 0.1)
	leader.take_damage(leader.max_hp + 100.0)
	toll.advance_battle(TOLL.telegraph_seconds + 0.1)
	if toll.phase != GraveTollController.IDLE or a.alive or toll.revive_count != 0 or toll.cancelled_count != 1:
		failures.append("Killed Sexton still completed a ritual or cancellation counter wrong")
	_close(f)
	await get_tree().process_frame


func _case_fury_restore() -> void:
	var f := _fixture()
	var leader := f["leader"] as BattleUnit
	var a := f["a"] as BattleUnit
	var b := f["b"] as BattleUnit
	var toll := f["controller"] as GraveTollController
	var base_a := a.attack_interval
	var base_b := b.attack_interval
	toll.start_toll()
	toll.advance_battle(TOLL.initial_delay + 0.1)
	toll.advance_battle(TOLL.telegraph_seconds + 0.1)
	if toll.phase != GraveTollController.FURY or a.attack_interval >= base_a or b.attack_interval >= base_b:
		failures.append("Temporary fury not applied to living bearers")
	toll.advance_battle(TOLL.fury_seconds + 0.1)
	if absf(a.attack_interval - base_a) > 0.0001 or absf(b.attack_interval - base_b) > 0.0001:
		failures.append("Fury cadence did not restore")
	toll.advance_battle(TOLL.cooldown_seconds)
	toll.advance_battle(TOLL.telegraph_seconds + 0.1)
	leader.take_damage(leader.max_hp + 100.0)
	if absf(a.attack_interval - base_a) > 0.0001 or absf(b.attack_interval - base_b) > 0.0001:
		failures.append("Death during second fury left permanent speed bonus")
	_close(f)
	await get_tree().process_frame
