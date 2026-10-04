extends Control

var pulse: float = 0.0
var boss_mode := false
var boss_phase_two := false

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
	if not boss_mode:
		return

	pulse += delta
	queue_redraw()

func _draw() -> void:
	if not boss_mode:
		return

	var intensity := 0.5 + 0.5 * sin(pulse * 4.0)
	var center := Vector2(size.x * 0.76, 250.0)
	var rune := Color(0.96, 0.14, 0.06, 0.26 + intensity * 0.08)
	if boss_phase_two:
		rune = Color(1.0, 0.18, 0.04, 0.42 + intensity * 0.12)

	draw_rect(
		Rect2(size.x * 0.52, 0.0, size.x * 0.48, size.y),
		Color(0.35, 0.01, 0.02, 0.035 + intensity * 0.015)
	)
	draw_circle(center, 132.0, Color(rune.r, rune.g, rune.b, 0.025 + intensity * 0.015))
	draw_arc(center, 126.0, 0.0, TAU, 56, rune, 3.0)
	draw_arc(center, 96.0, 0.0, TAU, 48, Color(rune.r, rune.g, rune.b, rune.a * 0.72), 2.0)

	if boss_phase_two:
		draw_circle(center, 142.0, Color(0.72, 0.02, 0.01, 0.045 + intensity * 0.025))
		draw_line(center + Vector2(-170, 0), center + Vector2(170, 0), Color(1.0, 0.20, 0.06, 0.25), 2.0)
