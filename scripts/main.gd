extends Control

@onready var status_label: Label = $Center/Panel/Status
@onready var start_button: Button = $Center/Panel/StartButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
	RunState.reset_run()
	status_label.text = "Волшебник освобождает для вас место за столом..."
	start_button.disabled = true
	await get_tree().create_timer(0.35).timeout
	get_tree().change_scene_to_file("res://scenes/intro/intro.tscn")
