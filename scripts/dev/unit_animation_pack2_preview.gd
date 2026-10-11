extends Control

# Review pack-2 candidate sheets alongside existing v4 art (F6). Missing
# candidates intentionally show "NOT READY". No gameplay art is replaced.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const QC := preload("res://scripts/dev/unit_animation_candidate_validator.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")

const ROLES := ["bone_thrall", "grave_bellkeeper", "crypt_guard", "bone_warden"]
const TITLES := ["КОСТЯНОЙ РАБ", "МОГИЛЬНЫЙ ЗВОНАРЬ", "СКЛЕПНЫЙ СТРАЖ", "НАДЗИРАТЕЛЬ"]
const ROW_Y := [179.0, 314.0, 449.0, 584.0]

var candidate_sprites: Array[AnimatedSprite2D] = []
var report_labels: Array[Label] = []


func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = UI.VOID
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	add_child(_text("MISDEAL / ПРОВЕРКА КАДРОВ НЕЖИТИ", Vector2(26, 12), Vector2(1160, 45), 27, UI.GOLD))
	add_child(_text("СЛЕВА — действующий v4. СПРАВА — кандидат. Кадры не внедрены в бой.", Vector2(26, 59), Vector2(1200, 27), 15, UI.TEXT_SECONDARY))

	var states := ["idle", "walk", "attack", "hit", "death"]
	for index in range(states.size()):
		var button := Button.new()
		button.text = states[index].to_upper()
		button.position = Vector2(28.0 + float(index) * 194.0, 91.0)
		button.size = Vector2(174.0, 34.0)
		add_child(button)
		UI.apply_action_button(button, UI.BRONZE, false)
		button.pressed.connect(_play_state.bind(states[index]))

	for i in range(ROLES.size()):
		var role: String = ROLES[i]
		var y: float = ROW_Y[i]
		add_child(_text(TITLES[i], Vector2(24, y - 41), Vector2(225, 29), 15, UI.GOLD))

		var original := UNIT_SCENE.instantiate() as BattleUnit
		original.visual_role = role
		original.team = 1
		original.is_boss = role == "bone_warden"
		original.display_name = TITLES[i]
		original.position = Vector2(323, y)
		original.z_index = 4
		add_child(original)
		(original.get_node("HealthBar") as ProgressBar).hide()
		(original.get_node("NameLabel") as Label).hide()

		var info: Dictionary = QC.inspect(role)
		var sprite := AnimatedSprite2D.new()
		sprite.position = Vector2(580, y - 18)
		sprite.scale = Vector2.ONE * (1.24 if role == "bone_warden" else 1.25)
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.flip_h = true
		add_child(sprite)
		candidate_sprites.append(sprite)

		var report := "ОЖИДАЕТ АРТ" if not info["ready"] else "ГОТОВ К ПРОСМОТРУ"
		if not info["errors"].is_empty():
			report = "ОШИБКА: %s" % info["errors"][0]
		elif not info["warnings"].is_empty() and info["ready"]:
			report = "ПРОВЕРИТЬ: %s" % info["warnings"][0]
		var status := _text(report, Vector2(680, y - 20), Vector2(559, 56), 14, UI.STEEL if info["ready"] else UI.TEXT_SECONDARY)
		status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		add_child(status)
		report_labels.append(status)

		if info["ready"]:
			sprite.sprite_frames = info["frames"] as SpriteFrames
			sprite.play("idle")

	add_child(_text("Проверяйте каждый кадр: отдельные ступни, целое оружие, ровная линия пола, отсутствие обрывков соседних строк.", Vector2(25, 663), Vector2(1215, 29), 13, UI.TEXT_SECONDARY))


func _play_state(state: String) -> void:
	for sprite in candidate_sprites:
		if sprite.sprite_frames == null:
			continue
		if sprite.sprite_frames.has_animation(state):
			sprite.play(state)


func _text(value: String, where: Vector2, size: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.position = where
	label.size = size
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.94))
	return label
