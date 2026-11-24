extends Control

# F6-only fixture. Uses the real Table button handler and dossier, not a mockup.
func _ready() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.recruit_companion("ranger", "D413 preview")
	RunState.recruit_companion("mage", "D413 preview")
	RunState.add_hero_upgrade("knight_executioner")
	RunState.add_artifact("dead_mans_shield")
	var table := load("res://scenes/table/table.tscn").instantiate() as Control
	add_child(table)
	while not table.can_open_table_modal():
		await get_tree().process_frame
	table.call("_toggle_squad_status")
