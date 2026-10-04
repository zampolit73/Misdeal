extends Control

@onready var status_label: Label = $Center/Panel/Status
@onready var start_button: Button = $Center/Panel/StartButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
	status_label.text = "The wizard is shuffling the deck..."
	start_button.text = "COMING NEXT"
	start_button.disabled = true
