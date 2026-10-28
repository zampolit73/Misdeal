extends Control

# D369: authored synthetic ambient-roomtone listening room, no music.
const NAMES := [
	["castle", "ЗАМОК  •  каменные залы"],
	["courtyard", "ДВОР  •  ветер и камень"],
	["ossuary", "КОСТНИЦА  •  подземный сквозняк"],
	["silence", "ТИШИНА  •  выключить фон"],
]
var _status: Label


func _ready() -> void:
	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 156.0
	root.offset_top = 80.0
	root.offset_right = -156.0
	root.offset_bottom = -66.0
	root.add_theme_constant_override("separation", 18)
	add_child(root)

	_add_label(root, "D369  •  ТИШИНА ЗАМКА", 28, Color("#e0c8aa"))
	_add_label(root, "Три тихие звуковые среды. Между ними — плавное затухание. Музыки нет.", 17, Color("#b5aaa1"))
	_add_label(root, "Нажимай на локации с паузой в несколько секунд. Звук намеренно слабее ударов, карт и голоса волшебника.", 15, Color("#90867c"))

	var choices := GridContainer.new()
	choices.columns = 2
	choices.add_theme_constant_override("h_separation", 20)
	choices.add_theme_constant_override("v_separation", 14)
	root.add_child(choices)
	for entry in NAMES:
		var button := Button.new()
		button.name = "Select" + String(entry[0]).capitalize()
		button.text = String(entry[1])
		button.custom_minimum_size = Vector2(400, 64)
		button.pressed.connect(_select_location.bind(String(entry[0])))
		choices.add_child(button)

	_add_label(root, "ГРОМКОСТЬ ОКРУЖЕНИЯ  •  независимый канал", 17, Color("#e0c8aa"))
	var slider := HSlider.new()
	slider.name = "AmbienceVolume"
	slider.min_value = 0.0
	slider.max_value = 100.0
	slider.step = 1.0
	slider.value = SoundDirector.get_channel_volume("Ambience") * 100.0
	slider.value_changed.connect(_on_volume_changed)
	root.add_child(slider)

	_status = _add_label(root, "В игре фон включается при входе на стол и в бой, а в финале плавно затихает.", 16, Color("#d3ae80"))
	_add_label(root, "Сэмплы — синтезированные прототипы, не записи природы или фоли. Оцени на слух повторяемость и громкость.", 13, Color("#8d857b"))


func _add_label(parent: Node, title: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = title
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", size)
	parent.add_child(label)
	return label


func _select_location(location_id: String) -> void:
	SoundDirector.set_location(location_id, 1.6)
	_status.text = "Локация: " + location_id + ". Слушай фон 8–12 секунд, затем переключи."


func _on_volume_changed(value: float) -> void:
	SoundDirector.set_channel_volume("Ambience", value / 100.0)
