extends RefCounted
## Battle Result V2: presentation only. The original Battle owns all actions,
## state, journal finalization, save/rollback and scene routing.

const MENU := preload("res://scripts/ui/system_dialog.gd")
const TYPE := preload("res://scripts/class_select/class_select_card_skin.gd")
const GOLD := Color("e8cb95")
const BONE := Color("ddc1a5")
const COPY := Color("e5dbc4")
const MUTED := Color("b7aa95")
const NEGATIVE := Color("f0a299")
const RULE := Color("705443")
const REFERENCE_CENTER := Vector2(640, 360)


static func present(overlay: CanvasLayer, won: bool, encounter_title: String, status: String, review: Button = null) -> void:
	var panel := overlay.get_node("ResultBackdrop") as Panel
	var scrim := overlay.get_node("ResultScrim") as ColorRect
	var title := overlay.get_node("Result") as Label
	var description := overlay.get_node("ResultSubtitle") as Label
	var price := overlay.get_node("LastDealPrice") as Label
	var accept := overlay.get_node("LastDealAccept") as Button
	var refuse := overlay.get_node("LastDealRefuse") as Button
	var proceed := overlay.get_node("ContinueButton") as Button
	var has_deal := not won and accept.visible
	var has_report := is_instance_valid(review) and review.visible
	var bounds := Rect2(320, 180, 640, 360) if won else (Rect2(268, 127, 744, 466) if has_deal else Rect2(300, 180, 680, 360))
	var center := bounds.get_center().x
	var frame := MENU.plate_style(MENU.SECONDARY)
	frame.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	frame.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	panel.add_theme_stylebox_override("panel", frame)
	panel.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_hide_old_chrome(panel)
	_place(panel, bounds)
	scrim.color = Color(0, 0, 0, 0.52)
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP

	var encounter := _label(overlay, "ResultEncounter")
	var note := _label(overlay, "ResultNote")
	var detail := _label(overlay, "ResultPriceDetail")
	var rule := _rect(overlay, "ResultDivider", RULE)
	var surface := _rect(overlay, "ResultPriceSurface", Color("100d0e"))
	var top := _rect(overlay, "ResultPriceTop", RULE)
	var bottom := _rect(overlay, "ResultPriceBottom", RULE)
	for element in [note, detail, surface, top, bottom]:
		element.hide()
	var body_width := bounds.size.x - 60.0
	var margin := bounds.position.x + 30.0
	var active: Array[Button] = []

	if has_deal:
		_fit_label(title, title.text, Rect2(margin, 143, body_width, 52), 38, GOLD)
		_fit_label(encounter, encounter_title.to_upper(), Rect2(margin, 192, body_width, 26), 19, MUTED)
		_place(rule, Rect2(bounds.position.x + 52, 222, bounds.size.x - 104, 1))
		_fit_label(description, description.text, Rect2(margin, 229, body_width, 38), 22, COPY)
		_fit_label(note, "Один раз за забег — право повторить этот бой.", Rect2(margin, 266, body_width, 29), 19, MUTED)
		note.show()
		var full_price := price.text
		var lines := full_price.split("\n", false, 1)
		price.set_meta("full_price_text", full_price)
		price.tooltip_text = full_price
		_place(surface, Rect2(315, 304, 650, 80))
		_place(top, Rect2(315, 304, 650, 1))
		_place(bottom, Rect2(315, 383, 650, 1))
		for element in [surface, top, bottom]:
			element.show()
		_fit_label(price, lines[0] if not lines.is_empty() else "", Rect2(326, 310 if lines.size() > 1 else 319, 628, 35 if lines.size() > 1 else 50), 23, GOLD)
		if lines.size() > 1:
			_fit_label(detail, lines[1], Rect2(326, 344, 628, 31), 21, NEGATIVE)
			detail.show()
		# Classic has the same two real choices, without a fabricated third
		# action. Center the pair in the available lower region.
		var action_y := 408 if has_report else 450
		_style_action(accept, Rect2(298, action_y, 330, 65), true, 23)
		_style_action(refuse, Rect2(652, action_y, 330, 65), false, 22)
		active.assign([accept, refuse])
		if has_report:
			_style_action(review, Rect2(475, 500, 330, 53), false, 21)
			active.append(review)
	else:
		_fit_label(title, title.text, Rect2(margin, 200, body_width, 52), 40, GOLD if won else BONE)
		_fit_label(encounter, encounter_title.to_upper(), Rect2(margin, 255, body_width, 26), 19, MUTED)
		_place(rule, Rect2(bounds.position.x + 56, 292, bounds.size.x - 112, 1))
		if won:
			var extended := description.text.contains("\n")
			_fit_label(description, description.text, Rect2(margin, 300, body_width, 100 if extended else 52), 23, COPY)
			_fit_label(note, status, Rect2(margin, 400 if extended else 350, body_width, 29), 19, MUTED)
			note.show()
		else:
			_fit_label(description, description.text, Rect2(margin, 300, body_width, 52), 22, COPY)
			_fit_label(price, price.text, Rect2(margin, 350, body_width, 30), 19, NEGATIVE)
		var primary := proceed if won else refuse
		var button_width := 280 if won else 300
		if has_report:
			_style_action(review, Rect2(margin, 432, button_width, 64), false, 21)
			_style_action(primary, Rect2(bounds.end.x - 30 - button_width, 432, button_width, 64), true, 21)
			active.assign([review, primary])
		else:
			_style_action(primary, Rect2(center - button_width * 0.5, 432, button_width, 64), true, 21)
			active.assign([primary])
	encounter.show()
	rule.show()
	_link_focus(active)
	# The report is read-only, a safe focus owner even when accepting or
	# refusing Last Deal would irreversibly change the run. Classic keeps
	# both Last Deal choices keyboard-accessible without auto-selecting either.
	if has_report:
		review.grab_focus()
	elif not has_deal and active.size() == 1:
		active[0].grab_focus()


static func show_save_error(overlay: CanvasLayer, message: String) -> void:
	var note := overlay.get_node_or_null("ResultNote") as Label
	if note != null:
		_fit_label(note, message, Rect2(298, 266, 684, 29), 19, NEGATIVE)
		note.show()


static func _style_action(button: Button, bounds: Rect2, primary: bool, point: int) -> void:
	var texture := MENU.PRIMARY if primary else MENU.SECONDARY
	var font := TYPE.heading_font()
	while point > 14 and font.get_string_size(button.text, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x > bounds.size.x - 42:
		point -= 1
	button.add_theme_font_override("font", font)
	button.add_theme_font_size_override("font_size", point)
	for state in ["font_color", "font_hover_color", "font_pressed_color"]:
		button.add_theme_color_override(state, BONE)
	button.add_theme_color_override("font_focus_color", GOLD)
	button.add_theme_color_override("font_disabled_color", MUTED.darkened(0.24))
	for state in ["normal", "hover", "pressed", "hover_pressed", "disabled"]:
		var style := MENU.plate_style(texture)
		style.content_margin_top = 0
		style.content_margin_bottom = 0
		if state == "hover":
			style.modulate_color = Color(1.10, 1.07, 1.04)
		elif state in ["pressed", "hover_pressed"]:
			style.modulate_color = Color("d4bfb3")
		elif state == "disabled":
			style.modulate_color = Color(0.55, 0.55, 0.55)
		button.add_theme_stylebox_override(state, style)
	var focus := MENU.plate_style(texture)
	focus.draw_center = false
	focus.modulate_color = Color(1.45, 1.30, 1.12)
	button.add_theme_stylebox_override("focus", focus)
	button.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.focus_mode = Control.FOCUS_ALL
	button.z_index = 3
	_hide_old_chrome(button)
	_place(button, bounds)


static func _hide_old_chrome(control: Control) -> void:
	var chrome := control.get_node_or_null("_MisdealChrome") as Control
	if chrome != null:
		chrome.hide()


static func _label(parent: CanvasLayer, node_name: String) -> Label:
	var label := parent.get_node_or_null(node_name) as Label
	if label == null:
		label = Label.new()
		label.name = node_name
		label.z_index = 2
		parent.add_child(label)
	return label


static func _rect(parent: CanvasLayer, node_name: String, tint: Color) -> ColorRect:
	var rect := parent.get_node_or_null(node_name) as ColorRect
	if rect == null:
		rect = ColorRect.new()
		rect.name = node_name
		rect.z_index = 1
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(rect)
	rect.color = tint
	return rect


static func _fit_label(label: Label, value: String, bounds: Rect2, point: int, tint: Color) -> void:
	var font := TYPE.heading_font()
	# The authored live strings have explicit LF for payouts/price. Measure
	# every line (including the append-only reward details) before placement,
	# avoiding the zero-width autowrap issue already repaired in SystemDialog.
	var lines := value.split("\n")
	while point > 14:
		var fits := false
		var widest := 0.0
		for line in lines:
			widest = maxf(widest, font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x)
		fits = widest <= bounds.size.x - 8 and lines.size() * (font.get_height(point) + 2) <= bounds.size.y
		if fits:
			break
		point -= 1
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", point)
	label.add_theme_color_override("font_color", tint)
	label.add_theme_color_override("font_shadow_color", Color("0d0908"))
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.add_theme_constant_override("line_spacing", 2)
	label.text = value
	_place(label, bounds)


static func _place(control: Control, bounds: Rect2) -> void:
	# CanvasLayer children are centered in the viewport with authored 1280x720
	# offsets. Only the result controls change; battle floor/HUD remain intact.
	control.set_anchors_preset(Control.PRESET_CENTER)
	control.offset_left = bounds.position.x - REFERENCE_CENTER.x
	control.offset_top = bounds.position.y - REFERENCE_CENTER.y
	control.offset_right = bounds.end.x - REFERENCE_CENTER.x
	control.offset_bottom = bounds.end.y - REFERENCE_CENTER.y


static func _link_focus(buttons: Array[Button]) -> void:
	for i in range(buttons.size()):
		var button := buttons[i]
		var previous := button.get_path_to(buttons[posmod(i - 1, buttons.size())])
		var following := button.get_path_to(buttons[(i + 1) % buttons.size()])
		button.focus_previous = previous
		button.focus_neighbor_left = previous
		button.focus_neighbor_top = previous
		button.focus_next = following
		button.focus_neighbor_right = following
		button.focus_neighbor_bottom = following
