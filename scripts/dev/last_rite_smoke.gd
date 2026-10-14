extends Control

# D151 source-only Last Rite regression: no registration in Act1 pool.
# Uses real BattleUnit instances and the real ritual controller, not mocks.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const LEADER: UnitData = preload("res://resources/units/funeral_priest.tres")
const BEARER: UnitData = preload("res://resources/units/pallbearer.tres")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/funeral_procession.tres")
const RITE: LastRiteData = preload("res://resources/encounters/last_rite.tres")
const CONTROLLER := preload("res://scripts/battle/last_rite.gd")

var title_label: Label
var status_label: Label
var failures: Array[String] = []


func _ready() -> void:
	title_label = Label.new()
	title_label.text = "DECK EXPANSION 03 / LAST RITE — TESTING"
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
	if RunState.ACT1_CARD_IDS.size() != 33 or RunState.ACT1_CARD_IDS.has("funeral_procession"):
		failures.append("Unfinished card must not be in the Act1 deal pool")
	var card := load("res://resources/cards/funeral_procession.tres") as RunCardData
	if card == null or card.card_id != "funeral_procession" or card.tier != 1 or card.resolution_type != "combat":
		failures.append("Missing unregistered D151 card Resource")
	if ENCOUNTER.get_formation_count() != 2 or ENCOUNTER.enemy_unit_paths.size() != 3:
		failures.append("Expected two formations with one original leader + two original bearers")
	if ENCOUNTER.enemy_unit_paths != PackedStringArray([
		"res://resources/units/funeral_priest.tres",
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
		title_label.text = "DECK EXPANSION 03 / LAST RITE — PASS"
		status_label.text = ("Ресурсы и состав 1+2 — OK.\n"
			+ "Первое воскрешение с 40% HP — OK.\n"
			+ "Повторного воскрешения нет — OK.\n"
			+ "Смерть лидера отменяет предупреждение — OK.\n"
			+ "Временный баф снимается без накопления — OK.\n"
			+ "Карта НЕ включена в обычную колоду до готовности артов.\n"
			+ "Это тест механики, НЕ сертификат игрового баланса.")
		status_label.add_theme_color_override("font_color", Color(0.56, 0.85, 0.66))
	else:
		title_label.text = "DECK EXPANSION 03 / LAST RITE — FAIL"
		status_label.text = "\n".join(failures)
		status_label.add_theme_color_override("font_color", Color(0.94, 0.33, 0.30))
		push_error(status_label.text)


func _fixture() -> Dictionary:
	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var leader := _unit(arena, LEADER, Vector2(800, 300))
	var a := _unit(arena, BEARER, Vector2(700, 270))
	var b := _unit(arena, BEARER, Vector2(710, 360))
	var controller := CONTROLLER.new() as LastRiteController
	arena.add_child(controller)
	var bearers: Array[BattleUnit] = [a, b]
	controller.configure(leader, bearers, RITE)
	return {"arena": arena, "leader": leader, "a": a, "b": b, "controller": controller}


func _unit(arena: Node2D, data: UnitData, pos: Vector2) -> BattleUnit:
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.configure(data, 1, pos)
	unit.set_process(false)
	arena.add_child(unit)
	return unit


func _close(fixture: Dictionary) -> void:
	(fixture["controller"] as LastRiteController).stop_rite()
	(fixture["arena"] as Node2D).queue_free()


func _case_revival_once() -> void:
	var f := _fixture()
	var leader := f["leader"] as BattleUnit
	var a := f["a"] as BattleUnit
	var b := f["b"] as BattleUnit
	var rite := f["controller"] as LastRiteController
	a.take_damage(a.max_hp + 10.0)
	rite.start_rite()
	rite.advance_battle(RITE.initial_delay + 0.1)
	if rite.phase != LastRiteController.TELEGRAPH or rite.warning_count != 1:
		failures.append("Ritual telegraph did not start")
	rite.advance_battle(RITE.telegraph_seconds + 0.1)
	if not a.alive or rite.revive_count != 1 or not rite.revival_spent:
		failures.append("First Pallbearer was not revived once")
	if absf(a.hp - a.max_hp * RITE.revive_hp_fraction) > 0.1:
		failures.append("Revive HP was not data-driven 40%")
	a.take_damage(a.max_hp + 10.0)
	rite.advance_battle(RITE.cooldown_seconds + 0.1)
	rite.advance_battle(RITE.telegraph_seconds + 0.1)
	if a.alive or rite.revive_count != 1:
		failures.append("Revive triggered twice; one-time limit broken")
	if not b.alive or not leader.alive or rite.fury_count < 1:
		failures.append("Subsequent ritual did not empower remaining bearer")
	_close(f)
	await get_tree().process_frame


func _case_cancelled_warning() -> void:
	var f := _fixture()
	var leader := f["leader"] as BattleUnit
	var a := f["a"] as BattleUnit
	var rite := f["controller"] as LastRiteController
	a.take_damage(a.max_hp + 10.0)
	rite.start_rite()
	rite.advance_battle(RITE.initial_delay + 0.1)
	leader.take_damage(leader.max_hp + 100.0)
	rite.advance_battle(RITE.telegraph_seconds + 0.1)
	if rite.phase != LastRiteController.IDLE or a.alive or rite.revive_count != 0 or rite.cancelled_count != 1:
		failures.append("Killed Priest still completed a ritual or cancellation counter wrong")
	_close(f)
	await get_tree().process_frame


func _case_fury_restore() -> void:
	var f := _fixture()
	var leader := f["leader"] as BattleUnit
	var a := f["a"] as BattleUnit
	var b := f["b"] as BattleUnit
	var rite := f["controller"] as LastRiteController
	var base_a := a.attack_interval
	var base_b := b.attack_interval
	rite.start_rite()
	rite.advance_battle(RITE.initial_delay + 0.1)
	rite.advance_battle(RITE.telegraph_seconds + 0.1)
	if rite.phase != LastRiteController.FURY or a.attack_interval >= base_a or b.attack_interval >= base_b:
		failures.append("Temporary fury not applied to living bearers")
	rite.advance_battle(RITE.fury_seconds + 0.1)
	if absf(a.attack_interval - base_a) > 0.0001 or absf(b.attack_interval - base_b) > 0.0001:
		failures.append("Fury cadence did not restore")
	rite.advance_battle(RITE.cooldown_seconds)
	rite.advance_battle(RITE.telegraph_seconds + 0.1)
	leader.take_damage(leader.max_hp + 100.0)
	if absf(a.attack_interval - base_a) > 0.0001 or absf(b.attack_interval - base_b) > 0.0001:
		failures.append("Death during second fury left permanent speed bonus")
	_close(f)
	await get_tree().process_frame
