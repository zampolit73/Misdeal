extends Control

# D396: side-by-side real pose timing comparison ONLY. No live BattleUnit edits.
const DRAFT := preload("res://scripts/dev/c3_motion_blocking.gd")
const AUTHORED := preload("res://scripts/dev/c3_authored_pose_study.gd")
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const ROLES := ["knight", "ranger", "mage"]
const TITLES := ["РЫЦАРЬ", "СЛЕДОПЫТ", "МАГ"]
const STATES := ["idle", "walk", "attack", "hit", "death"]
const PAIR_CENTERS := [228.0, 640.0, 1052.0]
const ACTOR_Y := 407.0
const ACTOR_SCALE := 1.35

var draft_actors: Array[AnimatedSprite2D] = []
var authored_actors: Array[AnimatedSprite2D] = []
var active_state := "idle"
var status: Label


func _ready() -> void:
	var arena := BACKDROP.new()
	add_child(arena)
	arena.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	arena.set_arena_id("firing_square")
	_scrim(Vector2.ZERO, Vector2(1280.0, 151.0), Color(0.013, 0.013, 0.02, 0.92))
	_scrim(Vector2(0.0, 545.0), Vector2(1280.0, 175.0), Color(0.013, 0.013, 0.02, 0.93))
	_label("MISDEAL / C3 — D396: РЕАЛЬНЫЕ ПОЗЫ ПРОТИВ ЧЕРНОВОГО БЛОКИНГА", Vector2(30, 10), Vector2(1230, 34), 22, Color(0.92, 0.76, 0.57))
	_label("Слева: деформация D395. Справа: старые нарисованные кадры v2 (рыцарь — проба бордового цвета).", Vector2(30, 49), Vector2(1210, 24), 15, Color(0.88, 0.84, 0.81))
	for index in range(STATES.size()):
		var state: String = STATES[index]
		var button := Button.new()
		button.name = "State_%s" % state
		button.text = state.to_upper()
		button.position = Vector2(30.0 + 202.0 * float(index), 91.0)
		button.size = Vector2(180.0, 34.0)
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(_play.bind(state))
		add_child(button)
	for i in range(ROLES.size()):
		var role: String = ROLES[i]
		var center: float = PAIR_CENTERS[i]
		_label(TITLES[i], Vector2(center - 146.0, 162.0), Vector2(292.0, 30.0), 20, Color(0.94, 0.74, 0.51), HORIZONTAL_ALIGNMENT_CENTER)
		var draft := _actor("Blocking_%s" % role, Vector2(center - 89.0, ACTOR_Y), DRAFT.make_frames(role))
		draft_actors.append(draft)
		var reference := _actor("Authored_%s" % role, Vector2(center + 89.0, ACTOR_Y), AUTHORED.make_frames(role))
		authored_actors.append(reference)
		_label("D395 / деформация", Vector2(center - 170.0, 502.0), Vector2(162.0, 26.0), 13, Color(0.70, 0.72, 0.77), HORIZONTAL_ALIGNMENT_CENTER)
		_label("D396 / позы v2", Vector2(center + 8.0, 502.0), Vector2(162.0, 26.0), 13, Color(0.84, 0.85, 0.79), HORIZONTAL_ALIGNMENT_CENTER)
	status = _label("", Vector2(30, 559), Vector2(1230, 27), 17, Color(0.89, 0.76, 0.59))
	_label("QA: справа движения из предыдущих НАСТОЯЩИХ 96px-атласов, но внешность ещё не утверждённый C3.", Vector2(30, 603), Vector2(1220, 27), 15, Color(0.92, 0.87, 0.84))
	_label("У мага в старом атласе 5 полноценных кадров атаки; отдельный снаряд пропущен. Бой не изменён.", Vector2(30, 644), Vector2(1220, 26), 14, Color(0.70, 0.72, 0.77))
	_play("idle")


func _actor(name_value: String, pos: Vector2, frames: SpriteFrames) -> AnimatedSprite2D:
	var sprite := AnimatedSprite2D.new()
	sprite.name = name_value
	sprite.position = pos
	sprite.scale = Vector2.ONE * ACTOR_SCALE
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.sprite_frames = frames
	add_child(sprite)
	return sprite


func _play(state: String) -> void:
	active_state = state
	var loaded := 0
	for actor in draft_actors + authored_actors:
		if actor.sprite_frames == null or not actor.sprite_frames.has_animation(state):
			continue
		actor.play(state)
		loaded += 1
	status.text = "D396 / %s — %d/6 фигурок движутся; сравнение ритма, хвата, контакта ног и падения" % [state.to_upper(), loaded]


func _scrim(pos: Vector2, dimensions: Vector2, tint: Color) -> void:
	var shape := ColorRect.new()
	shape.position = pos
	shape.size = dimensions
	shape.color = tint
	shape.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shape)


func _label(value: String, pos: Vector2, dimensions: Vector2, font_size: int, tint: Color, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = value
	label.position = pos
	label.size = dimensions
	label.horizontal_alignment = alignment
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", tint)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.96))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
	return label
