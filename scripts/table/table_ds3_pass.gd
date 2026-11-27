extends RefCounted

const UI_MOTION := preload("res://scripts/ui/ui_motion.gd")

# D289: staged Design System 3 pilot for the REAL two-offer cursed table.
# Peripheral UI chrome ONLY. Never mutate cards, their positions, Fate Spread,
# offer state, saved run logic, battlefield controls, or user interactions.
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
const CARD_SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")
const HUD := preload("res://scripts/ui/hud_visual_v2.gd")
const WAGER_VISUAL := preload("res://scripts/table/wizard_wager_visual.gd")

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
	HUD.apply_table(scene)

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

	# The approved V1 plate owns only the modal presentation.
	WAGER_VISUAL.apply(scene)

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
