extends Control

var pulse: float = 0.0
var boss_mode: bool = false
var boss_phase_two: bool = false

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
	if fmod(pulse, 0.08) < delta:
		queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.020, 0.018, 0.028, 1.0))
	_draw_crypt_wall()
	_draw_floor()
	_draw_side_washes()
	_draw_center_ritual()
	_draw_columns_and_banners()
	_draw_braziers()
	_draw_bones_and_rubble()
	if boss_mode:
		_draw_boss_arena()
	_draw_vignette()
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.30, 0.16, 0.17, 0.95), false, 3.0)

func _draw_crypt_wall() -> void:
	var wall_h: float = 112.0
	draw_rect(Rect2(0.0, 0.0, size.x, wall_h), Color(0.025, 0.023, 0.036, 1.0))
	draw_rect(Rect2(0.0, wall_h - 8.0, size.x, 8.0), Color(0.095, 0.060, 0.065, 1.0))

	var brick_w: float = 58.0
	var brick_h: float = 28.0
	for row in range(4):
		var row_offset: float = 0.0 if row % 2 == 0 else brick_w * 0.5
		for col in range(int(size.x / brick_w) + 2):
			var x: float = float(col) * brick_w - row_offset
			var rect: Rect2 = Rect2(x + 1.0, float(row) * brick_h + 1.0, brick_w - 3.0, brick_h - 3.0)
			var shade: float = 0.035 * float((row + col) % 3)
			draw_rect(rect, Color(0.060 - shade, 0.052 - shade * 0.6, 0.070 - shade * 0.2, 1.0))
			draw_rect(rect, Color(0.12, 0.085, 0.095, 0.58), false, 1.0)

	# central altar / barred recess
	draw_rect(Rect2(size.x * 0.5 - 130.0, 5.0, 260.0, 100.0), Color(0.012, 0.012, 0.020, 0.98))
	for x in range(int(size.x * 0.5 - 105.0), int(size.x * 0.5 + 106.0), 28):
		draw_rect(Rect2(float(x), 12.0, 5.0, 88.0), Color(0.11, 0.08, 0.085, 1.0))
	draw_rect(Rect2(size.x * 0.5 - 138.0, 94.0, 276.0, 12.0), Color(0.13, 0.085, 0.075, 1.0))

func _draw_floor() -> void:
	var floor_top: float = 108.0
	draw_rect(Rect2(0.0, floor_top, size.x, size.y - floor_top), Color(0.050, 0.046, 0.061, 1.0))

	var rows: int = 7
	var cols: int = 13
	var tile_h: float = (size.y - floor_top) / float(rows)
	var tile_w: float = size.x / float(cols)
	for row in range(rows):
		for col in range(cols):
			var offset_x: float = 0.0 if row % 2 == 0 else tile_w * 0.5
			var px: float = float(col) * tile_w - offset_x
			var py: float = floor_top + float(row) * tile_h
			var tile: Rect2 = Rect2(px + 2.0, py + 2.0, tile_w - 4.0, tile_h - 4.0)
			var alt: float = 0.008 if (row + col) % 2 == 0 else 0.0
			draw_rect(tile, Color(0.064 + alt, 0.057 + alt, 0.071 + alt, 1.0))
			draw_rect(tile, Color(0.13, 0.10, 0.11, 0.55), false, 1.0)

	# cracks and blood
	var crack_color: Color = Color(0.12, 0.09, 0.10, 0.7)
	var blood: Color = Color(0.26, 0.025, 0.035, 0.38)
	var crack_lines: Array[PackedVector2Array] = [
		PackedVector2Array([Vector2(72, 328), Vector2(140, 314), Vector2(205, 329)]),
		PackedVector2Array([Vector2(360, 192), Vector2(430, 207), Vector2(478, 188)]),
		PackedVector2Array([Vector2(930, 352), Vector2(1002, 338), Vector2(1078, 356)]),
		PackedVector2Array([Vector2(770, 182), Vector2(828, 198), Vector2(892, 188)])
	]
	for line in crack_lines:
		draw_polyline(line, crack_color, 2.0)

	draw_rect(Rect2(425.0, 340.0, 78.0, 8.0), blood)
	draw_rect(Rect2(812.0, 270.0, 96.0, 10.0), blood)
	draw_rect(Rect2(970.0, 395.0, 54.0, 6.0), blood)

func _draw_side_washes() -> void:
	draw_rect(Rect2(0.0, 108.0, size.x * 0.49, size.y - 108.0), Color(0.025, 0.12, 0.22, 0.10))
	draw_rect(Rect2(size.x * 0.51, 108.0, size.x * 0.49, size.y - 108.0), Color(0.24, 0.035, 0.035, 0.10))
	draw_line(Vector2(size.x * 0.5, 112.0), Vector2(size.x * 0.5, size.y - 8.0), Color(0.45, 0.10, 0.13, 0.48), 2.0)

func _draw_center_ritual() -> void:
	var center: Vector2 = Vector2(size.x * 0.5, 300.0)
	var glow: float = 0.5 + 0.5 * sin(pulse * 2.4)
	var rune: Color = Color(0.55, 0.11, 0.12, 0.40 + glow * 0.08)
	draw_circle(center, 115.0, Color(rune.r, rune.g, rune.b, 0.025))
	draw_arc(center, 112.0, 0.0, TAU, 56, rune, 3.0)
	draw_arc(center, 78.0, 0.0, TAU, 48, Color(rune.r, rune.g, rune.b, rune.a * 0.78), 2.0)
	draw_arc(center, 31.0, 0.0, TAU, 32, Color(rune.r, rune.g, rune.b, rune.a * 0.66), 1.5)

	var directions: Array[Vector2] = [
		Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0),
		Vector2(0.707, -0.707), Vector2(0.707, 0.707), Vector2(-0.707, 0.707), Vector2(-0.707, -0.707)
	]
	for direction in directions:
		draw_line(center + direction * 32.0, center + direction * 110.0, rune, 2.0)

	var diamond: PackedVector2Array = PackedVector2Array([
		center + Vector2(0, -17), center + Vector2(17, 0),
		center + Vector2(0, 17), center + Vector2(-17, 0), center + Vector2(0, -17)
	])
	draw_polyline(diamond, Color(0.70, 0.18, 0.16, 0.62), 2.0)

func _draw_columns_and_banners() -> void:
	var column_xs: Array[float] = [28.0, 190.0, 350.0, 850.0, 1010.0, 1172.0]
	for x in column_xs:
		draw_rect(Rect2(x, 18.0, 36.0, 98.0), Color(0.055, 0.045, 0.058, 1.0))
		draw_rect(Rect2(x - 6.0, 14.0, 48.0, 10.0), Color(0.105, 0.072, 0.075, 1.0))
		draw_rect(Rect2(x - 8.0, 103.0, 52.0, 11.0), Color(0.11, 0.072, 0.070, 1.0))
		draw_line(Vector2(x + 8.0, 28.0), Vector2(x + 8.0, 98.0), Color(0.12, 0.085, 0.09, 0.7), 2.0)
		draw_line(Vector2(x + 28.0, 28.0), Vector2(x + 28.0, 98.0), Color(0.12, 0.085, 0.09, 0.7), 2.0)

	var banner_xs: Array[float] = [128.0, 1032.0]
	for x in banner_xs:
		var cloth: PackedVector2Array = PackedVector2Array([
			Vector2(x, 4.0), Vector2(x + 42.0, 4.0), Vector2(x + 40.0, 82.0),
			Vector2(x + 22.0, 69.0), Vector2(x + 4.0, 82.0)
		])
		draw_colored_polygon(cloth, Color(0.24, 0.035, 0.050, 0.96))
		draw_polyline(PackedVector2Array([cloth[0], cloth[1], cloth[2], cloth[3], cloth[4], cloth[0]]), Color(0.48, 0.13, 0.12, 0.82), 2.0)
		draw_line(Vector2(x + 21.0, 18.0), Vector2(x + 21.0, 55.0), Color(0.63, 0.26, 0.15, 0.72), 3.0)
		draw_line(Vector2(x + 9.0, 35.0), Vector2(x + 33.0, 35.0), Color(0.63, 0.26, 0.15, 0.72), 3.0)

	# hanging chains
	var chain_starts: Array[Vector2] = [Vector2(82, 0), Vector2(278, 0), Vector2(922, 0), Vector2(1118, 0)]
	for start in chain_starts:
		for i in range(7):
			var p: Vector2 = start + Vector2(float(i) * 9.0, float(i) * 7.0)
			draw_arc(p, 4.0, 0.0, TAU, 10, Color(0.30, 0.24, 0.24, 0.72), 2.0)

func _draw_braziers() -> void:
	var brazier_positions: Array[Vector2] = [
		Vector2(82, 122), Vector2(300, 95), Vector2(900, 95), Vector2(1118, 122)
	]
	for pos in brazier_positions:
		var flicker: float = 1.0 + sin(pulse * 9.0 + pos.x * 0.02) * 0.10
		draw_rect(Rect2(pos.x - 12.0, pos.y - 7.0, 24.0, 14.0), Color(0.16, 0.095, 0.070, 1.0))
		draw_rect(Rect2(pos.x - 5.0, pos.y + 5.0, 10.0, 20.0), Color(0.095, 0.070, 0.070, 1.0))
		draw_circle(pos + Vector2(0, -14), 24.0 * flicker, Color(1.0, 0.16, 0.035, 0.07))
		draw_rect(Rect2(pos.x - 7.0, pos.y - 31.0, 14.0, 21.0 * flicker), Color(0.96, 0.20, 0.045, 0.92))
		draw_rect(Rect2(pos.x - 3.0, pos.y - 27.0, 6.0, 14.0 * flicker), Color(1.0, 0.69, 0.20, 1.0))

func _draw_bones_and_rubble() -> void:
	var bone: Color = Color(0.56, 0.49, 0.39, 0.72)
	var rubble: Color = Color(0.10, 0.085, 0.105, 0.96)
	var skulls: Array[Vector2] = [Vector2(110, 94), Vector2(246, 105), Vector2(947, 104), Vector2(1092, 92), Vector2(1125, 402)]
	for pos in skulls:
		draw_circle(pos, 8.0, bone)
		draw_rect(Rect2(pos.x - 5.0, pos.y + 5.0, 10.0, 5.0), bone.darkened(0.10))
		draw_circle(pos + Vector2(-3.0, -1.5), 1.4, Color(0.025, 0.020, 0.025, 1.0))
		draw_circle(pos + Vector2(3.0, -1.5), 1.4, Color(0.025, 0.020, 0.025, 1.0))

	var bone_lines: Array[PackedVector2Array] = [
		PackedVector2Array([Vector2(38, 388), Vector2(66, 378)]),
		PackedVector2Array([Vector2(50, 373), Vector2(75, 393)]),
		PackedVector2Array([Vector2(1090, 342), Vector2(1124, 354)]),
		PackedVector2Array([Vector2(1100, 359), Vector2(1120, 335)])
	]
	for line in bone_lines:
		draw_polyline(line, bone, 3.0)

	var rubble_positions: Array[Vector2] = [Vector2(120, 418), Vector2(326, 133), Vector2(812, 127), Vector2(1050, 414)]
	for pos in rubble_positions:
		draw_rect(Rect2(pos.x, pos.y, 20, 8), rubble)
		draw_rect(Rect2(pos.x + 12, pos.y - 6, 15, 7), rubble.darkened(0.08))

func _draw_boss_arena() -> void:
	var intensity: float = 0.5 + 0.5 * sin(pulse * 4.0)
	var center: Vector2 = Vector2(size.x * 0.76, 300.0)
	var rune: Color = Color(0.92, 0.12, 0.06, 0.44 + intensity * 0.12)
	if boss_phase_two:
		rune = Color(1.0, 0.18, 0.05, 0.64 + intensity * 0.12)

	draw_rect(Rect2(size.x * 0.52, 108.0, size.x * 0.48, size.y - 108.0), Color(0.22, 0.01, 0.018, 0.08 + intensity * 0.025))
	draw_arc(center, 124.0, 0.0, TAU, 56, rune, 3.0)
	draw_arc(center, 92.0, 0.0, TAU, 48, Color(rune.r, rune.g, rune.b, rune.a * 0.75), 2.0)

	if boss_phase_two:
		draw_circle(center, 130.0, Color(0.65, 0.02, 0.01, 0.055))
		draw_line(center + Vector2(-160, 0), center + Vector2(160, 0), Color(0.95, 0.14, 0.06, 0.32), 2.0)

func _draw_vignette() -> void:
	for i in range(7):
		var alpha: float = 0.030 + float(i) * 0.016
		var inset: float = float(i) * 7.0
		draw_rect(Rect2(inset, inset, size.x - inset * 2.0, size.y - inset * 2.0), Color(0, 0, 0, alpha), false, 8.0)
