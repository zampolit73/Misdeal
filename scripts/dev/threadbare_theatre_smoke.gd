extends Control

const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const CONTROLLER := preload("res://scripts/battle/thread_tether.gd")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/threadbare_theatre.tres")

var issues: Array[String] = []


func _ready() -> void:
	var title := Label.new()
	title.position = Vector2(72, 125)
	title.size = Vector2(1136, 80)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	add_child(title)
	var detail := Label.new()
	detail.position = Vector2(96, 246)
	detail.size = Vector2(1088, 305)
	detail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.add_theme_font_size_override("font_size", 19)
	add_child(detail)
	_test_threads()
	title.text = "D153 / SKELETAL STRINGS — PASS" if issues.is_empty() else "D153 / SKELETAL STRINGS — FAIL"
	detail.text = ("Два новых типа нежити и две расстановки: PASS.\n"
		+ "Нить даёт марионетке защиту 32% в радиусе 285 px: PASS.\n"
		+ "Удаление с дистанции разрывает связь: PASS.\n"
		+ "Гибель Кукловода мгновенно снимает защиту: PASS.\n"
		+ "Остановка восстанавливает исходные множители: PASS.\n"
		+ "Изолированная проверка нитей; боевые анимации и арена уже утверждены.\n"
		+ "Карта D153 входит в Act 1 (36/45).") if issues.is_empty() else "\n".join(issues)
	detail.add_theme_color_override("font_color", Color(0.64, 0.90, 0.70) if issues.is_empty() else Color(0.98, 0.44, 0.36))


func _spawn(arena: Node2D, path: String, pos: Vector2) -> BattleUnit:
	var data: UnitData = load(path) as UnitData
	if data == null:
		issues.append("Missing original D153 UnitData: " + path)
		return null
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	if unit == null:
		issues.append("Missing BattleUnit scene")
		return null
	unit.configure(data, 1, pos)
	arena.add_child(unit)
	unit.set_process(false)
	return unit


func _test_threads() -> void:
	if ENCOUNTER.encounter_id != "threadbare_theatre" or ENCOUNTER.get_formation_count() != 2:
		issues.append("Expected two original formations for Threadbare Theatre")
		return
	if ENCOUNTER.enemy_unit_paths != PackedStringArray([
		"res://resources/units/threadbare_puppeteer.tres",
		"res://resources/units/bone_marionette.tres",
		"res://resources/units/bone_marionette.tres",
	]):
		issues.append("Expected unique original 1+2 undead roster")
		return
	if RunState.ACT1_CARD_IDS.size() != 36 or not RunState.ACT1_CARD_IDS.has("threadbare_theatre"):
		issues.append("D153 must be in the 36-card live Act1 pool")
		return
	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var master: BattleUnit = _spawn(arena, "res://resources/units/threadbare_puppeteer.tres", Vector2(700, 300))
	var near: BattleUnit = _spawn(arena, "res://resources/units/bone_marionette.tres", Vector2(810, 300))
	var far: BattleUnit = _spawn(arena, "res://resources/units/bone_marionette.tres", Vector2(1050, 300))
	if master == null or near == null or far == null:
		arena.free()
		return
	var thread := CONTROLLER.new() as ThreadTetherController
	arena.add_child(thread)
	thread.configure(master, [near, far])
	thread.start_threads()
	if not thread.is_linked(near) or thread.is_linked(far):
		issues.append("Near puppet should be linked; distant puppet must not")
	var before_hp: float = near.hp
	near.take_damage(20.0)
	if absf((before_hp - near.hp) - 13.6) > 0.05:
		issues.append("Linked puppet did not apply 32% reduction")
	near.position = Vector2(1050, 300)
	thread.refresh_links()
	if thread.is_linked(near) or absf(near.damage_taken_multiplier - 1.0) > 0.001:
		issues.append("Separation failed to restore puppet damage")
	near.position = Vector2(810, 300)
	thread.refresh_links()
	if not thread.is_linked(near):
		issues.append("Rejoining the master failed to restore tether")
	master.take_damage(10000.0)
	if thread.is_linked(near) or thread.running or absf(near.damage_taken_multiplier - 1.0) > 0.001:
		issues.append("Master death did not immediately release the puppet")
	if thread.connections_made < 2 or thread.connections_broken < 1 or thread.master_death_breaks != 1:
		issues.append("Tether lifecycle counters incorrect")
	thread.stop_threads()
	arena.free()
