extends Control

@onready var title_label: Label = $Panel/Title
@onready var type_label: Label = $Panel/Type
@onready var description_label: Label = $Panel/Description
@onready var wizard_line: Label = $Panel/WizardLine
@onready var result_label: Label = $Panel/Result
@onready var continue_button: Button = $Panel/ContinueButton

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)

	var card := RunState.get_active_card()
	if card == null:
		push_warning("Prototype card scene opened without an active run card.")
		get_tree().change_scene_to_file("res://scenes/table/table.tscn")
		return

	title_label.text = card.title
	type_label.text = card.type_label
	description_label.text = card.card_text
	wizard_line.text = card.wizard_line
	result_label.text = card.prototype_result_text

func _on_continue_pressed() -> void:
	continue_button.disabled = true
	RunState.complete_active_card()
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")
