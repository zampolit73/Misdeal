extends Control

# D397 archival comparison. Since D398, the left side loads LIVE C3, while right remains the archived D397 v2 recolor.
# Both columns use genuine older illustrated poses, NOT D395 still warps.
# This scene never switches production BattleUnit sprites or core combat.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const RETOUCH := preload("res://scripts/dev/c3_frame_finish.gd")
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const ROLES := ["knight", "ranger", "mage"]
const TITLES := ["РЫЦАРЬ", "СЛЕДОПЫТ", "МАГ"]
const STATES := ["idle", "walk", "attack", "hit", "death"]
const CENTERS := [228.0, 640.0, 1052.0]
const SOLE_Y := 453.0
const PAIR_SPACING := 77.0
const SCALE := [1.15, 1.28, 1.60]
const AUTO_DURATIONS := [1.3, 1.6, 0.9, 0.6, 1.2]

var current_actors: Array[AnimatedSprite2D] = []
var candidate_actors: Array[AnimatedSprite2D] = []
var active_state := "idle"
var autoplay := false
var phase_time := 0.0
var phase_index := 0
var status_label: Label
var autoplay_button: Button


func _ready() -> void:
	var arena := BACKDROP.new()
	add_child(arena)
	arena.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	arena.set_arena_id("firing_square")
	_scrim(Vector2(0, 0), Vector2(1280, 151), Color(0.013, 0.013, 0.02, 0.94))
	_scrim(Vector2(0, 544), Vector2(1280, 176), Color(0.013, 0.013, 0.02, 0.94))
	_label("MISDEAL / C3 — D397: ПРАВКА БОЕВОЙ АНИМАЦИИ", Vector2(30, 9), Vector2(1220, 36), 23, Color(0.89, 0.75, 0.56))
	_label("АРХИВ D397: слева теперь живой C3 D398, справа старая проба перекраски v2. Используй сцену D398 для честного сравнения.", Vector2(30, 47), Vector2(1210, 27), 15, Color(0.87, 0.84, 0.80))
	for index in range(STATES.size()):
		var state: String = STATES[index]
		var button := Button.new()
		button.name = "State_%s" % state
		button.text = state.to_upper()
		button.position = Vector2(30.0 + float(index) * 186.0, 94.0)
		button.size = Vector2(168.0, 34.0)
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(_set_state_manual.bind(state))
		add_child(button)
	autoplay_button = Button.new()
	autoplay_button.name = "AutoPlayback"
	autoplay_button.text = "AUTO ▶"
	autoplay_button.position = Vector2(972, 94)
	autoplay_button.size = Vector2(180, 34)
	autoplay_button.focus_mode = Control.FOCUS_NONE
	autoplay_button.pressed.connect(_toggle_auto)
	add_child(autoplay_button)
	for i in range(ROLES.size()):
		var role: String = ROLES[i]
		var center: float = CENTERS[i]
		_label(TITLES[i], Vector2(center - 134, 166), Vector2(268, 30), 20, Color(0.92, 0.74, 0.53), HORIZONTAL_ALIGNMENT_CENTER)
		var unit_scale: float = SCALE[i]
		var foot_center := SOLE_Y - (92.5 - 48.0) * unit_scale
		current_actors.append(_actor("Current_%s" % role, Vector2(center - PAIR_SPACING, foot_center), unit_scale, LIBRARY.get_frames(role)))
		candidate_actors.append(_actor("Candidate_%s" % role, Vector2(center + PAIR_SPACING, foot_center), unit_scale, RETOUCH.make_frames(role)))
		_label("СЕЙЧАС", Vector2(center - 147, 493), Vector2(140, 29), 14, Color(0.78, 0.83, 0.91), HORIZONTAL_ALIGNMENT_CENTER)
		_label("C3 / ПРОБА", Vector2(center + 7, 493), Vector2(140, 29), 14, Color(0.88, 0.81, 0.66), HORIZONTAL_ALIGNMENT_CENTER)
	status_label = _label("", Vector2(30, 559), Vector2(1220, 28), 18, Color(0.93, 0.77, 0.55))
	_label("РЕАЛЬНЫЙ ФИКС: маг больше не исчезает на кадре отдельного снаряда при атаке.", Vector2(30, 605), Vector2(1220, 26), 16, Color(0.90, 0.87, 0.82))
	_label("ПРОБА АРТА: старые нарисованные позы, ещё НЕ новые 25 кадров C3. Боевые настройки и баланс не менялись.", Vector2(30, 645), Vector2(1220, 25), 14, Color(0.72, 0.73, 0.76))
	_play("idle")


func _process(delta: float) -> void:
	if not autoplay:
		return
	phase_time += delta
	if phase_time >= AUTO_DURATIONS[phase_index]:
		phase_time = 0.0
		phase_index = (phase_index + 1) % STATES.size()
		_play(STATES[phase_index])


func _actor(name_value: String, at: Vector2, magnification: float, frames: SpriteFrames) -> AnimatedSprite2D:
	var sprite := AnimatedSprite2D.new()
	sprite.name = name_value
	sprite.position = at
	sprite.scale = Vector2.ONE * magnification
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.sprite_frames = frames
	add_child(sprite)
	return sprite


func _set_state_manual(state: String) -> void:
	autoplay = false
	autoplay_button.text = "AUTO ▶"
	_play(state)


func _toggle_auto() -> void:
	autoplay = not autoplay
	autoplay_button.text = "AUTO ■" if autoplay else "AUTO ▶"
	if autoplay:
		phase_index = 0
		phase_time = 0.0
		_play(STATES[0])


func _play(state: String) -> void:
	active_state = state
	var valid := 0
	for sprite in current_actors + candidate_actors:
		if sprite.sprite_frames != null and sprite.sprite_frames.has_animation(state):
			sprite.play(state)
			valid += 1
	status_label.text = "D397 АРХИВ / %s — %d/6. Маг: слева 6 кадров C3, справа 5 старых v2" % [state.to_upper(), valid]


func _scrim(at: Vector2, size: Vector2, tint: Color) -> void:
	var shape := ColorRect.new()
	shape.position = at
	shape.size = size
	shape.color = tint
	shape.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shape)


func _label(value: String, at: Vector2, size: Vector2, font_size: int, tint: Color, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = value
	label.position = at
	label.size = size
	label.horizontal_alignment = alignment
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", tint)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
	return label
