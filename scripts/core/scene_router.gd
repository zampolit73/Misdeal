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
