extends Control

# D405: compare identical APPROVED C3 source attack drawings under the old
# even frame clock vs the new role-specific phase holds. Real BattleUnit
# SpriteFrames are used on BOTH sides; this is not a new bitmap or F5 combat.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const STAGE_SIZE := Vector2(1280.0, 720.0)
const ROLES := ["knight", "ranger", "mage"]
const TITLES := ["РЫЦАРЬ", "СЛЕДОПЫТ", "МАГ"]
const CENTER_X := [221.0, 638.0, 1052.0]
const PAIR_GAP := 73.0
const CYCLE_SECONDS := 0.95
const STEP_SECONDS := 0.055

var stage: Control
var even_actors: Array[BattleUnit] = []
var staged_actors: Array[BattleUnit] = []
var cycle_time := 0.0
var playing := true
var half_speed := false
var play_button: Button
var speed_button: Button
var phase_label: Label


func _ready() -> void:
	stage = Control.new()
	stage.name = "Stage"
	stage.size = STAGE_SIZE
	stage.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(stage)
	get_viewport().size_changed.connect(_fit_stage)
	_fit_stage()

	var backdrop := BACKDROP.new()
	stage.add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.set_arena_id("firing_square")
	_scrim(Vector2.ZERO, Vector2(1280, 157), Color(0.016, 0.014, 0.018, 0.94))
	_scrim(Vector2(0, 532), Vector2(1280, 188), Color(0.016, 0.014, 0.018, 0.94))
	_label("MISDEAL / D405 — АТАКИ C3: РИТМ КЛЮЧЕВЫХ ПОЗ", Vector2(25, 10), Vector2(1240, 36), 22, Color(0.91, 0.75, 0.55))
	_label("Слева — равные интервалы D404. Справа — новые выдержки тех же шести кадров. В бою повреждения не меняются.", Vector2(25, 50), Vector2(1245, 28), 16, Color(0.87, 0.83, 0.78))

	play_button = _button("PlaybackToggle", "ПАУЗА", 25, _toggle_play)
	speed_button = _button("SpeedToggle", "СКОРОСТЬ ×1", 212, _toggle_speed)
	_button("SingleStep", "СЛЕД. КАДР", 399, _step)
	_button("ResetPlayback", "ПОВТОР", 586, _reset)

	for i in range(ROLES.size()):
		var role: String = ROLES[i]
		var cx: float = CENTER_X[i]
		_label(TITLES[i], Vector2(cx - 140.0, 159), Vector2(280, 26), 18, Color(0.91, 0.75, 0.54), HORIZONTAL_ALIGNMENT_CENTER)
		even_actors.append(_actor("Even_%s" % role, role, Vector2(cx - PAIR_GAP, 411.0)))
		staged_actors.append(_actor("Staged_%s" % role, role, Vector2(cx + PAIR_GAP, 411.0)))
		_label("РОВНО", Vector2(cx - 132.0, 478), Vector2(120, 26), 15, Color(0.78, 0.79, 0.79), HORIZONTAL_ALIGNMENT_CENTER)
		_label("D405", Vector2(cx + 13.0, 478), Vector2(120, 26), 15, Color(0.94, 0.78, 0.56), HORIZONTAL_ALIGNMENT_CENTER)

	phase_label = _label("", Vector2(25, 551), Vector2(1220, 29), 18, Color(0.90, 0.76, 0.54))
	_label("Рыцарь: читаемый замах. Следопыт: задержка натяжения лука. Маг: выдержка посоха и свечения.", Vector2(25, 599), Vector2(1225, 27), 15, Color(0.86, 0.84, 0.80))
	_label("D405 не перерисовывает оружие и не меняет D404 WALK. Для ощущения попадания проверьте также реальный F5-бой.", Vector2(25, 646), Vector2(1235, 25), 14, Color(0.76, 0.78, 0.81))
	_apply_poses()


func _actor(node_name: String, role: String, at: Vector2) -> BattleUnit:
	var actor := UNIT_SCENE.instantiate() as BattleUnit
	actor.name = node_name
	actor.visual_role = role
	actor.team = 0
	actor.position = at
	stage.add_child(actor)
	actor.set_process(false)
	actor.set_process_input(false)
	actor.health_bar.visible = false
	actor.name_label.visible = false
	actor.combat_started = false
	return actor


func _process(delta: float) -> void:
	if playing:
		cycle_time = fposmod(cycle_time + delta * (0.5 if half_speed else 1.0), CYCLE_SECONDS)
		_apply_poses()


# The staged side passes through the same live BattleUnit frame selector that
# F5 uses. The even side samples exactly the old uniform source-frame clock.
func _apply_poses() -> void:
	for i in range(ROLES.size()):
		var even: BattleUnit = even_actors[i]
		var staged: BattleUnit = staged_actors[i]
		var frames: SpriteFrames = staged.sprite_frames
		if frames == null:
			continue
		var fps: float = frames.get_animation_speed("attack")
		var duration: float = 6.0 / fps
		if cycle_time >= duration:
			for actor in [even, staged]:
				actor.frame_state = "idle"
				actor.frame_time = 0.0
				actor.frame_one_shot_time = 0.0
				actor.art_sprite.texture = frames.get_frame_texture("idle", 0)
				actor._sync_rim_visual()
			continue
		var even_index := mini(int(cycle_time * fps), 5)
		even.frame_state = "attack"
		even.art_sprite.texture = frames.get_frame_texture("attack", even_index)
		even._sync_rim_visual()

		staged.frame_state = "attack"
		staged.frame_time = cycle_time
		staged.frame_one_shot_time = duration - cycle_time
		staged._update_frame_animation(0.0)
		staged._sync_rim_visual()
	phase_label.text = "D405 / %.2f с — %s (действующие C3 SpriteFrames и настоящие BattleUnit)" % [
		cycle_time, "×0.5" if half_speed else "×1"
	]


func _toggle_play() -> void:
	playing = not playing
	play_button.text = "ПАУЗА" if playing else "ВОСПРОИЗВЕСТИ"


func _toggle_speed() -> void:
	half_speed = not half_speed
	speed_button.text = "СКОРОСТЬ ×0.5" if half_speed else "СКОРОСТЬ ×1"
	_apply_poses()


func _step() -> void:
	playing = false
	play_button.text = "ВОСПРОИЗВЕСТИ"
	cycle_time = fposmod(cycle_time + STEP_SECONDS, CYCLE_SECONDS)
	_apply_poses()


func _reset() -> void:
	cycle_time = 0.0
	playing = true
	play_button.text = "ПАУЗА"
	_apply_poses()


func _fit_stage() -> void:
	_fit_stage_size(get_viewport_rect().size)


func _fit_stage_size(window_size: Vector2) -> void:
	if stage == null:
		return
	var factor := maxf(0.01, minf(window_size.x / STAGE_SIZE.x, window_size.y / STAGE_SIZE.y))
	stage.scale = Vector2.ONE * factor
	stage.position = (window_size - STAGE_SIZE * factor) * 0.5


func _button(node_name: String, label: String, left: float, action: Callable) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = label
	button.position = Vector2(left, 96)
	button.size = Vector2(171, 36)
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(action)
	stage.add_child(button)
	return button


func _scrim(at: Vector2, dimensions: Vector2, tint: Color) -> void:
	var rect := ColorRect.new()
	rect.position = at
	rect.size = dimensions
	rect.color = tint
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(rect)


func _label(value: String, at: Vector2, dimensions: Vector2, font_size: int, tint: Color,
		alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = value
	label.position = at
	label.size = dimensions
	label.horizontal_alignment = alignment
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", tint)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(label)
	return label
