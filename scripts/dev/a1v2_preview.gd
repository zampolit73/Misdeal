extends Node
const P := preload("res://scripts/memory/memory_profile.gd")
var table: Control
func _ready() -> void:
	P.shared=P.new()
	show_count(0)
func show_count(count: int) -> void:
	if is_instance_valid(table):
		table.free()
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	P.shared.unlocked.clear()
	for index in range(count):
		P.shared.unlocked.append("SG%02d"%(index+1))
	table=load("res://scenes/table/table.tscn").instantiate()
	add_child(table)
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode in [KEY_F1,KEY_F2,KEY_F3]:
			show_count({KEY_F1:0,KEY_F2:7,KEY_F3:24}[event.keycode])
		if event.keycode==KEY_F4:
			RunState.active_card_id="bone_patrol"
			RunState.last_battle_won=true
			RunState.complete_active_card()
			table.get_node("MemoryTable").open_viewer()
