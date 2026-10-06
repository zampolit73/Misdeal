class_name EncounterData
extends Resource

@export var encounter_id: String = ""
@export var title: String = "Схватка"
@export_multiline var card_text: String = ""
@export var wizard_line: String = ""
@export var arena_id: String = "crypt"
@export var enemy_unit_paths: PackedStringArray = PackedStringArray()
@export var enemy_names: PackedStringArray = PackedStringArray()
@export var enemy_positions: PackedVector2Array = PackedVector2Array()


@export_group("Reinforcements")
@export var reinforcement_unit_paths: PackedStringArray = PackedStringArray()
@export var reinforcement_names: PackedStringArray = PackedStringArray()
@export var reinforcement_positions: PackedVector2Array = PackedVector2Array()
