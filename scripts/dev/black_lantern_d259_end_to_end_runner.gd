extends Control

# Persistent monitor lives under /root, not current_scene, for real changes.
const DRIVER := preload("res://scripts/dev/black_lantern_d259_end_to_end_observer.gd")

func _ready() -> void:
	var watcher := DRIVER.new() as Node
	watcher.name = "BlackLanternEndToEndObserver"
	get_tree().root.call_deferred("add_child", watcher)
