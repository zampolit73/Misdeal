extends RefCounted

# D285: variant 3 ("dossier/card hybrid") is a layout/style overlay only.
# All displayed game values still originate from RunState / existing dossier.
const WEBP_TEXTURE := preload("res://scripts/ui/runtime_webp_texture.gd")
const PORTRAITS := {
	"knight": "res://assets/pixel/class_select/v7/knight.webp",
	"ranger": "res://assets/pixel/class_select/v7/ranger.webp",
	"mage": "res://assets/pixel/class_select/v7/mage.webp",
}
const NAMES := {"knight": "РЫЦАРЬ", "ranger": "СЛЕДОПЫТ", "mage": "МАГ"}
const ROLE_NOTES := {
	"knight": "Держит удар и прикрывает остальных.",
	"ranger": "Выбирает дистанцию и бьёт издалека.",
	"mage": "Поражает врагов магией по области.",
}
const BRONZE := Color(0.52, 0.34, 0.21, 1.0)
const BRONZE_LIGHT := Color(0.81, 0.59, 0.34, 1.0)
const PARCHMENT := Color(0.90, 0.80, 0.64, 1.0)
const FADED := Color(0.49, 0.45, 0.45, 1.0)
const PANEL_DARK := Color(0.031, 0.022, 0.028, 0.965)

static func apply(scene: Control) -> void:
	var frame := scene.get_node("Frame") as Panel
	frame.add_theme_stylebox_override("panel", _plate(PANEL_DARK, BRONZE_LIGHT, 2, 15))
	var portrait_frame := scene.get_node("Frame/PortraitFrame") as Panel
	portrait_frame.add_theme_stylebox_override("panel", _plate(Color(0.025, 0.019, 0.029, 1), BRONZE_LIGHT, 2, 10))
	portrait_frame.clip_contents = true
	for path in ["Frame/BuildPanel", "Frame/RelicsPanel"]:
		(scene.get_node(path) as Panel).add_theme_stylebox_override("panel", _plate(Color(0.032, 0.025, 0.029, 0.98), BRONZE, 1, 6))
	(scene.get_node("Frame/CommonPanel") as Panel).add_theme_stylebox_override("panel", _plate(Color(0.027, 0.023, 0.028, 0.99), BRONZE, 1, 5))
	for role in ["knight", "ranger", "mage"]:
		_build_role_card(scene, role)
	_make_label(frame, "RoleDescription", Vector2(586, 187), Vector2(213, 94), 14, FADED, true)
	_make_label(frame, "StatBaseHint", Vector2(582, 340), Vector2(212, 17), 11, FADED, false).text = "ИТОГ  /  (БАЗА)"
	_make_label(frame, "UpgradeCount", Vector2(1072, 130), Vector2(67, 25), 14, Color(0.65, 0.81, 0.99), false).horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_make_label(frame, "RelicCount", Vector2(1072, 405), Vector2(67, 25), 13, FADED, false).horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_build_upgrade_marks(frame)
	_build_relic_slots(frame)
	_build_footer(frame)
	_make_label(frame, "PartyCaption", Vector2(31, 465), Vector2(244, 74), 13, Color(0.64, 0.55, 0.49), true).text = "Три судьбы — одна дорога.\nКого удастся вернуть\nиз прошлого?"
	(scene.get_node("Frame/Stats") as RichTextLabel).add_theme_font_size_override("normal_font_size", 12)
	(scene.get_node("Frame/BuildList") as RichTextLabel).add_theme_font_size_override("normal_font_size", 12)
	(scene.get_node("Frame/RelicsList") as RichTextLabel).add_theme_font_size_override("normal_font_size", 12)
	var hint := scene.get_node("Frame/Hint") as Label
	hint.add_theme_color_override("font_color", Color(0.71, 0.63, 0.56, 1.0))
	var title := scene.get_node("Frame/Title") as Label
	title.add_theme_color_override("font_color", PARCHMENT)
	var close_button := scene.get_node("Frame/CloseButton") as Button
	close_button.text = "X"
	close_button.add_theme_stylebox_override("normal", _plate(Color(0.055, 0.038, 0.041, 1), BRONZE, 2, 2))
	close_button.add_theme_stylebox_override("hover", _plate(Color(0.12, 0.065, 0.058, 1), BRONZE_LIGHT, 2, 3))

static func _plate(fill: Color, outline: Color, thickness: int, shadow: int) -> StyleBoxFlat:
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
	for i in 3:
		var marker := _make_label(frame, "UpgradeMarker%d" % (i + 1), Vector2(840 + i * 97, 197), Vector2(81, 42), 25, FADED, false)
		marker.text = "◇"
		marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_make_label(frame, "UpgradeNumber%d" % (i + 1), Vector2(840 + i * 97, 235), Vector2(81, 17), 11, FADED, false).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

static func _build_relic_slots(frame: Control) -> void:
	for i in 3:
		var rect := Panel.new()
		rect.name = "RelicSlot%d" % (i + 1)
		rect.position = Vector2(832 + i * 105, 461)
		rect.size = Vector2(91, 54)
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rect.add_theme_stylebox_override("panel", _plate(Color(0.033, 0.028, 0.033, 1), BRONZE.darkened(0.38), 1, 1))
		frame.add_child(rect)
		var symbol := _make_label(rect, "Symbol", Vector2(4, 5), Vector2(83, 44), 20, FADED, false)
		symbol.text = "—"
		symbol.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

static func _build_footer(frame: Control) -> void:
	var footer := frame.get_node("CommonPanel") as Panel
	var headings := ["Отряд", "HP", "Урон", "Доп."]
	var start := [17, 162, 303, 449]
	for i in 4:
		var label := _make_label(footer, "Summary%d" % i, Vector2(start[i], 8), Vector2(140, 22), 14, PARCHMENT, false)
		label.text = headings[i]
	_make_label(footer, "Strength", Vector2(609, 9), Vector2(497, 39), 12, Color(0.72, 0.64, 0.60), true).horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
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
		icon.text = "◆" if completed else "◇"
		icon.add_theme_color_override("font_color", BRONZE_LIGHT if completed else FADED)
		(frame.get_node("UpgradeNumber%d" % (i + 1)) as Label).text = ["I", "II", "III"][i]
	var artifacts: Array = RunState.get_artifacts_for_role(role) if has_role else []
	(frame.get_node("RelicCount") as Label).text = "%d" % artifacts.size() if has_role else "—"
	for i in 3:
		var slot := frame.get_node("RelicSlot%d" % (i + 1)) as Panel
		var glyph := slot.get_node("Symbol") as Label
		var occupied := i < artifacts.size()
		glyph.text = "◆" if occupied else "—"
		glyph.add_theme_color_override("font_color", BRONZE_LIGHT if occupied else FADED)
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
