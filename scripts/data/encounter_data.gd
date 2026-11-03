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

# D382: strictly optional second attack group. A wave encounter stays ONE
# resolved run card, ONE battle result, ONE reward, and ONE Last Deal.
# All unrelated encounters use the existing single-group flow unchanged.
@export_group("Two-Wave Pilot")
@export var second_wave_unit_paths: PackedStringArray = PackedStringArray()
@export var second_wave_names: PackedStringArray = PackedStringArray()
@export var second_wave_positions: PackedVector2Array = PackedVector2Array()
@export var second_wave_hint: String = ""

# D383: authored words for any optional wave encounter. Keep the D382 Iron
# Wall script generic: its original cues now live in iron_wall.tres.
@export var wave_one_status: String = "ВОЛНА I / II — расставьте бойцов перед первой атакой."
@export var wave_intermission_status: String = "ПЕРЕДЫШКА — новая атака. Перестройте выживших."
@export var wave_two_status: String = "ВОЛНА II / II — новый натиск."
@export var wave_intermission_wizard_line: String = "Поправь своих бойцов. Я ещё не закончил."
@export var wave_two_wizard_line: String = "Продолжим игру."


func has_second_wave() -> bool:
	return (
		not enemy_unit_paths.is_empty()
		and enemy_unit_paths.size() == enemy_positions.size()
		and not second_wave_unit_paths.is_empty()
		and second_wave_unit_paths.size() == second_wave_positions.size()
	)


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

