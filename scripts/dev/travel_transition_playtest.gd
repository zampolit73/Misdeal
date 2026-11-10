extends Control
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
var roles: Array[String] = ["knight","ranger","mage"]
var view: CanvasLayer
var help_label: Label
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var help_layer := CanvasLayer.new()
	help_layer.layer = 200
	add_child(help_layer)
	help_label = Label.new()
	help_label.position = Vector2(52,68)
	help_label.add_theme_font_size_override("font_size",12)
	help_layer.add_child(help_label)
	_replay()
func _replay() -> void:
	get_tree().paused = false
	if is_instance_valid(view): view.queue_free()
	view = load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context = CATALOG.context_for("borrowed_boots","passed",roles)
	add_child(view)
	view.finished.connect(func(): _replay.call_deferred())
	_update_help()
func _update_help() -> void:
	help_label.text = "F6 · 1 — рыцарь · 2 — следопыт и маг · 3 — отряд · P — пауза · R — повтор" + (" · ПАУЗА" if get_tree().paused else "")
func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo: return
	match event.keycode:
		KEY_1: roles.assign(["knight"]); _replay()
		KEY_2: roles.assign(["ranger","mage"]); _replay()
		KEY_3: roles.assign(["knight","ranger","mage"]); _replay()
		KEY_R: _replay()
		KEY_P:
			get_tree().paused = not get_tree().paused
			_update_help()
