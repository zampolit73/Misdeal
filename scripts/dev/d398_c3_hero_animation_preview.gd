extends Control

# D398: native F6 pair comparison of actual archived original art vs actual
# new live C3 hero animation frames. Both are real alpha SpriteFrames atlases.
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const LEGACY := preload("res://scripts/dev/c3_authored_pose_study.gd")
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const ROLES := ["knight", "ranger", "mage"]
const TITLES := ["РЫЦАРЬ", "СЛЕДОПЫТ", "МАГ"]
const STATES := ["idle", "walk", "attack", "hit", "death"]
const CENTERS := [228.0, 640.0, 1052.0]
const SOLE_Y := 453.0
const GAP := 77.0
const SCALE := [1.15, 1.28, 1.60]
const AUTO_DURATIONS := [1.3, 1.6, 0.9, 0.6, 1.2]
const FPS := [2.7, 7.0, 14.0, 12.0, 10.0]

var original_actors: Array[AnimatedSprite2D] = []
var c3_actors: Array[AnimatedSprite2D] = []
var active_state := "idle"
var autoplay := false
var phase_index := 0
var phase_time := 0.0
var status_label: Label
var auto_button: Button


func _ready() -> void:
	var arena := BACKDROP.new()
	add_child(arena)
	arena.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	arena.set_arena_id("firing_square")
	_scrim(Vector2.ZERO, Vector2(1280, 151), Color(0.015, 0.013, 0.018, 0.94))
	_scrim(Vector2(0, 544), Vector2(1280, 176), Color(0.015, 0.013, 0.018, 0.94))
	_label("MISDEAL / C3 — D398: НОВЫЕ АНИМАЦИОННЫЕ ФИГУРКИ В БОЮ", Vector2(28, 8), Vector2(1220, 34), 22, Color(0.89, 0.74, 0.56))
	_label("Слева — исходные v2 позы. Справа — отдельные C3-кадры из художественного листа, уже подключённые в бою.", Vector2(28, 44), Vector2(1220, 27), 15, Color(0.88, 0.84, 0.80))
	for i in range(STATES.size()):
		var state: String = STATES[i]
		var button := Button.new()
		button.name = "State_%s" % state
		button.text = state.to_upper()
		button.position = Vector2(28 + float(i) * 187.0, 94)
		button.size = Vector2(167, 34)
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(_play_manual.bind(state))
		add_child(button)
	auto_button = Button.new()
	auto_button.name = "AutoPlayback"
	auto_button.text = "AUTO ▶"
	auto_button.position = Vector2(979, 94)
	auto_button.size = Vector2(180, 34)
	auto_button.focus_mode = Control.FOCUS_NONE
	auto_button.pressed.connect(_toggle_auto)
	add_child(auto_button)

	for i in range(ROLES.size()):
		var role: String = ROLES[i]
		var center: float = CENTERS[i]
		var factor: float = SCALE[i]
		var body_center_y: float = SOLE_Y - (92.5 - 48.0) * factor
		_label(TITLES[i], Vector2(center - 133, 169), Vector2(266, 28), 20, Color(0.91, 0.74, 0.53), HORIZONTAL_ALIGNMENT_CENTER)
		original_actors.append(_actor("Original_%s" % role, Vector2(center - GAP, body_center_y), factor, _load_old_frames(role)))
		c3_actors.append(_actor("C3_%s" % role, Vector2(center + GAP, body_center_y), factor, LIBRARY.get_frames(role)))
		_label("v2 / БЫЛО", Vector2(center - 150, 490), Vector2(144, 25), 14, Color(0.75, 0.77, 0.79), HORIZONTAL_ALIGNMENT_CENTER)
		_label("C3 / В БОЮ", Vector2(center + 6, 490), Vector2(144, 25), 14, Color(0.93, 0.79, 0.57), HORIZONTAL_ALIGNMENT_CENTER)

	status_label = _label("", Vector2(28, 559), Vector2(1200, 28), 18, Color(0.90, 0.77, 0.58))
	_label("C3: 25 разных поз на героя; атласы 96px. Исходник — иллюстрированная раскадровка, не вручную пиксельно нарисованный atlas.", Vector2(28, 603), Vector2(1230, 24), 14, Color(0.87, 0.85, 0.81))
	_label("Проверка движения обязательна: плавность, контакты стоп, лук, меч, посох, падение. Старая v2-графика сохранена для отката.", Vector2(28, 647), Vector2(1230, 24), 14, Color(0.74, 0.76, 0.79))
	_play("idle")


func _load_old_frames(role: String) -> SpriteFrames:
	var original: Image = LEGACY.load_reference_image(role)
	if original == null:
		return null
	var tex := ImageTexture.create_from_image(original)
	if tex == null:
		return null
	var result := SpriteFrames.new()
	if result.has_animation("default"):
		result.remove_animation("default")
	for row in range(STATES.size()):
		var state: String = STATES[row]
		var columns: Array[int] = LEGACY.source_columns(role, state)
		result.add_animation(state)
		result.set_animation_speed(state, FPS[row])
		result.set_animation_loop(state, row < 2)
		for col in columns:
			var tile := AtlasTexture.new()
			tile.atlas = tex
			tile.region = Rect2(col * 96, row * 96, 96, 96)
			result.add_frame(state, tile)
	return result


func _actor(value: String, at: Vector2, magnification: float, frames: SpriteFrames) -> AnimatedSprite2D:
	var sprite := AnimatedSprite2D.new()
	sprite.name = value
	sprite.position = at
	sprite.scale = Vector2.ONE * magnification
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.sprite_frames = frames
	add_child(sprite)
	return sprite


func _process(delta: float) -> void:
	if not autoplay:
		return
	phase_time += delta
	if phase_time >= AUTO_DURATIONS[phase_index]:
		phase_time = 0.0
		phase_index = (phase_index + 1) % STATES.size()
		_play(STATES[phase_index])


func _play_manual(state: String) -> void:
	autoplay = false
	auto_button.text = "AUTO ▶"
	_play(state)


func _toggle_auto() -> void:
	autoplay = not autoplay
	auto_button.text = "AUTO ■" if autoplay else "AUTO ▶"
	if autoplay:
		phase_index = 0
		phase_time = 0.0
		_play(STATES[0])


func _play(state: String) -> void:
	active_state = state
	var played := 0
	for sprite in original_actors + c3_actors:
		if sprite.sprite_frames == null or not sprite.sprite_frames.has_animation(state):
			continue
		sprite.play(state)
		played += 1
	status_label.text = "D398 / %s — %d/6 персонажей, C3 активен в BattleUnit" % [state.to_upper(), played]


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
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
	return label
