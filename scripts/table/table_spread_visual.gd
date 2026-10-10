extends Control

const CARD_BACK_FILL := Color(0.052, 0.020, 0.026, 0.94)
const CARD_BACK_BORDER := Color(0.48, 0.18, 0.12, 0.72)
const CARD_BACK_INNER := Color(0.25, 0.075, 0.065, 0.56)

var discard_pulse := 0.0:
	set(value):
		discard_pulse = value
		queue_redraw()

var deck_pulse := 0.0:
	set(value):
		deck_pulse = value
		queue_redraw()

var ritual_pulse := 0.0:
	set(value):
		ritual_pulse = value
		queue_redraw()

var ritual_color := Color(0.74, 0.18, 0.12, 1.0)
var ambient_time := 0.0
var ambient_redraw_accum := 0.0

var discard_pulse_tween: Tween
var deck_pulse_tween: Tween
var ritual_pulse_tween: Tween

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()


func _process(delta: float) -> void:
	ambient_time += delta
	ambient_redraw_accum += delta
	if ambient_redraw_accum >= 0.10:
		ambient_redraw_accum = 0.0
		queue_redraw()

func refresh() -> void:
	queue_redraw()


func pulse_discard() -> void:
	if discard_pulse_tween != null and discard_pulse_tween.is_valid():
		discard_pulse_tween.kill()
	discard_pulse = 1.0
	discard_pulse_tween = create_tween()
	discard_pulse_tween.tween_property(self, "discard_pulse", 0.0, 0.24).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func pulse_deal() -> void:
	if deck_pulse_tween != null and deck_pulse_tween.is_valid():
		deck_pulse_tween.kill()
	deck_pulse = 1.0
	deck_pulse_tween = create_tween()
	deck_pulse_tween.tween_property(self, "deck_pulse", 0.0, 0.30).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pulse_ritual("deal")


func pulse_ritual(kind: String = "attention") -> void:
	if ritual_pulse_tween != null and ritual_pulse_tween.is_valid():
		ritual_pulse_tween.kill()

	match kind:
		"meddle":
			ritual_color = Color(0.95, 0.16, 0.10, 1.0)
		"pleased":
			ritual_color = Color(0.92, 0.42, 0.18, 1.0)
		"cold":
			ritual_color = Color(0.34, 0.56, 0.82, 1.0)
		"hold":
			ritual_color = Color(0.58, 0.32, 0.22, 1.0)
		"choice":
			ritual_color = Color(0.88, 0.32, 0.16, 1.0)
		"deal":
			ritual_color = Color(0.70, 0.18, 0.12, 1.0)
		_:
			ritual_color = Color(0.74, 0.18, 0.12, 1.0)

	ritual_pulse = 1.0
	ritual_pulse_tween = create_tween()
	ritual_pulse_tween.tween_property(self, "ritual_pulse", 0.0, 0.42).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _draw() -> void:
	_draw_candle_ambience()
	_draw_ritual_reaction()
	_draw_deck()
	_draw_discard()
	_draw_progress_spread()

func _draw_deck() -> void:
	var remaining := RunState.remaining_card_ids.size()
	if not RunState.has_active_card():
		remaining = maxi(0, remaining - RunState.current_offer_ids.size())

	var base_rect := Rect2(137.0, 438.0, 84.0, 122.0).grow(deck_pulse * 2.5)
	if remaining <= 0:
		_draw_empty_card_place(base_rect)
		return

	var layers := mini(4, remaining)
	for layer in range(layers):
		var offset := Vector2(float(layer) * -2.0, float(layer) * -2.5)
		_draw_card_back(
			Rect2(base_rect.position + offset, base_rect.size),
			deg_to_rad(-2.0 + float(layer) * 0.8),
			0.72 + float(layer) * 0.07 + deck_pulse * 0.07
		)

func _draw_discard() -> void:
	var discarded := RunState.rejected_card_ids.size()
	var base_rect := Rect2(1059.0, 438.0, 84.0, 122.0).grow(discard_pulse * 3.0)

	if discarded <= 0:
		_draw_empty_card_place(base_rect)
		return

	var visible_cards := mini(4, discarded)
	for index in range(visible_cards):
		var offset := Vector2(float(index) * 3.5, float(index) * -2.0)
		_draw_card_back(
			Rect2(base_rect.position + offset, base_rect.size),
			deg_to_rad(-5.0 + float(index) * 3.0),
			0.58 + float(index) * 0.10 + discard_pulse * 0.08
		)

func _draw_empty_card_place(rect: Rect2) -> void:
	draw_rect(rect, Color(0.30, 0.11, 0.09, 0.12), false, 1.0)
	draw_rect(rect.grow(-6.0), Color(0.30, 0.11, 0.09, 0.07), false, 1.0)

func _draw_card_back(rect: Rect2, rotation: float, alpha: float) -> void:
	var center := rect.position + rect.size * 0.5
	draw_set_transform(center, rotation, Vector2.ONE)
	var local_rect := Rect2(-rect.size * 0.5, rect.size)

	var fill := CARD_BACK_FILL
	fill.a *= alpha
	var border := CARD_BACK_BORDER
	border.a *= alpha
	var inner := CARD_BACK_INNER
	inner.a *= alpha

	draw_rect(Rect2(local_rect.position + Vector2(3.0, 4.0), local_rect.size), Color(0, 0, 0, 0.22 * alpha))
	draw_rect(local_rect, fill)
	draw_rect(local_rect.grow(-3.0), border, false, 1.5)
	draw_rect(local_rect.grow(-9.0), inner, false, 1.0)

	var half := Vector2(11.0, 16.0)
	var diamond := PackedVector2Array([
		Vector2(0.0, -half.y),
		Vector2(half.x, 0.0),
		Vector2(0.0, half.y),
		Vector2(-half.x, 0.0),
		Vector2(0.0, -half.y)
	])
	draw_polyline(diamond, border.lightened(0.10), 1.5)
	draw_circle(Vector2.ZERO, 2.5, border.lightened(0.12))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

func _draw_candle_ambience() -> void:
	# The exact Variant C plate owns the candle artwork. These tiny translucent
	# halos only add life to the authored flames; no new flame shapes are drawn.
	var candles := [
		{"pos": Vector2(49.0, 211.0), "phase": 0.0, "radius": 26.0},
		{"pos": Vector2(105.0, 220.0), "phase": 1.4, "radius": 24.0},
		{"pos": Vector2(132.0, 226.0), "phase": 2.6, "radius": 20.0},
		{"pos": Vector2(376.0, 126.0), "phase": 0.7, "radius": 18.0},
		{"pos": Vector2(405.0, 128.0), "phase": 2.1, "radius": 17.0},
		{"pos": Vector2(858.0, 126.0), "phase": 1.1, "radius": 18.0},
		{"pos": Vector2(892.0, 128.0), "phase": 2.8, "radius": 17.0},
		{"pos": Vector2(1238.0, 220.0), "phase": 0.5, "radius": 26.0},
		{"pos": Vector2(1263.0, 237.0), "phase": 2.0, "radius": 21.0},
	]

	for candle in candles:
		var phase: float = float(candle["phase"])
		var flicker := 0.5 + 0.5 * sin(ambient_time * 7.0 + phase)
		flicker = 0.65 * flicker + 0.35 * (0.5 + 0.5 * sin(ambient_time * 11.0 + phase * 1.7))
		var alpha := 0.014 + flicker * 0.020
		var radius := float(candle["radius"]) + flicker * 2.0
		draw_circle(candle["pos"], radius, Color(1.0, 0.28, 0.08, alpha))


func _draw_ritual_reaction() -> void:
	if ritual_pulse <= 0.001:
		return

	# Variant C already contains the authored ritual circle. This overlay only
	# wakes that area for a fraction of a second when the table reacts.
	var center := Vector2(640.0, 468.0)
	var alpha := ritual_pulse * 0.18
	var outer := ritual_color
	outer.a = alpha
	var inner := ritual_color.lightened(0.10)
	inner.a = alpha * 0.72

	var expansion := (1.0 - ritual_pulse) * 10.0
	draw_arc(center, 174.0 + expansion, 0.0, TAU, 64, outer, 2.0, true)
	draw_arc(center, 132.0 + expansion * 0.45, 0.0, TAU, 56, inner, 1.5, true)
	draw_circle(center, 5.0 + ritual_pulse * 2.5, Color(inner.r, inner.g, inner.b, alpha * 0.85), false, 1.5, true)

	for index in range(4):
		var angle := PI * 0.25 + float(index) * PI * 0.5
		var direction := Vector2(cos(angle), sin(angle))
		var point := center + direction * (154.0 + expansion * 0.6)
		var tangent := Vector2(-direction.y, direction.x)
		draw_line(point - tangent * 5.0, point + tangent * 5.0, inner, 1.5, true)


func _draw_progress_spread() -> void:
	# The approved Variant C table already owns one strong ritual circle.
	# Detailed run progress lives in the Fate Spread screen; duplicating a
	# second progress ring here makes the main table feel like a HUD.
	pass
