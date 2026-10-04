extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
	var bg := Color(0.055, 0.050, 0.070, 1.0)
	var tile_a := Color(0.075, 0.068, 0.088, 1.0)
	var tile_b := Color(0.064, 0.059, 0.078, 1.0)
	var grout := Color(0.11, 0.095, 0.115, 0.75)
	var rune := Color(0.34, 0.18, 0.20, 0.28)
	var edge := Color(0.18, 0.14, 0.17, 0.9)

	draw_rect(Rect2(Vector2.ZERO, size), bg)

	var tile_size := Vector2(64.0, 58.0)
	var rows := int(ceil(size.y / tile_size.y))
	var cols := int(ceil(size.x / tile_size.x))

	for row in range(rows):
		for col in range(cols):
			var offset_x := 0.0 if row % 2 == 0 else tile_size.x * 0.5
			var tile_pos := Vector2(col * tile_size.x - offset_x, row * tile_size.y)
			var tile_rect := Rect2(tile_pos + Vector2(2.0, 2.0), tile_size - Vector2(4.0, 4.0))
			var tile_color := tile_a if (row + col) % 2 == 0 else tile_b
			draw_rect(tile_rect, tile_color)
			draw_rect(tile_rect, grout, false, 1.0)

	var center := size * 0.5
	draw_line(Vector2(center.x, 8.0), Vector2(center.x, size.y - 8.0), rune, 2.0)
	draw_line(Vector2(8.0, center.y), Vector2(size.x - 8.0, center.y), rune, 1.0)
	draw_arc(center, 64.0, 0.0, TAU, 32, rune, 2.0)
	draw_arc(center, 28.0, 0.0, TAU, 24, rune, 1.0)

	for stain in [
		Rect2(195.0, 96.0, 34.0, 7.0),
		Rect2(214.0, 104.0, 13.0, 6.0),
		Rect2(812.0, 304.0, 46.0, 8.0),
		Rect2(836.0, 314.0, 18.0, 5.0),
		Rect2(952.0, 112.0, 28.0, 6.0)
	]:
		draw_rect(stain, Color(0.20, 0.045, 0.045, 0.32))

	draw_rect(Rect2(Vector2.ZERO, size), edge, false, 3.0)
