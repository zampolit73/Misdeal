extends RefCounted

# D289: staged Design System 3 pilot for the REAL two-offer cursed table.
# Peripheral UI chrome ONLY. Never mutate cards, their positions, Fate Spread,
# offer state, saved run logic, battlefield controls, or user interactions.
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")

const PANEL_BG := Color(0.028, 0.020, 0.023, 0.94)
const WIZARD_BG := Color(0.046, 0.027, 0.030, 0.94)
const GILT := Color(0.61, 0.37, 0.19, 0.90)
const GILT_LOW := Color(0.53, 0.34, 0.20, 0.53)
const PARCHMENT := Color("#dfb77e")
const TEXT_WARM := Color(0.87, 0.78, 0.67, 1.0)

static func apply(scene: Control) -> void:
	# The DS2 system and scene nodes run first. This one screen opts in last.
	# Existing authored geometry (including two 272x338 offer cards) remains.
	var hud := scene.get_node("HudPanel") as Panel
	var wizard := scene.get_node("WizardLinePanel") as Panel
	# The preceding DS2 pass attached extra painted-looking 2px corner strokes.
	# Hide them on these TWO panels only; DS3 provides the thinner single trim.
	for panel in [hud, wizard]:
		var old_chrome := panel.get_node_or_null("_MisdealChrome") as CanvasItem
		if old_chrome != null:
			old_chrome.visible = false
	hud.add_theme_stylebox_override("panel", DS3.make_plate(PANEL_BG, GILT_LOW, 1, 3))
	wizard.add_theme_stylebox_override("panel", DS3.make_plate(WIZARD_BG, GILT_LOW, 1, 3))
	_engrave_plate(hud, "Status", false)
	_engrave_plate(wizard, "Wizard", true)

	var stats := scene.get_node("Stats") as Label
	stats.add_theme_color_override("font_color", Color(0.91, 0.82, 0.69, 1))
	# The full dynamically sourced stats line retains its original 12pt metrics.
	var line := scene.get_node("WizardLine") as Label
	line.add_theme_color_override("font_color", TEXT_WARM)

	var party := scene.get_node("SquadButton") as Button
	var spread := scene.get_node("FateSpreadButton") as Button
	DS3.apply_action(party, false)
	DS3.apply_action(spread, false)
	# Highlight only the actual Fate Spread inspection action, not a third deal.
	var spread_idle := DS3.make_plate(Color(0.070, 0.035, 0.034, 0.94), GILT_LOW, 1, 3)
	spread.add_theme_stylebox_override("normal", spread_idle)
	spread.add_theme_color_override("font_color", PARCHMENT)
	spread.add_theme_font_size_override("font_size", 12)

	# D290 screenshot QA: the approved painterly Table is a legacy composite
	# containing a STATIC "КОЛОДА 22" inscription. The old mask began at x166,
	# leaving the baked number visible beside the LIVE value (e.g. 22 / 37).
	# Extend the matte only over that baked number, NOT over "КОЛОДА" lettering.
	# Preserve the real DeckCount label, its position and RunState updates.
	var deck_mask := scene.get_node("DeckCountMask") as ColorRect
	deck_mask.position.x = 148.0
	deck_mask.size.x = 70.0
	deck_mask.color = Color(0.035, 0.018, 0.016, 0.985)

	# Scattered tabletop labels are counters, NOT more interactive buttons.
	for counter_path in ["DeckCount", "DiscardCount"]:
		var counter := scene.get_node(counter_path) as Label
		counter.add_theme_color_override("font_color", PARCHMENT)
		counter.add_theme_font_size_override("font_size", 12)
	var lore_hint := scene.get_node("CardInspectHint") as Label
	lore_hint.add_theme_color_override("font_color", Color(0.82, 0.72, 0.61, 0.96))

	# The Wager is a real optional existing mechanic. Only surface/CTA chrome:
	# risk/reward contents and accept/refuse handlers remain exactly as authored.
	var wager := scene.get_node("WagerOverlay/Root/WagerPanel") as Panel
	var risk := scene.get_node("WagerOverlay/Root/WagerPanel/RiskPanel") as Panel
	var reward := scene.get_node("WagerOverlay/Root/WagerPanel/RewardPanel") as Panel
	DS3.apply_surface(wager, "dossier")
	DS3.apply_surface(risk, "dossier")
	DS3.apply_surface(reward, "dossier")
	_engrave_plate(wager, "Wager", true)
	DS3.apply_action(scene.get_node("WagerOverlay/Root/WagerPanel/AcceptButton") as Button, true)
	DS3.apply_action(scene.get_node("WagerOverlay/Root/WagerPanel/RefuseButton") as Button, false)


static func _engrave_plate(panel: Panel, prefix: String, center_mark: bool) -> void:
	# A few purposeful bronze marks. No ornamental clutter over labels.
	if panel.has_node(prefix + "DS3EdgeTop"):
		return
	var w := panel.size.x
	var h := panel.size.y
	# An understated top/bottom hairline; do not stack a second set of
	# orange corner brackets inside this already framed UI panel.
	_strip(panel, prefix + "DS3EdgeTop", Vector2(10, 3), Vector2(w - 20, 1), GILT_LOW.darkened(0.30))
	_strip(panel, prefix + "DS3EdgeBottom", Vector2(10, h - 4), Vector2(w - 20, 1), GILT_LOW.darkened(0.30))
	if center_mark:
		# Inside the top border, away from Wizard text. Decorative only.
		_strip(panel, prefix + "DS3Seal", Vector2(w * 0.5 - 5, 2), Vector2(10, 2), Color(0.68, 0.18, 0.13, 0.87))


static func _strip(parent: Control, node_name: String, at: Vector2, dimensions: Vector2, tone: Color) -> void:
	var strip := ColorRect.new()
	strip.name = node_name
	strip.position = at
	strip.size = dimensions
	strip.color = tone
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(strip)
