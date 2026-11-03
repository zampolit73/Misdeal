extends Control

# Masks only baked sample cards that must be replaced by live run state.
# Future reference card-backs remain visible wherever they are already generic.

const CLOTH := Color(0.022, 0.010, 0.014, 0.965)
const CLOTH_EDGE := Color(0.16, 0.045, 0.040, 0.34)
const FATE_GEOMETRY := preload("res://scripts/table/fate_spread_geometry.gd")
const CARD_MASK_SIZE := FATE_GEOMETRY.CARD_MASK_SIZE
const NUMERAL_MASK_SIZE := FATE_GEOMETRY.NUMERAL_MASK_SIZE
const SLOT_CENTERS := FATE_GEOMETRY.SLOT_CENTERS
const SLOT_ROTATIONS_DEG := FATE_GEOMETRY.SLOT_ROTATIONS_DEG

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()


func refresh() -> void:
	queue_redraw()


func _draw() -> void:
	for index in range(SLOT_CENTERS.size()):
		if not _slot_needs_live_cover(index):
			continue
		_draw_slot_mask(index)

	# The fixed painting calls the sixth position "V". While its generic
	# future card is visible, cover ONLY that numeral for the live "VI" label.
	# From step VI onward, the regular full-card mask includes its numeral.
	if not _slot_needs_live_cover(5):
		draw_rect(FATE_GEOMETRY.PRINTED_SIXTH_ROMAN_MASK,
			Color(CLOTH.r, CLOTH.g, CLOTH.b, 1.0))

	if RunState.is_boss_due() or RunState.active_card_id == RunState.BOSS_CARD_ID or RunState.boss_defeated:
		draw_rect(Rect2(312.0, 154.0, 156.0, 214.0), Color(0.026, 0.010, 0.014, 0.96))


func _slot_needs_live_cover(index: int) -> bool:
	# The approved reference contains sample cards in I–IV and XII.
	# Those positions always need a live replacement.
	if index < 4 or index == 11:
		return true

	# V–XII are already clean/generic card-backs in the reference. Mask them
	# only once that position becomes the current step or part of run history.
	return index <= RunState.cards_resolved


func _draw_slot_mask(index: int) -> void:
	var center: Vector2 = SLOT_CENTERS[index]
	var rotation := deg_to_rad(float(SLOT_ROTATIONS_DEG[index]))
	draw_set_transform(center, rotation, Vector2.ONE)

	var card_rect := Rect2(-CARD_MASK_SIZE * 0.5, CARD_MASK_SIZE)
	draw_rect(card_rect, CLOTH)
	draw_rect(card_rect.grow(-2.0), CLOTH_EDGE, false, 1.0)

	# Cover only the baked Roman numeral immediately above a replaced card.
	var numeral_rect := Rect2(
		Vector2(-NUMERAL_MASK_SIZE.x * 0.5, -CARD_MASK_SIZE.y * 0.5 - 13.0),
		NUMERAL_MASK_SIZE
	)
	draw_rect(numeral_rect, Color(CLOTH.r, CLOTH.g, CLOTH.b, 0.94))

	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
