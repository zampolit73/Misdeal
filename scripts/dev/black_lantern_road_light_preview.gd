extends Control

# D205 standalone preview only. No production combat, damage, or unit stats.
# Uses battle.gd's production 1280x720 ground rectangle as the guide.
const FLOOR := Rect2(110.0, 380.0, 1080.0, 158.0)
const WARNING_DURATION := 1.4
const ACTIVE_DURATION := 3.1
const REST_DURATION := 1.8
const PERIOD := WARNING_DURATION + ACTIVE_DURATION + REST_DURATION
const POOL_RADIUS := 93.0
const HERO_POSITIONS: Array[Vector2] = [Vector2(240, 465), Vector2(345, 505), Vector2(415, 430)]
const ENEMY_POSITIONS: Array[Vector2] = [
	Vector2(850, 463), Vector2(916, 517), Vector2(995, 457),
	Vector2(1061, 506), Vector2(1117, 464)
]
const ZONE_SET_A: Array[Vector2] = [Vector2(872, 473), Vector2(1068, 503)]
const ZONE_SET_B: Array[Vector2] = [Vector2(978, 500), Vector2(1096, 438)]

var elapsed := 0.0
var running := true
var state_label: Label
var help_label: Label
var pause_button: Button

func _ready() -> void:
	custom_minimum_size = Vector2(1280, 720)
	mouse_filter = Control.MOUSE_FILTER_PASS
	var title := _make_label("D205 / ДОРОГА ЧЁРНЫХ ФОНАРЕЙ — СВЕТ", Vector2(54, 25), Vector2(1170, 42), 24)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	state_label = _make_label("ПРЕДУПРЕЖДЕНИЕ", Vector2(70, 74), Vector2(1140, 42), 20)
	state_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	help_label = _make_label(
		"QA-ЭСКИЗ: 3 героя слева, 5 противников справа (крупный Проводник).\n"
		+ "Свет под бойцами, предупреждение перед смещением. Бонус атаки и бой НЕ включены.",
		Vector2(112, 582), Vector2(1056, 88), 16
	)
	help_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	help_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_button = Button.new()
	pause_button.text = "ПАУЗА"
	pause_button.position = Vector2(1092, 31)
	pause_button.size = Vector2(125, 38)
	pause_button.pressed.connect(_toggle_pause)
	add_child(pause_button)
	set_process(true)
	_refresh_state()

func _make_label(value: String, at: Vector2, dimensions: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.text = value
	label.position = at
	label.size = dimensions
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.93, 0.83, 0.69))
	add_child(label)
	return label

func _toggle_pause() -> void:
	running = not running
	pause_button.text = "ПАУЗА" if running else "ПРОДОЛЖИТЬ"

func _process(delta: float) -> void:
	if not running:
		return
	elapsed += delta
	_refresh_state()
	queue_redraw()

func _cycle_index() -> int:
	return int(floor(elapsed / PERIOD))

func _cycle_time() -> float:
	return fposmod(elapsed, PERIOD)

func _get_phase() -> String:
	var t := _cycle_time()
	if t < WARNING_DURATION:
		return "warning"
	if t < WARNING_DURATION + ACTIVE_DURATION:
		return "active"
	return "rest"

func _refresh_state() -> void:
	match _get_phase():
		"warning":
			state_label.text = "ПРЕДУПРЕЖДЕНИЕ • %.1f сек до света" % (WARNING_DURATION - _cycle_time())
		"active":
			state_label.text = "ФОНАРНЫЙ СВЕТ АКТИВЕН • %.1f сек" % (WARNING_DURATION + ACTIVE_DURATION - _cycle_time())
		_:
			state_label.text = "ТЬМА / ПЕРЕДЫШКА • %.1f сек" % (PERIOD - _cycle_time())

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), Color("#101015"))
	draw_rect(Rect2(0, 110, 1280, 460), Color("#222833"))
	# The known free-foot movement envelope is the only QA geometry.
	draw_rect(FLOOR, Color("#393936"))
	draw_line(Vector2(FLOOR.position.x, FLOOR.end.y), Vector2(FLOOR.end.x, FLOOR.end.y), Color("#79674f"), 2.0)
	draw_rect(Rect2(0, 573, 1280, 147), Color("#171317"))
	_draw_light()
	for i in range(HERO_POSITIONS.size()):
		_draw_proxy(HERO_POSITIONS[i], 58, Color("#7aa4c1"), false)
	for i in range(ENEMY_POSITIONS.size()):
		_draw_proxy(ENEMY_POSITIONS[i], 175 if i == 0 else 77, Color("#b99a6a"), i == 0)
	for pt in HERO_POSITIONS + ENEMY_POSITIONS:
		draw_arc(pt + Vector2(0, 4), 16, 0, TAU, 22, Color(0.8, 0.7, 0.5, 0.30), 1.1)

func _draw_proxy(foot: Vector2, height_px: int, color: Color, large: bool) -> void:
	var width_px := 52.0 if large else 25.0
	var height_size := float(height_px)
	draw_rect(Rect2(foot.x - width_px * 0.5, foot.y - height_size, width_px, height_size), color.darkened(0.52))
	draw_rect(Rect2(foot.x - width_px * 0.5, foot.y - height_size, width_px, height_size), color, false, 2.0)

func _draw_light() -> void:
	var is_a := (_cycle_index() % 2 == 0)
	var next_zones: Array[Vector2] = ZONE_SET_A if is_a else ZONE_SET_B
	var old_zones: Array[Vector2] = ZONE_SET_B if is_a else ZONE_SET_A
	var phase := _get_phase()
	if phase == "rest":
		return
	if phase == "warning":
		var opacity: float = 0.42 + 0.30 * absf(sin(_cycle_time() * 5.0))
		for center in next_zones:
			draw_arc(center, POOL_RADIUS, 0, TAU, 56, Color(1.0, 0.72, 0.32, opacity), 3.0, true)
		return
	# In the active phase pools visibly travel, then remain in place.
	var v: float = (_cycle_time() - WARNING_DURATION) / ACTIVE_DURATION
	var eased: float = smoothstep(0.0, 0.66, v)
	for i in range(2):
		var center: Vector2 = old_zones[i].lerp(next_zones[i], eased)
		draw_circle(center, POOL_RADIUS, Color(0.9, 0.48, 0.12, 0.13))
		draw_circle(center, POOL_RADIUS * 0.67, Color(1.0, 0.64, 0.27, 0.10))
		draw_arc(center, POOL_RADIUS, 0, TAU, 56, Color(1.0, 0.73, 0.36, 0.73), 2.0, true)
