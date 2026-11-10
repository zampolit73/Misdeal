extends Control
@export_enum("firing_square", "black_crossing", "threadbare_theatre") var arena_id := "firing_square"
var battle: Control
func _ready() -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.recruit_companion("ranger", "Living Arenas QA")
	RunState.recruit_companion("mage", "Living Arenas QA")
	RunState.active_card_id = arena_id
	RunState.select_encounter("res://resources/encounters/"+arena_id+".tres")
	battle = load("res://scenes/battle/battle.tscn").instantiate()
	add_child(battle)
	var layer := CanvasLayer.new()
	layer.layer = 20
	add_child(layer)
	var bar := HBoxContainer.new()
	bar.position = Vector2(30,684)
	bar.add_theme_constant_override("separation",12)
	layer.add_child(bar)
	var enabled := CheckButton.new()
	enabled.text = "Живой фон"
	enabled.button_pressed = true
	enabled.toggled.connect(func(value: bool): battle.battle_backdrop.set_living_enabled(value))
	bar.add_child(enabled)
	var pause := CheckButton.new()
	pause.text = "Пауза фона"
	pause.toggled.connect(func(value: bool): battle.battle_backdrop.set_living_paused(value))
	bar.add_child(pause)
	var info := Label.new()
	info.text = "F6 / "+arena_id+" · БОЙ — настоящий бой · ESC — игровая пауза"
	bar.add_child(info)
