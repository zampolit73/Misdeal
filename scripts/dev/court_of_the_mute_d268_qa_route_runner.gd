extends Control

# D268 unreleased card #39 end-to-end QA driver; never shipped as menu route.
const DRIVER := preload("res://scripts/dev/court_of_the_mute_d268_qa_route_observer.gd")

func _ready() -> void:
	var observer := DRIVER.new() as Node
	observer.name = "D268CourtQaRouteObserver"
	get_tree().root.call_deferred("add_child", observer)
