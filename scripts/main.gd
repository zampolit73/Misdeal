extends Control

@onready var status_label: Label = $Center/Panel/Status
@onready var start_button: Button = $Center/Panel/StartButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
	status_label.text = "The wizard deals your first opponents..."
	start_button.disabled = true
	await get_tree().create_timer(0.35).timeout
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")
