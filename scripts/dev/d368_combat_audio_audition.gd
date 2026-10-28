extends Control

# D368 ear-test room: synthetic Foley prototypes, not recorded sound effects.
# Does not touch gameplay, DS3 screens, combat visuals, or the Oak table audio.
@onready var combat_audio: Node = $CombatAudio

var _feedback: Label

const CUES := [
	["Клинок / сухой металл", "attack", "knight"],
	["Тетива / скелет-лучник", "attack", "bone_archer"],
	["Магический выдох", "attack", "mage"],
	["Кость / попадание", "hit", ""],
	["Кости / падение", "death", "bone_archer"],
	["Колокол / настоящее лечение", "heal", "grave_bellkeeper"],
	["Надзиратель / акцент босса", "boss", "bone_warden"],
	["Начало сражения", "start", ""],
]


func _ready() -> void:
	var layout := VBoxContainer.new()
	layout.set_anchors_preset(Control.PRESET_FULL_RECT)
	layout.offset_left = 145.0
	layout.offset_right = -145.0
	layout.offset_top = 72.0
	layout.offset_bottom = -52.0
	layout.add_theme_constant_override("separation", 12)
	add_child(layout)

	_add_text(layout, "D368  •  ЗВУКИ СРАЖЕНИЯ", 28, Color("#e0c8aa"))
	_add_text(layout, "Сухой металл, кость, тетива и глухой колокол. Здесь только звуки — никаких новых визуальных эффектов.", 16, Color("#a99e91"))

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 16)
	grid.add_theme_constant_override("v_separation", 10)
	layout.add_child(grid)
	for item in CUES:
		var button := Button.new()
		button.text = item[0]
		button.custom_minimum_size = Vector2(390, 46)
		button.pressed.connect(_play_sample.bind(item[1], item[2]))
		grid.add_child(button)

	var volley := Button.new()
	volley.text = "ПРОВЕРКА: ЧЕТЫРЕ ЛУЧНИКА В ОДНОМ ЗАЛПЕ"
	volley.custom_minimum_size.y = 48
	volley.pressed.connect(_play_archer_volley)
	layout.add_child(volley)

	var mix := Button.new()
	mix.text = "ПРОВЕРКА: УДАРЫ + ЛЕЧЕНИЕ + БОСС"
	mix.custom_minimum_size.y = 48
	mix.pressed.connect(_play_layered_mix)
	layout.add_child(mix)

	_add_text(layout, "Громкость боевого канала", 15, Color("#c3b49e"))
	var volume := HSlider.new()
	volume.min_value = 0
	volume.max_value = 100
	volume.step = 1
	volume.value = SoundDirector.get_channel_volume("Combat") * 100.0
	volume.value_changed.connect(_set_volume)
	layout.add_child(volume)

	_feedback = _add_text(layout, "Слушай паузы между выстрелами и слышимость колокола на фоне ударов.", 15, Color("#d0ad83"))
	_add_text(layout, "Прототипы синтезированы, не записаны в студии. B — Oak на карточном столе не менялся.", 13, Color("#8d857b"))


func _add_text(parent: Node, message: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = message
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", font_size)
	parent.add_child(label)
	return label


func _play_sample(event_name: String, role: String) -> void:
	combat_audio.call("play_event", event_name, role)
	_feedback.text = "Слушаем: " + event_name + (" / " + role if role != "" else "")


func _play_archer_volley() -> void:
	_feedback.text = "4 стрелы в течение 120 мс: должен звучать один короткий сухой акцент, не пулемёт."
	for shot in range(4):
		combat_audio.call("play_event", "attack", "bone_archer")
		if shot < 3:
			await get_tree().create_timer(0.04).timeout
	await get_tree().create_timer(0.20).timeout
	combat_audio.call("play_event", "attack", "bone_archer")
	_feedback.text = "Через паузу прозвучал второй, слегка отличающийся выстрел."


func _play_layered_mix() -> void:
	_feedback.text = "Проверяем, что колокол и голос босса не тонут в ударах."
	combat_audio.call("play_event", "attack", "knight")
	combat_audio.call("play_event", "hit", "")
	combat_audio.call("play_event", "heal", "grave_bellkeeper")
	combat_audio.call("play_event", "boss", "bone_warden")


func _set_volume(value: float) -> void:
	SoundDirector.set_channel_volume("Combat", value / 100.0)
