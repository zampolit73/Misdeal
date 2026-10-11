extends Control

# Open with F6 to inspect all five animated roles without starting a run.
const ANIM_LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const ROLES := ["knight", "ranger", "mage", "skeleton", "bone_archer"]
const ROLE_TITLES := ["РЫЦАРЬ", "СЛЕДОПЫТ", "МАГ", "СКЕЛЕТ", "КОСТЯНОЙ ЛУЧНИК"]
const STATES := ["idle", "walk", "attack", "hit", "death"]

var previews: Array[AnimatedSprite2D] = []
var status_label: Label


func _ready() -> void:
	var background := ColorRect.new()
	background.color = Color(0.014, 0.012, 0.020, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var title := _label("MISDEAL  /  АНИМАЦИЯ ЮНИТОВ — ПАКЕТ 1", Vector2(32, 20), Vector2(1200, 52), 27, Color(0.93, 0.68, 0.36, 1.0))
	add_child(title)
	var hint := _label("Выбери состояние, чтобы просмотреть все пять ролей. В игре остальные юниты остаются на v4.", Vector2(32, 66), Vector2(1200, 28), 15, Color(0.78, 0.73, 0.67, 1.0))
	add_child(hint)

	for index in range(STATES.size()):
		var state: String = STATES[index]
		var button := Button.new()
		button.text = state.to_upper()
		button.position = Vector2(32 + index * 200, 110)
		button.size = Vector2(180, 42)
		add_child(button)
		button.pressed.connect(_play_animation.bind(state))

	for index in range(ROLES.size()):
		var role: String = ROLES[index]
		var x := 140.0 + float(index) * 248.0
		var sprite := AnimatedSprite2D.new()
		sprite.position = Vector2(x, 385)
		sprite.scale = Vector2.ONE * 1.60
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.flip_h = index >= 3
		sprite.sprite_frames = ANIM_LIBRARY.get_frames(role)
		add_child(sprite)
		previews.append(sprite)

		var role_label := _label(ROLE_TITLES[index], Vector2(x - 116.0, 466.0), Vector2(232.0, 36.0), 15, Color(0.94, 0.84, 0.70, 1.0))
		role_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(role_label)

	status_label = _label("", Vector2(32, 576), Vector2(1200, 50), 15, Color(0.78, 0.73, 0.67, 1.0))
	add_child(status_label)
	_play_animation("idle")


func _play_animation(name: String) -> void:
	var loaded_count := 0
	for sprite in previews:
		if sprite.sprite_frames == null or not sprite.sprite_frames.has_animation(name):
			continue
		sprite.play(name)
		loaded_count += 1
	status_label.text = "Состояние: %s  /  подключены %d из 5. Объекты справа развёрнуты к героям (влево)." % [name.to_upper(), loaded_count]


func _label(value: String, where: Vector2, label_size: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.position = where
	label.size = label_size
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.94))
	return label
