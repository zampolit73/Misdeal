extends Control

const CARD_BACK_FILL := Color(0.052, 0.020, 0.026, 0.94)
const CARD_BACK_BORDER := Color(0.48, 0.18, 0.12, 0.72)
const CARD_BACK_INNER := Color(0.25, 0.075, 0.065, 0.56)

var discard_pulse := 0.0:
	set(value):
		discard_pulse = value
		queue_redraw()

var discard_pulse_tween: Tween

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func refresh() -> void:
	queue_redraw()


func pulse_discard() -> void:
	if discard_pulse_tween != null and discard_pulse_tween.is_valid():
		discard_pulse_tween.kill()
	discard_pulse = 1.0
	discard_pulse_tween = create_tween()
	discard_pulse_tween.tween_property(self, "discard_pulse", 0.0, 0.24).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _draw() -> void:
	_draw_deck()
	_draw_discard()
	_draw_progress_spread()

func _draw_deck() -> void:
	var remaining := RunState.remaining_card_ids.size()
	if not RunState.has_active_card():
		remaining = maxi(0, remaining - RunState.current_offer_ids.size())

	var base_rect := Rect2(137.0, 438.0, 84.0, 122.0)
	if remaining <= 0:
		_draw_empty_card_place(base_rect)
		return

	var layers := mini(4, remaining)
	for layer in range(layers):
		var offset := Vector2(float(layer) * -2.0, float(layer) * -2.5)
		_draw_card_back(
			Rect2(base_rect.position + offset, base_rect.size),
			deg_to_rad(-2.0 + float(layer) * 0.8),
			0.72 + float(layer) * 0.07
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

func _draw_progress_spread() -> void:
	# The approved Variant C table already owns one strong ritual circle.
	# Detailed run progress lives in the Fate Spread screen; duplicating a
	# second progress ring here makes the main table feel like a HUD.
	pass
