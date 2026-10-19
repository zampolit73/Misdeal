extends RefCounted

# D264: Court's combat footprints follow the *lower stone floor*, never the
# dais / stone steps. 1280x720 Battle viewport, UnitsLayer origin (20, 96).
# Keep this single coordinate contract shared by native Battle and D263 F6.
const UNITS_LAYER_OFFSET := Vector2(20.0, 96.0)
const SCREEN_COMBAT_BOUNDS := Rect2(Vector2(40.0, 532.0), Vector2(1228.0, 178.0))
const COMBAT_BOUNDS := Rect2(Vector2(20.0, 436.0), Vector2(1228.0, 178.0))

# Placement stays on the *upper strip of the lower stone floor* while the
# pre-fight tactics panel occupies y=574..710. Full combat may use the whole
# lower floor after the HUD is hidden on Fight.
const PLACEMENT_BOUNDS := Rect2(Vector2(140.0, 442.0), Vector2(395.0, 51.0))

# D263 QA plate stairs occupy the screen above y≈532.
const FLOOR_TOP_SCREEN_Y := 532.0
const FLOOR_BOTTOM_SCREEN_Y := 710.0
