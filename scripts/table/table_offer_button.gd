extends Button

# Godot's stock tooltip sizes itself to the longest *unwrapped* text line.
# Long Cyrillic card lore then paints across both physical offer cards.
# Keep full lore available, but constrain the native popup to a short,
# readable hand-inscribed parchment panel.
const TOOLTIP_WIDTH := 318.0

func _make_custom_tooltip(for_text: String) -> Object:
	var panel := PanelContainer.new()
	panel.name = "CardLoreTooltip"
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.custom_minimum_size = Vector2(TOOLTIP_WIDTH, 0.0)
	var background := StyleBoxFlat.new()
	background.bg_color = Color("#251712")
	background.border_color = Color("#ad7848")
	background.border_width_left = 2
	background.border_width_top = 2
	background.border_width_right = 2
	background.border_width_bottom = 2
	background.shadow_color = Color(0.0, 0.0, 0.0, 0.82)
	background.shadow_size = 8
	background.content_margin_left = 15.0
	background.content_margin_top = 12.0
	background.content_margin_right = 15.0
	background.content_margin_bottom = 12.0
	panel.add_theme_stylebox_override("panel", background)
	var label := Label.new()
	label.name = "LoreCopy"
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.custom_minimum_size = Vector2(TOOLTIP_WIDTH - 30.0, 0.0)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color("#f1d9ae"))
	label.add_theme_constant_override("line_spacing", 4)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.clip_text = false
	label.text = for_text
	panel.add_child(label)
	return panel
