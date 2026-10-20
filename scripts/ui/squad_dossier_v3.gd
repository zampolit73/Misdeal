extends RefCounted

# D285: variant 3 ("dossier/card hybrid") is a layout/style overlay only.
# All displayed game values still originate from RunState / existing dossier.
const WEBP_TEXTURE := preload("res://scripts/ui/runtime_webp_texture.gd")
const MISDEAL_DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
const PORTRAITS := {
	"knight": "res://assets/pixel/class_select/v7/knight.webp",
	"ranger": "res://assets/pixel/class_select/v7/ranger.webp",
	"mage": "res://assets/pixel/class_select/v7/mage.webp",
}
const NAMES := {"knight": "РЫЦАРЬ", "ranger": "СЛЕДОПЫТ", "mage": "МАГ"}
const ROLE_NOTES := {
	"knight": "Непоколебимая стена между тьмой и теми, кто ещё сражается.",
	"ranger": "Его путь пролегает там, где враг не ждёт удара.",
	"mage": "За каждым заклинанием скрыта опасная цена.",
}
const BRONZE := Color(0.52, 0.34, 0.21, 1.0)
const BRONZE_LIGHT := Color(0.81, 0.59, 0.34, 1.0)
const PARCHMENT := Color(0.90, 0.80, 0.64, 1.0)
const FADED := Color(0.49, 0.45, 0.45, 1.0)
const PANEL_DARK := Color(0.031, 0.022, 0.028, 0.965)
# D287: ONLY isolated transparent ornament scraps from the user-approved final render.
# No painted Cyrillic text, filled-in stats, item counts or fake UI are embedded.
const DECOR_DIR := "res://assets/pixel/ui/squad_dossier_d287/"

static func apply(scene: Control) -> void:
	var frame := scene.get_node("Frame") as Panel
	frame.add_theme_stylebox_override("panel", _plate(PANEL_DARK, BRONZE_LIGHT, 2, 15))
	var portrait_frame := scene.get_node("Frame/PortraitFrame") as Panel
	portrait_frame.add_theme_stylebox_override("panel", _plate(Color(0.025, 0.019, 0.029, 1), BRONZE_LIGHT, 2, 10))
	portrait_frame.clip_contents = true
	# Screenshot D286: a 640x480 class illustration must cover the tall frame.
	# The earlier ASPECT_CENTERED mode left ~120px of black both above and below.
	var main_portrait := scene.get_node("Frame/PortraitFrame/Portrait") as TextureRect
	main_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	main_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	main_portrait.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	for path in ["Frame/BuildPanel", "Frame/RelicsPanel"]:
		(scene.get_node(path) as Panel).add_theme_stylebox_override("panel", _plate(Color(0.026, 0.019, 0.023, 0.995), Color(0.56, 0.36, 0.21), 2, 7))
	# The approved mockup is a reference, NEVER a full-screen runtime image.
	# These three isolated image details sit BEHIND real Godot labels and markers.
	_decor_texture(frame, "PortraitRubyCrest", "ruby_crest.webp", Vector2(385, 84), Vector2(78, 78), Vector2i(103, 103), Color(1, 1, 1, 0.93))
	_gilt_panel(scene.get_node("Frame/BuildPanel") as Panel, "Development", true)
	_gilt_panel(scene.get_node("Frame/RelicsPanel") as Panel, "Relics", false)
	_gilt_corners(frame, "Dossier", Vector2(13, 13), Vector2(1162, 626), 35)
	_gilt_corners(portrait_frame, "HeroPortrait", Vector2(2, 2), Vector2(244, 417), 35)
	(scene.get_node("Frame/CommonPanel") as Panel).add_theme_stylebox_override("panel", _plate(Color(0.027, 0.023, 0.028, 0.99), BRONZE, 1, 5))
	for role in ["knight", "ranger", "mage"]:
		_build_role_card(scene, role)
	_make_label(frame, "RoleDescription", Vector2(586, 191), Vector2(213, 88), 15, Color(0.69, 0.62, 0.57), true)
	var rule := ColorRect.new()
	rule.name = "HeroInfoRule"
	rule.position = Vector2(584, 284)
	rule.size = Vector2(210, 1)
	rule.color = Color(0.55, 0.35, 0.22, 0.9)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(rule)
	_make_label(frame, "StatBaseHint", Vector2(582, 325), Vector2(212, 19), 12, FADED, false).text = "ИТОГ  /  (БАЗА)"
	_make_label(frame, "UpgradeCount", Vector2(1072, 130), Vector2(67, 25), 14, Color(0.65, 0.81, 0.99), false).horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_make_label(frame, "RelicCount", Vector2(1072, 397), Vector2(67, 25), 13, FADED, false).horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_build_upgrade_marks(frame)
	_build_relic_slots(frame)
	_build_footer(frame)
	_make_label(frame, "PartyCaption", Vector2(31, 465), Vector2(244, 74), 13, Color(0.64, 0.55, 0.49), true).text = "Три судьбы — одна дорога.\nКого удастся вернуть\nиз прошлого?"
	(scene.get_node("Frame/Stats") as RichTextLabel).add_theme_font_size_override("normal_font_size", 15)
	(scene.get_node("Frame/BuildList") as RichTextLabel).add_theme_font_size_override("normal_font_size", 14)
	(scene.get_node("Frame/RelicsList") as RichTextLabel).add_theme_font_size_override("normal_font_size", 13)
	var hint := scene.get_node("Frame/Hint") as Label
	hint.add_theme_color_override("font_color", Color(0.71, 0.63, 0.56, 1.0))
	var title := scene.get_node("Frame/Title") as Label
	title.add_theme_color_override("font_color", PARCHMENT)
	var close_button := scene.get_node("Frame/CloseButton") as Button
	close_button.text = "X"
	close_button.add_theme_stylebox_override("normal", _plate(Color(0.055, 0.038, 0.041, 1), BRONZE, 2, 2))
	close_button.add_theme_stylebox_override("hover", _plate(Color(0.12, 0.065, 0.058, 1), BRONZE_LIGHT, 2, 3))

static func _plate(fill: Color, outline: Color, thickness: int, shadow: int) -> StyleBoxFlat:
	# D288: shared DS3 component, identical styling on D287's approved layout.
	return MISDEAL_DS3.make_plate(fill, outline, thickness, shadow)

static func _make_label(parent: Control, node_name: String, where: Vector2, dimensions: Vector2, font_size: int, color: Color, wrap: bool) -> Label:
	var label := Label.new()
	label.name = node_name
	label.position = where
	label.size = dimensions
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	if wrap:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parent.add_child(label)
	return label

# Parent panels render first; move textured backgrounds before title/other children.
static func _decor_texture(parent: Control, name: String, filename: String, at: Vector2, area: Vector2, native_size: Vector2i, tint: Color) -> TextureRect:
	var item := TextureRect.new()
	item.name = name
	item.set_script(WEBP_TEXTURE)
	item.position = at
	item.size = area
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	item.stretch_mode = TextureRect.STRETCH_SCALE
	item.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	item.modulate = tint
	parent.add_child(item)
	item.call("load_webp_path", DECOR_DIR + filename, native_size)
	return item


static func _gilt_corners(parent: Control, prefix: String, near: Vector2, far: Vector2, side: int) -> void:
	var corners := [Vector2(near.x, near.y), Vector2(far.x, near.y), Vector2(far.x, far.y), Vector2(near.x, far.y)]
	for i in 4:
		var ornament := _decor_texture(parent, prefix + "Filigree%d" % i, "gilt_corner.webp", corners[i], Vector2(side, side), Vector2i(53, 53), Color(1, 0.96, 0.89, 0.82))
		ornament.pivot_offset = Vector2(side, side) * 0.5
		ornament.rotation = float(i) * PI * 0.5


static func _thin_rule(parent: Control, node_name: String, at: Vector2, dimensions: Vector2, tone: Color) -> void:
	var rule := ColorRect.new()
	rule.name = node_name
	rule.position = at
	rule.size = dimensions
	rule.color = tone
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(rule)


static func _gilt_panel(panel: Panel, prefix: String, with_relief: bool) -> void:
	if with_relief:
		var relief := _decor_texture(panel, prefix + "StoneRelief", "carved_knight_relief.webp", Vector2(106, 40), Vector2(138, 91), Vector2i(138, 91), Color(1, 1, 1, 0.72))
		panel.move_child(relief, 0)
	_thin_rule(panel, prefix + "TopRule", Vector2(15, 42), Vector2(panel.size.x - 30, 1), Color(0.51, 0.32, 0.20, 0.9))
	_thin_rule(panel, prefix + "LowerRule", Vector2(15, panel.size.y - 15), Vector2(panel.size.x - 30, 1), Color(0.34, 0.23, 0.16, 0.7))
	_gilt_corners(panel, prefix, Vector2(4, 4), Vector2(panel.size.x - 32, panel.size.y - 32), 28)


static func _upgrade_diamond(frame: Control, index: int) -> void:
	var gem := Panel.new()
	gem.name = "UpgradeGem%d" % (index + 1)
	gem.position = Vector2(862 + index * 97, 197)
	gem.size = Vector2(36, 36)
	gem.pivot_offset = Vector2(18, 18)
	gem.rotation = PI / 4.0
	gem.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gem.add_theme_stylebox_override("panel", _plate(Color(0.05, 0.044, 0.046), BRONZE.darkened(0.42), 2, 2))
	frame.add_child(gem)


static func _relic_medallion(rect: Panel) -> void:
	var medal := Panel.new()
	medal.name = "Medallion"
	medal.position = Vector2(19, 12)
	medal.size = Vector2(53, 53)
	medal.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := _plate(Color(0.043, 0.033, 0.038, 1), Color(0.44, 0.29, 0.18, 1), 2, 2)
	style.set_corner_radius_all(26)
	medal.add_theme_stylebox_override("panel", style)
	rect.add_child(medal)


static func _build_role_card(scene: Control, role: String) -> void:
	var button := scene.get_node("Frame/" + role.capitalize() + "Button") as Button
	button.clip_contents = true
	button.text = ""
	button.add_theme_stylebox_override("normal", _plate(Color(0.040, 0.028, 0.031, 1), BRONZE.darkened(0.45), 1, 2))
	button.add_theme_stylebox_override("hover", _plate(Color(0.10, 0.044, 0.040, 1), BRONZE_LIGHT, 2, 5))
	button.add_theme_stylebox_override("pressed", _plate(Color(0.12, 0.05, 0.05, 1), BRONZE_LIGHT, 2, 5))
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	var mini := TextureRect.new()
	mini.name = "MiniPortrait"
	mini.set_script(WEBP_TEXTURE)
	mini.position = Vector2(5, 5)
	mini.size = Vector2(88, 85)
	mini.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	mini.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	mini.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.add_child(mini)
	mini.call("load_webp_path", PORTRAITS[role], Vector2i(640, 480))
	_make_label(button, "RoleTitle", Vector2(106, 14), Vector2(131, 28), 17, PARCHMENT, false)
	_make_label(button, "RoleStatus", Vector2(106, 47), Vector2(137, 38), 11, FADED, true)

static func refresh_role_cards(scene: Control, selected_role: String) -> void:
	for role in ["knight", "ranger", "mage"]:
		var button := scene.get_node("Frame/" + role.capitalize() + "Button") as Button
		var active: bool = RunState.is_role_in_party(role)
		var selected: bool = role == selected_role
		var lost: bool = RunState.get_companion_fate(role) == RunState.FATE_LOST
		button.text = ""
		var body := Color(0.11, 0.047, 0.045, 1) if selected else Color(0.037, 0.027, 0.032, 1)
		var line := BRONZE_LIGHT if selected else BRONZE.darkened(0.40)
		button.add_theme_stylebox_override("normal", _plate(body, line, 2 if selected else 1, 8 if selected else 2))
		button.get_node("MiniPortrait").modulate = Color.WHITE if active else (Color(0.47, 0.35, 0.34, 0.62) if lost else Color(0.47, 0.45, 0.47, 0.53))
		var role_title := button.get_node("RoleTitle") as Label
		role_title.text = NAMES[role]
		role_title.add_theme_color_override("font_color", Color(0.69, 0.84, 1.0) if selected else (Color(0.79, 0.71, 0.64) if active else Color(0.53, 0.49, 0.47)))
		var status := button.get_node("RoleStatus") as Label
		if active:
			status.text = "◆ %d / 3  ·  В ОТРЯДЕ" % RunState.get_role_upgrade_count(role)
		elif lost:
			status.text = "ПОТЕРЯН"
		else:
			status.text = "СУДЬБА НЕ РАЗЫГРАНА"
		status.add_theme_color_override("font_color", Color(0.74, 0.64, 0.53) if active else (Color(0.78, 0.36, 0.32) if lost else FADED))

static func _build_upgrade_marks(frame: Control) -> void:
	# Simple connecting rules carry the visual rhythm; only real progress fills a mark.
	for i in 2:
		var connector := ColorRect.new()
		connector.name = "UpgradeConnector%d" % (i + 1)
		connector.position = Vector2(903 + i * 97, 216)
		connector.size = Vector2(49, 1)
		connector.color = Color(0.47, 0.34, 0.25, 0.7)
		connector.mouse_filter = Control.MOUSE_FILTER_IGNORE
		frame.add_child(connector)
	for i in 3:
		_upgrade_diamond(frame, i)
		var marker := _make_label(frame, "UpgradeMarker%d" % (i + 1), Vector2(850 + i * 97, 198), Vector2(60, 35), 25, FADED, false)
		marker.text = "+"
		marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		marker.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_make_label(frame, "UpgradeNumber%d" % (i + 1), Vector2(840 + i * 97, 241), Vector2(81, 20), 12, FADED, false).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

static func _build_relic_slots(frame: Control) -> void:
	for i in 3:
		var rect := Panel.new()
		rect.name = "RelicSlot%d" % (i + 1)
		rect.position = Vector2(832 + i * 105, 440)
		rect.size = Vector2(91, 75)
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rect.add_theme_stylebox_override("panel", _plate(Color(0.032, 0.024, 0.025, 1), Color(0.52, 0.33, 0.20), 2, 2))
		frame.add_child(rect)
		_relic_medallion(rect)
		_gilt_corners(rect, "Slot%d" % (i + 1), Vector2(2, 2), Vector2(67, 51), 22)
		var symbol := _make_label(rect, "Symbol", Vector2(4, 10), Vector2(83, 54), 26, FADED, false)
		symbol.text = "+"
		symbol.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		symbol.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

static func _build_footer(frame: Control) -> void:
	var footer := frame.get_node("CommonPanel") as Panel
	var headings := ["Отряд", "HP", "Урон", "Доп."]
	var start := [17, 162, 303, 449]
	for i in 4:
		var label := _make_label(footer, "Summary%d" % i, Vector2(start[i], 8), Vector2(140, 22), 14, PARCHMENT, false)
		label.text = headings[i]
	# Keep the solo/duo modifiers on their own full-width row instead of a tiny squeezed footer.
	_make_label(footer, "Strength", Vector2(17, 31), Vector2(1095, 24), 13, Color(0.72, 0.64, 0.60), false).horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	for i in [149, 294, 440, 589]:
		_thin_rule(footer, "ColumnRule%d" % i, Vector2(i, 6), Vector2(1, 20), Color(0.43, 0.28, 0.18, 0.75))
	var common := footer.get_node("Common") as Label
	common.visible = false

static func refresh_details(scene: Control, role: String, has_role: bool) -> void:
	var frame := scene.get_node("Frame") as Panel
	var description := frame.get_node("RoleDescription") as Label
	if has_role:
		description.text = ROLE_NOTES[role]
		description.add_theme_color_override("font_color", Color(0.70, 0.61, 0.55))
		(scene.get_node("Frame/Stats") as RichTextLabel).text = _compact_stats(RunState.get_effective_hero_stats(role))
	else:
		description.text = RunState.get_companion_fate_note(role)
		description.add_theme_color_override("font_color", FADED)
	var count := RunState.get_role_upgrade_count(role) if has_role else 0
	(frame.get_node("UpgradeCount") as Label).text = "%d / 3" % count if has_role else "—"
	for i in 3:
		var completed := has_role and i < count
		var icon := frame.get_node("UpgradeMarker%d" % (i + 1)) as Label
		icon.text = "◆" if completed else "+"
		icon.add_theme_color_override("font_color", BRONZE_LIGHT if completed else Color(0.51, 0.45, 0.42))
		var gem := frame.get_node("UpgradeGem%d" % (i + 1)) as Panel
		gem.add_theme_stylebox_override("panel", _plate(Color(0.23, 0.075, 0.062, 1) if completed else Color(0.045, 0.036, 0.04, 1), BRONZE_LIGHT if completed else BRONZE.darkened(0.4), 2, 3))
		(frame.get_node("UpgradeNumber%d" % (i + 1)) as Label).text = ["I", "II", "III"][i]
	var artifacts: Array = RunState.get_artifacts_for_role(role) if has_role else []
	(frame.get_node("RelicCount") as Label).text = "%d" % artifacts.size() if has_role else "—"
	for i in 3:
		var slot := frame.get_node("RelicSlot%d" % (i + 1)) as Panel
		var glyph := slot.get_node("Symbol") as Label
		var occupied := i < artifacts.size()
		glyph.text = "◆" if occupied else "+"
		glyph.add_theme_color_override("font_color", BRONZE_LIGHT if occupied else Color(0.51, 0.42, 0.37))
		var medal := slot.get_node("Medallion") as Panel
		var medal_style := _plate(Color(0.17, 0.072, 0.050, 1) if occupied else Color(0.043, 0.033, 0.038, 1), BRONZE_LIGHT if occupied else Color(0.44, 0.29, 0.18, 1), 2, 2)
		medal_style.set_corner_radius_all(26)
		medal.add_theme_stylebox_override("panel", medal_style)
		slot.tooltip_text = str(artifacts[i].title) if occupied else "Нет реликвии"
	refresh_footer(scene)

static func refresh_footer(scene: Control) -> void:
	var footer := scene.get_node("Frame/CommonPanel") as Panel
	var txts := [
		"ОТРЯД  %d / 3" % RunState.get_party_size(),
		"HP  %+d" % int(RunState.party_hp_bonus),
		"УРОН  %+d" % int(RunState.party_damage_bonus),
		"ДОП.  %s" % RunState.get_extra_upgrade_progress_text()
	]
	for i in txts.size():
		(footer.get_node("Summary%d" % i) as Label).text = txts[i]
	var annotations: Array[String] = []
	var strength := RunState.get_party_strength_text()
	if not strength.is_empty():
		annotations.append(strength)
	var scars := RunState.rescue_scar_roles.size()
	if RunState.last_deal_hp_penalty > 0.0:
		scars += 1
	if scars > 0:
		annotations.append("ШРАМЫ %d" % scars)
	if RunState.wizard_debt_active:
		annotations.append("ДОЛГ ВОЛШЕБНИКУ")
	(footer.get_node("Strength") as Label).text = " · ".join(annotations)

static func _compact_stats(stats: Dictionary) -> String:
	if stats.is_empty():
		return ""
	var specs := [
		["ЗДОРОВЬЕ", "hp", "base_hp", 0],
		["УРОН", "damage", "base_damage", 1],
		["АТАК/СЕК", "attack_rate", "base_attack_rate", 2],
		["ДАЛЬНОСТЬ", "attack_range", "base_attack_range", 0],
		["СКОРОСТЬ", "move_speed", "base_move_speed", 0],
		["УРОН/СЕК", "dps", "base_dps", 1]
	]
	if float(stats.get("minimum_range", 0.0)) > 0.01:
		specs.append(["МИН. ДИСТ.", "minimum_range", "base_minimum_range", 0])
	if float(stats.get("splash_radius", 0.0)) > 0.01:
		specs.append(["РАДИУС", "splash_radius", "base_splash_radius", 0])
		specs.append(["ПОБОЧН. %", "splash_damage", "base_splash_damage", 0])
	var lines: Array[String] = []
	for spec in specs:
		var value := float(stats.get(spec[1], 0.0))
		var base := float(stats.get(spec[2], 0.0))
		var decimals := int(spec[3])
		var modified := absf(value - base) > 0.01
		var current := _number(value * 100.0 if spec[1] == "splash_damage" else value, decimals)
		var original := _number(base * 100.0 if spec[1] == "splash_damage" else base, decimals)
		var color := "#91d795" if value > base else "#ec897c"
		var value_text := "[color=%s]%s%s[/color]" % [color, current, "▲" if value > base else "▼"] if modified else "[color=#f0e2ce]%s[/color]" % current
		lines.append("[color=#d0bfa4]%s[/color]  %s [color=#81746c](%s)[/color]" % [str(spec[0]), value_text, original])
	return "\n".join(lines)
static func _number(v: float, d: int) -> String:
	match d:
		0:
			return str(roundi(v))
		1:
			return "%.1f" % v
		_:
			return "%.2f" % v
