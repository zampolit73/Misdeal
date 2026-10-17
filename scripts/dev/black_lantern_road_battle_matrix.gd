extends Control

# D207 / QA ONLY: 54 deterministic simulations of the REAL BattleUnit AI,
# with encounter-local lanternlight. No approved #38 sprites are available:
# the arena remains invisible and this smoke does NOT unlock the live card.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/black_lantern_road.tres")
const LIGHT_SCRIPT := preload("res://scripts/battle/black_lantern_light.gd")
const HERO_ROLES: Array[String] = ["knight", "ranger", "mage"]
const TACTICS: Array[String] = ["assault", "hunt", "formation"]
const EXPECTED_ENEMY_ROLES: Array[String] = [
	"extinguished_guide", "lantern_bearer", "road_sentinel",
	"oil_acolyte", "lantern_archer"
]
const COMBAT_BOUNDS := Rect2(Vector2(90, 284), Vector2(1080, 158))
const PLACEMENT_BOUNDS := Rect2(Vector2(140, 304), Vector2(395, 124))
const STEP: float = 1.0 / 30.0
const MAX_SECONDS: float = 90.0
const TOTAL_CASES: int = 54

var failures: Array[String] = []
var completed: int = 0
var victories: int = 0
var defeats: int = 0
var timeouts: int = 0
var light_warnings: int = 0
var light_active_steps: int = 0
var buffed_enemy_steps: int = 0
var max_buffed_enemies: int = 0
var wins_per_size: Array[int] = [0, 0, 0]
var wins_per_class: Array[int] = [0, 0, 0]
var hp_per_size: Array[float] = [0.0, 0.0, 0.0]
var worst_hp: Array[float] = [1.0, 1.0, 1.0]
var duration_per_size: Array[float] = [0.0, 0.0, 0.0]
var fallen_per_size: Array[int] = [0, 0, 0]
var title_label: Label
var report_label: Label


func _ready() -> void:
	var background := ColorRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = Color("#17151b")
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	title_label = Label.new()
	title_label.position = Vector2(70, 70)
	title_label.size = Vector2(1140, 58)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 27)
	title_label.text = "D207 / ФОНАРИ — ПРЕДВАРИТЕЛЬНАЯ МАТРИЦА"
	add_child(title_label)
	report_label = Label.new()
	report_label.position = Vector2(65, 146)
	report_label.size = Vector2(1150, 490)
	report_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	report_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	report_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	report_label.add_theme_font_size_override("font_size", 19)
	report_label.text = "Подготовка 54 боевых сценариев..."
	add_child(report_label)
	await _run_matrix()


func _check_contract() -> void:
	if RunState.ACT1_CARD_IDS.size() != 37 or RunState.ACT1_CARD_IDS.has("black_lantern_road"):
		failures.append("D207: карта #38 должна оставаться вне обычной колоды 37/45")
	if ENCOUNTER.encounter_id != "black_lantern_road" or ENCOUNTER.get_formation_count() != 2:
		failures.append("D207: две оригинальные расстановки не загрузились")
	if ENCOUNTER.enemy_unit_paths.size() != 5:
		failures.append("D207: бой должен содержать ровно пять уникальных врагов")
	else:
		for i in range(5):
			var data: UnitData = load(ENCOUNTER.enemy_unit_paths[i]) as UnitData
			if data == null or data.visual_role != EXPECTED_ENEMY_ROLES[i]:
				failures.append("D207: отсутствует уникальный враг #%d" % i)
	for role in HERO_ROLES:
		if RunState.get_hero_unit_data(role) == null:
			failures.append("D207: отсутствуют ресурсы героя " + role)
	for formation in range(2):
		var pos: PackedVector2Array = ENCOUNTER.get_enemy_positions_for_formation(formation)
		if pos.size() != 5:
			failures.append("D207: неполная расстановка %d" % formation)
			continue
		for point in pos:
			var actual: Vector2 = _project_floor(point)
			if not COMBAT_BOUNDS.has_point(actual):
				failures.append("D207: враг за границами боевого пола %d" % formation)


# Mirrors battle.gd _project_spawn_on_floor() for the normal arena.
func _project_floor(source: Vector2) -> Vector2:
	var depth: float = clampf((source.y - 130.0) / 275.0, 0.0, 1.0)
	return Vector2(
		source.x,
		lerpf(COMBAT_BOUNDS.position.y + 32.0, COMBAT_BOUNDS.end.y - 32.0, depth)
	)


# Mirrors the default branch of battle.gd _get_party_spawn_positions().
func _hero_positions(party_size: int) -> Array[Vector2]:
	match party_size:
		1:
			return [Vector2(300, 245)]
		2:
			return [Vector2(200, 205), Vector2(435, 340)]
		_:
			return [Vector2(185, 195), Vector2(335, 280), Vector2(490, 370)]


func _make_unit(arena: Node2D, data: UnitData, team: int, pos: Vector2, tactic: String) -> BattleUnit:
	var unit: BattleUnit = UNIT_SCENE.instantiate() as BattleUnit
	if unit == null or data == null:
		failures.append("D207: BattleUnit / UnitData отсутствует")
		return null
	unit.configure(data, team, _project_floor(pos))
	unit.set_arena_presentation(ENCOUNTER.arena_id)
	if team == 0:
		unit.max_hp *= RunState.get_party_hp_multiplier()
		unit.damage *= RunState.get_party_damage_multiplier()
		unit.attack_interval = maxf(0.2, unit.attack_interval * RunState.get_party_attack_interval_multiplier())
		unit.move_speed *= RunState.get_party_move_speed_multiplier()
		unit.set_tactical_order(tactic)
	else:
		unit.max_hp *= RunState.get_enemy_hp_multiplier()
		unit.damage *= RunState.get_enemy_damage_multiplier()
	unit.set_combat_bounds(COMBAT_BOUNDS)
	unit.set_process(false)
	arena.add_child(unit)
	return unit


func _fight(formation: int, protagonist: int, party_size: int, tactic: String) -> Dictionary:
	RunState.reset_run()
	if not RunState.choose_protagonist(HERO_ROLES[protagonist]):
		failures.append("D207: не удалось выбрать героя")
		return {}
	for member in range(1, party_size):
		RunState.recruit_companion(HERO_ROLES[(protagonist + member) % HERO_ROLES.size()], "D207 matrix")

	var arena := Node2D.new()
	arena.visible = false # No art substitution / no unapproved enemy sprites rendered.
	add_child(arena)
	var all_units: Array[BattleUnit] = []
	var hero_starts: Array[Vector2] = _hero_positions(party_size)
	for i in range(RunState.party_roles.size()):
		var data: UnitData = RunState.get_hero_unit_data(String(RunState.party_roles[i]))
		var hero: BattleUnit = _make_unit(arena, data, 0, hero_starts[i], tactic)
		if hero == null:
			arena.free()
			return {}
		hero.enable_placement_regions([PLACEMENT_BOUNDS])
		all_units.append(hero)
	for i in range(ENCOUNTER.enemy_unit_paths.size()):
		var enemy_data: UnitData = load(ENCOUNTER.enemy_unit_paths[i]) as UnitData
		var enemy: BattleUnit = _make_unit(arena, enemy_data, 1, ENCOUNTER.get_enemy_positions_for_formation(formation)[i], tactic)
		if enemy == null:
			arena.free()
			return {}
		all_units.append(enemy)

	var light: BlackLanternLightController = LIGHT_SCRIPT.new() as BlackLanternLightController
	arena.add_child(light)
	light.configure(all_units)
	for unit in all_units:
		unit.start_combat()
	light.start_light()
	light.set_process(false)

	var elapsed: float = 0.0
	var frame: int = 0
	var outcome: String = ""
	var case_warnings: int = 0
	var case_active: int = 0
	var case_buff_steps: int = 0
	var case_max_buff: int = 0
	var old_phase: String = light.get_phase()
	while elapsed < MAX_SECONDS:
		# Advance the controller exactly once per deterministic frame.
		light.advance_battle(STEP)
		var phase: String = light.get_phase()
		if phase == "warning" and old_phase != "warning":
			case_warnings += 1
		old_phase = phase
		if phase == "active":
			case_active += 1
		case_buff_steps += light.buffed_enemy_count
		case_max_buff = maxi(case_max_buff, light.buffed_enemy_count)
		for unit in all_units:
			if unit.alive:
				unit._process(STEP)
			var r: float = unit.body_radius
			if unit.position.x < COMBAT_BOUNDS.position.x + r - 0.01 or unit.position.x > COMBAT_BOUNDS.end.x - r + 0.01 or unit.position.y < COMBAT_BOUNDS.position.y + r - 0.01 or unit.position.y > COMBAT_BOUNDS.end.y - r + 0.01:
				failures.append("D207: боец покинул пол: %s" % unit.display_name)
				break
		if not failures.is_empty():
			break
		elapsed += STEP
		frame += 1
		var living_heroes: int = 0
		var living_enemies: int = 0
		for unit in all_units:
			if not unit.alive:
				continue
			if unit.team == 0:
				living_heroes += 1
			else:
				living_enemies += 1
		if living_enemies == 0:
			outcome = "win"
			break
		if living_heroes == 0:
			outcome = "loss"
			break
		if frame % 90 == 0:
			await get_tree().process_frame

	var hp_fraction: float = 0.0
	var hero_count: int = 0
	var hero_losses: int = 0
	for unit in all_units:
		if unit.team != 0:
			continue
		hero_count += 1
		hp_fraction += clampf(unit.hp / maxf(1.0, unit.max_hp), 0.0, 1.0)
		if not unit.alive:
			hero_losses += 1
	var result := {
		"outcome": outcome,
		"duration": elapsed,
		"hp_fraction": hp_fraction / float(maxi(1, hero_count)),
		"hero_deaths": hero_losses,
		"warnings": case_warnings,
		"active": case_active,
		"buff_steps": case_buff_steps,
		"max_buff": case_max_buff
	}
	light.stop_light()
	for unit in all_units:
		if unit.team != 1 or not is_instance_valid(unit):
			continue
		if absf(unit.attack_interval - float(light.enemy_base_intervals.get(unit.get_instance_id(), unit.attack_interval))) > 0.001:
			failures.append("D207: ускорение осталось после конца боя")
	arena.free()
	await get_tree().process_frame
	return result


func _run_matrix() -> void:
	_check_contract()
	if failures.is_empty():
		await get_tree().process_frame
		for formation in range(2):
			for protagonist in range(3):
				for party_size in range(1, 4):
					for tactic in TACTICS:
						seed(207000 + formation * 1000 + protagonist * 100 + party_size * 10 + TACTICS.find(tactic))
						var result: Dictionary = await _fight(formation, protagonist, party_size, tactic)
						if result.is_empty():
							failures.append("D207: сценарий не вернул результат")
							break
						completed += 1
						var outcome: String = String(result["outcome"])
						if outcome == "win":
							victories += 1
							wins_per_size[party_size - 1] += 1
							wins_per_class[protagonist] += 1
						elif outcome == "loss":
							defeats += 1
						else:
							timeouts += 1
						hp_per_size[party_size - 1] += float(result["hp_fraction"])
						worst_hp[party_size - 1] = minf(worst_hp[party_size - 1], float(result["hp_fraction"]))
						duration_per_size[party_size - 1] += float(result["duration"])
						fallen_per_size[party_size - 1] += int(result["hero_deaths"])
						light_warnings += int(result["warnings"])
						light_active_steps += int(result["active"])
						buffed_enemy_steps += int(result["buff_steps"])
						max_buffed_enemies = maxi(max_buffed_enemies, int(result["max_buff"]))
						report_label.text = "%d/54 • %s • %d героя • %s" % [completed, HERO_ROLES[protagonist], party_size, tactic]
						if not failures.is_empty():
							break
					if not failures.is_empty():
						break
				if not failures.is_empty():
					break
			if not failures.is_empty():
				break

	RunState.reset_run()
	if failures.is_empty() and completed != TOTAL_CASES:
		failures.append("D207: проверено только %d из 54 сценариев" % completed)
	if failures.is_empty() and victories + defeats + timeouts != TOTAL_CASES:
		failures.append("D207: часть исходов не подсчитана")
	if failures.is_empty() and timeouts > 0:
		failures.append("D207: %d боёв зависли по тайм-ауту" % timeouts)
	if failures.is_empty() and light_active_steps == 0:
		failures.append("D207: не наступила ни одна активная фаза света")
	if failures.is_empty() and buffed_enemy_steps == 0:
		failures.append("D207: свет ни разу не усилил скелета")
	# IMPORTANT: even 54/54 wins alone does not mean the balance is approved.
	if failures.is_empty():
		title_label.text = "D207 / ФУНКЦИОНАЛЬНЫЙ PASS — БАЛАНС НЕ ПРИНЯТ"
		report_label.text = (
			"54/54 завершено • победы %d • поражения %d • тайм-ауты %d\n"
			+ "Победы соло / дуо / трио: %d / %d / %d\n"
			+ "Победы Рыцарь / Следопыт / Маг: %d / %d / %d\n"
			+ "Средний HP: %.0f%% / %.0f%% / %.0f%%\n"
			+ "Худший HP: %.0f%% / %.0f%% / %.0f%%\n"
			+ "Средняя длительность: %.1f / %.1f / %.1f сек\n"
			+ "Потери героев: %d / %d / %d\n"
			+ "Свет: %d предупреждений, %d активных кадров, %d кадров усиления, максимум %d врагов одновременно\n"
			+ "АРТ / РЕАЛЬНЫЙ БОЙ / НАГРАДЫ НЕ ПРОВЕРЕНЫ"
		) % [
			victories, defeats, timeouts,
			wins_per_size[0], wins_per_size[1], wins_per_size[2],
			wins_per_class[0], wins_per_class[1], wins_per_class[2],
			hp_per_size[0] * 100.0 / 18.0, hp_per_size[1] * 100.0 / 18.0, hp_per_size[2] * 100.0 / 18.0,
			worst_hp[0] * 100.0, worst_hp[1] * 100.0, worst_hp[2] * 100.0,
			duration_per_size[0] / 18.0, duration_per_size[1] / 18.0, duration_per_size[2] / 18.0,
			fallen_per_size[0], fallen_per_size[1], fallen_per_size[2],
			light_warnings, light_active_steps, buffed_enemy_steps, max_buffed_enemies
		]
		report_label.add_theme_color_override("font_color", Color(0.67, 0.90, 0.74))
	else:
		title_label.text = "D207 / ФУНКЦИОНАЛЬНЫЙ FAIL"
		report_label.text = "\n".join(failures.slice(0, 8))
		report_label.add_theme_color_override("font_color", Color(1.0, 0.45, 0.37))
		push_error(report_label.text)
