extends Control

# D404 — actual BattleUnit C3 walk renderer on a real authored arena.
# Unlike the D398 raw AnimatedSprite2D preview, each actor uses the live
# distance-driven BattleUnit animation path. No combat AI, stats or cards.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const BACKDROP := preload("res://scripts/battle/authored_backdrop.gd")
const STAGE_SIZE := Vector2(1280.0, 720.0)
const ROLES := ["knight", "ranger", "mage"]
const LABELS := ["РЫЦАРЬ", "СЛЕДОПЫТ", "МАГ"]
const CENTERS := [205.0, 635.0, 1050.0]
const WALK_SPEEDS := [72.0, 84.0, 108.0]
const HALF_TRAVEL := 72.0
const TURN_HOLD := 0.38

var stage: Control
var heroes: Array[BattleUnit] = []
var play_time := 0.0
var running := true
var status: Label
var pause_button: Button


func _ready() -> void:
	stage = Control.new()
	stage.name = "Stage"
	stage.size = STAGE_SIZE
	stage.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(stage)
	get_viewport().size_changed.connect(_fit_stage)
	_fit_stage()

	var arena := BACKDROP.new()
	stage.add_child(arena)
	arena.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	arena.set_arena_id("firing_square")
	_scrim(Vector2.ZERO, Vector2(1280, 158), Color(0.015, 0.013, 0.018, 0.94))
	_scrim(Vector2(0, 536), Vector2(1280, 184), Color(0.015, 0.013, 0.018, 0.94))
	_label("MISDEAL / D404 — ШАГ В РЕАЛЬНОМ BATTLEUNIT", Vector2(28, 12), Vector2(1210, 36), 23, Color(0.92, 0.75, 0.54))
	_label("Три героя C3: 6 кадров WALK связаны с пройденными пикселями. Реальные масштаб, тени и точка опоры.", Vector2(28, 54), Vector2(1220, 28), 16, Color(0.88, 0.84, 0.79))
	_label("РЫЦАРЬ / 72 px/s                       СЛЕДОПЫТ / 84 px/s                           МАГ / 108 px/s", Vector2(34, 151), Vector2(1210, 29), 18, Color(0.92, 0.73, 0.52))

	pause_button = Button.new()
	pause_button.name = "PauseMotion"
	pause_button.text = "ПАУЗА"
	pause_button.size = Vector2(168, 36)
	pause_button.position = Vector2(28, 95)
	pause_button.focus_mode = Control.FOCUS_NONE
	pause_button.pressed.connect(_toggle_pause)
	stage.add_child(pause_button)
	var replay := Button.new()
	replay.name = "RestartMotion"
	replay.text = "СНАЧАЛА"
	replay.size = Vector2(168, 36)
	replay.position = Vector2(208, 95)
	replay.focus_mode = Control.FOCUS_NONE
	replay.pressed.connect(_restart)
	stage.add_child(replay)

	for i in range(ROLES.size()):
		var unit := UNIT_SCENE.instantiate() as BattleUnit
		unit.name = "LiveC3_%s" % ROLES[i]
		unit.visual_role = ROLES[i]
		unit.display_name = LABELS[i]
		unit.team = 0
		unit.position = Vector2(CENTERS[i] - HALF_TRAVEL, 407.0)
		stage.add_child(unit)
		unit.set_process(false)
		unit.set_process_input(false)
		unit.health_bar.visible = false
		unit.name_label.visible = false
		unit.combat_started = true
		unit.visual_moving = false
		heroes.append(unit)

	status = _label("", Vector2(28, 558), Vector2(1190, 30), 18, Color(0.92, 0.76, 0.53))
	_label("На поворотах боец замирает, затем идёт обратно. Кадры оружия/мантий взяты из реальных игровых атласов.", Vector2(28, 603), Vector2(1230, 25), 15, Color(0.85, 0.84, 0.79))
	_label("Это проверка ходьбы, не финальная художественная приёмка. Атаки/падения оценивайте отдельно в F5.", Vector2(28, 646), Vector2(1230, 23), 14, Color(0.76, 0.78, 0.82))
	_update_status()


func _process(delta: float) -> void:
	if not running:
		return
	play_time += delta
	for i in range(heroes.size()):
		var hero := heroes[i]
		if not is_instance_valid(hero):
			continue
		# Exactly the real game's sequencing: first read last-frame travel
		# for animation, then move the Node2D and update the velocity flag.
		hero._update_frame_animation(delta)
		hero._update_idle_visual(delta)
		hero._sync_rim_visual()
		var next_x: float = _path_x(i, play_time)
		var displacement := next_x - hero.position.x
		if absf(displacement) > 0.2:
			hero._set_facing_left(displacement < 0.0)
		hero.position.x = next_x
		hero.visual_moving = absf(displacement) > 0.2
		hero.queue_redraw()
	_update_status()


func _path_x(hero_index: int, time_seconds: float) -> float:
	var speed: float = WALK_SPEEDS[hero_index]
	var crossing: float = HALF_TRAVEL * 2.0 / speed
	var period: float = 2.0 * crossing + 2.0 * TURN_HOLD
	var t := fposmod(time_seconds, period)
	var x: float = CENTERS[hero_index]
	if t < crossing:
		return x - HALF_TRAVEL + speed * t
	if t < crossing + TURN_HOLD:
		return x + HALF_TRAVEL
	if t < crossing * 2.0 + TURN_HOLD:
		return x + HALF_TRAVEL - speed * (t - crossing - TURN_HOLD)
	return x - HALF_TRAVEL


func _toggle_pause() -> void:
	running = not running
	pause_button.text = "ПАУЗА" if running else "ПРОДОЛЖИТЬ"
	_update_status()


func _restart() -> void:
	play_time = 0.0
	running = true
	pause_button.text = "ПАУЗА"
	for i in range(heroes.size()):
		var hero := heroes[i]
		hero.position.x = CENTERS[i] - HALF_TRAVEL
		hero.c3_walk_has_sample = false
		hero.frame_state = "idle"
		hero.frame_time = 0.0
		hero.frame_one_shot_time = 0.0
		hero.walk_hold_timer = 0.0
		hero.visual_moving = false
		hero._set_facing_left(false)
		hero._update_frame_animation(0.0)
	_update_status()


func _update_status() -> void:
	if status != null:
		status.text = "D404 / %s — 3 игровых C3 BattleUnit, 12px на кадр, остановки без шагов" % ("ДВИЖЕНИЕ" if running else "ПАУЗА")


func _fit_stage() -> void:
	_fit_stage_size(get_viewport_rect().size)


func _fit_stage_size(window_size: Vector2) -> void:
	if stage == null:
		return
	var factor: float = maxf(0.01, minf(window_size.x / STAGE_SIZE.x, window_size.y / STAGE_SIZE.y))
	stage.scale = Vector2.ONE * factor
	stage.position = (window_size - STAGE_SIZE * factor) * 0.5


func _scrim(at: Vector2, dimensions: Vector2, tint: Color) -> void:
	var rect := ColorRect.new()
	rect.position = at
	rect.size = dimensions
	rect.color = tint
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(rect)


func _label(value: String, at: Vector2, dimensions: Vector2, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.position = at
	label.size = dimensions
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(label)
	return label
