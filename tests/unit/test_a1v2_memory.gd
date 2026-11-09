extends GutTest
const P := preload("res://scripts/memory/memory_profile.gd")

func test_catalog_and_finite_reachability_with_cap_and_class_gates() -> void:
	var p := P.new()
	var ids := {}
	var groups := {}
	for item in P.catalog():
		assert_false(ids.has(item.id))
		ids[item.id] = true
		groups[item.group] = int(groups.get(item.group,0))+1
		assert_false(item.memory_ru.is_empty())
		assert_true(FileAccess.file_exists("res://assets/story/a1v2/"+item.id+".png"))
	assert_eq(ids.size(),24)
	assert_eq(groups,{"chronicle":12,"knight":4,"ranger":4,"mage":4})
	for role in ["knight","ranger","mage","knight","ranger","mage"]:
		p.begin_run()
		for stage in range(1,14):
			var added := p.resolved(role,stage,{},stage==13,str(stage))
			for id in added:
				for item in P.catalog():
					if item.id==id:
						assert_true(item.group in [role,"chronicle"])
			assert_eq(p.resolved(role,stage,{},stage==13,str(stage)).size(),0)
		assert_lte(p.earned,8)
	assert_eq(p.unlocked.size(),24)
	p.begin_run()
	assert_eq(p.unlocked.size(),24)

func test_save_roundtrip_invalid_input_and_unknown_ids() -> void:
	var path := "res://.tmp/a1v2_test_profile.json"
	DirAccess.make_dir_recursive_absolute("res://.tmp")
	var p := P.new()
	p.path=path
	p.unlocked.assign(["SG01","SG13"])
	assert_true(p.save_profile())
	var second := P.new()
	second.open_profile(path)
	assert_eq(second.unlocked,p.unlocked)
	second.begin_run()
	assert_eq(second.unlocked.size(),2)
	var file := FileAccess.open(path,FileAccess.WRITE)
	file.store_string("broken")
	file.close()
	second.open_profile(path)
	assert_false(second.error_message.is_empty())
	assert_false(second.save_profile())
	assert_eq(FileAccess.get_file_as_string(path),"broken")

func test_live_completion_does_not_award_failed_battle_or_reset_clues() -> void:
	P.shared=P.new()
	RunState.reset_run()
	RunState.choose_protagonist("ranger")
	RunState.active_card_id="bone_patrol"
	RunState.last_battle_won=false
	RunState.complete_active_card()
	assert_eq(P.instance().unlocked.size(),0)
	RunState.active_card_id="graveyard_ambush"
	RunState.last_battle_won=true
	RunState.complete_active_card()
	assert_gt(P.instance().unlocked.size(),0)
	var count: int=P.instance().unlocked.size()
	RunState.reset_run()
	assert_eq(P.instance().unlocked.size(),count)
	assert_true(RunState.castle_memory_facts.is_empty())
	P.shared=null

func test_actual_event_resolution_and_unavailable_purchase() -> void:
	P.shared=P.new()
	RunState.reset_run()
	RunState.choose_protagonist("mage")
	RunState.active_card_id="moon_seal"
	var event := load("res://scenes/event/act_choice.tscn").instantiate() as Control
	add_child_autofree(event)
	assert_eq(P.instance().unlocked.size(),0)
	event.call("_resolve_moon_seal","keep")
	assert_eq(P.instance().unlocked.size(),1)
	assert_true(P.instance().unlocked.has("SG21"))
	var count: int=P.instance().unlocked.size()
	event.call("_resolve_moon_seal","keep")
	assert_eq(P.instance().unlocked.size(),count)
	RunState.active_card_id="blood_ledger"
	RunState.gold=0
	var shop := load("res://scenes/event/act_choice.tscn").instantiate() as Control
	add_child_autofree(shop)
	shop.call("_resolve_blood_ledger","gold")
	assert_eq(P.instance().unlocked.size(),count)
	RunState.reset_run()
	P.shared=null
