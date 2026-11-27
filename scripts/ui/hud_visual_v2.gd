extends RefCounted
## Approved localized HUD presentation for the existing Table and Battle.
## Original scenes still own every action, rule, run value and status message.

const MENU := preload("res://scripts/ui/system_dialog.gd")
const TYPE := preload("res://scripts/class_select/class_select_card_skin.gd")
const GOLD := Color("e8cb95")
const BONE := Color("ddc1a5")
const COPY := Color("e5dbc4")
const MUTED := Color("b7aa95")
const RULE := Color("705443")
const BENEFIT := Color("c4d5a6")
const TABLE_STATS := Rect2(312, 13, 656, 54)
const TABLE_WIZARD := Rect2(336, 66, 608, 40)
const WIZARD_COPY := Rect2(471, 70, 453, 32)
const BATTLE_STATUS := Rect2(105, 69, 732, 31)
const BATTLE_TITLE := Rect2(105, 32, 732, 31)
const BATTLE_CONDITIONS := Rect2(949, 47, 290, 51)
const METRIC_NAMES := ["КАРТА", "ЗОЛОТО", "ОТРЯД", "РАЗВИТИЕ", "РЕЛИКВИИ"]

static var _bold: SystemFont
static var _italic: SystemFont


static func apply_table(scene: Control) -> void:
	var panel := scene.get_node("HudPanel") as Panel
	var wizard := scene.get_node("WizardLinePanel") as Panel
	_style_plate(panel, TABLE_STATS)
	_style_plate(wizard, TABLE_WIZARD)
	var source := scene.get_node("Stats") as Label
	source.hide() # Keep the original aggregate text for existing consumers.
	for index in METRIC_NAMES.size():
		_make_label(panel, "MetricName%d" % index, String(METRIC_NAMES[index]), Rect2(0, 0, 1, 1), 13, BONE)
		_make_label(panel, "MetricValue%d" % index, "", Rect2(0, 0, 1, 1), 24, GOLD, true)
		if index > 0:
			_rule(panel, "MetricRule%d" % index, Rect2(0, 0, 1, 32))
	var conditions := _make_label(panel, "RunConditions", "", Rect2(24, 40, 608, 24), 12, COPY)
	conditions.mouse_filter = Control.MOUSE_FILTER_PASS
	_rule(panel, "ConditionRule", Rect2(24, 39, 608, 1)).hide()
	_make_label(wizard, "Speaker", "ВОЛШЕБНИК", Rect2(18, 5, 104, 30), 13, GOLD, true, HORIZONTAL_ALIGNMENT_LEFT)
	_rule(wizard, "SpeakerRule", Rect2(123, 11, 1, 20))
	refresh_table_stats(scene)
	fit_wizard_line(scene.get_node("WizardLine") as Label)


static func refresh_table_stats(scene: Control) -> void:
	var panel := scene.get_node("HudPanel") as Panel
	var source := scene.get_node("Stats") as Label
	var progress: String = RunState.get_progress_text()
	var condition_text: String = RunState.get_run_condition_text()
	var values := [
		progress.trim_prefix("КАРТА "),
		str(RunState.gold),
		"%d/3" % RunState.get_party_size(),
		str(RunState.hero_upgrade_ids.size()),
		str(RunState.artifact_ids.size()),
	]
	source.text = "%s     ЗОЛОТО %s     ОТРЯД %s     РАЗВИТИЕ %s     РЕЛИКВИИ %s" % [progress, values[1], values[2], values[3], values[4]]
	if not condition_text.is_empty():
		source.text += "     %s" % condition_text
	# Extra live conditions occupy the existing top margin, not the Wizard's
	# face. The empty-state geometry is exactly the approved concept.
	var has_conditions := not condition_text.is_empty()
	_place(panel, Rect2(312, 0, 656, 67) if has_conditions else TABLE_STATS)
	panel.tooltip_text = source.text
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	for index in METRIC_NAMES.size():
		var x := 24.0 + 121.6 * index
		var name := panel.get_node("MetricName%d" % index) as Label
		var value := panel.get_node("MetricValue%d" % index) as Label
		_place(name, Rect2(x, 4 if has_conditions else 6, 121, 16))
		name.add_theme_font_size_override("font_size", 12 if has_conditions else 13)
		value.text = values[index]
		_fit_single(value, Rect2(x, 17 if has_conditions else 21, 121, 24 if has_conditions else 27), 21 if has_conditions else 24, 14)
		if index > 0:
			_place(panel.get_node("MetricRule%d" % index), Rect2(x, 9 if has_conditions else 11, 1, 29 if has_conditions else 32))
	var conditions := panel.get_node("RunConditions") as Label
	conditions.text = condition_text
	conditions.visible = has_conditions
	panel.get_node("ConditionRule").visible = has_conditions
	if has_conditions:
		_fit_copy(conditions, Rect2(24, 40, 608, 24), 12, 10, 2, COPY)
		conditions.tooltip_text = condition_text


static func fit_wizard_line(label: Label) -> void:
	_style_text(label, 16, COPY, _font(false, true), HORIZONTAL_ALIGNMENT_LEFT)
	_fit_copy(label, WIZARD_COPY, 16, 13, 2, COPY)


static func apply_battle(scene: Control) -> void:
	var top := scene.get_node("TopHudPanel") as Panel
	var run := scene.get_node("RunHudPanel") as Panel
	_style_plate(top, Rect2(23, 12, 837, 96), "DS3PaintedBanner")
	_style_plate(run, Rect2(873, 12, 385, 96), "DS3PaintedMedallion")
	var banner := top.get_node_or_null("DS3PaintedBanner") as TextureRect
	if banner != null:
		_place(banner, Rect2(-24, -15, 96, 165))
	var medallion := run.get_node_or_null("DS3PaintedMedallion") as TextureRect
	if medallion != null:
		_place(medallion, Rect2(4, 7, 62, 82))
	_make_label(top, "EncounterKicker", "СТОЛКНОВЕНИЕ", Rect2(82, 7, 732, 15), 12, MUTED, false, HORIZONTAL_ALIGNMENT_LEFT)
	_rule(top, "HeaderRule", Rect2(82, 53, 732, 1))
	_rule(run, "ProgressRule", Rect2(76, 33, 290, 1))
	fit_battle_title(scene.get_node("Title") as Label)
	fit_battle_status(scene.get_node("Status") as Label)
	var deal := scene.get_node("DealLabel") as Label
	_style_text(deal, 23, GOLD, _font(true), HORIZONTAL_ALIGNMENT_CENTER)
	_fit_single(deal, Rect2(949, 17, 286, 28), 23, 16)
	var condition := scene.get_node("RunConditionLabel") as Label
	_style_text(condition, 12, COPY, _font(), HORIZONTAL_ALIGNMENT_LEFT)
	_place(condition, BATTLE_CONDITIONS)
	condition.self_modulate.a = 0.0 # Child rows inherit visibility, not this alpha.
	condition.mouse_filter = Control.MOUSE_FILTER_STOP
	for index in range(2):
		_make_label(condition, "ModifierName%d" % index, "", Rect2(0, 0, 1, 1), 14, GOLD, true, HORIZONTAL_ALIGNMENT_LEFT)
		_make_label(condition, "ModifierValue%d" % index, "", Rect2(0, 0, 1, 1), 15, COPY, false, HORIZONTAL_ALIGNMENT_LEFT)
	_make_label(condition, "MoreModifiers", "", Rect2(0, 34, 290, 16), 12, MUTED, false, HORIZONTAL_ALIGNMENT_LEFT).hide()
	for label_name in ["PartyLabel", "EnemyLabel"]:
		var caption := scene.get_node(label_name) as Label
		var old := caption.get_node_or_null("DS3SideDivider") as CanvasItem
		if old != null:
			old.hide()
		var x := 101.0 if label_name == "PartyLabel" else 1066.0
		var width := 194.0 if label_name == "PartyLabel" else 208.0
		_style_text(caption, 16, GOLD, _font(true), HORIZONTAL_ALIGNMENT_CENTER)
		_fit_single(caption, Rect2(x, 113, width, 25), 16, 12)
		_rule(caption, "SideRuleV2", Rect2((width - 124.0) * 0.5, 26, 124, 1))


static func fit_battle_title(label: Label) -> void:
	_style_text(label, 26, GOLD, _font(true), HORIZONTAL_ALIGNMENT_LEFT)
	_fit_single(label, BATTLE_TITLE, 26, 17)


static func fit_battle_status(label: Label) -> void:
	_style_text(label, 17, COPY, _font(), HORIZONTAL_ALIGNMENT_LEFT)
	_fit_copy(label, BATTLE_STATUS, 17, 13, 2, COPY)


static func strip_duplicate_prefix(value: String, encounter_title: String) -> String:
	var prefix := encounter_title.to_upper() + " — "
	if value.to_upper().begins_with(prefix):
		var body := value.substr(prefix.length())
		if not body.is_empty():
			return body.left(1).to_upper() + body.substr(1)
	return value


static func present_modifiers(scene: Control, full_text: String) -> void:
	var condition := scene.get_node("RunConditionLabel") as Label
	if not condition.has_node("ModifierName0"):
		return
	var lines := full_text.split("\n", false)
	var base_count := 0
	if not lines.is_empty():
		base_count = 1
		if lines.size() > 1 and lines[1].begins_with("ДАВЛЕНИЕ ВРАГОВ"):
			base_count = 2
	var extra := lines.size() - base_count
	for index in range(2):
		var name := condition.get_node("ModifierName%d" % index) as Label
		var value := condition.get_node("ModifierValue%d" % index) as Label
		name.visible = index < base_count
		value.visible = index < base_count
		if index >= base_count:
			continue
		var parts := lines[index].split(" • ", false, 1)
		name.text = parts[0].replace("ДАВЛЕНИЕ ВРАГОВ", "ВРАГИ")
		value.text = parts[1].replace(" • ", " · ").replace(" -", " −") if parts.size() > 1 else ""
		var name_width := 96.0 if name.text.begins_with("ОТРЯД") else 53.0 if index == 1 else 46.0
		var row_height := 17.0 if extra > 0 else 23.0
		var y := index * row_height + 1
		_fit_single(name, Rect2(0, y, name_width, row_height), 14, 11)
		_fit_single(value, Rect2(name_width, y, 290 - name_width, row_height), 15 if extra == 0 else 14, 11)
		value.add_theme_color_override("font_color", BENEFIT if index == 0 else COPY)
		name.add_theme_color_override("font_color", GOLD if index == 0 else MUTED)
	var more := condition.get_node("MoreModifiers") as Label
	more.visible = extra > 0
	more.text = "+%d УСЛОВИЙ · ПОДРОБНОСТИ ПРИ НАВЕДЕНИИ" % extra
	_fit_single(more, Rect2(0, base_count * 17 + 1, 290, 16), 12, 10)
	condition.tooltip_text = full_text


static func _font(bold := false, italic := false) -> Font:
	if bold:
		if _bold == null:
			_bold = TYPE.heading_font().duplicate() as SystemFont
			_bold.font_weight = 700
		return _bold
	if italic:
		if _italic == null:
			_italic = TYPE.heading_font().duplicate() as SystemFont
			_italic.font_italic = true
		return _italic
	return TYPE.heading_font()


static func _style_plate(panel: Panel, bounds: Rect2, retain := "") -> void:
	for child in panel.get_children():
		if child is CanvasItem and child.name != retain:
			child.hide()
	var frame := MENU.plate_style(MENU.SECONDARY)
	frame.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	frame.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	panel.add_theme_stylebox_override("panel", frame)
	panel.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_place(panel, bounds)


static func _style_text(label: Label, point: int, tint: Color, font: Font, alignment: HorizontalAlignment) -> void:
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.max_lines_visible = 1
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", point)
	label.add_theme_color_override("font_color", tint)
	label.add_theme_color_override("font_shadow_color", Color("100c0b"))
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", 1)
	label.add_theme_constant_override("line_spacing", 0)


static func _make_label(parent: Control, node_name: String, value: String, bounds: Rect2, point: int, tint: Color, bold := false, alignment := HORIZONTAL_ALIGNMENT_CENTER) -> Label:
	var label := Label.new()
	label.name = node_name
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_style_text(label, point, tint, _font(bold), alignment)
	label.text = value
	parent.add_child(label)
	_place(label, bounds)
	return label


static func _rule(parent: Control, node_name: String, bounds: Rect2) -> ColorRect:
	var rect := ColorRect.new()
	rect.name = node_name
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rect.color = RULE
	parent.add_child(rect)
	_place(rect, bounds)
	return rect


static func _fit_single(label: Label, bounds: Rect2, point: int, minimum: int) -> void:
	var font := label.get_theme_font("font")
	while point > minimum and font.get_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x > bounds.size.x - 4:
		point -= 1
	label.add_theme_font_size_override("font_size", point)
	_place(label, bounds)


# Measure explicitly before enabling wrap. Label's native ellipsis handles
# only genuinely overflowing copy; the original string is never shortened.
static func _fit_copy(label: Label, bounds: Rect2, point: int, minimum: int, max_lines: int, tint: Color) -> void:
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.max_lines_visible = 1
	label.clip_text = true
	_place(label, bounds)
	var font := label.get_theme_font("font")
	var lines := 1
	while point >= minimum:
		lines = _wrapped_lines(font, label.text, point, bounds.size.x - 4)
		if lines <= max_lines and font.get_height(point) * lines <= bounds.size.y - 1:
			break
		if point == minimum:
			break
		point -= 1
	label.add_theme_font_size_override("font_size", point)
	label.add_theme_color_override("font_color", tint)
	var visible_lines := maxi(1, mini(max_lines, int(floor(bounds.size.y / font.get_height(point)))))
	label.max_lines_visible = visible_lines
	if lines > 1:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_place(label, bounds)
	label.tooltip_text = label.text if lines > visible_lines else ""
	label.mouse_filter = Control.MOUSE_FILTER_PASS if not label.tooltip_text.is_empty() else Control.MOUSE_FILTER_IGNORE


static func _wrapped_lines(font: Font, value: String, point: int, width: float) -> int:
	var count := 0
	for paragraph in value.split("\n"):
		var row := ""
		count += 1
		for word in paragraph.split(" ", false):
			var next := word if row.is_empty() else row + " " + word
			if font.get_string_size(next, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x <= width:
				row = next
			else:
				if not row.is_empty():
					count += 1
				var word_width := font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x
				count += maxi(0, ceili(word_width / width) - 1)
				row = word
	return count


static func _place(control: Control, bounds: Rect2) -> void:
	control.position = bounds.position
	control.size = bounds.size
