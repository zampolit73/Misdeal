extends Control

const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")

@onready var units_layer: Node2D = $UnitsLayer
@onready var status_label: Label = $Status
@onready var fight_button: Button = $FightButton
@onready var restart_button: Button = $RestartButton
@onready var result_label: Label = $Result

var units: Array[BattleUnit] = []
var combat_started := false
var battle_finished := false

func _ready() -> void:
	fight_button.pressed.connect(_on_fight_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	restart_button.disabled = true
	_spawn_test_encounter()

func _spawn_test_encounter() -> void:
	_spawn_unit("Knight", 0, Vector2(220, 145), 150.0, 18.0, 0.90, 56.0, 84.0)
	_spawn_unit("Ranger", 0, Vector2(180, 245), 90.0, 14.0, 0.72, 185.0, 72.0)
	_spawn_unit("Mage", 0, Vector2(220, 345), 80.0, 24.0, 1.25, 155.0, 66.0)

	_spawn_unit("Skeleton A", 1, Vector2(980, 145), 105.0, 13.0, 0.95, 54.0, 78.0)
	_spawn_unit("Skeleton B", 1, Vector2(1020, 245), 105.0, 13.0, 0.95, 54.0, 78.0)
	_spawn_unit("Skeleton C", 1, Vector2(980, 345), 105.0, 13.0, 0.95, 54.0, 78.0)

func _spawn_unit(
	unit_name: String,
	team: int,
	spawn_position: Vector2,
	hp: float,
	unit_damage: float,
	interval: float,
	unit_range: float,
	speed: float
) -> void:
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.display_name = unit_name
	unit.team = team
	unit.max_hp = hp
	unit.damage = unit_damage
	unit.attack_interval = interval
	unit.attack_range = unit_range
	unit.move_speed = speed
	unit.position = spawn_position
	unit.died.connect(_on_unit_died)
	units_layer.add_child(unit)
	units.append(unit)

func _on_fight_pressed() -> void:
	if combat_started or battle_finished:
		return

	combat_started = true
	fight_button.disabled = true
	fight_button.text = "FIGHTING..."
	status_label.text = "The wager is sealed. No turning back."

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

	for unit in units:
		unit.combat_started = false

	if player_won:
		result_label.text = "VICTORY\nThe wizard looks mildly annoyed."
		status_label.text = "You survived the first deal."
	else:
		result_label.text = "DEFEAT\nThe wizard smiles."
		status_label.text = "The table claims another party."

	result_label.visible = true
	restart_button.disabled = false
	fight_button.text = "BATTLE OVER"

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
