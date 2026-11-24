extends RefCounted

const UI_MOTION := preload("res://scripts/ui/ui_motion.gd")

# D289: staged Design System 3 pilot for the REAL two-offer cursed table.
# Peripheral UI chrome ONLY. Never mutate cards, their positions, Fate Spread,
# offer state, saved run logic, battlefield controls, or user interactions.
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
const CARD_SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")

const GILT_LOW := Color(0.53, 0.34, 0.20, 0.53)
const PARCHMENT := Color("#dfb77e")
const TEXT_WARM := Color(0.87, 0.78, 0.67, 1.0)
const MATTE_WOOD := Color("#100c0c")
const FRAME_BRONZE := Color("#69503c")
const FOCUS_BRONZE := Color("#987552")

static func apply(scene: Control) -> void:
	for path in ["FateSpreadButton", "Cards/HoldAButton", "Cards/HoldBButton", "WagerOverlay/Root/WagerPanel/AcceptButton", "WagerOverlay/Root/WagerPanel/RefuseButton"]:
		UI_MOTION.bind_button(scene.get_node(path) as Button)
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
	hud.add_theme_stylebox_override("panel", DS3.make_plate(MATTE_WOOD, FRAME_BRONZE, 1, 3))
	wizard.add_theme_stylebox_override("panel", DS3.make_plate(MATTE_WOOD, FRAME_BRONZE, 1, 3))
	_engrave_plate(hud, "Status", false)
	_engrave_plate(wizard, "Wizard", true)
	_corner_engraving(hud)
	_corner_engraving(wizard)

	var stats := scene.get_node("Stats") as Label
	var line := scene.get_node("WizardLine") as Label
	for label in [stats, line]:
		label.add_theme_font_override("font", CARD_SKIN.heading_font())
		label.add_theme_font_size_override("font_size", 13 if label == stats else 14)
		label.add_theme_color_override("font_color", TEXT_WARM)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var fit_header := func() -> void: _fit_header(hud, stats, wizard, line)
	stats.minimum_size_changed.connect(fit_header, CONNECT_DEFERRED)
	line.minimum_size_changed.connect(fit_header, CONNECT_DEFERRED)
	fit_header.call()

	var spread := scene.get_node("FateSpreadButton") as Button
	_skin_action(spread, 14)
	var crest := Polygon2D.new()
	crest.color = FOCUS_BRONZE
	crest.polygon = PackedVector2Array([Vector2(-4, 0), Vector2(0, -4), Vector2(4, 0), Vector2(0, 2)])
	crest.position = Vector2(spread.size.x * 0.5, 1)
	spread.add_child(crest)
	for path in ["Cards/HoldAButton", "Cards/HoldBButton"]:
		_skin_action(scene.get_node(path) as Button, 12)

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
	var lower := _strip(panel, prefix + "DS3EdgeBottom", Vector2(10, h - 4), Vector2(w - 20, 1), GILT_LOW.darkened(0.30))
	lower.anchor_top = 1.0
	lower.anchor_bottom = 1.0
	lower.offset_top = -4.0
	lower.offset_bottom = -3.0
	if center_mark:
		# Inside the top border, away from Wizard text. Decorative only.
		_strip(panel, prefix + "DS3Seal", Vector2(w * 0.5 - 5, 2), Vector2(10, 2), Color("#754336"))


static func _fit_header(hud: Panel, stats: Label, wizard: Panel, line: Label) -> void:
	stats.size.y = maxf(21, stats.get_minimum_size().y)
	hud.size.y = stats.size.y + 14
	stats.position.y = hud.position.y + 7
	wizard.position.y = hud.position.y + hud.size.y + 7
	line.position.y = wizard.position.y + 6
	line.size.y = maxf(21, line.get_minimum_size().y)
	wizard.size.y = line.size.y + 12


static func _skin_action(button: Button, point_size: int) -> void:
	button.add_theme_stylebox_override("normal", DS3.make_plate(MATTE_WOOD, FRAME_BRONZE, 1, 2))
	button.add_theme_stylebox_override("hover", DS3.make_plate(Color("#26191a"), FOCUS_BRONZE, 1, 3))
	button.add_theme_stylebox_override("pressed", DS3.make_plate(Color("#351d20"), FOCUS_BRONZE, 1, 1))
	button.add_theme_stylebox_override("disabled", DS3.make_plate(Color("#161112"), Color("#4b3c32"), 1, 1))
	var focus := DS3.make_plate(Color.TRANSPARENT, FOCUS_BRONZE, 1, 0)
	focus.draw_center = false
	button.add_theme_stylebox_override("focus", focus)
	button.add_theme_font_override("font", CARD_SKIN.heading_font())
	button.add_theme_font_size_override("font_size", point_size)
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		button.add_theme_color_override(state, TEXT_WARM)
	button.add_theme_color_override("font_disabled_color", Color("#b2a497"))


static func _corner_engraving(panel: Panel) -> void:
	for edge in [0.0, 1.0]:
		var tab := Control.new()
		tab.mouse_filter = Control.MOUSE_FILTER_IGNORE
		panel.add_child(tab)
		tab.set_anchor(SIDE_LEFT, edge)
		tab.set_anchor(SIDE_RIGHT, edge)
		tab.set_anchor(SIDE_TOP, 0.5)
		tab.set_anchor(SIDE_BOTTOM, 0.5)
		tab.position = Vector2(panel.size.x * edge, panel.size.y * 0.5)
		var mark := Line2D.new()
		mark.width = 1.0
		mark.default_color = FRAME_BRONZE
		mark.points = PackedVector2Array([Vector2(0, -5), Vector2(-8 if edge == 0 else 8, 0), Vector2(0, 5)])
		tab.add_child(mark)


static func _strip(parent: Control, node_name: String, at: Vector2, dimensions: Vector2, tone: Color) -> ColorRect:
	var strip := ColorRect.new()
	strip.name = node_name
	strip.position = at
	strip.size = dimensions
	strip.color = tone
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(strip)
	return strip
