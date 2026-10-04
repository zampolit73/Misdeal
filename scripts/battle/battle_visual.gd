extends Control

var pulse := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _process(delta: float) -> void:
	pulse += delta
	if fmod(pulse, 0.08) < delta:
		queue_redraw()

func _draw() -> void:
	var bg := Color(0.035, 0.033, 0.048, 1.0)
	var tile_a := Color(0.070, 0.064, 0.082, 1.0)
	var tile_b := Color(0.057, 0.053, 0.071, 1.0)
	var grout := Color(0.105, 0.090, 0.110, 0.78)
	var rune := Color(0.42, 0.18, 0.17, 0.42)
	var wall_dark := Color(0.040, 0.033, 0.048, 1.0)
	var wall_mid := Color(0.075, 0.055, 0.066, 1.0)
	var edge := Color(0.20, 0.14, 0.16, 0.95)

	draw_rect(Rect2(Vector2.ZERO, size), bg)
	_draw_back_wall(wall_dark, wall_mid)
	_draw_floor(tile_a, tile_b, grout)
	_draw_center_sigil(rune)
	_draw_banners()
	_draw_torches()
	_draw_debris()
	_draw_blood()
	_draw_vignette()
	draw_rect(Rect2(Vector2.ZERO, size), edge, false, 3.0)

func _draw_back_wall(wall_dark: Color, wall_mid: Color) -> void:
	draw_rect(Rect2(0.0, 0.0, size.x, 74.0), wall_dark)
	draw_rect(Rect2(0.0, 70.0, size.x, 5.0), Color(0.13, 0.085, 0.09, 1.0))

	var brick_w := 52.0
	var brick_h := 24.0
	for row in range(3):
		var offset := 0.0 if row % 2 == 0 else brick_w * 0.5
		for col in range(int(size.x / brick_w) + 2):
			var x := float(col) * brick_w - offset
			var rect := Rect2(x + 1.0, float(row) * brick_h + 2.0, brick_w - 3.0, brick_h - 3.0)
			draw_rect(rect, wall_mid.darkened(float((row + col) % 3) * 0.05))
			draw_rect(rect, Color(0.12, 0.085, 0.10, 0.75), false, 1.0)

	for x in [94.0, 558.0, 1085.0]:
		draw_rect(Rect2(x, 10.0, 18.0, 64.0), Color(0.032, 0.027, 0.038, 1.0))
		draw_rect(Rect2(x - 5.0, 6.0, 28.0, 7.0), Color(0.10, 0.075, 0.082, 1.0))

func _draw_floor(tile_a: Color, tile_b: Color, grout: Color) -> void:
	var floor_top := 74.0
	var tile_size := Vector2(64.0, 56.0)
	var rows := int(ceil((size.y - floor_top) / tile_size.y))
	var cols := int(ceil(size.x / tile_size.x))

	for row in range(rows):
		for col in range(cols):
			var offset_x := 0.0 if row % 2 == 0 else tile_size.x * 0.5
			var tile_pos := Vector2(float(col) * tile_size.x - offset_x, floor_top + float(row) * tile_size.y)
			var tile_rect := Rect2(tile_pos + Vector2(2.0, 2.0), tile_size - Vector2(4.0, 4.0))
			var tile_color := tile_a if (row + col) % 2 == 0 else tile_b
			draw_rect(tile_rect, tile_color)
			draw_rect(tile_rect, grout, false, 1.0)

func _draw_center_sigil(rune: Color) -> void:
	var center := Vector2(size.x * 0.5, 270.0)
	draw_line(Vector2(center.x, 78.0), Vector2(center.x, size.y - 10.0), rune, 2.0)
	draw_line(Vector2(center.x - 190.0, center.y), Vector2(center.x + 190.0, center.y), rune.darkened(0.08), 1.0)
	draw_arc(center, 68.0, 0.0, TAU, 32, rune, 2.0)
	draw_arc(center, 31.0, 0.0, TAU, 24, rune, 1.0)

	for angle in [0.0, PI * 0.5, PI, PI * 1.5]:
		var dir := Vector2(cos(angle), sin(angle))
		draw_line(center + dir * 31.0, center + dir * 68.0, rune, 2.0)

	var diamond := PackedVector2Array([
		center + Vector2(0.0, -10.0),
		center + Vector2(10.0, 0.0),
		center + Vector2(0.0, 10.0),
		center + Vector2(-10.0, 0.0),
		center + Vector2(0.0, -10.0)
	])
	draw_polyline(diamond, rune.lightened(0.08), 2.0)

func _draw_banners() -> void:
	for entry in [
		{"x": 150.0, "flip": false},
		{"x": 990.0, "flip": true}
	]:
		var x: float = entry["x"]
		var cloth := PackedVector2Array([
			Vector2(x, 5.0),
			Vector2(x + 42.0, 5.0),
			Vector2(x + 39.0, 58.0),
			Vector2(x + 22.0, 48.0),
			Vector2(x + 5.0, 58.0)
		])
		draw_colored_polygon(cloth, Color(0.20, 0.055, 0.06, 0.88))
		draw_polyline(PackedVector2Array([cloth[0], cloth[1], cloth[2], cloth[3], cloth[4], cloth[0]]), Color(0.34, 0.12, 0.11, 0.9), 2.0)
		draw_line(Vector2(x + 21.0, 15.0), Vector2(x + 21.0, 43.0), Color(0.52, 0.23, 0.17, 0.65), 2.0)
		draw_line(Vector2(x + 11.0, 29.0), Vector2(x + 31.0, 29.0), Color(0.52, 0.23, 0.17, 0.65), 2.0)

func _draw_torches() -> void:
	var flicker := 1.0 + sin(pulse * 12.0) * 0.08
	for pos in [
		Vector2(55.0, 58.0),
		Vector2(300.0, 56.0),
		Vector2(900.0, 56.0),
		Vector2(1140.0, 58.0)
	]:
		draw_rect(Rect2(pos.x - 3.0, pos.y - 20.0, 6.0, 22.0), Color(0.22, 0.12, 0.075, 1.0))
		draw_circle(pos + Vector2(0.0, -24.0), 12.0 * flicker, Color(0.75, 0.18, 0.04, 0.10))
		draw_rect(Rect2(pos.x - 4.0, pos.y - 32.0, 8.0, 13.0 * flicker), Color(1.0, 0.36, 0.08, 0.95))
		draw_rect(Rect2(pos.x - 2.0, pos.y - 29.0, 4.0, 8.0 * flicker), Color(1.0, 0.75, 0.22, 1.0))

func _draw_debris() -> void:
	var bone := Color(0.52, 0.46, 0.38, 0.70)
	var stone := Color(0.11, 0.095, 0.12, 0.95)

	for pos in [Vector2(340, 92), Vector2(845, 108), Vector2(1040, 390), Vector2(125, 395)]:
		draw_rect(Rect2(pos.x, pos.y, 18.0, 7.0), stone)
		draw_rect(Rect2(pos.x + 12.0, pos.y - 5.0, 11.0, 6.0), stone.darkened(0.08))

	draw_circle(Vector2(420.0, 56.0), 8.0, bone)
	draw_rect(Rect2(415.0, 59.0, 10.0, 5.0), bone.darkened(0.08))
	draw_circle(Vector2(423.0, 54.0), 1.5, Color(0.05, 0.04, 0.05, 1.0))
	draw_circle(Vector2(417.0, 54.0), 1.5, Color(0.05, 0.04, 0.05, 1.0))

	for line in [
		[Vector2(91, 350), Vector2(112, 341)],
		[Vector2(92, 343), Vector2(110, 355)],
		[Vector2(1090, 356), Vector2(1115, 365)],
		[Vector2(1095, 368), Vector2(1113, 349)]
	]:
		draw_line(line[0], line[1], bone, 3.0)

func _draw_blood() -> void:
	for stain in [
		Rect2(205.0, 155.0, 32.0, 6.0),
		Rect2(225.0, 164.0, 16.0, 5.0),
		Rect2(795.0, 330.0, 52.0, 8.0),
		Rect2(822.0, 340.0, 22.0, 5.0),
		Rect2(944.0, 183.0, 34.0, 6.0)
	]:
		draw_rect(stain, Color(0.23, 0.035, 0.045, 0.34))

func _draw_vignette() -> void:
	for i in range(6):
		var alpha := 0.035 + float(i) * 0.018
		var inset := float(i) * 8.0
		draw_rect(Rect2(inset, inset, size.x - inset * 2.0, size.y - inset * 2.0), Color(0.0, 0.0, 0.0, alpha), false, 8.0)
