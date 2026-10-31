extends CanvasLayer

# D377: Debug-build-only live F5 sound isolation panel. The player needs to
# identify whether the unwanted sound comes from UI, Combat, or Ambience.
# Disabled by default and never included in release builds.
const BUILD_LABEL := "D377 / LIVE AUDIO / 2026-10-31"
const BUS_NAMES := ["UI", "Combat", "Ambience"]
const MODE_LABELS := {
	"normal": "ИСХОДНЫЙ МИКС",
	"ui": "ТОЛЬКО КАРТЫ / UI",
	"combat": "ТОЛЬКО БОЙ / COMBAT",
	"ambience": "ТОЛЬКО ОКРУЖЕНИЕ / AMBIENCE",
	"silence": "ПОЛНАЯ ТИШИНА",
}

var _panel: PanelContainer
var _status: Label
var _mode := "normal"
var _previous_mutes: Dictionary = {}
var _elapsed := 0.0


func _ready() -> void:
	layer = 240
	process_mode = Node.PROCESS_MODE_ALWAYS
	_capture_original_mutes()
	var root := Control.new()
	root.name = "AudioProbeRoot"
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	_panel = PanelContainer.new()
	_panel.name = "AudioProbePanel"
	_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_panel.offset_left = -572.0
	_panel.offset_right = -14.0
	_panel.offset_top = 16.0
	_panel.offset_bottom = 488.0
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	root.add_child(_panel)

	var column := VBoxContainer.new()
	column.name = "Content"
	column.add_theme_constant_override("separation", 9)
	_panel.add_child(column)
	_add_label(column, "D377  •  ПРОВЕРКА ЗВУКА В ИГРЕ", 22, Color("#e5bb82"))
	_add_label(column, BUILD_LABEL, 13, Color("#c9b8a5"))
	_add_label(column, "Ctrl+Shift+M — открыть / закрыть. Панель не меняет музыку, карты или бой до нажатия кнопки.", 13, Color("#d4cbba"))

	var choices := GridContainer.new()
	choices.name = "AudioModes"
	choices.columns = 2
	choices.add_theme_constant_override("h_separation", 8)
	choices.add_theme_constant_override("v_separation", 8)
	column.add_child(choices)
	for mode in MODE_LABELS:
		var button := Button.new()
		button.name = "Mode" + String(mode).capitalize()
		button.text = String(MODE_LABELS[mode])
		button.custom_minimum_size = Vector2(245.0, 43.0)
		button.pressed.connect(_set_mode.bind(mode))
		choices.add_child(button)

	_status = _add_label(column, "", 14, Color("#c5d8c7"))
	_add_label(column, "В D374 все фоновые записи отключены по умолчанию. Если слышно шум — сравни UI, COMBAT и полную тишину.", 13, Color("#b8a69c"))
	_panel.visible = false
	set_process(true)


func _add_label(parent: Node, value: String, font_size: int, font_color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)
	parent.add_child(label)
	return label


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var pressed_key := event as InputEventKey
	if not pressed_key.pressed or pressed_key.echo:
		return
	if pressed_key.keycode != KEY_M or not pressed_key.ctrl_pressed or not pressed_key.shift_pressed:
		return
	if _panel.visible:
		_set_mode("normal")
		_panel.visible = false
	else:
		_capture_original_mutes()
		_panel.visible = true
		_set_mode("normal")
	get_viewport().set_input_as_handled()


func _capture_original_mutes() -> void:
	for bus_name in BUS_NAMES:
		var bus := AudioServer.get_bus_index(bus_name)
		if bus >= 0:
			_previous_mutes[bus_name] = AudioServer.is_bus_mute(bus)


func _set_mode(mode: String) -> void:
	if not MODE_LABELS.has(mode):
		return
	_mode = mode
	for bus_name in BUS_NAMES:
		var idx := AudioServer.get_bus_index(bus_name)
		if idx < 0:
			continue
		var muted := bool(_previous_mutes.get(bus_name, false))
		match mode:
			"ui":
				muted = bus_name != "UI"
			"combat":
				muted = bus_name != "Combat"
			"ambience":
				muted = bus_name != "Ambience"
			"silence":
				muted = true
		AudioServer.set_bus_mute(idx, muted)
	if _status != null:
		_refresh_status()


func _process(delta: float) -> void:
	if not _panel.visible:
		return
	_elapsed += delta
	if _elapsed >= 0.25:
		_elapsed = 0.0
		_refresh_status()


func _refresh_status() -> void:
	if _status == null:
		return
	var counts := {"Master": 0, "UI": 0, "Combat": 0, "Ambience": 0}
	_count_active_voices(SoundDirector, counts)
	var current_scene: Node = get_tree().current_scene
	if current_scene != null:
		_count_active_voices(current_scene, counts)
	var ambient_state: Dictionary = SoundDirector.get_ambience_debug_info()
	var message := "РЕЖИМ: %s\n" % MODE_LABELS[_mode]
	message += "Автофон D374: %s | Локация: %s\n" % [
		"ВКЛЮЧЁН" if bool(ambient_state.get("enabled", false)) else "ВЫКЛЮЧЕН",
		String(ambient_state.get("location", "?")),
	]
	for bus_name in BUS_NAMES:
		var bus_idx := AudioServer.get_bus_index(bus_name)
		var bus_status := "НЕТ КАНАЛА"
		if bus_idx >= 0:
			bus_status = "MUTE" if AudioServer.is_bus_mute(bus_idx) else "ON"
		message += "%s: %s | играющих плееров: %d\n" % [
			bus_name, bus_status, int(counts.get(bus_name, 0))
		]
	message += "Если UI или COMBAT слышны при выключенном окружении, источник не в фоновых WAV."
	_status.text = message


func _count_active_voices(node: Node, counts: Dictionary) -> void:
	if node is AudioStreamPlayer:
		var voice := node as AudioStreamPlayer
		if voice.playing:
			var bus := String(voice.bus)
			counts[bus] = int(counts.get(bus, 0)) + 1
	elif node is AudioStreamPlayer2D:
		var spatial_voice := node as AudioStreamPlayer2D
		if spatial_voice.playing:
			var bus := String(spatial_voice.bus)
			counts[bus] = int(counts.get(bus, 0)) + 1
	for child in node.get_children():
		_count_active_voices(child, counts)


func _exit_tree() -> void:
	_set_mode("normal")
