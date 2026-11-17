extends CanvasLayer
## Exists only after launching the developer hub. No project autoload or player-menu changes.
const HUB := "res://scenes/dev/qa_hub.tscn"
const SAVE := preload("res://scripts/core/run_save_service.gd")
const MEMORY := preload("res://scripts/memory/memory_profile.gd")
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
var original_save: RefCounted
var original_memory: RefCounted
var original_state: Dictionary = {}
var state: Node
var sandbox := ""
var last_entry: Dictionary = {}
var last_options: Dictionary = {}
var hub_group := "ВСЁ"
var hub_query := ""
var hub_selected := ""
var navigating := false
var panel: HBoxContainer
var hidden_panel := false
var error_message := ""
var available := false

static func ensure(owner: Node) -> Node:
	var existing := owner.get_tree().root.get_node_or_null("QAHubSession")
	if existing!=null: return existing
	var session := load("res://scripts/dev/qa_hub_session.gd").new() as CanvasLayer
	session.name="QAHubSession"
	owner.get_tree().root.add_child(session)
	return session

func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	layer=300
	state=get_node_or_null("/root/RunState")
	if state==null:
		state=load("res://scripts/core/run_state.gd").new()
		state.name="RunState"
		get_tree().root.add_child(state)
	for key in SAVE.FIELDS:
		var value: Variant=state.get(key)
		original_state[key]=value.duplicate(true) if value is Array or value is Dictionary else value
	original_save=SAVE.shared
	original_memory=MEMORY.shared
	sandbox="user://qa_hub/session_%s_%s" % [OS.get_process_id(),Time.get_ticks_usec()]
	if DirAccess.make_dir_recursive_absolute(sandbox)!=OK:
		error_message="Не удалось создать отдельную папку QA-сохранений."
		return
	SAVE.shared=SAVE.new()
	SAVE.shared.path=sandbox+"/current_run.json"
	MEMORY.shared=MEMORY.new()
	MEMORY.shared.path=sandbox+"/memory_glass.json"
	available=true
	var holder := Control.new()
	holder.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	holder.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	panel=HBoxContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	panel.position=Vector2(-310,-42)
	panel.size=Vector2(298,32)
	holder.add_child(panel)
	for row in [["ПОВТОР · F9",replay],["В ХАБ · F10",return_to_hub]]:
		var button := Button.new()
		button.text=row[0]
		button.custom_minimum_size=Vector2(145,30)
		button.add_theme_font_size_override("font_size",12)
		button.tooltip_text="F11 — скрыть QA-панель; F9/F10 продолжают работать."
		DS3.apply_action(button,false)
		button.pressed.connect(row[1])
		panel.add_child(button)

func _process(_delta: float) -> void:
	if panel!=null:
		panel.visible=not hidden_panel and get_tree().current_scene!=null and get_tree().current_scene.scene_file_path!=HUB

func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo: return
	match event.keycode:
		KEY_F10:
			get_viewport().set_input_as_handled()
			return_to_hub()
		KEY_F9:
			get_viewport().set_input_as_handled()
			replay()
		KEY_F11:
			get_viewport().set_input_as_handled()
			hidden_panel=not hidden_panel

func prepare(entry: Dictionary, options: Dictionary) -> bool:
	error_message=""
	if not sandbox.is_empty() and SAVE.shared!=null: SAVE.shared.path=sandbox+"/current_run.json"
	var prep: String=entry.get("prep","")
	if prep.is_empty(): return true
	var roles: Array=options.get("roles",["knight","ranger","mage"])
	state.reset_run()
	if roles.is_empty() or not state.choose_protagonist(roles[0]): return false
	for role in roles.slice(1): state.recruit_companion(role,"QA Hub")
	if not bool(options.get("recruitment",true)):
		for role in ["knight","ranger","mage"]:
			if role not in roles: state.lose_companion(role,"QA Hub: вариант без найма")
	state.gold=int(options.get("gold",200))
	if bool(options.get("upgrades",false)):
		for role in roles:
			var id: String=state.get_next_available_hero_upgrade_id(role)
			if not id.is_empty(): state.add_hero_upgrade(id)
	state.wizard_wager_slots.clear()
	state.wizard_mark_slots.clear()
	state.wizard_meddling_slots.clear()
	state.fate_spread_last_milestone_shown=12
	if prep=="graveyard": state.select_encounter("res://resources/encounters/graveyard_ambush.tres")
	if prep.begins_with("reward_"):
		state.active_card_id="bone_patrol"
		state.last_battle_won=true
		if prep=="reward_loot": state.claimed_upgrade_tiers.assign([0,1,2])
	if prep.begins_with("fate"):
		state.cards_resolved=4 if prep=="fate4" else 12
		state.resolved_card_ids.assign(state.ACT1_CARD_IDS.slice(0,state.cards_resolved))
	if prep.begins_with("end_"):
		state.cards_resolved=12
		state.boss_defeated=prep=="end_win"
		state.run_failed=prep=="end_loss"
		state.run_end_reason="Проверка итогового экрана в QA Hub."
	if prep=="card":
		var id: String=entry.card_id
		var card: Resource=state.get_card(id)
		state.cards_resolved=12 if id=="bone_warden" else int(card.tier)*4
		state.current_offer_ids.assign([id,"whispering_well" if id=="bone_patrol" else "bone_patrol"])
		if not state.choose_card(id):
			error_message="Карта недоступна при этом составе. Для Джека нужен Следопыт."
			return false
	return true

func launch_entry(entry: Dictionary, options: Dictionary) -> bool:
	if navigating or not available: return false
	if not ResourceLoader.exists(str(entry.scene),"PackedScene"): return false
	if not prepare(entry,options): return false
	last_entry=entry.duplicate(true)
	last_options=options.duplicate(true)
	get_tree().paused=false
	return get_tree().change_scene_to_file(entry.scene)==OK

func _settle_transition() -> bool:
	var run_menu := get_tree().root.get_node_or_null("RunMenu")
	if run_menu!=null and run_menu.has_method("close_menu"): run_menu.close_menu()
	get_tree().paused=false
	var travel := get_tree().root.get_node_or_null("TravelTransition")
	if travel!=null and travel.has_method("finish"): travel.finish()
	var deadline := Time.get_ticks_msec()+10000
	while Time.get_ticks_msec()<deadline:
		var transition := get_tree().root.get_node_or_null("SceneTransition")
		var busy: bool=transition!=null and bool(transition.get("_busy"))
		if not busy and not get_tree().root.has_node("TravelTransition"): return true
		await get_tree().process_frame
	error_message="Переход ещё не завершился. Повторите F10 через несколько секунд."
	return false

func return_to_hub() -> void:
	if navigating: return
	navigating=true
	if await _settle_transition(): get_tree().change_scene_to_file(HUB)
	navigating=false

func replay() -> void:
	if navigating or last_entry.is_empty(): return
	navigating=true
	if not await _settle_transition():
		navigating=false
		return
	navigating=false
	launch_entry(last_entry,last_options)

func _exit_tree() -> void:
	SAVE.shared=original_save
	MEMORY.shared=original_memory
	if is_instance_valid(state):
		for key in original_state: state.set(key,original_state[key])
