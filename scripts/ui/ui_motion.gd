extends Node

# Opt-in presentation only. Never emits gameplay signals or delays actions.
const ENTRANCE_KEY := &"d417_entrance"
var _button: Button
var _tween: Tween
var _rest_scale := Vector2.ONE
var _rest_color := Color.WHITE
var _held := false

static func bind_button(button: Button) -> void:
	if button.has_node("_D417ButtonMotion"):
		return
	var feedback := (load("res://scripts/ui/ui_motion.gd") as Script).new() as Node
	feedback.name = "_D417ButtonMotion"
	feedback.set("_button", button)
	button.add_child(feedback)

static func replace_tween(control: Control, key: StringName) -> Tween:
	stop(control, key)
	var tween := control.create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ignore_time_scale(true)
	control.set_meta(key, tween)
	return tween

static func stop(control: Control, key: StringName = ENTRANCE_KEY) -> void:
	if not control.has_meta(key):
		return
	var previous = control.get_meta(key)
	if previous is Tween and previous.is_valid():
		previous.kill()
	if control.has_meta(key):
		control.remove_meta(key)

static func reveal(panel: Control, scrim: CanvasItem = null) -> void:
	var home := panel.position
	panel.position = home + Vector2(0, 10)
	# Render a barely visible preparation frame before starting the clock.
	# Otherwise cold texture/font work can consume the whole entrance tween.
	panel.modulate.a = 0.001
	var tween := replace_tween(panel, ENTRANCE_KEY)
	tween.pause()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "position", home, 0.22)
	tween.tween_property(panel, "modulate:a", 1.0, 0.18)
	if scrim != null:
		scrim.modulate.a = 0.001
		tween.tween_property(scrim, "modulate:a", 1.0, 0.18)
	if DisplayServer.get_name() == "headless":
		await panel.get_tree().process_frame
	else:
		await RenderingServer.frame_post_draw
	if is_instance_valid(panel) and tween.is_valid():
		tween.play()

func _ready() -> void:
	_rest_scale = _button.scale
	_rest_color = _button.self_modulate
	_pivot()
	_button.resized.connect(_pivot)
	_button.mouse_entered.connect(_refresh)
	_button.mouse_exited.connect(_refresh)
	_button.focus_entered.connect(_refresh)
	_button.focus_exited.connect(_refresh)
	_button.button_down.connect(_down)
	_button.button_up.connect(_up)

func _pivot() -> void:
	_button.pivot_offset = _button.size * 0.5

func _process(_delta: float) -> void:
	if _button.disabled and (_held or _button.scale != _rest_scale or _button.self_modulate != _rest_color):
		if _tween != null and _tween.is_valid():
			_tween.kill()
		_held = false
		_button.scale = _rest_scale
		_button.self_modulate = _rest_color

func _down() -> void:
	if _button.disabled:
		return
	_held = true
	_refresh()

func _up() -> void:
	_held = false
	_refresh()

func _refresh() -> void:
	if _button.disabled:
		return
	if _tween != null and _tween.is_valid():
		_tween.kill()
	var hot := _button.is_hovered() or _button.has_focus()
	_tween = _button.create_tween()
	_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_tween.set_ignore_time_scale(true)
	_tween.set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(_button, "scale", _rest_scale * (0.975 if _held else (1.012 if hot else 1.0)), 0.07 if _held else 0.13)
	_tween.tween_property(_button, "self_modulate", _rest_color * (Color(0.90, 0.87, 0.83) if _held else Color.WHITE), 0.07 if _held else 0.13)
