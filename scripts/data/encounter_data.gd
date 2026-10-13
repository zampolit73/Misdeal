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

# Optional authored second deployment for the SAME card and SAME enemy roster.
# A variant with a mismatched roster size is ignored, never partially spawned.
@export_group("Tactical Deployment")
@export var alternate_enemy_positions: PackedVector2Array = PackedVector2Array()
@export var formation_hint: String = ""
@export var alternate_formation_hint: String = ""


@export_group("Reinforcements")
@export var reinforcement_unit_paths: PackedStringArray = PackedStringArray()
@export var reinforcement_names: PackedStringArray = PackedStringArray()
@export var reinforcement_positions: PackedVector2Array = PackedVector2Array()


func get_formation_count() -> int:
	if not enemy_unit_paths.is_empty() and alternate_enemy_positions.size() == enemy_unit_paths.size():
		return 2
	return 1


func get_enemy_positions_for_formation(index: int) -> PackedVector2Array:
	if index == 1 and get_formation_count() == 2:
		return alternate_enemy_positions
	return enemy_positions


func get_formation_hint(index: int) -> String:
	if index == 1 and get_formation_count() == 2 and not alternate_formation_hint.is_empty():
		return alternate_formation_hint
	return formation_hint

