class_name UnitData
extends Resource

@export var unit_name: String = "Unit"
@export var visual_role: String = "unit"
@export var max_hp: float = 100.0
@export var damage: float = 10.0
@export var attack_interval: float = 1.0
@export var attack_range: float = 54.0
@export var minimum_range: float = 0.0
@export var splash_radius: float = 0.0
@export var splash_damage_multiplier: float = 0.0
@export var move_speed: float = 80.0
@export var body_radius: float = 22.0
@export var separation_padding: float = 10.0
@export var separation_strength: float = 120.0

@export_group("Boss")
@export var is_boss: bool = false
@export var visual_scale: float = 1.0
@export_range(0.0, 1.0, 0.05) var enrage_threshold: float = 0.0
@export var enrage_damage_multiplier: float = 1.0
@export var enrage_attack_interval_multiplier: float = 1.0
@export var enrage_move_speed_multiplier: float = 1.0
