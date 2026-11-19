extends Control
const PROFILE := preload("res://scripts/battle/living_arena_profile.gd")
const QA_SESSION := preload("res://scripts/dev/qa_hub_session.gd")

@export_enum("firing_square", "black_crossing", "threadbare_theatre", "last_bell", "ossuary_gate", "warden") var arena_id := "firing_square"
var battle: Control
func _ready() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	var session := QA_SESSION.ensure(self)
	if not session.available:
		push_error("Living Arenas preview requires an isolated QA profile.")
		return
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	if arena_id != "warden":
		RunState.recruit_companion("ranger", "Living Arenas QA")
		RunState.recruit_companion("mage", "Living Arenas QA")
	var encounter_id := PROFILE.encounter_for(arena_id)
	RunState.active_card_id = encounter_id
	if arena_id == "warden":
		RunState.cards_resolved = 12
	RunState.select_encounter("res://resources/encounters/"+encounter_id+".tres")
	battle = load("res://scenes/battle/battle.tscn").instantiate()
	add_child(battle)
	var layer := CanvasLayer.new()
	layer.layer = 20
	add_child(layer)
	var bar := HBoxContainer.new()
	bar.position = Vector2(42,126) if arena_id in PROFILE.V2_ARENAS else Vector2(30,684)
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
	if arena_id == "warden":
		var phase := CheckButton.new()
		phase.text = "Фаза II · только фон"
		phase.toggled.connect(func(value: bool): battle.battle_backdrop.set_living_phase_two(value))
		battle.combat_beginning.connect(func():
			phase.disabled = true
			phase.set_pressed_no_signal(false)
			battle.battle_backdrop.set_living_phase_two(false))
		bar.add_child(phase)
	if arena_id in PROFILE.V2_ARENAS:
		var replay := Button.new()
		replay.text = "Повтор"
		replay.pressed.connect(func(): get_tree().reload_current_scene())
		bar.add_child(replay)

func qa_toolbar_visible() -> bool:
	return is_instance_valid(battle) and battle.battle_finished
