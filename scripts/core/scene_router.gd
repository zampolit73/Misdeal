extends RefCounted

# Scene navigation must not depend on the editor having already refreshed a
# newly-added autoload entry from project.godot. Use the registered singleton
# when available; otherwise create the same persistent transition node at
# runtime so scripts still parse and transitions stay covered.

const TRANSITION_SCRIPT := preload("res://scripts/core/scene_transition.gd")


static func change_to(context: Node, scene_path: String) -> void:
	var transition: Node = _get_transition(context)
	if transition == null:
		push_error("SceneRouter could not create the transition layer.")
		context.get_tree().change_scene_to_file(scene_path)
		return
	transition.call("change_to", scene_path)


static func reload_current(context: Node) -> void:
	var transition := _get_transition(context)
	if transition == null:
		push_error("SceneRouter could not create the transition layer.")
		context.get_tree().reload_current_scene()
		return
	transition.call("reload_current")


static func _get_transition(context: Node) -> Node:
	if context == null or context.get_tree() == null:
		return null

	var root: Window = context.get_tree().root
	var transition: Node = root.get_node_or_null("SceneTransition")
	if transition != null:
		return transition

	transition = root.get_node_or_null("SceneTransitionRuntime")
	if transition != null:
		return transition

	transition = TRANSITION_SCRIPT.new() as Node
	transition.name = "SceneTransitionRuntime"
	root.add_child(transition)
	return transition


static func after_resolution(context: Node, travel_context: Dictionary) -> void:
	const CATALOG = preload("res://scripts/travel/travel_catalog.gd")
	if context.has_meta("travel_navigation_started"): return
	context.set_meta("travel_navigation_started",true)
	if travel_context.is_empty() or not CATALOG.is_enabled():
		change_to(context,"res://scenes/table/table.tscn")
		return
	var tree := context.get_tree()
	var packed := load("res://scenes/travel/travel_transition.tscn") as PackedScene
	if packed == null:
		change_to(context,"res://scenes/table/table.tscn")
		return
	var view := packed.instantiate()
	view.context = travel_context.duplicate(true)
	var transition := _get_transition(context)
	if transition.has_method("present_overlay"):
		await transition.call("present_overlay",view)
	else:
		tree.root.add_child(view)
	if view.available: await view.finished
	if transition.has_method("dismiss_presentation_on_swap"):
		transition.call("dismiss_presentation_on_swap",view)
	change_to(context,"res://scenes/table/table.tscn")
	while is_instance_valid(transition) and transition.get("_busy"):
		await tree.process_frame
	if is_instance_valid(view): view.queue_free()
