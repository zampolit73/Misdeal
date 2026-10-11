extends Control

const ARENA_CRYPT := "crypt"
const ARENA_GRAVEYARD := "graveyard"
const ARENA_GALLOWS := "gallows"
const ARENA_OSSUARY := "ossuary"
const ARENA_WARDEN := "warden"
const ARENA_BONE_CRUSH := "bone_crush"
const ARENA_BONE_SWARM := "bone_swarm"
const ARENA_GRAVE_CROSSFIRE := "grave_crossfire"
const ARENA_IRON_WALL := "iron_wall"
const ARENA_LAST_BELL := "last_bell"
const ARENA_FIRING_SQUARE := "firing_square"
const ARENA_BONE_RITUAL := "bone_ritual"

var pulse: float = 0.0
var redraw_cooldown: float = 0.0
var boss_mode: bool = false
var boss_phase_two: bool = false
var arena_id: String = ARENA_CRYPT

func set_arena_id(value: String) -> void:
	match value:
		ARENA_GRAVEYARD, ARENA_GALLOWS, ARENA_OSSUARY, ARENA_WARDEN, ARENA_BONE_CRUSH, ARENA_BONE_SWARM, ARENA_GRAVE_CROSSFIRE, ARENA_IRON_WALL, ARENA_LAST_BELL, ARENA_FIRING_SQUARE, ARENA_BONE_RITUAL:
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
	redraw_cooldown -= delta
	if redraw_cooldown <= 0.0:
		redraw_cooldown = 0.05
		queue_redraw()

func _draw() -> void:
	match arena_id:
		ARENA_GRAVEYARD, ARENA_GALLOWS, ARENA_GRAVE_CROSSFIRE, ARENA_LAST_BELL, ARENA_FIRING_SQUARE:
			_draw_graveyard_atmosphere()
		ARENA_OSSUARY, ARENA_BONE_RITUAL:
			_draw_ossuary_atmosphere()
		ARENA_WARDEN:
			_draw_warden_atmosphere()
		ARENA_BONE_CRUSH, ARENA_BONE_SWARM:
			_draw_bone_crush_atmosphere()
		_:
			_draw_crypt_atmosphere()

	if boss_mode:
		_draw_boss_runes()

func _draw_crypt_atmosphere() -> void:
	var flicker := 0.5 + 0.5 * sin(pulse * 8.0)
	var glow := Color(1.0, 0.34, 0.08, 0.022 + flicker * 0.018)
	for point in [Vector2(90.0, 72.0), Vector2(332.0, 64.0), Vector2(904.0, 66.0), Vector2(1146.0, 76.0)]:
		draw_circle(point, 58.0 + flicker * 8.0, glow)
		draw_circle(point, 22.0 + flicker * 4.0, Color(1.0, 0.54, 0.16, 0.030 + flicker * 0.024))

func _draw_graveyard_atmosphere() -> void:
	var drift := fmod(pulse * 18.0, 220.0)
	var fog_color := Color(0.48, 0.62, 0.76, 0.035)
	for index in range(4):
		var x := -120.0 + drift + float(index) * 330.0
		var y := 268.0 + float(index % 2) * 72.0
		draw_circle(Vector2(x, y), 112.0, fog_color)
		draw_circle(Vector2(x + 94.0, y + 14.0), 78.0, Color(fog_color.r, fog_color.g, fog_color.b, fog_color.a * 0.72))

	var crow_x := fmod(pulse * 38.0, size.x + 120.0) - 60.0
	var crow_y := 42.0 + sin(pulse * 2.4) * 10.0
	draw_line(Vector2(crow_x - 8.0, crow_y + 3.0), Vector2(crow_x, crow_y), Color(0.02, 0.025, 0.04, 0.72), 2.0)
	draw_line(Vector2(crow_x, crow_y), Vector2(crow_x + 8.0, crow_y + 3.0), Color(0.02, 0.025, 0.04, 0.72), 2.0)

func _draw_ossuary_atmosphere() -> void:
	for index in range(16):
		var seed := float(index) * 73.0
		var x := fmod(seed * 7.0 + pulse * (5.0 + float(index % 4)), maxf(1.0, size.x))
		var y := fmod(seed * 3.0 + pulse * (12.0 + float(index % 5)), maxf(1.0, size.y))
		var alpha := 0.045 + float(index % 3) * 0.012
		draw_circle(Vector2(x, y), 1.2 + float(index % 2), Color(0.88, 0.76, 0.52, alpha))

	var breathe := 0.5 + 0.5 * sin(pulse * 2.0)
	draw_rect(Rect2(0.0, size.y - 110.0, size.x, 110.0), Color(0.30, 0.12, 0.035, 0.014 + breathe * 0.010))

func _draw_bone_crush_atmosphere() -> void:
	var breathe := 0.5 + 0.5 * sin(pulse * 1.7)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.015, 0.020, 0.028, 0.018 + breathe * 0.006))

	var chalk := Color(0.64, 0.57, 0.45, 0.24)
	var chalk_faint := Color(0.64, 0.57, 0.45, 0.11)
	var top_band := Rect2(35.0, 115.0, 480.0, 130.0)
	var bottom_band := Rect2(35.0, 270.0, 480.0, 130.0)

	var bands: Array[Rect2] = [top_band, bottom_band]
	for band in bands:
		draw_line(band.position, Vector2(band.end.x, band.position.y), chalk_faint, 1.0)
		draw_line(Vector2(band.position.x, band.end.y), band.end, chalk_faint, 1.0)

		for marker_index in range(3):
			var x: float = band.position.x + 90.0 + float(marker_index) * 135.0
			var y: float = band.position.y + band.size.y * 0.5
			draw_line(Vector2(x - 12.0, y), Vector2(x + 12.0, y), chalk, 2.0)
			draw_line(Vector2(x, y - 12.0), Vector2(x, y + 12.0), chalk, 2.0)
			draw_line(Vector2(x - 7.0, y - 7.0), Vector2(x + 7.0, y + 7.0), chalk_faint, 1.0)

func _draw_warden_atmosphere() -> void:
	var intensity := 0.5 + 0.5 * sin(pulse * 3.3)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.28, 0.0, 0.01, 0.018 + intensity * 0.012))

	for index in range(12):
		var seed := float(index) * 91.0
		var x := fmod(seed * 5.0 + pulse * (8.0 + float(index % 3)), maxf(1.0, size.x))
		var y := size.y - fmod(seed * 2.0 + pulse * (22.0 + float(index % 4) * 3.0), size.y + 40.0)
		draw_circle(Vector2(x, y), 1.5 + float(index % 2), Color(1.0, 0.20, 0.06, 0.10 + intensity * 0.04))

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
