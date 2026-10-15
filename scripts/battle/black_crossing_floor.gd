class_name BlackCrossingFloor
extends RefCounted

# D189: single source of truth for the flat, intact planks in the approved
# 1280x720 storm background. Positions are local to UnitsLayer (20, 96).
# BattleUnit feet appear at local origin + (0, 36), not at its origin.
# This gives visible foot contact between screen Y 389 and 483, safely
# above the broken beams/water at the front of the plate.
const COMBAT_BOUNDS := Rect2(Vector2(110.0, 240.0), Vector2(1060.0, 128.0))
const PLACEMENT_BOUNDS := Rect2(Vector2(145.0, 250.0), Vector2(390.0, 112.0))

# Two alternating foam lanes entirely inside the legal 240–368 floor range.
const WAVE_LANE_CENTERS := [284.0, 330.0]
const WAVE_HALF_WIDTH := 25.0
const WAVE_MIN_X := 135.0
const WAVE_MAX_X := 1145.0


static func contains_unit_origin(position_value: Vector2, body_radius: float) -> bool:
	var inset := Rect2(
		COMBAT_BOUNDS.position + Vector2(body_radius, body_radius),
		COMBAT_BOUNDS.size - Vector2(body_radius * 2.0, body_radius * 2.0)
	)
	return inset.has_point(position_value) or (
		position_value.x >= inset.position.x - 0.01
		and position_value.x <= inset.end.x + 0.01
		and position_value.y >= inset.position.y - 0.01
		and position_value.y <= inset.end.y + 0.01
	)
