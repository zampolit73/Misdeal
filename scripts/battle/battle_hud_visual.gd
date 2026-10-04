extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
	var panel: Color = Color(0.018, 0.014, 0.022, 0.985)
	var inner: Color = Color(0.038, 0.027, 0.034, 0.985)
	var border: Color = Color(0.33, 0.18, 0.18, 1.0)
	var highlight: Color = Color(0.58, 0.31, 0.22, 0.92)
	var ornament: Color = Color(0.55, 0.23, 0.17, 0.80)

	_draw_panel(Rect2(8.0, 8.0, 920.0, 118.0), panel, inner, border, highlight)
	_draw_panel(Rect2(1000.0, 18.0, 270.0, 82.0), panel, inner, border, highlight)
	_draw_panel(Rect2(8.0, 622.0, 1264.0, 90.0), panel, inner, border, highlight)
	_draw_side_plate(Rect2(18.0, 143.0, 205.0, 48.0), Color(0.10, 0.16, 0.24, 0.98), Color(0.23, 0.52, 0.82, 0.88))
	_draw_side_plate(Rect2(1057.0, 143.0, 205.0, 48.0), Color(0.23, 0.055, 0.055, 0.98), Color(0.82, 0.22, 0.16, 0.90))

	_draw_corner_marks(Rect2(8.0, 8.0, 920.0, 118.0), ornament)
	_draw_corner_marks(Rect2(1000.0, 18.0, 270.0, 82.0), ornament)
	_draw_corner_marks(Rect2(8.0, 622.0, 1264.0, 90.0), ornament)

	_draw_skull(Vector2(36, 655), 12.0)
	_draw_skull(Vector2(1244, 655), 12.0)
	_draw_candles(Vector2(78, 684))
	_draw_candles(Vector2(1200, 684))

	draw_line(Vector2(392.0, 637.0), Vector2(392.0, 700.0), Color(0.25, 0.12, 0.14, 0.85), 2.0)
	draw_line(Vector2(888.0, 637.0), Vector2(888.0, 700.0), Color(0.25, 0.12, 0.14, 0.85), 2.0)

func _draw_panel(rect: Rect2, panel: Color, inner: Color, border: Color, highlight: Color) -> void:
	draw_rect(rect, Color(0, 0, 0, 0.72))
	draw_rect(rect, border, false, 4.0)
	var inner_rect: Rect2 = rect.grow(-6.0)
	draw_rect(inner_rect, panel)
	draw_rect(inner_rect, highlight, false, 1.0)
	var core: Rect2 = inner_rect.grow(-4.0)
	draw_rect(core, inner)
	draw_rect(core, Color(0.16, 0.085, 0.095, 0.9), false, 1.0)

func _draw_side_plate(rect: Rect2, fill: Color, edge: Color) -> void:
	draw_rect(rect, Color(0.012, 0.010, 0.016, 0.97))
	draw_rect(rect, edge.darkened(0.25), false, 3.0)
	var inner_rect: Rect2 = rect.grow(-5.0)
	draw_rect(inner_rect, fill)
	draw_rect(inner_rect, edge, false, 1.0)
	_draw_corner_marks(rect, edge)

func _draw_corner_marks(rect: Rect2, color: Color) -> void:
	var mark: float = 13.0
	draw_line(rect.position + Vector2(7, 7), rect.position + Vector2(7 + mark, 7), color, 2.0)
	draw_line(rect.position + Vector2(7, 7), rect.position + Vector2(7, 7 + mark), color, 2.0)
	draw_line(Vector2(rect.end.x - 7, rect.position.y + 7), Vector2(rect.end.x - 7 - mark, rect.position.y + 7), color, 2.0)
	draw_line(Vector2(rect.end.x - 7, rect.position.y + 7), Vector2(rect.end.x - 7, rect.position.y + 7 + mark), color, 2.0)
	draw_line(Vector2(rect.position.x + 7, rect.end.y - 7), Vector2(rect.position.x + 7 + mark, rect.end.y - 7), color, 2.0)
	draw_line(Vector2(rect.position.x + 7, rect.end.y - 7), Vector2(rect.position.x + 7, rect.end.y - 7 - mark), color, 2.0)
	draw_line(rect.end - Vector2(7, 7), rect.end - Vector2(7 + mark, 7), color, 2.0)
	draw_line(rect.end - Vector2(7, 7), rect.end - Vector2(7, 7 + mark), color, 2.0)

func _draw_skull(pos: Vector2, radius: float) -> void:
	var bone: Color = Color(0.48, 0.40, 0.34, 0.88)
	draw_circle(pos, radius, bone)
	draw_rect(Rect2(pos.x - radius * 0.55, pos.y + radius * 0.45, radius * 1.1, radius * 0.65), bone.darkened(0.12))
	draw_circle(pos + Vector2(-4, -2), 2.3, Color(0.025, 0.020, 0.024, 1.0))
	draw_circle(pos + Vector2(4, -2), 2.3, Color(0.025, 0.020, 0.024, 1.0))

func _draw_candles(origin: Vector2) -> void:
	var candle_xs: Array[float] = [-12.0, 0.0, 11.0]
	for index in range(candle_xs.size()):
		var x: float = origin.x + candle_xs[index]
		var height: float = 16.0 + float(index % 2) * 8.0
		draw_rect(Rect2(x - 3.0, origin.y - height, 6.0, height), Color(0.78, 0.58, 0.37, 1.0))
		draw_circle(Vector2(x, origin.y - height - 6.0), 8.0, Color(1.0, 0.18, 0.04, 0.08))
		draw_rect(Rect2(x - 2.0, origin.y - height - 10.0, 4.0, 8.0), Color(1.0, 0.55, 0.12, 0.96))
