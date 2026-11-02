extends SceneTree

# Headless scene test. Intentionally does not read or mutate the original RunState.
func _initialize() -> void:
	call_deferred("_verify")


func _verify() -> void:
	var packed := load("res://scenes/alternative/veil_table.tscn") as PackedScene
	if packed == null:
		push_error("ALTERNATIVE_OATH_SMOKE_FAIL: scene not found")
		quit(1)
		return
	var table := packed.instantiate() as Control
	if table == null:
		push_error("ALTERNATIVE_OATH_SMOKE_FAIL: wrong root type")
		quit(1)
		return
	root.add_child(table)
	var roles: Array = table.get("role_buttons")
	var valid: bool = roles.size() == 3 and bool(table.get("game").is_empty())
	if valid:
		(roles[0] as Button).pressed.emit()
		var state: Dictionary = table.get("game")
		valid = str(state.get("phase", "")) == "deal"
		valid = valid and (table.get("choices") as Array).size() == 2
		valid = valid and int(state["party"][0]["hp"]) == 58
	if valid:
		print("ALTERNATIVE_OATH_SMOKE_PASS")
		quit(0)
	else:
		push_error("ALTERNATIVE_OATH_SMOKE_FAIL: UI not initialized")
		quit(1)
