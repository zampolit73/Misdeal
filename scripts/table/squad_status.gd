extends Control

const UNIT_TILE_SIZE: float = 96.0
const UNIT_SHEET_PARTS: Array[String] = [
	"res://assets/pixel/units/combat_units_v3/part_00.txt",
	"res://assets/pixel/units/combat_units_v3/part_01.txt",
	"res://assets/pixel/units/combat_units_v3/part_02.txt",
	"res://assets/pixel/units/combat_units_v3/part_03.txt",
	"res://assets/pixel/units/combat_units_v3/part_04.txt",
	"res://assets/pixel/units/combat_units_v3/part_05.txt",
	"res://assets/pixel/units/combat_units_v3/part_06.txt",
	"res://assets/pixel/units/combat_units_v3/part_07.txt",
	"res://assets/pixel/units/combat_units_v3/part_08.txt",
	"res://assets/pixel/units/combat_units_v3/part_09.txt",
]

@onready var knight_button: Button = $Frame/KnightButton
@onready var ranger_button: Button = $Frame/RangerButton
@onready var mage_button: Button = $Frame/MageButton
@onready var close_button: Button = $Frame/CloseButton
@onready var portrait: TextureRect = $Frame/PortraitFrame/Portrait
@onready var hero_name: Label = $Frame/HeroName
@onready var specialization: Label = $Frame/Specialization
@onready var stats_label: RichTextLabel = $Frame/Stats
@onready var build_label: RichTextLabel = $Frame/BuildList
@onready var relics_label: RichTextLabel = $Frame/RelicsList
@onready var common_label: Label = $Frame/CommonPanel/Common

var current_role := "knight"
var unit_sheet_texture: Texture2D

func _ready() -> void:
	knight_button.pressed.connect(_select_role.bind("knight"))
	ranger_button.pressed.connect(_select_role.bind("ranger"))
	mage_button.pressed.connect(_select_role.bind("mage"))
	close_button.pressed.connect(_close)
	_select_role(current_role)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				get_viewport().set_input_as_handled()
				_close()
			KEY_1:
				get_viewport().set_input_as_handled()
				_select_role("knight")
			KEY_2:
				get_viewport().set_input_as_handled()
				_select_role("ranger")
			KEY_3:
				get_viewport().set_input_as_handled()
				_select_role("mage")

func _close() -> void:
	queue_free()

func _select_role(role: String) -> void:
	current_role = role
	_refresh_role_buttons()
	_refresh_hero()

func _refresh_role_buttons() -> void:
	var buttons := {
		"knight": knight_button,
		"ranger": ranger_button,
		"mage": mage_button
	}

	for role_value in buttons.keys():
		var role := String(role_value)
		var button := buttons[role] as Button
		var selected := role == current_role
		var marker := "◆ " if selected else ""
		button.text = "%s%s   %d/3" % [
			marker,
			_get_role_label(role),
			RunState.get_role_upgrade_count(role)
		]
		button.add_theme_color_override(
			"font_color",
			_get_role_color(role) if selected else Color(0.74, 0.69, 0.66, 1.0)
		)
		button.add_theme_color_override(
			"font_hover_color",
			_get_role_color(role).lightened(0.12)
		)

func _refresh_hero() -> void:
	var stats := RunState.get_effective_hero_stats(current_role)
	if stats.is_empty():
		return

	hero_name.text = str(stats.get("unit_name", _get_role_label(current_role)))
	specialization.text = _get_specialization(current_role)
	specialization.add_theme_color_override("font_color", _get_role_color(current_role))
	portrait.texture = _get_role_texture(current_role)

	stats_label.text = _build_stats_text(stats, current_role)
	build_label.text = _build_upgrades_text(current_role)
	relics_label.text = _build_relics_text(current_role)
	common_label.text = _build_common_text()

func _build_stats_text(stats: Dictionary, role: String) -> String:
	var lines: Array[String] = []
	lines.append(_stat_line("ЗДОРОВЬЕ", float(stats["hp"]), float(stats["base_hp"]), 0, true))
	lines.append(_stat_line("УРОН", float(stats["damage"]), float(stats["base_damage"]), 1, true))
	lines.append(_stat_line("АТАК / СЕК", float(stats["attack_rate"]), float(stats["base_attack_rate"]), 2, true))
	lines.append(_stat_line("ДАЛЬНОСТЬ", float(stats["attack_range"]), float(stats["base_attack_range"]), 0, true))
	lines.append(_stat_line("СКОРОСТЬ", float(stats["move_speed"]), float(stats["base_move_speed"]), 0, true))
	lines.append(_stat_line("УРОН / СЕК", float(stats["dps"]), float(stats["base_dps"]), 1, true))

	var minimum_range := float(stats["minimum_range"])
	if minimum_range > 0.01:
		lines.append("")
		lines.append(_stat_line(
			"БЕЗОПАСНАЯ ДИСТ.",
			minimum_range,
			float(stats["base_minimum_range"]),
			0,
			true
		))

	var splash_radius := float(stats["splash_radius"])
	if splash_radius > 0.01:
		var splash_title := "РАДИУС УДАРА" if role == "knight" else "РАДИУС ВЗРЫВА"
		lines.append("")
		lines.append(_stat_line(
			splash_title,
			splash_radius,
			float(stats["base_splash_radius"]),
			0,
			true
		))
		lines.append(_stat_line(
			"ПОБОЧНЫЙ УРОН",
			float(stats["splash_damage"]) * 100.0,
			float(stats["base_splash_damage"]) * 100.0,
			0,
			true,
			"%"
		))

	return "\n".join(lines)

func _stat_line(
	label: String,
	value: float,
	base_value: float,
	decimals: int,
	higher_is_better: bool,
	suffix: String = ""
) -> String:
	var value_text := _format_number(value, decimals) + suffix
	if absf(value - base_value) < 0.01:
		return "[color=#d9c6aa]%-18s[/color] [color=#f1e7d5]%s[/color]" % [label, value_text]

	var increased := value > base_value
	var improved := increased if higher_is_better else not increased
	var color := "#8fd18f" if improved else "#e27b72"
	var arrow := "▲" if increased else "▼"
	var base_text := _format_number(base_value, decimals) + suffix

	return "[color=#d9c6aa]%-18s[/color] [color=%s]%s %s[/color] [color=#756b68](база %s)[/color]" % [
		label,
		color,
		value_text,
		arrow,
		base_text
	]

func _format_number(value: float, decimals: int) -> String:
	match decimals:
		0:
			return str(int(round(value)))
		1:
			return "%.1f" % value
		_:
			return "%.2f" % value

func _build_upgrades_text(role: String) -> String:
	var upgrades := RunState.get_hero_upgrades_for_role(role)
	if upgrades.is_empty():
		return "[color=#756b68]Пока без личного развития.[/color]"

	var chunks: Array[String] = []
	for upgrade in upgrades:
		chunks.append("[color=%s][b]%s[/b][/color]\n[color=#bcae9e]%s[/color]" % [
			_get_role_color_hex(role),
			upgrade.title,
			upgrade.description
		])

	return "\n\n".join(chunks)

func _build_relics_text(role: String) -> String:
	var artifacts := RunState.get_artifacts_for_role(role)
	if artifacts.is_empty():
		return "[color=#756b68]Нет реликвий, влияющих на героя.[/color]"

	var chunks: Array[String] = []
	for artifact in artifacts:
		var shared := "  [color=#9b8070]ОБЩАЯ[/color]" if artifact.target_role == "*" else ""
		chunks.append("[color=#e2bd78][b]%s[/b][/color]%s\n[color=#bcae9e]%s[/color]" % [
			artifact.title,
			shared,
			artifact.description
		])

	return "\n\n".join(chunks)

func _build_common_text() -> String:
	var debt := "   •   ДОЛГ ВОЛШЕБНИКУ" if RunState.wizard_debt_active else ""
	return "ОБЩИЕ ЭФФЕКТЫ     HP %+d     УРОН %+d     ДОП. РАЗВИТИЕ %s%s" % [
		int(RunState.party_hp_bonus),
		int(RunState.party_damage_bonus),
		RunState.get_extra_upgrade_progress_text(),
		debt
	]

func _get_specialization(role: String) -> String:
	match role:
		"knight":
			if RunState.has_hero_upgrade("knight_executioner") and RunState.has_hero_upgrade("knight_cleaver"):
				return "ПАЛАЧ"
			if RunState.has_hero_upgrade("knight_iron_oath") and RunState.has_artifact("dead_mans_shield"):
				return "ЖЕЛЕЗНАЯ СТЕНА"
			if RunState.has_hero_upgrade("knight_executioner"):
				return "ПАЛАЧ"
			if RunState.has_hero_upgrade("knight_cleaver"):
				return "РУБАКА"
			if RunState.has_hero_upgrade("knight_iron_oath"):
				return "СТРАЖ"
			return "ПЕРЕДНЯЯ ЛИНИЯ"
		"ranger":
			if RunState.has_hero_upgrade("ranger_longshot") and RunState.has_artifact("blind_quiver"):
				return "МЁРТВАЯ ЗОНА"
			if RunState.has_hero_upgrade("ranger_arrowstorm") and RunState.has_hero_upgrade("ranger_beast_trail"):
				return "ОХОТНИК БУРЬ"
			if RunState.has_hero_upgrade("ranger_longshot"):
				return "СНАЙПЕР"
			if RunState.has_hero_upgrade("ranger_arrowstorm"):
				return "ЗАЛПОВИК"
			if RunState.has_hero_upgrade("ranger_beast_trail"):
				return "СКИТАЛЕЦ"
			return "ДАЛЬНИЙ БОЙ"
		"mage":
			if RunState.has_hero_upgrade("mage_wildfire") and RunState.has_artifact("cracked_focus"):
				return "ПИРОМАНТ"
			if RunState.has_hero_upgrade("mage_glass_heart") and RunState.has_hero_upgrade("mage_overload"):
				return "АРКАННЫЙ РАЗРЫВ"
			if RunState.has_hero_upgrade("mage_glass_heart"):
				return "СТЕКЛЯННАЯ ПУШКА"
			if RunState.has_hero_upgrade("mage_wildfire"):
				return "ПИРОМАНТ"
			if RunState.has_hero_upgrade("mage_overload"):
				return "ПЕРЕГРУЖЕННЫЙ"
			return "ОБЛАСТНОЙ УРОН"
		_:
			return ""

func _get_role_label(role: String) -> String:
	match role:
		"knight":
			return "РЫЦАРЬ"
		"ranger":
			return "СЛЕДОПЫТ"
		"mage":
			return "МАГ"
		_:
			return "ГЕРОЙ"

func _get_role_color(role: String) -> Color:
	match role:
		"knight":
			return Color(0.62, 0.80, 1.0, 1.0)
		"ranger":
			return Color(0.58, 0.88, 0.50, 1.0)
		"mage":
			return Color(0.82, 0.56, 1.0, 1.0)
		_:
			return Color(0.9, 0.82, 0.72, 1.0)

func _get_role_color_hex(role: String) -> String:
	match role:
		"knight":
			return "#9ecbff"
		"ranger":
			return "#94e080"
		"mage":
			return "#d18fff"
		_:
			return "#e6d1b6"

func _get_role_texture(role: String) -> Texture2D:
	var tile := Vector2i(-1, -1)
	match role:
		"knight":
			tile = Vector2i(0, 0)
		"ranger":
			tile = Vector2i(1, 0)
		"mage":
			tile = Vector2i(2, 0)
		_:
			return null

	var sheet := _get_unit_sheet_texture()
	if sheet == null:
		return null

	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		Vector2(float(tile.x) * UNIT_TILE_SIZE, float(tile.y) * UNIT_TILE_SIZE),
		Vector2(UNIT_TILE_SIZE, UNIT_TILE_SIZE)
	)
	return atlas

func _get_unit_sheet_texture() -> Texture2D:
	if unit_sheet_texture != null:
		return unit_sheet_texture

	var encoded := ""
	for part_path in UNIT_SHEET_PARTS:
		if not FileAccess.file_exists(part_path):
			push_error("Missing combat unit atlas part for squad status: %s" % part_path)
			return null
		encoded += FileAccess.get_file_as_string(part_path).strip_edges()

	var bytes := Marshalls.base64_to_raw(encoded)
	if bytes.is_empty():
		push_error("Squad status could not decode combat atlas base64.")
		return null

	var image := Image.new()
	var error := image.load_png_from_buffer(bytes)
	if error != OK:
		push_error("Squad status could not decode combat atlas PNG: %s" % error_string(error))
		return null

	unit_sheet_texture = ImageTexture.create_from_image(image)
	return unit_sheet_texture
