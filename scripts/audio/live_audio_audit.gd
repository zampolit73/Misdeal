extends CanvasLayer

# D377: debug-only, on-demand in-game A/B audio inspector.
# It never plays/replaces any SFX. It restores every audio bus mute on exit.
const BUILD_MARKER := "D377 / LIVE AUDIO A-B"
const AUDIO_BUSES := ["Master", "UI", "Combat", "Ambience"]
const VALID_MODES := ["normal", "ui_only", "combat_only", "silence"]

var _original_bus_mutes: Dictionary = {}
var _mode := "normal"
var _state: Label
var _meters: Label
var _voices: Label
var _tick := 0.0


func _ready() -> void:
	layer = 250
	process_mode = Node.PROCESS_MODE_ALWAYS
	for bus_name in AUDIO_BUSES:
		var idx := AudioServer.get_bus_index(bus_name)
		if idx >= 0:
			_original_bus_mutes[bus_name] = AudioServer.is_bus_mute(idx)
	_build_panel()
	_refresh()
	set_process(true)


func _build_panel() -> void:
	var panel := PanelContainer.new()
	panel.name = "AudioAuditPanel"
	panel.anchor_left = 1.0
	panel.anchor_right = 1.0
	panel.offset_left = -565.0
	panel.offset_right = -16.0
	panel.offset_top = 38.0
	panel.offset_bottom = 333.0
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.019, 0.024, 0.96)
	style.border_color = Color(0.59, 0.38, 0.26, 0.85)
	style.set_border_width_all(2)
	style.set_content_margin_all(14)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 8)
	panel.add_child(layout)

	_label(layout, "D377  •  ЗВУК В РЕАЛЬНОЙ ИГРЕ", 21, Color("#f1c389"))
	_label(layout, "ДИАГНОСТИКА — не меняет музыку или игровой дизайн", 13, Color("#bca89a"))
	_state = _label(layout, "Инициализация...", 14, Color("#e2d0b9"))
	_meters = _label(layout, "Уровни звука...", 13, Color("#c8d2ce"))
	_voices = _label(layout, "Звуковые плееры...", 13, Color("#a7c8bd"))

	var actions := GridContainer.new()
	actions.columns = 2
	actions.add_theme_constant_override("h_separation", 8)
	actions.add_theme_constant_override("v_separation", 8)
	layout.add_child(actions)
	_button(actions, "ОБЫЧНЫЙ ЗВУК", "normal")
	_button(actions, "ТОЛЬКО КАРТЫ / UI", "ui_only")
	_button(actions, "ТОЛЬКО БОЙ / COMBAT", "combat_only")
	_button(actions, "ПОЛНАЯ ТИШИНА", "silence")

	_label(layout, "Ctrl+Shift+F10 — скрыть и восстановить громкость", 12, Color("#9f978f"))


func _label(parent: Node, value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)
	return label


func _button(parent: Node, title: String, mode: String) -> void:
	var button := Button.new()
	button.name = "Mode_" + mode
	button.text = title
	button.custom_minimum_size = Vector2(235.0, 43.0)
	button.pressed.connect(set_mode.bind(mode))
	parent.add_child(button)


func set_mode(mode: String) -> void:
	if mode not in VALID_MODES:
		return
	_restore_mutes()
	match mode:
		"ui_only":
			_mute_bus("Combat", true)
			_mute_bus("Ambience", true)
		"combat_only":
			_mute_bus("UI", true)
			_mute_bus("Ambience", true)
		"silence":
			_mute_bus("Master", true)
	_mode = mode
	_refresh()


func get_mode() -> String:
	return _mode


func _mute_bus(bus_name: String, muted: bool) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx >= 0:
		AudioServer.set_bus_mute(idx, muted)


func _restore_mutes() -> void:
	for bus_name in _original_bus_mutes:
		_mute_bus(String(bus_name), bool(_original_bus_mutes[bus_name]))


func _process(delta: float) -> void:
	_tick += delta
	if _tick < 0.25:
		return
	_tick = 0.0
	_refresh()


func _refresh() -> void:
	if _state == null:
		return
	var current := get_tree().current_scene
	var scene := current.name if current != null else "none"
	var director := get_node_or_null("/root/SoundDirector")
	var ambience_on := false
	var location := "?"
	if director != null and director.has_method("get_ambience_debug_info"):
		var info: Dictionary = director.call("get_ambience_debug_info")
		ambience_on = bool(info.get("enabled", false))
		location = String(info.get("location", "?"))

	_state.text = "%s  |  СЦЕНА: %s  |  РЕЖИМ: %s\nОкружение: %s  |  Локация: %s" % [
		BUILD_MARKER, scene, _mode.to_upper(),
		"ВКЛ" if ambience_on else "ВЫКЛ", location,
	]
	var parts := PackedStringArray()
	for bus_name in AUDIO_BUSES:
		var idx := AudioServer.get_bus_index(bus_name)
		if idx < 0:
			parts.append(bus_name + ": НЕТ")
		elif AudioServer.is_bus_mute(idx):
			parts.append(bus_name + ": MUTE")
		else:
			parts.append("%s: %.0f dB" % [bus_name, AudioServer.get_bus_peak_volume_left_db(idx, 0)])
	_meters.text = "ПИКИ: " + "  |  ".join(parts)
	var active := {}
	_count_active_players(get_tree().root, active)
	_voices.text = "ИГРАЮТ: UI %d  •  Combat %d  •  Ambience %d  •  Master %d" % [
		int(active.get("UI", 0)), int(active.get("Combat", 0)),
		int(active.get("Ambience", 0)), int(active.get("Master", 0)),
	]


func _count_active_players(node: Node, counts: Dictionary) -> void:
	if node is AudioStreamPlayer:
		var player := node as AudioStreamPlayer
		if player.playing:
			var bus := String(player.bus)
			counts[bus] = int(counts.get(bus, 0)) + 1
	for child in node.get_children():
		_count_active_players(child, counts)


func _exit_tree() -> void:
	_restore_mutes()
