extends Control

# D395: real playback of QA motion drafts; never modifies production characters.
const MOTION := preload("res://scripts/dev/c3_motion_blocking.gd")
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const ROLES := ["knight", "ranger", "mage"]
const TITLES := ["РЫЦАРЬ", "СЛЕДОПЫТ", "МАГ"]
const STATES := ["idle", "walk", "attack", "hit", "death"]
const ACTOR_Y := 386.0
const ACTOR_SCALE := 1.55
var actors: Array[AnimatedSprite2D] = []
var status: Label
var selected_state := "idle"


func _ready() -> void:
	var backdrop := BACKDROP.new()
	add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.set_arena_id("firing_square")
	_overlay(Vector2(0.0, 0.0), Vector2(1280.0, 140.0), Color(0.015, 0.012, 0.02, 0.90))
	_overlay(Vector2(0.0, 548.0), Vector2(1280.0, 172.0), Color(0.015, 0.012, 0.02, 0.94))
	_label("MISDEAL / C3 — D395 АНИМАЦИЯ: ЧЕРНОВОЙ БЛОКИНГ", Vector2(32, 14), Vector2(1220, 36), 24, Color(0.87, 0.72, 0.54))
	_label("25 кадров/герой: idle 4 / walk 6 / attack 6 / hit 3 / death 6", Vector2(32, 55), Vector2(1200, 28), 17, Color(0.9, 0.85, 0.79))
	for index in range(STATES.size()):
		var state: String = STATES[index]
		var button := Button.new()
		button.name = "State_%s" % state
		button.text = state.to_upper()
		button.position = Vector2(32.0 + float(index) * 207.0, 94.0)
		button.size = Vector2(182.0, 32.0)
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(_play.bind(state))
		add_child(button)
	for index in range(ROLES.size()):
		var sprite := AnimatedSprite2D.new()
		sprite.name = "C3_%s" % ROLES[index]
		sprite.position = Vector2(240.0 + float(index) * 405.0, ACTOR_Y)
		sprite.scale = Vector2.ONE * ACTOR_SCALE
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.sprite_frames = MOTION.make_frames(ROLES[index])
		add_child(sprite)
		actors.append(sprite)
		_label(TITLES[index], Vector2(135.0 + float(index) * 405.0, 177.0), Vector2(210.0, 32.0), 21, Color(0.89, 0.74, 0.55))
	status = _label("", Vector2(32.0, 567.0), Vector2(1215.0, 28.0), 18, Color(0.92, 0.78, 0.58))
	_label("QA ТОЛЬКО: это анимированный блокинг из одиночных поз D392, НЕ готовая нарисованная анимация.", Vector2(32.0, 611.0), Vector2(1210.0, 24.0), 15, Color(0.91, 0.87, 0.83))
	_label("Постановка шагов, удара, реакции и падения — без замены действующих боевых спрайтов.", Vector2(32.0, 648.0), Vector2(1210.0, 24.0), 14, Color(0.67, 0.7, 0.72))
	_play("idle")


func _play(state: String) -> void:
	selected_state = state
	var count := 0
	for actor in actors:
		if actor.sprite_frames == null or not actor.sprite_frames.has_animation(state):
			continue
		actor.play(state)
		count += 1
	status.text = "D395 / %s — анимация %d/3 героев (~96px черновые кадры; не в бою)" % [state.to_upper(), count]


func _overlay(where: Vector2, size: Vector2, color: Color) -> void:
	var block := ColorRect.new()
	block.position = where
	block.size = size
	block.color = color
	block.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(block)


func _label(value: String, where: Vector2, size: Vector2, font_size: int, color: Color) -> Label:
	var result := Label.new()
	result.text = value
	result.position = where
	result.size = size
	result.add_theme_font_size_override("font_size", font_size)
	result.add_theme_color_override("font_color", color)
	result.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	result.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(result)
	return result
