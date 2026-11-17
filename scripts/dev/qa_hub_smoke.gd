extends SceneTree

# OPT4 native self-test: scene launcher is still completely outside the game flow.
const HUB := preload("res://scenes/dev/qa_hub.tscn")
const REQUIRED_GROUPS := ["ИГРА", "КАРТЫ", "СОБЫТИЯ", "TRAVEL", "БОЙ", "АНИМАЦИИ", "ИНТЕРФЕЙС", "АРХИВ"]

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var hub := HUB.instantiate() as Control
	if hub == null:
		_fail("QA Hub scene is not a Control")
		return
	root.add_child(hub)
	await process_frame
	if not hub.has_method("get_entries"):
		_fail("QA Hub script did not compile/load; check GDScript errors")
		return
	var entries: Array = hub.get_entries()
	if entries.size() < 70:
		_fail("QA Hub lost its authored preview entries")
		return
	var groups: Dictionary = {}
	for entry in entries:
		groups[entry["group"]] = true
		var file_path: String = entry["scene"]
		if not ResourceLoader.exists(file_path, "PackedScene"):
			_fail("QA Hub points to missing scene: " + file_path)
			return
	for required in REQUIRED_GROUPS:
		if not groups.has(required):
			_fail("QA Hub category missing: " + required)
			return
	if hub.get_node_or_null("Categories") == null or hub.get_node_or_null("DetailPanel/LaunchButton") == null:
		_fail("QA Hub navigation structure missing")
		return
	hub.call("_show_group", "БОЙ")
	await process_frame
	var list := hub.get_node("ScenePanel/SceneScroll/SceneList") as VBoxContainer
	if list.get_child_count() < 3:
		_fail("QA Hub battle category is not populated")
		return
	hub.call("_show_group", "ВСЁ")
	await process_frame
	if list.get_child_count() != hub.get_visible_entries().size():
		_fail("QA Hub current list does not match filtered entries")
		return
	hub.get_node("Search").text="Batch 02"
	hub.call("_show_group","ВСЁ")
	await process_frame
	if hub.get_visible_entries().size()!=1:
		_fail("QA Hub search must find the complete Batch02 preview")
		return
	print("OPT4_QA_HUB_PASS: ", entries.size(), " live F6 routes; all categories, paths and controls valid")
	hub.queue_free()
	await process_frame
	quit(0)

func _fail(message: String) -> void:
	push_error("OPT4_QA_HUB_FAIL: " + message)
	quit(1)
