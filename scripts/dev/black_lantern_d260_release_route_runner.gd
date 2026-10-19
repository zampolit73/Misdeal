extends Control

# Headless driver only; not part of shipped game navigation.
const DRIVER := preload("res://scripts/dev/black_lantern_d260_release_route_observer.gd")

func _ready() -> void:
	var watcher := DRIVER.new() as Node
	watcher.name = "D260ReleaseRouteObserver"
	get_tree().root.call_deferred("add_child", watcher)
