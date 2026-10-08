extends Control

const MISDEAL_UI_KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")

const FRAME_PATHS: Array[String] = [
	"res://assets/pixel/intro/frame_01.webp",
	"res://assets/pixel/intro/frame_02.webp",
	"res://assets/pixel/intro/frame_03.webp",
	"res://assets/pixel/intro/frame_04.webp",
	"res://assets/pixel/intro/frame_05.webp",
]

@onready var frame_rect: TextureRect = $Frame
@onready var skip_button: Button = $SkipButton
@onready var hint_label: Label = $Hint
@onready var fade: ColorRect = $Fade

var frame_index: int = 0
var transitioning := false

func _ready() -> void:
	MISDEAL_UI_KIT.apply_action_button(skip_button, MISDEAL_UI_KIT.STEEL, false)
	skip_button.pressed.connect(_on_skip_pressed)
	_show_frame(0)

	fade.modulate.a = 1.0
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 0.32)

func _unhandled_input(event: InputEvent) -> void:
	if transitioning:
		return

	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			_advance()
			get_viewport().set_input_as_handled()
	elif event is InputEventKey:
		var key_event := event as InputEventKey
		if not key_event.pressed or key_event.echo:
			return
		if key_event.keycode == KEY_ESCAPE:
			_finish_intro()
			get_viewport().set_input_as_handled()
		elif key_event.keycode == KEY_SPACE or key_event.keycode == KEY_ENTER:
			_advance()
			get_viewport().set_input_as_handled()

func _advance() -> void:
	if transitioning:
		return

	if frame_index >= FRAME_PATHS.size() - 1:
		_finish_intro()
		return

	_transition_to_frame(frame_index + 1)

func _transition_to_frame(next_index: int) -> void:
	transitioning = true

	var fade_out := create_tween()
	fade_out.tween_property(fade, "modulate:a", 1.0, 0.14)
	await fade_out.finished

	_show_frame(next_index)

	var fade_in := create_tween()
	fade_in.tween_property(fade, "modulate:a", 0.0, 0.18)
	await fade_in.finished
	transitioning = false

func _show_frame(index: int) -> void:
	frame_index = clampi(index, 0, FRAME_PATHS.size() - 1)
	var loaded := load(FRAME_PATHS[frame_index])
	if loaded is Texture2D:
		frame_rect.texture = loaded as Texture2D
	else:
		push_error("Could not load intro frame: %s" % FRAME_PATHS[frame_index])

	if frame_index >= FRAME_PATHS.size() - 1:
		hint_label.text = "КЛИК / ENTER — НАЧАТЬ РАЗДАЧУ"
	else:
		hint_label.text = "КЛИК / ПРОБЕЛ — ДАЛЕЕ"

func _on_skip_pressed() -> void:
	_finish_intro()

func _finish_intro() -> void:
	if transitioning:
		return

	transitioning = true
	skip_button.disabled = true

	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 0.18)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/class_select/class_select.tscn")
