extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")

@onready var approved_splash: TextureRect = $ApprovedSplash
@onready var status_label: Label = $Status
@onready var start_button: Button = $StartButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	start_button.grab_focus()
	call_deferred("_animate_main_in")


func _animate_main_in() -> void:
	approved_splash.modulate.a = 0.84
	start_button.pivot_offset = start_button.size * 0.5
	start_button.scale = Vector2(0.97, 0.97)
	start_button.modulate.a = 0.0

	var backdrop_tween := approved_splash.create_tween()
	backdrop_tween.tween_property(approved_splash, "modulate:a", 1.0, 0.32)

	var button_tween := start_button.create_tween()
	button_tween.set_parallel(true)
	button_tween.tween_property(start_button, "modulate:a", 1.0, 0.16).set_delay(0.14)
	button_tween.tween_property(start_button, "scale", Vector2.ONE, 0.20).set_delay(0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_start_button_pressed() -> void:
	start_button.disabled = true
	await _animate_start_commit()
	RunState.reset_run()
	SCENE_ROUTER.change_to(self, "res://scenes/intro/intro.tscn")


func _animate_start_commit() -> void:
	start_button.pivot_offset = start_button.size * 0.5
	var tween := start_button.create_tween()
	tween.tween_property(start_button, "scale", Vector2(0.96, 0.94), 0.055).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(start_button, "scale", Vector2(1.04, 1.04), 0.075).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(start_button, "scale", Vector2.ONE, 0.055)
	await tween.finished
