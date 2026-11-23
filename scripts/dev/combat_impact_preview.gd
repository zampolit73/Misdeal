extends Control

const QA := preload("res://scripts/dev/qa_hub_session.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const FIXED_SEED := 418
var battle: Control

func _ready() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	if not QA.ensure(self).available:
		push_error("Combat Impact preview requires an isolated QA profile.")
		return
	var layer := CanvasLayer.new()
	layer.layer = 53
	add_child(layer)
	var controls := HBoxContainer.new()
	controls.position = Vector2(425, 139)
	layer.add_child(controls)
	var modes := ButtonGroup.new()
	for enabled in [false, true]:
		var button := Button.new()
		button.text = "Impact V2" if enabled else "Classic"
		button.custom_minimum_size = Vector2(125, 28)
		button.toggle_mode = true
		button.button_group = modes
		button.button_pressed = enabled
		UI.apply_action_button(button, UI.BRONZE, false)
		controls.add_child(button)
		button.pressed.connect(load_fight.bind(enabled))
	var replay := Button.new()
	replay.text = "Повтор"
	replay.custom_minimum_size = Vector2(95, 28)
	UI.apply_action_button(replay, UI.BRONZE, false)
	controls.add_child(replay)
	replay.pressed.connect(func(): load_fight(battle.impact_v2_preview))
	load_fight(true)

func load_fight(enabled: bool) -> void:
	if is_instance_valid(battle):
		remove_child(battle)
		battle.queue_free()
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.recruit_companion("ranger", "Combat Impact QA")
	RunState.recruit_companion("mage", "Combat Impact QA")
	RunState.active_card_id = "grave_bell"
	RunState.select_encounter("res://resources/encounters/grave_bell.tres")
	seed(FIXED_SEED)
	battle = (load("res://scenes/battle/battle.tscn") as PackedScene).instantiate()
	battle.impact_v2_preview = enabled
	add_child(battle)
