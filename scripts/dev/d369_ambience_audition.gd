extends Control

# D369: authored synthetic roomtone listening room, no music.
# Audibility hotfix: auto-start, visible routing information and an explicit
# audible Ambience-channel probe to distinguish playback from a quiet mix.
const NAMES := [
	["castle", "ЗАМОК  •  каменные залы"],
	["courtyard", "ДВОР  •  ветер и камень"],
	["ossuary", "КОСТНИЦА  •  подземный сквозняк"],
	["silence", "ТИШИНА  •  выключить фон"],
]
const TEST_TONE_RATE := 22050
var _status: Label
var _volume_slider: HSlider
var _test_player: AudioStreamPlayer


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
	_volume_slider = slider

	var probe_button := Button.new()
	probe_button.name = "AudioChannelTestButton"
	probe_button.text = "ПРОВЕРИТЬ ЗВУК  •  короткий тестовый сигнал"
	probe_button.custom_minimum_size = Vector2(0, 52)
	probe_button.pressed.connect(_play_channel_test)
	root.add_child(probe_button)

	_test_player = AudioStreamPlayer.new()
	_test_player.name = "AudioChannelTest"
	_test_player.bus = "Ambience"
	_test_player.volume_db = -4.0
	_test_player.stream = _make_channel_test_stream()
	add_child(_test_player)

	_status = _add_label(root, "В игре фон включается при входе на стол и в бой, а в финале плавно затихает.", 16, Color("#d3ae80"))
	_add_label(root, "Сэмплы — синтезированные прототипы, не записи природы или фоли. Оцени на слух повторяемость и громкость.", 13, Color("#8d857b"))

	# F6 opens straight into an audible roomtone; no hidden extra click required.
	_select_location("castle")


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
	_status.text = "Локация: %s | Ambience %.1f dB. Слушай 8–12 секунд." % [location_id, _get_bus_db()]


func _on_volume_changed(value: float) -> void:
	SoundDirector.set_channel_volume("Ambience", value / 100.0)


func _play_channel_test() -> void:
	if AudioServer.get_bus_index("Ambience") < 0:
		_status.text = "Канал Ambience отсутствует: проверь Audio Bus Layout в Godot."
		return
	# An explicit test should never appear silent just because a previous
	# listening session left the Ambience slider at a near-zero value.
	if SoundDirector.get_channel_volume("Ambience") < 0.3:
		SoundDirector.set_channel_volume("Ambience", 0.72)
		_volume_slider.set_value_no_signal(72.0)
	_test_player.stop()
	_test_player.play()
	_status.text = "Тестовый тон на канале Ambience (%.1f dB). Если тон слышен, сравни три фона." % _get_bus_db()


func _get_bus_db() -> float:
	var idx := AudioServer.get_bus_index("Ambience")
	if idx < 0:
		return -80.0
	if AudioServer.is_bus_mute(idx):
		return -80.0
	return AudioServer.get_bus_volume_db(idx)


func _make_channel_test_stream() -> AudioStreamWAV:
	# Brief neutral two-note-free calibration sine, preview only, not game SFX.
	const TEST_DURATION := 0.34
	var count := int(float(TEST_TONE_RATE) * TEST_DURATION)
	var pcm := PackedByteArray()
	pcm.resize(count * 2)
	for sample_id in range(count):
		var elapsed := float(sample_id) / float(TEST_TONE_RATE)
		var attack := minf(1.0, elapsed / 0.008)
		var release := minf(1.0, (TEST_DURATION - elapsed) / 0.085)
		var envelope := maxf(0.0, attack * release)
		var wave := sin(TAU * 660.0 * elapsed)
		pcm.encode_s16(sample_id * 2, roundi(wave * envelope * 12000.0))
	var output := AudioStreamWAV.new()
	output.format = AudioStreamWAV.FORMAT_16_BITS
	output.mix_rate = TEST_TONE_RATE
	output.stereo = false
	output.data = pcm
	return output


func _exit_tree() -> void:
	if _test_player != null:
		_test_player.stop()
	# The F6 sound booth is only an audition; close it back into silence.
	SoundDirector.set_location("silence", 0.1)
