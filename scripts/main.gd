extends Control

@onready var status_label: Label = $Status
@onready var start_button: Button = $StartButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	start_button.grab_focus()

func _on_start_button_pressed() -> void:
	RunState.reset_run()
	start_button.disabled = true
	await get_tree().create_timer(0.18).timeout
	get_tree().change_scene_to_file("res://scenes/intro/intro.tscn")
