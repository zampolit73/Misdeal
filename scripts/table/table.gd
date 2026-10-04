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
@onready var whispering_well_button: Button = $Cards/WhisperingWellCard

func _ready() -> void:
	if RunState.is_run_complete():
		get_tree().change_scene_to_file("res://scenes/run_end/run_end.tscn")
		return

	_setup_card(bone_patrol_button, BONE_PATROL, BONE_PATROL_PATH)
	_setup_card(graveyard_button, GRAVEYARD_AMBUSH, GRAVEYARD_AMBUSH_PATH)
	_setup_card(gallows_button, GALLOWS_VOLLEY, GALLOWS_VOLLEY_PATH)
	whispering_well_button.pressed.connect(_choose_whispering_well)
	_refresh_table()

func _setup_card(button: Button, encounter: EncounterData, encounter_path: String) -> void:
	var title_label := button.get_node("Title") as Label
	var type_label := button.get_node("Type") as Label
	var description_label := button.get_node("Description") as Label
	var hint_label := button.get_node("Hint") as Label

	title_label.text = encounter.title
	type_label.text = "БОЙ"
	description_label.text = encounter.card_text.replace("\n", " ")
	hint_label.text = "ВЫБРАТЬ"
	button.tooltip_text = encounter.card_text.replace("\n", " ")
	button.pressed.connect(_choose_encounter.bind(encounter, encounter_path))

func _refresh_table() -> void:
	var current_deal := RunState.deals_survived + 1
	stats_label.text = "РАЗДАЧА %d/%d     ЗОЛОТО %d     ЗДОРОВЬЕ %+d     УРОН %+d" % [
		current_deal,
		RunState.MAX_DEALS,
		RunState.gold,
		int(RunState.party_hp_bonus),
		int(RunState.party_damage_bonus)
	]

	if RunState.deals_survived == 0:
		wizard_line.text = "Волшебник раскладывает судьбы. Выбирай."
	elif RunState.deals_survived == RunState.MAX_DEALS - 1:
		wizard_line.text = "Последняя раздача. Постарайся умереть поинтереснее."
	else:
		wizard_line.text = "Всё ещё здесь? Какая досада. Тогда ещё одна карта."

	var well_art := whispering_well_button.get_node("Art") as TextureRect
	var well_type := whispering_well_button.get_node("Type") as Label
	var well_description := whispering_well_button.get_node("Description") as Label
	var well_hint := whispering_well_button.get_node("Hint") as Label

	if RunState.whispering_well_resolved:
		whispering_well_button.disabled = true
		well_art.modulate = Color(0.34, 0.38, 0.40, 0.72)
		well_type.text = "СОБЫТИЕ ИСЧЕРПАНО"
		well_description.text = "Колодец больше не отвечает."
		well_hint.text = ""
	else:
		whispering_well_button.disabled = false
		well_art.modulate = Color.WHITE
		well_type.text = "СОБЫТИЕ"
		well_description.text = "Чёрная вода обещает силу. Цена неизвестна."
		well_hint.text = "ВЫБРАТЬ"

func _choose_encounter(encounter: EncounterData, encounter_path: String) -> void:
	_disable_cards()
	RunState.select_encounter(encounter_path)
	wizard_line.text = encounter.wizard_line
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")

func _choose_whispering_well() -> void:
	if RunState.whispering_well_resolved:
		return

	_disable_cards()
	wizard_line.text = "О, вот это уже интереснее. Загляни поглубже."
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scenes/event/whispering_well.tscn")

func _disable_cards() -> void:
	bone_patrol_button.disabled = true
	graveyard_button.disabled = true
	gallows_button.disabled = true
	whispering_well_button.disabled = true
