extends RefCounted

# D291: opt-in DS3 battle HUD visual pass. Art, layout, unit nodes, target
# preview, tactic semantics, HP, arena and movement remain untouched.
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")

const BRONZE := Color("#a66636")
const STEEL := Color("#50677b")
const CRIMSON := Color("#8c4136")
const PARCHMENT := Color("#dfb77e")
const MUTED := Color(0.69, 0.65, 0.62, 1.0)

static func apply(scene: Control) -> void:
	# Panels live OUTSIDE the artwork's active fight floor. No new overlays.
	var panels := [
		["TopHudPanel", 0.76],
		["RunHudPanel", 0.79],
		["BottomHudPanel", 0.89],
		["FightHudPanel", 0.91],
		["SideObjectivePanel", 0.86],
		["WizardCommentaryPanel", 0.88],
	]
	for pair in panels:
		var panel := scene.get_node(pair[0]) as Panel
		var is_action: bool = String(pair[0]) == "FightHudPanel"
		var accent := BRONZE if is_action else STEEL
		var style := DS3.make_plate(
			Color(0.015, 0.015, 0.022, pair[1]),
			Color(accent.r, accent.g, accent.b, 0.54 if is_action else 0.38),
			1, 3
		)
		panel.add_theme_stylebox_override("panel", style)
		# DS2 carries heavyweight decorative corners on a few panels. Do not
		# stack any legacy drawn chrome over the thin battle DS3 surround.
		var ds2_marks := panel.get_node_or_null("_MisdealChrome") as CanvasItem
		if ds2_marks != null:
			ds2_marks.visible = false

	for path in ["OrderLabel", "DealLabel"]:
		var header := scene.get_node(path) as Label
		header.add_theme_color_override("font_color", PARCHMENT)
	for path in ["OrderDescription", "RunConditionLabel", "WizardCommentary", "Status"]:
		var copy := scene.get_node(path) as Label
		copy.add_theme_color_override("font_color", MUTED)
	# Combat's five real toggles retain their scene-authored dimensions,
	# text/availability and selected state; dynamic states are set separately.
	for path in ["AssaultOrderButton", "HuntOrderButton", "FormationOrderButton", "SacrificeOrderButton", "DefianceOrderButton"]:
		var tactic := scene.get_node(path) as Button
		style_tactic(tactic, tactic.button_pressed, _accent_for(path))
	style_secondary(scene.get_node("TargetPreviewButton") as Button, STEEL)
	style_secondary(scene.get_node("RestartButton") as Button, STEEL)
	style_primary(scene.get_node("FightButton") as Button, CRIMSON)
	style_primary(scene.get_node("ContinueButton") as Button, BRONZE)


static func style_tactic(button: Button, selected: bool, accent: Color) -> void:
	# Called AFTER the existing tactical_order logic applies DS2 colors.
	# The state belongs to the real Button; visuals never set button_pressed.
	if button == null:
		return
	_styles(button, accent, selected, false)
	button.add_theme_color_override("font_color", PARCHMENT if selected else Color(0.83, 0.76, 0.66))
	button.add_theme_color_override("font_hover_color", PARCHMENT)
	button.add_theme_color_override("font_pressed_color", PARCHMENT)


static func style_primary(button: Button, accent: Color) -> void:
	if button == null:
		return
	_styles(button, accent, false, true)
	button.add_theme_color_override("font_color", PARCHMENT)
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.94, 0.82))


static func style_secondary(button: Button, accent: Color) -> void:
	if button == null:
		return
	_styles(button, accent, button.button_pressed, false)
	button.add_theme_color_override("font_color", Color(0.84, 0.82, 0.77))
	button.add_theme_color_override("font_hover_color", PARCHMENT)


static func _accent_for(path: String) -> Color:
	if path == "SacrificeOrderButton":
		return CRIMSON
	if path == "DefianceOrderButton":
		return STEEL.lightened(0.18)
	return BRONZE


static func _styles(button: Button, accent: Color, selected: bool, primary: bool) -> void:
	var dark := Color(0.026, 0.022, 0.030, 0.96)
	var base := Color(0.071, 0.040, 0.039, 0.98) if selected else dark
	if primary:
		base = Color(0.16, 0.052, 0.048, 0.99)
	var muted_border := Color(accent.r, accent.g, accent.b, 0.73 if selected or primary else 0.47)
	var bright_border := Color(accent.r, accent.g, accent.b, 0.95)
	button.add_theme_stylebox_override("normal", DS3.make_plate(base, muted_border, 2 if selected or primary else 1, 3))
	button.add_theme_stylebox_override("hover", DS3.make_plate(base.lightened(0.10), bright_border, 2, 5))
	button.add_theme_stylebox_override("pressed", DS3.make_plate(base.lightened(0.055), bright_border, 2, 2))
	button.add_theme_stylebox_override("hover_pressed", DS3.make_plate(base.lightened(0.12), bright_border, 2, 4))
	button.add_theme_stylebox_override("disabled", DS3.make_plate(Color(0.022, 0.022, 0.027, 0.78), Color(0.25, 0.25, 0.26, 0.35), 1, 1))
	# Native Godot focus outline and pressed signals remain on the Button.
