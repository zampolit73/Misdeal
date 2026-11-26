extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")
const TYPE := preload("res://scripts/class_select/class_select_card_skin.gd")
const DIALOGUE := preload("res://assets/pixel/intro/visual_v2/intro_dialogue.json")
const FRAMES: Array[Texture2D] = [
	preload("res://assets/pixel/intro/visual_v2/frame_01.webp"),
	preload("res://assets/pixel/intro/visual_v2/frame_02.webp"),
	preload("res://assets/pixel/intro/visual_v2/frame_03.webp"),
	preload("res://assets/pixel/intro/visual_v2/frame_04.webp"),
	preload("res://assets/pixel/intro/visual_v2/frame_05.webp"),
	preload("res://assets/pixel/intro/visual_v2/frame_06.webp"),
]
const DIALOGUE_AREAS: Array[Rect2] = [
	Rect2(32, 32, 562, 96),
	Rect2(32, 28, 680, 120),
	Rect2(32, 28, 655, 96),
	Rect2(24, 15, 708, 86),
	Rect2(32, 27, 698, 96),
	Rect2(32, 27, 484, 43),
]
const BONE := Color("dec8af")
const WIZARD_BONE := Color("edceaa")

@onready var frame_rect: TextureRect = $Frame
@onready var dialogue_panel: Panel = $Dialogue
@onready var lines: VBoxContainer = $Dialogue/Lines
@onready var skip_button: Button = $SkipButton
@onready var hint_label: Label = $Hint
@onready var fade: ColorRect = $Fade

var frame_index := 0
var transitioning := false


func _ready() -> void:
	dialogue_panel.add_theme_stylebox_override("panel", _plate(Color("131012d6"), Color("775b4699"), 12))
	hint_label.add_theme_font_override("font", TYPE.heading_font())
	skip_button.add_theme_font_override("font", TYPE.heading_font())
	skip_button.add_theme_color_override("font_color", BONE)
	skip_button.add_theme_color_override("font_hover_color", WIZARD_BONE)
	skip_button.add_theme_color_override("font_focus_color", WIZARD_BONE)
	skip_button.add_theme_color_override("font_pressed_color", BONE)
	skip_button.add_theme_stylebox_override("normal", _plate(Color("231a1bea"), Color("886a52"), 7))
	skip_button.add_theme_stylebox_override("hover", _plate(Color("382326ef"), Color("b79370"), 7))
	skip_button.add_theme_stylebox_override("pressed", _plate(Color("171214ee"), Color("a48363"), 7))
	skip_button.add_theme_stylebox_override("disabled", _plate(Color("191619ed"), Color("625349"), 7))
	var focus := _plate(Color.TRANSPARENT, Color("bd9a76"), 7)
	focus.draw_center = false
	focus.set_expand_margin_all(2)
	skip_button.add_theme_stylebox_override("focus", focus)
	skip_button.pressed.connect(_on_skip_pressed)
	_show_frame(0)

	transitioning = true
	fade.modulate.a = 1.0
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 0.32)
	await tween.finished
	transitioning = false


func _unhandled_input(event: InputEvent) -> void:
	if not transitioning and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_advance()
		get_viewport().set_input_as_handled()


func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	var advance_key: bool = event.keycode in [KEY_SPACE, KEY_ENTER, KEY_KP_ENTER]
	if not advance_key and event.keycode != KEY_ESCAPE:
		return
	get_viewport().set_input_as_handled()
	if event.keycode == KEY_ESCAPE or skip_button.has_focus():
		_finish_intro()
	else:
		_advance()


func _advance() -> void:
	if transitioning:
		return
	if frame_index == FRAMES.size() - 1:
		_finish_intro()
	else:
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
	frame_index = index
	frame_rect.texture = FRAMES[index]
	for child in lines.get_children():
		lines.remove_child(child)
		child.queue_free()
	var area := DIALOGUE_AREAS[index]
	dialogue_panel.position = area.position
	dialogue_panel.size = area.size
	lines.position = Vector2(12, 7)
	lines.size = area.size - Vector2(24, 14)
	for entry: Dictionary in DIALOGUE.data.frames[index].dialogue:
		var line := Label.new()
		line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		line.add_theme_font_override("font", TYPE.heading_font())
		line.add_theme_font_size_override("font_size", 20)
		line.add_theme_color_override("font_color", WIZARD_BONE if entry.speaker == "wizard" else BONE)
		line.text = entry.text_ru
		lines.add_child(line)

	var final_frame := index == FRAMES.size() - 1
	hint_label.text = "КЛИК / ENTER — НАЧАТЬ РАЗДАЧУ" if final_frame else "КЛИК / ПРОБЕЛ — ДАЛЕЕ"
	hint_label.position.y = 73.0 if index == 3 else 678.0


func _plate(fill: Color, edge: Color, padding: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = edge
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.content_margin_left = padding
	style.content_margin_right = padding
	style.content_margin_top = 7
	style.content_margin_bottom = 7
	return style


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
	SCENE_ROUTER.change_to(self, "res://scenes/class_select/class_select.tscn")
