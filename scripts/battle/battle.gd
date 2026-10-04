extends Control

const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const KNIGHT_DATA: UnitData = preload("res://resources/units/knight.tres")
const RANGER_DATA: UnitData = preload("res://resources/units/ranger.tres")
const MAGE_DATA: UnitData = preload("res://resources/units/mage.tres")
const DEFAULT_ENCOUNTER: EncounterData = preload("res://resources/encounters/graveyard_ambush.tres")

const COMBAT_BOUNDS := Rect2(Vector2.ZERO, Vector2(1200, 465))
const PLAYER_PLACEMENT_BOUNDS := Rect2(Vector2(35, 70), Vector2(525, 340))

@onready var title_label: Label = $Title
@onready var units_layer: Node2D = $UnitsLayer
@onready var status_label: Label = $Status
@onready var fight_button: Button = $FightButton
@onready var restart_button: Button = $RestartButton
@onready var continue_button: Button = $ContinueButton
@onready var result_label: Label = $Result
@onready var placement_hint: Label = $PlacementHint

var encounter: EncounterData
var units: Array[BattleUnit] = []
var combat_started := false
var battle_finished := false

func _ready() -> void:
	fight_button.pressed.connect(_on_fight_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	restart_button.disabled = true
	continue_button.visible = false
	continue_button.disabled = true
	encounter = _load_selected_encounter()
	title_label.text = "MISDEAL — %s" % encounter.title
	_spawn_encounter()
	_begin_preparation_phase()

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

	unit.set_combat_bounds(COMBAT_BOUNDS)
	unit.died.connect(_on_unit_died)
	unit.placement_rejected.connect(_on_placement_rejected)
	units_layer.add_child(unit)
	units.append(unit)

func _begin_preparation_phase() -> void:
	status_label.text = "ПОДГОТОВКА — расставьте героев и нажмите «БОЙ»."
	placement_hint.visible = true

	for unit in units:
		if unit.team == 0:
			unit.enable_placement(PLAYER_PLACEMENT_BOUNDS)

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
		result_label.text = "ПОБЕДА\nВолшебник выглядит слегка раздражённым."
		status_label.text = "Вы пережили раздачу."
		continue_button.text = "ЗАБРАТЬ НАГРАДУ"
	else:
		result_label.text = "ПОРАЖЕНИЕ\nВолшебник улыбается."
		status_label.text = "Стол забирает ещё один отряд."
		continue_button.text = "ВЕРНУТЬСЯ К СТОЛУ"

	result_label.visible = true
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
