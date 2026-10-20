extends RefCounted

# D288: opt-in DS3 shared visual surfaces. DO NOT apply these globally.
# The frozen DS2 checkpoint is checkpoint/ds2-pre-ds3-2026-10-20.
# Runtime data, item counts, text, input handlers, combat and scene layout
# belong to Godot Controls / RunState, never to flattened background art.

const OBSIDIAN := Color("#100c0d")
const CRIMSON := Color("#62201e")
const BRONZE := Color("#a66636")
const PARCHMENT := Color("#dfb77e")
const STEEL := Color("#334758")
const POSITIVE := Color("#91d795")
const NEGATIVE := Color("#ec897c")
const TEXT := Color("#e5cfad")
const MUTED := Color("#91827a")

# Retains the D287 exact StyleBoxFlat parameters for the first migrated screen.
# Porting is visually neutral until each screen's full DS3 skin is approved.
static func make_plate(fill: Color, outline: Color, thickness: int, shadow: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = outline
	style.set_border_width_all(thickness)
	style.shadow_color = Color(0, 0, 0, 0.78)
	style.shadow_size = shadow
	style.shadow_offset = Vector2(0, 3)
	style.content_margin_left = 5.0
	style.content_margin_right = 5.0
	return style


# Three deliberately different levels of detail:
# "dossier": engraved metal; "table": lighter tabletop surface;
# "battle": low-opacity, thin chrome with no loss of battlefield readability.
static func make_surface(surface: String) -> StyleBoxFlat:
	match surface:
		"table":
			return make_plate(Color(0.055, 0.039, 0.035, 0.90), Color(BRONZE.r, BRONZE.g, BRONZE.b, 0.58), 1, 4)
		"battle":
			return make_plate(Color(0.012, 0.014, 0.022, 0.74), Color(STEEL.r, STEEL.g, STEEL.b, 0.57), 1, 2)
		_:
			return make_plate(Color(0.032, 0.023, 0.028, 0.97), Color(BRONZE.r, BRONZE.g, BRONZE.b, 0.82), 2, 6)


static func apply_surface(panel: Panel, surface: String) -> void:
	if panel == null:
		return
	panel.add_theme_stylebox_override("panel", make_surface(surface))


# New screens only; existing DS2 button semantics and focus remain unchanged.
static func apply_action(button: Button, primary: bool = false) -> void:
	if button == null:
		return
	var normal := make_plate(Color(0.18, 0.053, 0.045, 0.99) if primary else Color(0.049, 0.038, 0.042, 0.99), BRONZE, 2 if primary else 1, 5)
	var hover := make_plate(Color(0.29, 0.076, 0.060, 1.0) if primary else Color(0.086, 0.053, 0.047, 1.0), PARCHMENT, 2, 7)
	var pressed := make_plate(Color(0.16, 0.041, 0.038, 1.0), PARCHMENT, 2, 2)
	var disabled := make_plate(Color(0.031, 0.029, 0.033, 0.85), Color(0.29, 0.26, 0.26, 0.6), 1, 1)
	for state in ["normal", "hover", "pressed", "disabled"]:
		match state:
			"normal":
				button.add_theme_stylebox_override(state, normal)
			"hover":
				button.add_theme_stylebox_override(state, hover)
			"pressed":
				button.add_theme_stylebox_override(state, pressed)
			"disabled":
				button.add_theme_stylebox_override(state, disabled)
	button.add_theme_color_override("font_color", TEXT)
	button.add_theme_color_override("font_hover_color", PARCHMENT)
	button.add_theme_color_override("font_disabled_color", MUTED)
	# Button.text/disabled/toggle_mode/focus/pressed callbacks remain authored.
