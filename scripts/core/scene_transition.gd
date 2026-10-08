extends CanvasLayer

# Persistent transition layer. The next PackedScene is loaded while the old
# scene is still alive, then swapped manually under an already-rendered veil.
# This avoids SceneTree's empty-scene frame and keeps runtime WebP decoding
# hidden behind a stable frame.

const VEIL_COLOR := Color(0.006, 0.004, 0.009, 1.0)
const FADE_OUT_TIME := 0.10
const FADE_IN_TIME := 0.16

var _veil: ColorRect
var _busy := false


func _ready() -> void:
	layer = 128
	process_mode = Node.PROCESS_MODE_ALWAYS
	RenderingServer.set_default_clear_color(VEIL_COLOR)

	_veil = ColorRect.new()
	_veil.name = "SceneVeil"
	_veil.color = VEIL_COLOR
	_veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_veil.z_index = 4095
	add_child(_veil)

	_sync_veil_rect()
	get_viewport().size_changed.connect(_sync_veil_rect)

	_veil.modulate.a = 0.0
	_veil.visible = false


func change_to(scene_path: String) -> void:
	if _busy or scene_path.is_empty():
		return

	_busy = true

	# Block duplicate input immediately, but keep the current scene fully
	# visible while the next PackedScene is prepared in the background.
	_veil.visible = true
	_veil.modulate.a = 0.0
	_veil.mouse_filter = Control.MOUSE_FILTER_STOP
	_sync_veil_rect()

	var packed_scene: PackedScene = await _load_scene(scene_path)
	if packed_scene == null:
		_reset_veil()
		return

	# Instantiate before the blackout. _ready() does not run until the node is
	# added to the tree, so this removes another chunk of work from the swap.
	var next_scene: Node = packed_scene.instantiate()
	if next_scene == null:
		push_error("Could not instantiate scene: %s" % scene_path)
		_reset_veil()
		return

	var fade_out: Tween = create_tween()
	fade_out.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	fade_out.tween_property(_veil, "modulate:a", 1.0, FADE_OUT_TIME)
	await fade_out.finished

	# Ensure at least one completely covered frame reaches the renderer before
	# any scene-tree mutation or runtime image decoding can block the main loop.
	await RenderingServer.frame_post_draw

	var tree: SceneTree = get_tree()
	var old_scene: Node = tree.current_scene

	# Add the new scene while the old one still exists. There is never a frame
	# where the viewport has no scene beneath the persistent autoload layer.
	tree.root.add_child(next_scene)
	tree.current_scene = next_scene

	if old_scene != null and old_scene != next_scene:
		old_scene.queue_free()

	# Incoming _ready() work (including FileAccess/WebP decoding) runs while the
	# veil is fully opaque. Give layout/runtime art another frame to settle,
	# then wait for an actually rendered incoming frame before revealing it.
	await tree.process_frame
	await tree.process_frame
	await RenderingServer.frame_post_draw

	var fade_in: Tween = create_tween()
	fade_in.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	fade_in.tween_property(_veil, "modulate:a", 0.0, FADE_IN_TIME)
	await fade_in.finished

	_reset_veil()


func reload_current() -> void:
	var current: Node = get_tree().current_scene
	if current == null:
		return

	var scene_path: String = current.scene_file_path
	if scene_path.is_empty():
		return

	change_to(scene_path)


func _load_scene(scene_path: String) -> PackedScene:
	# Threaded loading keeps the outgoing scene on screen instead of freezing on
	# an empty viewport. Cached scenes may report ERR_BUSY; load_threaded_get()
	# still resolves them through the existing request/cache.
	var request_error: Error = ResourceLoader.load_threaded_request(
		scene_path,
		"PackedScene",
		true
	)

	if request_error != OK and request_error != ERR_BUSY:
		push_warning(
			"Threaded scene load request failed for '%s': %s. Falling back to cached/direct load."
			% [scene_path, error_string(request_error)]
		)
		return ResourceLoader.load(scene_path, "PackedScene") as PackedScene

	var progress: Array = []
	while true:
		var status: int = ResourceLoader.load_threaded_get_status(scene_path, progress)
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				await get_tree().process_frame
			ResourceLoader.THREAD_LOAD_LOADED:
				return ResourceLoader.load_threaded_get(scene_path) as PackedScene
			ResourceLoader.THREAD_LOAD_FAILED:
				push_error("Threaded scene load failed: %s" % scene_path)
				return null
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				# A cached resource may not have an active threaded request.
				return ResourceLoader.load(scene_path, "PackedScene") as PackedScene
			_:
				push_error("Unexpected threaded load state for: %s" % scene_path)
				return null

	return null


func _sync_veil_rect() -> void:
	if _veil == null:
		return
	_veil.position = Vector2.ZERO
	_veil.size = get_viewport().get_visible_rect().size


func _reset_veil() -> void:
	_veil.modulate.a = 0.0
	_veil.visible = false
	_veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_busy = false
