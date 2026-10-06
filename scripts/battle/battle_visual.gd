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
	if boss_mode and fmod(pulse, 0.08) < delta:
		queue_redraw()

func _draw() -> void:
	if boss_mode:
		_draw_boss_runes()

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
