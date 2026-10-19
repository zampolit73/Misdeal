extends Control

# D273 independent headless ordinary-deal Court release QA. No game runtime hooks.
const DRIVER := preload("res://scripts/dev/court_of_the_mute_d273_release_route_observer.gd")

func _ready() -> void:
	var watcher := DRIVER.new() as Node
	watcher.name = "D273CourtReleasedOrdinaryDealObserver"
	get_tree().root.call_deferred("add_child", watcher)
