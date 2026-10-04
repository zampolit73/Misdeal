extends Control

@onready var wizard_line: Label = $WizardLine
@onready var stats_label: Label = $Stats
@onready var graveyard_button: Button = $Cards/GraveyardCard
@onready var locked_card_left: Button = $Cards/LockedCardLeft
@onready var locked_card_right: Button = $Cards/LockedCardRight

func _ready() -> void:
	graveyard_button.pressed.connect(_on_graveyard_pressed)
	_refresh_table()

func _refresh_table() -> void:
	stats_label.text = "Пережито раздач: %d    Золото: %d    Здоровье отряда: +%d    Урон отряда: +%d" % [
		RunState.deals_survived,
		RunState.gold,
		int(RunState.party_hp_bonus),
		int(RunState.party_damage_bonus)
	]

	if RunState.deals_survived == 0:
		wizard_line.text = "Волшебник барабанит пальцами по столу. Выбирай."
	else:
		wizard_line.text = "Всё ещё здесь? Какая досада. Тогда ещё одна карта."

	locked_card_left.disabled = true
	locked_card_right.disabled = true

func _on_graveyard_pressed() -> void:
	graveyard_button.disabled = true
	wizard_line.text = "Ах, кладбище. Моя маленькая слабость."
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")
