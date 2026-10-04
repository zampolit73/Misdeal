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
	stats_label.text = "Deals survived: %d    Gold: %d    Party HP: +%d    Party damage: +%d" % [
		RunState.deals_survived,
		RunState.gold,
		int(RunState.party_hp_bonus),
		int(RunState.party_damage_bonus)
	]

	if RunState.deals_survived == 0:
		wizard_line.text = "The wizard drums his fingers on the table.  Choose."
	else:
		wizard_line.text = "Still here?  How inconvenient.  Another card, then."

	locked_card_left.disabled = true
	locked_card_right.disabled = true

func _on_graveyard_pressed() -> void:
	graveyard_button.disabled = true
	wizard_line.text = "Ah.  The graveyard.  A sentimental favorite."
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")
