extends Control

const ARENA_CRYPT := "crypt"
const ARENA_GRAVEYARD := "graveyard"
const ARENA_OSSUARY := "ossuary"
const ARENA_WARDEN := "warden"

var pulse: float = 0.0
var boss_mode: bool = false
var boss_phase_two: bool = false
var arena_id: String = ARENA_CRYPT

func set_arena_id(value: String) -> void:
	match value:
		ARENA_GRAVEYARD, ARENA_OSSUARY, ARENA_WARDEN:
			arena_id = value
		_:
			arena_id = ARENA_CRYPT
	queue_redraw()

func set_boss_mode(enabled: bool) -> void:
	boss_mode = enabled
	queue_redraw()

func set_boss_phase_two(enabled: bool) -> void:
	boss_phase_two = enabled
	queue_redraw()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _process(delta: float) -> void:
	pulse += delta
	if boss_mode and fmod(pulse, 0.08) < delta:
		queue_redraw()

func _draw() -> void:
	match arena_id:
		ARENA_GRAVEYARD:
			_draw_graveyard()
		ARENA_OSSUARY:
			_draw_ossuary()
		ARENA_WARDEN:
			_draw_warden_lair()
		_:
			_draw_crypt()

	_draw_ground_fade()

	if boss_mode:
		_draw_boss_runes()

func _draw_graveyard() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.035, 0.075, 0.13, 0.20))
	_draw_moon_haze(Vector2(925.0, 74.0))
	_draw_dead_tree(Vector2(120.0, 0.0), 1.0, false)
	_draw_dead_tree(Vector2(1130.0, 5.0), 0.88, true)

	var stones: Array[Rect2] = [
		Rect2(85.0, 185.0, 54.0, 82.0),
		Rect2(172.0, 210.0, 42.0, 60.0),
		Rect2(280.0, 192.0, 50.0, 76.0),
		Rect2(765.0, 205.0, 46.0, 66.0),
		Rect2(1075.0, 188.0, 58.0, 84.0),
		Rect2(1150.0, 214.0, 38.0, 58.0)
	]
	for stone in stones:
		_draw_tombstone(stone)

	_draw_fog_band(230.0, 0.11)
	_draw_fog_band(285.0, 0.07)

	for index in range(7):
		var x := 35.0 + float(index) * 188.0
		draw_line(
			Vector2(x, 330.0),
			Vector2(x + 96.0, 320.0 + float(index % 2) * 8.0),
			Color(0.38, 0.48, 0.60, 0.10),
			2.0
		)

func _draw_moon_haze(center: Vector2) -> void:
	for index in range(5, 0, -1):
		var ratio := float(index) / 5.0
		draw_circle(center, 88.0 * ratio, Color(0.36, 0.48, 0.66, 0.012 + (1.0 - ratio) * 0.012))
	draw_circle(center, 31.0, Color(0.56, 0.64, 0.72, 0.10))

func _draw_tombstone(rect: Rect2) -> void:
	var silhouette := Color(0.035, 0.047, 0.060, 0.72)
	var edge := Color(0.18, 0.24, 0.30, 0.18)
	draw_rect(Rect2(rect.position + Vector2(4.0, 18.0), Vector2(rect.size.x, rect.size.y - 18.0)), silhouette)
	draw_circle(Vector2(rect.position.x + rect.size.x * 0.5, rect.position.y + 18.0), rect.size.x * 0.5, silhouette)
	draw_line(
		Vector2(rect.position.x + 7.0, rect.position.y + rect.size.y),
		Vector2(rect.position.x + rect.size.x - 6.0, rect.position.y + rect.size.y),
		edge,
		2.0
	)

func _draw_dead_tree(origin: Vector2, scale_value: float, mirrored: bool) -> void:
	var sign := -1.0 if mirrored else 1.0
	var trunk := Color(0.025, 0.020, 0.027, 0.76)
	var branch := Color(0.050, 0.045, 0.055, 0.58)
	var base := origin + Vector2(0.0, 250.0)
	draw_line(base, origin + Vector2(sign * 14.0, 60.0), trunk, 13.0 * scale_value)
	draw_line(origin + Vector2(sign * 8.0, 132.0), origin + Vector2(sign * 82.0, 90.0), branch, 6.0 * scale_value)
	draw_line(origin + Vector2(sign * 46.0, 112.0), origin + Vector2(sign * 120.0, 68.0), branch, 4.0 * scale_value)
	draw_line(origin + Vector2(sign * 19.0, 98.0), origin + Vector2(sign * 54.0, 35.0), branch, 4.0 * scale_value)
	draw_line(origin + Vector2(sign * 73.0, 94.0), origin + Vector2(sign * 93.0, 39.0), branch, 3.0 * scale_value)

func _draw_fog_band(y: float, alpha: float) -> void:
	var fog := Color(0.35, 0.43, 0.53, alpha)
	draw_rect(Rect2(0.0, y, size.x, 22.0), fog)
	draw_circle(Vector2(220.0, y + 9.0), 54.0, Color(fog.r, fog.g, fog.b, fog.a * 0.42))
	draw_circle(Vector2(760.0, y + 14.0), 78.0, Color(fog.r, fog.g, fog.b, fog.a * 0.32))
	draw_circle(Vector2(1110.0, y + 7.0), 48.0, Color(fog.r, fog.g, fog.b, fog.a * 0.38))

func _draw_crypt() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.13, 0.055, 0.034, 0.11))
	_draw_crypt_arch(Vector2(128.0, 20.0), 0.92)
	_draw_crypt_arch(Vector2(1010.0, 18.0), 0.88)

	for index in range(5):
		var x := 30.0 + float(index) * 294.0
		draw_line(
			Vector2(x, 345.0),
			Vector2(x + 238.0, 345.0),
			Color(0.44, 0.26, 0.19, 0.08),
			2.0
		)
		draw_line(
			Vector2(x + 92.0, 300.0),
			Vector2(x + 116.0, 465.0),
			Color(0.16, 0.08, 0.065, 0.12),
			1.0
		)

	_draw_brazier(Vector2(126.0, 295.0), 0.75)
	_draw_brazier(Vector2(1112.0, 295.0), 0.75)

func _draw_crypt_arch(origin: Vector2, scale_value: float) -> void:
	var stone := Color(0.045, 0.031, 0.034, 0.62)
	var edge := Color(0.25, 0.14, 0.12, 0.13)
	draw_rect(Rect2(origin.x, origin.y + 70.0, 62.0 * scale_value, 205.0 * scale_value), stone)
	draw_rect(Rect2(origin.x + 112.0 * scale_value, origin.y + 70.0, 62.0 * scale_value, 205.0 * scale_value), stone)
	draw_arc(
		origin + Vector2(87.0, 76.0) * scale_value,
		88.0 * scale_value,
		PI,
		TAU,
		24,
		stone,
		24.0 * scale_value
	)
	draw_line(origin + Vector2(0.0, 275.0) * scale_value, origin + Vector2(174.0, 275.0) * scale_value, edge, 3.0)

func _draw_brazier(center: Vector2, scale_value: float) -> void:
	var metal := Color(0.12, 0.07, 0.06, 0.72)
	draw_line(center + Vector2(-18.0, 0.0) * scale_value, center + Vector2(18.0, 0.0) * scale_value, metal, 5.0 * scale_value)
	draw_line(center, center + Vector2(0.0, 50.0) * scale_value, metal, 5.0 * scale_value)
	draw_line(center + Vector2(-13.0, 50.0) * scale_value, center + Vector2(13.0, 50.0) * scale_value, metal, 4.0 * scale_value)
	draw_circle(center + Vector2(0.0, -10.0) * scale_value, 19.0 * scale_value, Color(0.82, 0.20, 0.05, 0.055))
	draw_circle(center + Vector2(0.0, -8.0) * scale_value, 9.0 * scale_value, Color(1.0, 0.45, 0.10, 0.15))

func _draw_ossuary() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.16, 0.095, 0.035, 0.13))
	_draw_bone_arch(Vector2(175.0, 58.0), 0.86)
	_draw_bone_arch(Vector2(1015.0, 52.0), 0.82)
	_draw_bone_pile(Vector2(105.0, 315.0), 1.0)
	_draw_bone_pile(Vector2(1130.0, 315.0), 0.95)
	_draw_bone_pile(Vector2(640.0, 367.0), 0.62)

	for index in range(6):
		var y := 118.0 + float(index) * 34.0
		draw_line(
			Vector2(440.0, y),
			Vector2(800.0, y + 3.0),
			Color(0.62, 0.48, 0.30, 0.055),
			2.0
		)

	_draw_brazier(Vector2(210.0, 282.0), 0.66)
	_draw_brazier(Vector2(1030.0, 282.0), 0.66)

func _draw_bone_arch(origin: Vector2, scale_value: float) -> void:
	var bone := Color(0.46, 0.38, 0.27, 0.22)
	var shadow := Color(0.035, 0.025, 0.020, 0.44)
	draw_line(origin + Vector2(0.0, 205.0) * scale_value, origin + Vector2(0.0, 52.0) * scale_value, shadow, 17.0 * scale_value)
	draw_line(origin + Vector2(108.0, 205.0) * scale_value, origin + Vector2(108.0, 52.0) * scale_value, shadow, 17.0 * scale_value)
	draw_arc(origin + Vector2(54.0, 56.0) * scale_value, 56.0 * scale_value, PI, TAU, 24, shadow, 17.0 * scale_value)

	for index in range(5):
		var y := 82.0 + float(index) * 28.0
		draw_line(
			origin + Vector2(8.0, y) * scale_value,
			origin + Vector2(40.0, y + 12.0) * scale_value,
			bone,
			4.0 * scale_value
		)
		draw_line(
			origin + Vector2(100.0, y) * scale_value,
			origin + Vector2(68.0, y + 12.0) * scale_value,
			bone,
			4.0 * scale_value
		)

func _draw_bone_pile(center: Vector2, scale_value: float) -> void:
	var bone := Color(0.64, 0.52, 0.34, 0.18)
	var shadow := Color(0.025, 0.018, 0.017, 0.34)
	_draw_ellipse_shape(center + Vector2(0.0, 18.0), Vector2(72.0, 22.0) * scale_value, shadow)
	for index in range(7):
		var angle := -0.8 + float(index) * 0.27
		var start := center + Vector2(-46.0 + float(index) * 14.0, 4.0 + float(index % 2) * 8.0) * scale_value
		var direction := Vector2(cos(angle), sin(angle))
		draw_line(start, start + direction * 42.0 * scale_value, bone, 4.0 * scale_value)
		draw_circle(start, 3.0 * scale_value, bone)

func _draw_ellipse_shape(center: Vector2, radii: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for index in range(24):
		var angle := TAU * float(index) / 24.0
		points.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	draw_colored_polygon(points, color)

func _draw_warden_lair() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.20, 0.018, 0.018, 0.16))
	_draw_ossuary()
	_draw_chain(Vector2(70.0, -20.0), Vector2(280.0, 182.0))
	_draw_chain(Vector2(1170.0, -20.0), Vector2(960.0, 182.0))
	_draw_warden_gate()

func _draw_chain(start: Vector2, finish: Vector2) -> void:
	var chain := Color(0.26, 0.17, 0.13, 0.34)
	var segments := 11
	for index in range(segments):
		var t := float(index) / float(segments - 1)
		var center := start.lerp(finish, t)
		var radius := 9.0 if index % 2 == 0 else 7.0
		draw_arc(center, radius, 0.0, TAU, 12, chain, 3.0)

func _draw_warden_gate() -> void:
	var center_x := size.x * 0.76
	var gate := Color(0.035, 0.022, 0.025, 0.46)
	var edge := Color(0.40, 0.12, 0.08, 0.12)
	draw_rect(Rect2(center_x - 122.0, 42.0, 244.0, 240.0), gate)
	for index in range(6):
		var x := center_x - 96.0 + float(index) * 38.0
		draw_line(Vector2(x, 45.0), Vector2(x, 280.0), edge, 5.0)
	draw_arc(Vector2(center_x, 74.0), 118.0, PI, TAU, 30, edge, 8.0)

func _draw_ground_fade() -> void:
	draw_rect(Rect2(0.0, size.y - 90.0, size.x, 90.0), Color(0.008, 0.006, 0.009, 0.11))

func _draw_boss_runes() -> void:
	var intensity: float = 0.5 + 0.5 * sin(pulse * 4.0)
	var center: Vector2 = Vector2(size.x * 0.76, 300.0)
	var rune_color: Color = Color(0.92, 0.12, 0.06, 0.26 + intensity * 0.08)

	if boss_phase_two:
		rune_color = Color(1.0, 0.18, 0.05, 0.42 + intensity * 0.13)

	draw_rect(
		Rect2(size.x * 0.52, 0.0, size.x * 0.48, size.y),
		Color(0.26, 0.01, 0.02, 0.035 + intensity * 0.018)
	)
	draw_arc(center, 124.0, 0.0, TAU, 56, rune_color, 3.0)
	draw_arc(
		center,
		92.0,
		0.0,
		TAU,
		48,
		Color(rune_color.r, rune_color.g, rune_color.b, rune_color.a * 0.72),
		2.0
	)

	if boss_phase_two:
		draw_circle(center, 130.0, Color(0.68, 0.02, 0.01, 0.035 + intensity * 0.02))
		draw_line(
			center + Vector2(-160.0, 0.0),
			center + Vector2(160.0, 0.0),
			Color(0.96, 0.14, 0.06, 0.24 + intensity * 0.08),
			2.0
		)
