extends RefCounted

const DATA := preload("res://assets/pixel/travel/batch_03/scenes.json")
const ROOT := "res://assets/pixel/travel/batch_03/"
const ROLES := ["knight", "ranger", "mage"]

static func scene_for(id: String) -> Dictionary:
	return DATA.data.get(id, {})

static func action_for(id: String, action: String, roles: Array) -> Dictionary:
	var scene := scene_for(id)
	var state: Dictionary = scene.get("states", {}).get(action, {})
	if state.is_empty() or roles.is_empty():
		return {}
	var seen := {}
	for role in roles:
		if role not in ROLES or seen.has(role):
			return {}
		seen[role] = true
	var change: String = state.party
	if id == "jack" and "ranger" not in roles:
		return {}
	if change.begins_with("+") and change != "+jack animal":
		if roles.size() < 2 or change.substr(1) not in roles:
			return {}
	if change.ends_with(" lost") and change.trim_suffix(" lost") in roles:
		return {}
	if action == "witnessless" and roles.size() != 1:
		return {}
	if action in ROLES and action not in roles:
		return {}
	return state
