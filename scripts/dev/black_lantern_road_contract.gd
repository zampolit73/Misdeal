extends RefCounted

# D206 is a local smoke for staged resources and isolated light math ONLY.
# It does not spawn a fight, enable unreleased sprites, or touch RunState.
const LIGHT := preload("res://scripts/battle/black_lantern_light.gd")
const ENCOUNTER_PATH := "res://resources/encounters/black_lantern_road.tres"
const ROLES: Array[String] = [
	"extinguished_guide", "lantern_bearer", "road_sentinel",
	"oil_acolyte", "lantern_archer"
]
const BOUNDS := Rect2(90.0, 284.0, 1080.0, 158.0)

static func inspect() -> Array[String]:
	var errors: Array[String] = []
	var encounter: EncounterData = load(ENCOUNTER_PATH) as EncounterData
	if encounter == null:
		errors.append("Не удалось загрузить EncounterData карты №38")
		return errors
	if encounter.encounter_id != "black_lantern_road":
		errors.append("Encounter ID неверный")
	if encounter.arena_id != "black_lantern_road":
		errors.append("Указана не та арена")
	if encounter.get_formation_count() != 2:
		errors.append("Нужны две расстановки с пятью врагами")
	if encounter.enemy_unit_paths.size() != 5 or encounter.enemy_names.size() != 5:
		errors.append("Неверное число уникальных боевых ролей")
	else:
		var seen: Dictionary = {}
		for index in range(5):
			var data: UnitData = load(encounter.enemy_unit_paths[index]) as UnitData
			if data == null:
				errors.append("UnitData %d не загружен" % index)
				continue
			if data.visual_role != ROLES[index]:
				errors.append("Неверная роль %d: %s" % [index, data.visual_role])
			if seen.has(data.visual_role):
				errors.append("Повторяется роль %s" % data.visual_role)
			seen[data.visual_role] = true
			if data.max_hp <= 0.0 or data.attack_interval <= 0.0 or data.damage <= 0.0:
				errors.append("Некорректные боевые параметры %s" % data.visual_role)
			if data.visual_role == "extinguished_guide" and data.visual_scale < 1.7:
				errors.append("Размер Проводника недостаточно отличается")
	for formation in range(2):
		var points: PackedVector2Array = encounter.get_enemy_positions_for_formation(formation)
		if points.size() != 5:
			errors.append("Расстановка %d: ожидается пять точек" % formation)
			continue
		for point in points:
			if not BOUNDS.has_point(point):
				errors.append("Расстановка %d: боец за пределами пола" % formation)
	_test_light_math(errors)
	return errors

static func _test_light_math(errors: Array[String]) -> void:
	var monster: BattleUnit = BattleUnit.new()
	monster.team = 1
	monster.alive = true
	monster.position = Vector2(958.0, 368.0) # Boot contact at B[0].
	monster.attack_interval = 2.0
	var hero: BattleUnit = BattleUnit.new()
	hero.team = 0
	hero.alive = true
	hero.position = monster.position
	hero.attack_interval = 1.5
	var participants: Array[BattleUnit] = [monster, hero]
	var light: BlackLanternLightController = LIGHT.new() as BlackLanternLightController
	light.configure(participants)
	light.start_light()
	if light.get_phase() != "warning" or absf(monster.attack_interval - 2.0) > 0.001:
		errors.append("Свет не должен ускорять до предупреждения")
	light.advance_battle(BlackLanternLightController.WARNING_SECONDS + 0.02)
	if light.get_phase() != "active" or monster.attack_interval >= 1.999:
		errors.append("Активный свет не ускорил врага")
	if absf(hero.attack_interval - 1.5) > 0.001:
		errors.append("Свет не должен ускорять героя")
	light.advance_battle(BlackLanternLightController.ACTIVE_SECONDS + 0.02)
	if light.get_phase() != "rest" or absf(monster.attack_interval - 2.0) > 0.001:
		errors.append("Ускорение не снялось в темноте")
	light.stop_light()
	if absf(monster.attack_interval - 2.0) > 0.001:
		errors.append("Прекращение боя не вернуло базовую скорость")
	light.free()
	monster.free()
	hero.free()
