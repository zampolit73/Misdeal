extends Control

const BONE_PATROL_PATH := "res://resources/encounters/bone_patrol.tres"
const GRAVEYARD_AMBUSH_PATH := "res://resources/encounters/graveyard_ambush.tres"
const GALLOWS_VOLLEY_PATH := "res://resources/encounters/gallows_volley.tres"

const BONE_PATROL: EncounterData = preload("res://resources/encounters/bone_patrol.tres")
const GRAVEYARD_AMBUSH: EncounterData = preload("res://resources/encounters/graveyard_ambush.tres")
const GALLOWS_VOLLEY: EncounterData = preload("res://resources/encounters/gallows_volley.tres")

@onready var wizard_line: Label = $WizardLine
@onready var stats_label: Label = $Stats
@onready var bone_patrol_button: Button = $Cards/BonePatrolCard
@onready var graveyard_button: Button = $Cards/GraveyardCard
@onready var gallows_button: Button = $Cards/GallowsVolleyCard

func _ready() -> void:
	if RunState.is_run_complete():
		get_tree().change_scene_to_file("res://scenes/run_end/run_end.tscn")
		return

	_setup_card(bone_patrol_button, BONE_PATROL, BONE_PATROL_PATH)
	_setup_card(graveyard_button, GRAVEYARD_AMBUSH, GRAVEYARD_AMBUSH_PATH)
	_setup_card(gallows_button, GALLOWS_VOLLEY, GALLOWS_VOLLEY_PATH)
	_refresh_table()

func _setup_card(button: Button, encounter: EncounterData, encounter_path: String) -> void:
	button.text = "%s\n\nБОЙ\n\n%s\n\nНАЖМИТЕ, ЧТОБЫ ВЫБРАТЬ" % [
		encounter.title,
		encounter.card_text
	]
	button.pressed.connect(_choose_encounter.bind(encounter, encounter_path))

func _refresh_table() -> void:
	var current_deal := RunState.deals_survived + 1
	stats_label.text = "Раздача: %d/%d    Золото: %d    Здоровье отряда: +%d    Урон отряда: +%d" % [
		current_deal,
		RunState.MAX_DEALS,
		RunState.gold,
		int(RunState.party_hp_bonus),
		int(RunState.party_damage_bonus)
	]

	if RunState.deals_survived == 0:
		wizard_line.text = "Волшебник барабанит пальцами по столу. Выбирай."
	elif RunState.deals_survived == RunState.MAX_DEALS - 1:
		wizard_line.text = "Последняя раздача. Постарайся умереть поинтереснее."
	else:
		wizard_line.text = "Всё ещё здесь? Какая досада. Тогда ещё одна карта."

func _choose_encounter(encounter: EncounterData, encounter_path: String) -> void:
	_disable_cards()
	RunState.select_encounter(encounter_path)
	wizard_line.text = encounter.wizard_line
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")

func _disable_cards() -> void:
	bone_patrol_button.disabled = true
	graveyard_button.disabled = true
	gallows_button.disabled = true
