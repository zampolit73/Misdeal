extends Control
const CATALOG := preload("res://scripts/travel/travel_catalog.gd")
func _ready() -> void:
	var view: CanvasLayer = load("res://scenes/travel/travel_transition.tscn").instantiate()
	view.context = CATALOG.context_for("borrowed_boots","passed",["knight","ranger","mage"])
	add_child(view)
	view.finished.connect(func(): view.queue_free(); get_tree().reload_current_scene())
