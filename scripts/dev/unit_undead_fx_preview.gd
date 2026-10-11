extends Control

# Standalone F6 review scene for Pack 2 Stage A. The four figures are live
# static-v4 BattleUnit nodes; buttons trigger only their non-damage contact FX.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ATTACK_VISUALS := preload("res://scripts/battle/unit_attack_visuals.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")

const ROLES := ["bone_thrall", "grave_bellkeeper", "crypt_guard", "bone_warden"]
const TITLES := ["КОСТЯНОЙ РАБ", "МОГИЛЬНЫЙ ЗВОНАРЬ", "СКЛЕПНЫЙ СТРАЖ", "КОСТЯНОЙ НАДЗИРАТЕЛЬ"]


func _ready() -> void:
	var background := ColorRect.new()
	background.color = UI.VOID
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var heading := _label("MISDEAL  /  НЕЖИТЬ — ЭФФЕКТЫ АТАК", Vector2(32, 22), Vector2(1215, 52), 27, UI.GOLD)
	add_child(heading)
	var hint := _label("Первый проход пакета 2: статичные v4 силуэты + короткие визуальные акценты настоящих ударов.", Vector2(32, 78), Vector2(1215, 32), 15, UI.TEXT_SECONDARY)
	add_child(hint)

	for index in range(ROLES.size()):
		var role: String = ROLES[index]
		var x: float = 160.0 + 315.0 * float(index)
		var unit := UNIT_SCENE.instantiate() as BattleUnit
		unit.name = "Sample_%s" % role
		unit.visual_role = role
		unit.team = 1
		unit.display_name = TITLES[index]
		unit.max_hp = 100.0
		unit.is_boss = role == "bone_warden"
		unit.position = Vector2(x, 355.0)
		unit.z_index = 2
		add_child(unit)

		var title := _label(TITLES[index], Vector2(x - 138.0, 445.0), Vector2(275.0, 28.0), 14, UI.TEXT)
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(title)

		var button := Button.new()
		button.text = "ПОКАЗАТЬ УДАР"
		button.position = Vector2(x - 117.0, 501.0)
		button.size = Vector2(234.0, 45.0)
		add_child(button)
		UI.apply_action_button(button, UI.EMBER if role == "bone_warden" else UI.BRONZE, role == "bone_warden")
		button.pressed.connect(_show_attack.bind(role, Vector2(x - 46.0, 355.0)))

	var legend := _label("Это не покадровая анимация. Персонажи пока используют v4, а длительность эффектов — 0,17–0,36 с.", Vector2(32, 590), Vector2(1200, 36), 14, UI.TEXT_SECONDARY)
	add_child(legend)
	var note := _label("Проверяйте в игре урон и момент контакта отдельно: здесь эффекты запускаются без изменения HP.", Vector2(32, 622), Vector2(1200, 32), 13, UI.TEXT_MUTED)
	add_child(note)


func _show_attack(role: String, target_position: Vector2) -> void:
	ATTACK_VISUALS.spawn(role, self, target_position)


func _label(value: String, pos: Vector2, dimensions: Vector2, font_size: int, font_color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.position = pos
	label.size = dimensions
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.94))
	return label
