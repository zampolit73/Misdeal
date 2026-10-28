extends Control

# D372: sparse spatial sound scenes (creaks, distant stone/metal, bones).
# This is a developer-only F6 scene, not a game HUD migration.
const BUILD_LABEL := "D372 / SPATIAL-AMBIENCE / 2026-10-29"
const TEST_TONE_RATE := 22050
const SCENE_NOTES := {
	"castle": "Скрип балок (2–4 и 10–12 с), тяжёлый стук двери и металла. Между событиями — тишина.",
	"courtyard": "Порывы ветра (1–4 и 8–12 с), скрип ворот и удар железной защёлки.",
	"ossuary": "Костяные щелчки (2–3 и 10–11 с), капли воды и далёкий скрип камня.",
	"silence": "Полная тишина: сравни её с остальными средами.",
}
var _scene_description: Label
const LOCATIONS := [
	["castle", "ЗАМОК — каменные залы"],
	["courtyard", "ДВОР — ветер и камень"],
	["ossuary", "КОСТНИЦА — холодный сквозняк"],
	["silence", "ТИШИНА — выключить фон"],
]

var _status: Label
var _routing: Label
var _meter: Label
var _volume_slider: HSlider
var _test_player: AudioStreamPlayer
var _master_player: AudioStreamPlayer
var _original_ambience_volume := 1.0
var _update_accum := 0.0


func _ready() -> void:
	_original_ambience_volume = SoundDirector.get_channel_volume("Ambience")
	var root := VBoxContainer.new()
	root.name = "AudioCheckContent"
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 130.0
	root.offset_top = 50.0
	root.offset_right = -130.0
	root.offset_bottom = -48.0
	root.add_theme_constant_override("separation", 12)
	add_child(root)

	_add_label(root, "D372  •  ЗВУКОВЫЕ СЦЕНЫ", 29, Color("#f2c17a"))
	_add_label(root, BUILD_LABEL + "  •  Если на экране D371, локальный проект ещё не обновлён.", 16, Color("#d8b19b"))
	_add_label(root, "НОВЫЙ ЗВУК: больше никакого постоянного белого шума. Слушай отдельные события.", 17, Color("#e3d7c2"))

	var choices := GridContainer.new()
	choices.name = "LocationChoices"
	choices.columns = 2
	choices.add_theme_constant_override("h_separation", 18)
	choices.add_theme_constant_override("v_separation", 8)
	root.add_child(choices)
	_scene_description = _add_label(root, "Выбери звуковую сцену", 15, Color("#d8ba9a"))
	for entry in LOCATIONS:
		var id := String(entry[0])
		var button := Button.new()
		button.name = "Select" + id.capitalize()
		button.text = String(entry[1])
		button.custom_minimum_size = Vector2(450, 54)
		button.pressed.connect(_select_location.bind(id))
		choices.add_child(button)

	_add_label(root, "ГРОМКОСТЬ ОКРУЖЕНИЯ (только для прослушивания)", 16, Color("#f2c17a"))
	_volume_slider = HSlider.new()
	_volume_slider.name = "AmbienceVolume"
	_volume_slider.min_value = 0.0
	_volume_slider.max_value = 100.0
	_volume_slider.step = 1.0
	_volume_slider.value_changed.connect(_on_volume_changed)
	root.add_child(_volume_slider)

	var tests := HBoxContainer.new()
	tests.name = "AudioTests"
	tests.add_theme_constant_override("separation", 16)
	root.add_child(tests)
	var master_button := Button.new()
	master_button.name = "MasterTestButton"
	master_button.text = "ТЕСТ 1 — MASTER"
	master_button.custom_minimum_size = Vector2(450, 56)
	master_button.pressed.connect(_play_master_test)
	tests.add_child(master_button)

	var ambience_button := Button.new()
	ambience_button.name = "AudioChannelTestButton"
	ambience_button.text = "ТЕСТ 2 — AMBIENCE"
	ambience_button.custom_minimum_size = Vector2(450, 56)
	ambience_button.pressed.connect(_play_channel_test)
	tests.add_child(ambience_button)

	var tone := _make_channel_test_stream()
	_master_player = AudioStreamPlayer.new()
	_master_player.name = "AudioChannelMaster"
	_master_player.bus = "Master"
	_master_player.volume_db = -4.0
	_master_player.stream = tone
	add_child(_master_player)
	_test_player = AudioStreamPlayer.new()
	_test_player.name = "AudioChannelTest"
	_test_player.bus = "Ambience"
	_test_player.volume_db = -4.0
	_test_player.stream = tone
	add_child(_test_player)

	_status = _add_label(root, "Загрузка аудио...", 16, Color("#e4c891"))
	_routing = _add_label(root, "Подключение к звуковым каналам...", 15, Color("#d6bfaa"))
	_meter = _add_label(root, "Датчики: -", 15, Color("#a7d2c1"))
	_add_label(root, "1: MASTER должен дать короткий писк. 2: AMBIENCE должен дать такой же писк.", 14, Color("#aaa399"))
	_add_label(root, "Если писки слышны, но фоны нет — проблема в образцах/громкости, а не в устройстве.", 14, Color("#aaa399"))

	# F6 playback is intentionally unmistakable and does not persist in F5.
	SoundDirector.set_channel_volume("Ambience", 1.0)
	_volume_slider.set_value_no_signal(100.0)
	SoundDirector.set_location("silence", 0.05)
	_select_location("castle")
	set_process(true)


func _add_label(parent: Node, content: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = content
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", size)
	parent.add_child(label)
	return label


func _select_location(location_id: String) -> void:
	SoundDirector.set_location(location_id, 0.65)
	if _scene_description != null:
		_scene_description.text = String(SCENE_NOTES.get(location_id, ""))
	if _status != null:
		_status.text = "ВЫБРАНО: " + location_id + ". Подожди секунду, затем сравни другую локацию."


func _on_volume_changed(value: float) -> void:
	SoundDirector.set_channel_volume("Ambience", value / 100.0)


func _play_master_test() -> void:
	_master_player.stop()
	_master_player.play()
	_status.text = "ТЕСТ 1: отправлен сигнал в MASTER. Если тишина — проверь звук Godot/Windows."


func _play_channel_test() -> void:
	SoundDirector.set_channel_volume("Ambience", 1.0)
	_volume_slider.set_value_no_signal(100.0)
	_test_player.stop()
	_test_player.play()
	_status.text = "ТЕСТ 2: отправлен сигнал в AMBIENCE. Если слышен только Master — проверь канал Ambience."


func _process(delta: float) -> void:
	_update_accum += delta
	if _update_accum < 0.15:
		return
	_update_accum = 0.0
	var data: Dictionary = SoundDirector.get_ambience_debug_info()
	var players: Array = data.get("players", [])
	var active := ""
	for i in range(players.size()):
		var info: Dictionary = players[i]
		active += "  [%d %s / %.1f dB / %.1f c]" % [i, "PLAY" if bool(info.get("playing", false)) else "STOP", float(info.get("gain_db", -60.0)), float(info.get("position_s", 0.0))]
	var current_id: String = String(data.get("location", "unknown"))
	_routing.text = "D372 / Location: %s  | Ambience bus: %s / %.1f dB  | WAV: %s" % [
		current_id,
		"OK" if bool(data.get("bus_exists", false)) else "MISSING",
		float(data.get("bus_db", -80.0)),
		"OK" if bool(data.get("stream_loaded", false)) else "NONE",
	]
	var bus_idx := AudioServer.get_bus_index("Ambience")
	var master_idx := AudioServer.get_bus_index("Master")
	_meter.text = "ПЛЕЕРЫ: %s    ПИКИ: Master %s / Ambience %s" % [
		active,
		_peak_text(master_idx),
		_peak_text(bus_idx),
	]


func _peak_text(idx: int) -> String:
	if idx < 0:
		return "NO BUS"
	return "%.0f dB" % AudioServer.get_bus_peak_volume_left_db(idx, 0)


func _make_channel_test_stream() -> AudioStreamWAV:
	const TEST_DURATION := 0.48
	var sample_count := roundi(TEST_TONE_RATE * TEST_DURATION)
	var pcm := PackedByteArray()
	pcm.resize(sample_count * 2)
	for sample_id in range(sample_count):
		var elapsed := float(sample_id) / TEST_TONE_RATE
		var attack := minf(1.0, elapsed / 0.012)
		var release := minf(1.0, (TEST_DURATION - elapsed) / 0.09)
		var envelope := maxf(0.0, attack * release)
		var wave := sin(TAU * 660.0 * elapsed)
		pcm.encode_s16(sample_id * 2, roundi(wave * envelope * 16000.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = TEST_TONE_RATE
	stream.stereo = false
	stream.data = pcm
	return stream


func _exit_tree() -> void:
	if _master_player != null:
		_master_player.stop()
	if _test_player != null:
		_test_player.stop()
	SoundDirector.set_location("silence", 0.1)
	SoundDirector.set_channel_volume("Ambience", _original_ambience_volume)
