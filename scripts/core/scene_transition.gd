extends CanvasLayer

# Persistent scene-change veil. It stays in the autoload layer while the
# current scene is replaced, so heavyweight runtime art decoding never exposes
# the viewport clear color between screens.

const VEIL_COLOR := Color(0.006, 0.004, 0.009, 1.0)
const FADE_OUT_TIME := 0.10
const FADE_IN_TIME := 0.16

var _veil: ColorRect
var _busy := false


func _ready() -> void:
	layer = 10000
	process_mode = Node.PROCESS_MODE_ALWAYS

	_veil = ColorRect.new()
	_veil.name = "SceneVeil"
	_veil.color = VEIL_COLOR
	_veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_veil)
	_veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_veil.modulate.a = 0.0
	_veil.visible = false


func change_to(scene_path: String) -> void:
	if _busy or scene_path.is_empty():
		return

	_busy = true
	_veil.visible = true
	_veil.mouse_filter = Control.MOUSE_FILTER_STOP

	var fade_out := create_tween()
	fade_out.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	fade_out.tween_property(_veil, "modulate:a", 1.0, FADE_OUT_TIME)
	await fade_out.finished

	var error := get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Could not change scene to '%s': %s" % [scene_path, error_string(error)])
		_veil.modulate.a = 0.0
		_veil.visible = false
		_veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_busy = false
		return

	# Give the incoming scene two frames to finish _ready() work and runtime
	# texture assignment while the persistent veil still covers the viewport.
	await get_tree().process_frame
	await get_tree().process_frame

	var fade_in := create_tween()
	fade_in.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	fade_in.tween_property(_veil, "modulate:a", 0.0, FADE_IN_TIME)
	await fade_in.finished

	_veil.visible = false
	_veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_busy = false
