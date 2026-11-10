extends GutTest
const SAVE := preload("res://scripts/core/run_save_service.gd")
const MEMORY := preload("res://scripts/memory/memory_profile.gd")
var service: RefCounted
func before_each() -> void:
	service=SAVE.new()
	SAVE.shared=service
	MEMORY.shared=MEMORY.new()
	RunState.reset_run()
	RunState.choose_protagonist("knight")
func after_each() -> void:
	SAVE.shared=null
	MEMORY.shared=null
func test_all_authored_fields_are_audited() -> void:
	var names:=[]
	for item in RunState.get_script().get_script_property_list():
		if item.usage & PROPERTY_USAGE_SCRIPT_VARIABLE: names.append(item.name)
	assert_eq(names.size(),SAVE.FIELDS.size())
	for key in names: assert_has(SAVE.FIELDS,key)
func test_roundtrip_all_roles_and_no_partial_corrupt_load() -> void:
	for role in ["knight","ranger","mage"]:
		RunState.reset_run()
		RunState.choose_protagonist(role)
		RunState.get_offer_cards()
		RunState.gold=123
		RunState.event_outcomes["jack"]="recruited"
		RunState.wizard_debt_active=true
		var data: Dictionary=service.snapshot(RunState)
		assert_true(service.validate(data,RunState))
		RunState.gold=999
		assert_true(service.apply_slot(RunState,data))
		assert_eq(RunState.gold,123)
		assert_eq(RunState.current_offer_ids,data.state.current_offer_ids)
		assert_eq(RunState.remaining_card_ids,data.state.remaining_card_ids)
		var broken: Dictionary=data.duplicate(true)
		broken.state.current_offer_ids.assign(["not_a_card"])
		assert_false(service.apply_slot(RunState,broken))
		assert_eq(RunState.gold,123)
func test_disk_backup_corruption_completion_and_memory_rewind() -> void:
	service.path="res://.tmp/run_save_test.json"
	for suffix in ["",".bak",".tmp"]:
		if FileAccess.file_exists(service.path+suffix): DirAccess.remove_absolute(service.path+suffix)
	RunState.get_offer_cards()
	var before: Dictionary=service.snapshot(RunState)
	assert_true(service.write_slot(RunState))
	RunState.gold=15
	assert_true(service.write_slot(RunState))
	assert_true(FileAccess.file_exists(service.path+".bak"))
	var memory:=MEMORY.instance()
	memory.resolved("knight",1,{},false,"0:bone_patrol")
	var count: int=memory.unlocked.size()
	assert_true(service.apply_slot(RunState,before))
	memory.resolved("knight",1,{},false,"0:bone_patrol")
	assert_eq(memory.unlocked.size(),count)
	RunState.run_failed=true
	assert_true(service.write_slot(RunState))
	assert_true(service.read_slot(RunState).finished)
	assert_false(service.apply_slot(RunState,service.read_slot(RunState)))
	var file:=FileAccess.open(service.path,FileAccess.WRITE)
	file.store_string("broken")
	file.close()
	assert_true(service.read_slot(RunState).is_empty())
	assert_false(service.write_slot(RunState))
	assert_eq(FileAccess.get_file_as_string(service.path),"broken")

func test_rich_state_and_new_run_preserve_collection() -> void:
	RunState.recruit_companion("ranger","save QA")
	RunState.recruit_companion("mage","save QA")
	RunState.add_artifact("dead_mans_shield")
	RunState.add_hero_upgrade("knight_iron_oath")
	RunState.held_card_id="moon_seal"
	RunState.held_card_return_at=4
	RunState.fate_hold_used=true
	RunState.wizard_wagers_accepted=2
	RunState.wizard_meddling_pending=true
	RunState.castle_memory_facts["promise_heard"]="moon_seal"
	var saved: Dictionary=service.snapshot(RunState)
	assert_true(service.validate(saved,RunState))
	RunState.reset_run()
	assert_true(service.apply_slot(RunState,saved))
	for key in SAVE.FIELDS: assert_eq(RunState.get(key),saved.state[key],key)
	MEMORY.instance().unlocked.assign(["SG01","SG02"])
	RunState.reset_run()
	assert_eq(MEMORY.instance().unlocked.size(),2)

func test_reward_checkpoint_and_failed_battle_return() -> void:
	RunState.get_offer_cards()
	var table: Dictionary=service.snapshot(RunState)
	RunState.active_card_id="bone_patrol"
	RunState.last_battle_won=false
	assert_true(service.apply_slot(RunState,table))
	assert_eq(RunState.active_card_id,"")
	assert_eq(RunState.current_offer_ids,table.state.current_offer_ids)
	RunState.active_card_id="death_wager"
	RunState.last_battle_won=true
	RunState.pending_wager_artifact_id="dead_mans_shield"
	var reward: Dictionary=service.snapshot(RunState,SAVE.REWARD,"death_wager")
	assert_true(service.validate(reward,RunState))
	RunState.reset_run()
	assert_true(service.apply_slot(RunState,reward))
	assert_eq(RunState.pending_wager_artifact_id,"dead_mans_shield")
	assert_eq(service.resume_phase,"death_wager")

func test_cancel_new_game_confirmation_changes_nothing() -> void:
	service.path="res://.tmp/run_save_cancel.json"
	if FileAccess.file_exists(service.path): DirAccess.remove_absolute(service.path)
	RunState.get_offer_cards()
	assert_true(service.write_slot(RunState))
	var original := FileAccess.get_file_as_bytes(service.path)
	var gold := RunState.gold
	var screen := load("res://scenes/main/main.tscn").instantiate() as Control
	add_child_autofree(screen)
	screen.call("_on_start_button_pressed")
	var found := false
	for child in screen.get_children():
		if child is ConfirmationDialog:
			found=true
			child.canceled.emit()
			child.hide()
	assert_true(found)
	assert_eq(FileAccess.get_file_as_bytes(service.path),original)
	assert_eq(RunState.gold,gold)

func test_pause_cannot_interrupt_scene_swap() -> void:
	var menu := get_tree().root.get_node("RunMenu")
	var transition := get_tree().root.get_node("SceneTransition")
	transition.set("_busy",true)
	var event := InputEventKey.new()
	event.keycode=KEY_ESCAPE
	event.pressed=true
	menu.call("_unhandled_key_input",event)
	assert_false(is_instance_valid(menu.get("menu")))
	assert_false(get_tree().paused)
	transition.set("_busy",false)

func test_explicit_new_game_clears_memory_and_archives_it() -> void:
	var memory:=MEMORY.instance()
	memory.path="res://.tmp/new_game_memory.json"
	memory.unlocked.assign(["SG01","SG13"])
	memory.run_ledger["old"]={"earned":2,"seen":{"0:bone_patrol":true}}
	assert_true(memory.save_profile())
	service.path="res://.tmp/new_game_run.json"
	if FileAccess.file_exists(service.path): DirAccess.remove_absolute(service.path)
	assert_true(service.write_slot(RunState))
	assert_true(service.prepare_new_game())
	assert_true(memory.unlocked.is_empty())
	assert_true(memory.run_ledger.is_empty())
	assert_eq(memory.pending,0)
	assert_false(FileAccess.file_exists(service.path))
	assert_true(FileAccess.file_exists(service.path+".previous"))
	var reopened:=MEMORY.new()
	reopened.open_profile(memory.path)
	assert_true(reopened.unlocked.is_empty())
	var previous:=MEMORY.new()
	previous.open_profile(memory.path+".bak")
	assert_eq(previous.unlocked,["SG01","SG13"])

func test_memory_only_new_game_still_asks_and_cancel_keeps_memory() -> void:
	MEMORY.instance().unlocked.assign(["SG13"])
	var screen:=load("res://scenes/main/main.tscn").instantiate() as Control
	add_child_autofree(screen)
	screen.call("_on_start_button_pressed")
	var found:=false
	for child in screen.get_children():
		if child is ConfirmationDialog:
			found=true
			assert_true(child.dialog_text.contains("0/24"))
			child.canceled.emit()
			child.hide()
	assert_true(found)
	assert_eq(MEMORY.instance().unlocked,["SG13"])

func test_next_run_keeps_collection_and_failed_reset_keeps_run() -> void:
	MEMORY.instance().unlocked.assign(["SG13"])
	assert_true(service.prepare_new_game(false))
	RunState.reset_run()
	assert_eq(MEMORY.instance().unlocked,["SG13"])
	RunState.choose_protagonist("knight")
	service.path="res://.tmp/blocked_new_game.json"
	if FileAccess.file_exists(service.path): DirAccess.remove_absolute(service.path)
	assert_true(service.write_slot(RunState))
	var previous:=FileAccess.get_file_as_bytes(service.path)
	MEMORY.instance().error_message="Проверочный отказ записи профиля"
	assert_false(service.prepare_new_game())
	assert_eq(FileAccess.get_file_as_bytes(service.path),previous)
	assert_eq(MEMORY.instance().unlocked,["SG13"])
