extends Control
const PROFILE := preload("res://scripts/battle/living_arena_profile.gd")
const QA_SESSION := preload("res://scripts/dev/qa_hub_session.gd")

@export var arena_id := "firing_square"
var battle: Control
func _ready() -> void:
	_initialize.call_deferred()

func _initialize() -> void:
	var session := QA_SESSION.ensure(self)
	if not session.available:
		push_error("Living Arenas preview requires an isolated QA profile.")
		return
	var roles: Array = ["knight"]
	if arena_id != "warden":
		roles.append_array(["ranger", "mage"])
	if session.last_entry.get("scene") == scene_file_path and session.last_entry.has("living_profile"):
		arena_id = session.last_entry.living_profile
		roles = session.last_options.get("roles", roles)
	RunState.reset_run()
	RunState.choose_protagonist(roles[0])
	for role: String in roles.slice(1):
		RunState.recruit_companion(role, "Living Arenas QA")
	var encounter_id := PROFILE.encounter_for(arena_id)
	RunState.active_card_id = encounter_id
	if arena_id == "warden":
		RunState.cards_resolved = 12
	RunState.select_encounter("res://resources/encounters/"+encounter_id+".tres")
	battle = load("res://scenes/battle/battle.tscn").instantiate()
	add_child(battle)
	var layer := CanvasLayer.new()
	layer.name = "LivingArenaControls"
	layer.layer = 20
	add_child(layer)
	var bar := HBoxContainer.new()
	bar.name = "Toolbar"
	bar.position = Vector2(455,139)
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
	var replay := Button.new()
	replay.text = "Повтор · F9"
	replay.pressed.connect(session.replay)
	bar.add_child(replay)

func replay_qa_battle() -> bool:
	return get_tree().reload_current_scene() == OK

func qa_toolbar_visible() -> bool:
	return is_instance_valid(battle) and battle.battle_finished
