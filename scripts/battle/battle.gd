extends Control

const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const KNIGHT_DATA: UnitData = preload("res://resources/units/knight.tres")
const RANGER_DATA: UnitData = preload("res://resources/units/ranger.tres")
const MAGE_DATA: UnitData = preload("res://resources/units/mage.tres")
const DEFAULT_ENCOUNTER: EncounterData = preload("res://resources/encounters/graveyard_ambush.tres")

const COMBAT_BOUNDS := Rect2(Vector2.ZERO, Vector2(1240, 465))
const PLAYER_PLACEMENT_BOUNDS := Rect2(Vector2(35, 82), Vector2(545, 326))

@onready var title_label: Label = $Title
@onready var deal_label: Label = $DealLabel
@onready var enemy_label: Label = $EnemyLabel
@onready var arena_visual: Control = $Arena
@onready var units_layer: Node2D = $UnitsLayer
@onready var status_label: Label = $Status
@onready var fight_button: Button = $FightButton
@onready var restart_button: Button = $RestartButton
@onready var continue_button: Button = $ContinueButton
@onready var result_backdrop: Panel = $ResultBackdrop
@onready var result_label: Label = $Result
@onready var result_subtitle: Label = $ResultSubtitle
@onready var placement_hint: Label = $PlacementHint

var encounter: EncounterData
var units: Array[BattleUnit] = []
var combat_started := false
var battle_finished := false
var boss_reinforcements_spawned := false

func _ready() -> void:
	fight_button.pressed.connect(_on_fight_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	restart_button.disabled = true
	continue_button.visible = false
	continue_button.disabled = true
	encounter = _load_selected_encounter()
	if arena_visual.has_method("set_boss_mode"):
		arena_visual.call("set_boss_mode", _is_boss_encounter())
	title_label.text = "MISDEAL — %s" % encounter.title
	deal_label.text = RunState.get_progress_text()
	if _is_boss_encounter():
		enemy_label.text = "БОСС • ФАЗА I"
		title_label.add_theme_color_override("font_color", Color(1.0, 0.72, 0.42, 1.0))
	elif _is_death_wager_encounter():
		enemy_label.text = "СТАВКА"
	elif _is_elite_encounter():
		enemy_label.text = "ЭЛИТА"
	else:
		enemy_label.text = "НЕЖИТЬ"
	result_backdrop.visible = false
	_spawn_encounter()
	_begin_preparation_phase()

func _is_boss_encounter() -> bool:
	return encounter != null and encounter.encounter_id == "bone_warden"

func _is_elite_encounter() -> bool:
	return encounter != null and encounter.encounter_id == "crypt_guard"

func _is_death_wager_encounter() -> bool:
	return encounter != null and encounter.encounter_id == "death_wager"

func _load_selected_encounter() -> EncounterData:
	if not RunState.selected_encounter_path.is_empty():
		var loaded := load(RunState.selected_encounter_path)
		if loaded is EncounterData:
			return loaded as EncounterData

	push_warning("Could not load selected encounter, using Graveyard Ambush.")
	return DEFAULT_ENCOUNTER

func _spawn_encounter() -> void:
	_spawn_unit(KNIGHT_DATA, 0, Vector2(220, 145))
	_spawn_unit(RANGER_DATA, 0, Vector2(180, 245))
	_spawn_unit(MAGE_DATA, 0, Vector2(220, 345))

	var enemy_count: int = mini(encounter.enemy_unit_paths.size(), encounter.enemy_positions.size())

	for index in range(enemy_count):
		var enemy_data := load(encounter.enemy_unit_paths[index]) as UnitData
		if enemy_data == null:
			push_warning("Could not load enemy UnitData: %s" % encounter.enemy_unit_paths[index])
			continue

		var enemy_name := enemy_data.unit_name
		if index < encounter.enemy_names.size() and not encounter.enemy_names[index].is_empty():
			enemy_name = encounter.enemy_names[index]

		_spawn_unit(enemy_data, 1, encounter.enemy_positions[index], enemy_name)

func _spawn_unit(
	data: UnitData,
	team: int,
	spawn_position: Vector2,
	name_override: String = ""
) -> void:
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.configure(data, team, spawn_position, name_override)

	if team == 0:
		unit.max_hp += RunState.party_hp_bonus
		unit.damage += RunState.party_damage_bonus
		_apply_artifacts_to_unit(unit)
		unit.max_hp = maxf(20.0, unit.max_hp)
		unit.damage = maxf(1.0, unit.damage)
	else:
		unit.damage *= RunState.get_enemy_damage_multiplier()

	unit.set_combat_bounds(COMBAT_BOUNDS)
	unit.died.connect(_on_unit_died)
	unit.placement_rejected.connect(_on_placement_rejected)
	if unit.is_boss:
		unit.boss_enraged.connect(_on_boss_enraged)
	units_layer.add_child(unit)
	units.append(unit)

	if combat_started:
		unit.start_combat()

func _apply_artifacts_to_unit(unit: BattleUnit) -> void:
	for artifact in RunState.get_artifacts_for_role(unit.visual_role):
		unit.max_hp += artifact.hp_bonus
		unit.damage *= artifact.damage_multiplier
		unit.attack_interval = maxf(0.2, unit.attack_interval * artifact.attack_interval_multiplier)
		unit.attack_range += artifact.attack_range_bonus
		unit.minimum_range += artifact.minimum_range_bonus
		unit.splash_radius += artifact.splash_radius_bonus
		unit.splash_damage_multiplier += artifact.splash_damage_bonus
		unit.move_speed *= artifact.move_speed_multiplier

func _begin_preparation_phase() -> void:
	if _is_boss_encounter():
		status_label.text = "БОСС — надзиратель бьёт по площади. На половине здоровья начнётся вторая фаза."
	elif _is_death_wager_encounter():
		status_label.text = "СТАВКА НА СМЕРТЬ — пять врагов и усиленная награда. Лучников лучше не оставлять без внимания."
	elif _is_elite_encounter():
		status_label.text = "ЭЛИТА — страж бьёт по площади. Не собирайте героев в одну точку."
	elif encounter.encounter_id == "grave_bell":
		status_label.text = "МОГИЛЬНЫЙ ЗВОН — звонарь периодически лечит ближайшую нежить."
	elif encounter.encounter_id == "bone_crush":
		status_label.text = "КОСТЯНАЯ ДАВКА — пять слабых врагов. Маг особенно полезен против толпы."
	elif encounter.encounter_id == "ossuary_gate":
		status_label.text = "ВРАТА ОССУАРИЯ — страж держит фронт, звонарь лечит, лучник давит с тыла."
	else:
		status_label.text = "ПОДГОТОВКА — расставьте героев и нажмите «БОЙ»."

	if RunState.wizard_debt_active:
		status_label.text += "  ДОЛГ ВОЛШЕБНИКУ: враги наносят +25% урона."

	placement_hint.visible = true

	for unit in units:
		if unit.team == 0:
			unit.enable_placement(PLAYER_PLACEMENT_BOUNDS)

func _on_boss_enraged(_unit: BattleUnit) -> void:
	if not _is_boss_encounter() or boss_reinforcements_spawned:
		return

	boss_reinforcements_spawned = true
	enemy_label.text = "БОСС • ЯРОСТЬ"
	status_label.text = "ФАЗА II — надзиратель зовёт подкрепление!"
	if arena_visual.has_method("set_boss_phase_two"):
		arena_visual.call("set_boss_phase_two", true)

	_show_boss_phase_flash()

	var count := mini(encounter.reinforcement_unit_paths.size(), encounter.reinforcement_positions.size())
	for index in range(count):
		var reinforcement_data := load(encounter.reinforcement_unit_paths[index]) as UnitData
		if reinforcement_data == null:
			continue

		var reinforcement_name := reinforcement_data.unit_name
		if index < encounter.reinforcement_names.size() and not encounter.reinforcement_names[index].is_empty():
			reinforcement_name = encounter.reinforcement_names[index]

		_spawn_unit(reinforcement_data, 1, encounter.reinforcement_positions[index], reinforcement_name)

func _show_boss_phase_flash() -> void:
	var phase_label := Label.new()
	phase_label.text = "ФАЗА II — ПРИЗЫВ"
	phase_label.position = Vector2(390.0, 195.0)
	phase_label.size = Vector2(500.0, 52.0)
	phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	phase_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	phase_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	phase_label.z_index = 3000
	phase_label.add_theme_font_size_override("font_size", 28)
	phase_label.add_theme_color_override("font_color", Color(1.0, 0.56, 0.28, 1.0))
	phase_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.95))
	phase_label.add_theme_constant_override("shadow_offset_x", 2)
	phase_label.add_theme_constant_override("shadow_offset_y", 2)
	add_child(phase_label)

	var tween := phase_label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(phase_label, "position", phase_label.position + Vector2(0.0, -18.0), 0.9)
	tween.tween_property(phase_label, "modulate:a", 0.0, 0.9)
	tween.chain().tween_callback(phase_label.queue_free)

func _on_placement_rejected(unit: BattleUnit) -> void:
	status_label.text = "%s нельзя поставить поверх другого героя." % unit.display_name

func _on_fight_pressed() -> void:
	if combat_started or battle_finished:
		return

	combat_started = true
	fight_button.disabled = true
	fight_button.text = "БОЙ..."
	status_label.text = "Ставка сделана. Назад пути нет."
	placement_hint.visible = false

	for unit in units:
		if unit.alive:
			unit.start_combat()

func _on_unit_died(_unit: BattleUnit) -> void:
	if battle_finished:
		return

	var heroes_alive := 0
	var enemies_alive := 0

	for unit in units:
		if not unit.alive:
			continue
		if unit.team == 0:
			heroes_alive += 1
		else:
			enemies_alive += 1

	if enemies_alive == 0:
		_finish_battle(true)
	elif heroes_alive == 0:
		_finish_battle(false)

func _finish_battle(player_won: bool) -> void:
	battle_finished = true
	RunState.last_battle_won = player_won

	for unit in units:
		unit.combat_started = false
		unit.disable_placement()

	if player_won:
		result_label.text = "ПОБЕДА"
		if _is_boss_encounter():
			result_subtitle.text = "Волшебник впервые перестаёт улыбаться."
		elif _is_death_wager_encounter():
			result_subtitle.text = "Похоже, волшебник только что проиграл собственную ставку."
		elif _is_elite_encounter():
			result_subtitle.text = "Склеп открыт. Внутри осталось кое-что ценное."
		elif encounter.encounter_id == "grave_bell":
			result_subtitle.text = "Колокол наконец замолчал."
		elif encounter.encounter_id == "ossuary_gate":
			result_subtitle.text = "Последние врата перед надзирателем открыты."
		else:
			result_subtitle.text = "Волшебник выглядит слегка раздражённым."
		status_label.text = "Карта пережита. Пока что."
		continue_button.text = "ЗАБРАТЬ НАГРАДУ"
	else:
		result_label.text = "ПОРАЖЕНИЕ"
		result_subtitle.text = "Волшебник улыбается."
		status_label.text = "Стол забирает ещё один отряд."
		continue_button.text = "ВЕРНУТЬСЯ К СТОЛУ"

	result_backdrop.visible = true
	result_label.visible = true
	result_subtitle.visible = true
	restart_button.disabled = false
	continue_button.visible = true
	continue_button.disabled = false
	fight_button.text = "БОЙ ОКОНЧЕН"

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_continue_pressed() -> void:
	continue_button.disabled = true

	if RunState.last_battle_won:
		get_tree().change_scene_to_file("res://scenes/reward/reward.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/table/table.tscn")
