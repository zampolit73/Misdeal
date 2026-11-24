extends Control
const PROFILE := preload("res://scripts/memory/memory_profile.gd")
const VIEWER := preload("res://scripts/memory/memory_viewer.gd")
const NAVIGATION := preload("res://scripts/table/table_navigation_v5.gd")
var viewer: Control
var button: Button
var _glass: TextureRect
var _profile := PROFILE.instance()
var _displayed_count := -1
var _pulse: Tween

func _ready() -> void:
	name = "MemoryTable"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	button = Button.new()
	button.name = "MemoryWindow"
	button.pressed.connect(open_viewer)
	add_child(button)
	NAVIGATION.apply(button, "memory")
	_glass = button.get_node("GlassLight")
	_refresh_progress()
	# Narrow architectural glints, confined to background beside the hood.
	for x in [310,950]:
		var aperture := Control.new()
		aperture.position = Vector2(x,140)
		aperture.size = Vector2(14,105)
		aperture.clip_contents = true
		aperture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(aperture)
		var strip := TextureRect.new()
		strip.position = Vector2(0 if x == 310 else -236,-50)
		strip.size = Vector2(250,312.4)
		strip.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		strip.texture = load("res://assets/story/a1v2/approved_vitrazh_memory.png") as Texture2D
		var strength: float = 0.08 + 0.22*_profile.unlocked.size()/24.0
		strip.modulate = Color(0.3,0.3,0.3,strength)
		strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		aperture.add_child(strip)


func _process(_delta: float) -> void:
	if _displayed_count != _profile.unlocked.size() or _profile.pending > 0:
		_refresh_progress()


func _refresh_progress() -> void:
	_displayed_count = _profile.unlocked.size()
	var caption := NAVIGATION.LAYOUT.data.objects.memory.label as String
	var label := button.get_node("Caption") as Label
	label.text = caption.replace("{found}", str(_displayed_count))
	button.accessibility_name = label.text
	var strength := clampf(_displayed_count / 24.0, 0.0, 1.0)
	if _pulse != null:
		_pulse.kill()
	_glass.modulate.a = strength
	if _profile.pending > 0:
		_profile.pending = 0
		button.tooltip_text = "Открыто новое воспоминание"
		_pulse = create_tween()
		_pulse.tween_property(_glass, "modulate", Color(1.30, 1.15, 1.0, minf(1.0, strength + 0.62)), 0.13)
		_pulse.tween_property(_glass, "modulate", Color(1.0, 1.0, 1.0, strength), 0.69)

func open_viewer() -> void:
	var table := get_parent()
	if not table.can_open_table_modal():
		return
	viewer = VIEWER.new()
	button.tooltip_text = ""
	table.mount_table_modal(viewer, button)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_M:
		open_viewer()
		get_viewport().set_input_as_handled()
