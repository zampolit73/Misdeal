extends CanvasLayer
## Only confirmed profile commits feed this queue. No gameplay/input ownership.
const ARCHIVE := preload("res://scripts/core/wizard_archive.gd")
const CATALOG := preload("res://scripts/core/achievement_catalog.gd")
const UI := preload("res://scripts/ui/wizard_reliquary.gd")

var _archive: RefCounted
var _queue: Array[String] = []
var _panel: Panel
var _heading: Label
var _names: Label
var _timer: Timer


func _ready() -> void:
	layer = 40
	process_mode = Node.PROCESS_MODE_ALWAYS
	var surface := Control.new()
	surface.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(surface)
	_panel = UI.VISUAL.plaque(surface, Rect2(22, 142, 398, 118))
	_panel.name = "AchievementToast"
	_heading = UI.caption(_panel, Rect2(12, 8, 374, 25), "", 16, UI.GOLD)
	_names = UI.caption(_panel, Rect2(12, 34, 374, 75), "", 18, UI.COPY)
	_panel.hide()
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.timeout.connect(_show_next)
	bind_archive(ARCHIVE.instance())

func _process(_delta: float) -> void:
	# A scene swap's veil sits above the toast. Its visible-time budget
	# must not be consumed while the next scene is loading.
	if _timer != null and not _timer.is_stopped():
		var transition := get_tree().root.get_node_or_null("SceneTransition")
		_timer.paused = transition != null and bool(transition.get("_busy"))


func bind_archive(archive: RefCounted) -> void:
	if _archive != null and _archive.achievements_unlocked.is_connected(enqueue):
		_archive.achievements_unlocked.disconnect(enqueue)
	_archive = archive
	_archive.achievements_unlocked.connect(enqueue)


func enqueue(ids: Array[String]) -> void:
	_queue.append_array(ids)
	if _timer.is_stopped():
		_show_next()


func _show_next() -> void:
	if _queue.is_empty():
		_panel.hide()
		return
	var batch: Array[String] = []
	while not _queue.is_empty() and batch.size() < 3:
		batch.append(CATALOG.title(_queue.pop_front()))
	_heading.text = "ДОСТИЖЕНИЕ ОТКРЫТО" if batch.size() == 1 else "ДОСТИЖЕНИЯ ОТКРЫТЫ · %d" % batch.size()
	_names.text = "\n".join(batch)
	_panel.show()
	_panel.modulate.a = 0.0
	create_tween().tween_property(_panel, "modulate:a", 1.0, 0.16)
	_timer.start(3.4)
