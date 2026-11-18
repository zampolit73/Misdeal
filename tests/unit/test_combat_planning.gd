extends GutTest
const DATA := preload("res://scripts/battle/planning/hero_battle_plan.gd")
const EXEC := preload("res://scripts/battle/planning/battle_plan_executor.gd")
const UNIT := preload("res://scenes/battle/unit.tscn")
const KNIGHT := preload("res://resources/units/knight.tres")
var arena: Node2D
var policies: Array[RefCounted]=[]

func before_each() -> void:
	arena=Node2D.new()
	add_child_autofree(arena)

func after_each() -> void:
	get_tree().paused=false
	for policy in policies: policy.disconnect_unit()
	policies.clear()

func spawn(team: int, at: Vector2=Vector2.ZERO) -> BattleUnit:
	var actor: BattleUnit=UNIT.instantiate()
	actor.configure(KNIGHT,team,at)
	arena.add_child(actor)
	actor.set_process(false)
	return actor

func order(tactic: String="assault", priority: String="nearest", condition: String="time", limit: int=2) -> Dictionary:
	return {"tactic":tactic,"priority":priority,"condition":condition,"limit":limit,"target":null}

func executor(hero: BattleUnit, orders: Array) -> RefCounted:
	var plan := DATA.new()
	plan.orders.assign(orders)
	var policy := EXEC.new(hero,plan)
	policies.append(policy)
	hero.plan_executor=policy
	hero.combat_started=true
	policy.begin()
	return policy

func test_data_contract_clamps_and_copies_without_special_orders() -> void:
	var plan := DATA.new()
	plan.orders.assign([order("sacrifice","bad","bad",40),order("defiance","nearest","time",0),order(),order()])
	var frozen: Array=plan.copy_orders()
	assert_eq(frozen.size(),3)
	assert_eq(frozen[0].tactic,"assault")
	assert_eq(frozen[1].tactic,"assault")
	assert_eq(frozen[0].limit,12)
	assert_eq(frozen[1].limit,2)
	frozen[0].limit=3
	assert_eq(plan.orders[0].limit,40)
	for count in [1,2,3]:
		plan.resize_orders(count)
		assert_eq(plan.orders.size(),count)

func test_priority_absolute_hp_support_fallback_farthest_and_target_lock() -> void:
	var hero := spawn(0)
	var near := spawn(1,Vector2(100,0))
	var far := spawn(1,Vector2(400,0))
	far.max_hp=1000
	far.hp=80
	near.hp=70
	var policy := executor(hero,[order("assault","weakest")])
	assert_same(hero.target,near,"Absolute HP, not health ratio")
	far.hp=1
	assert_same(policy.choose_target(hero.target),near,"Keep a valid target despite changing HP")
	policy.orders[0].priority="farthest"
	assert_same(policy.choose_target(null),far)
	policy.orders[0].priority="support"
	far.minimum_range=50
	assert_same(policy.choose_target(null),far)
	near.support_heal_interval=2
	assert_same(policy.choose_target(null),near)
	near.support_heal_interval=0
	far.minimum_range=0
	assert_same(policy.choose_target(null),near,"No support category: nearest")

func test_explicit_target_death_fallback_and_freed_reference() -> void:
	var hero := spawn(0)
	var near := spawn(1,Vector2(60,0))
	var chosen := spawn(1,Vector2(250,0))
	var first := order()
	first.target=weakref(chosen)
	var policy := executor(hero,[first])
	assert_same(hero.target,chosen)
	chosen.take_damage(chosen.hp)
	assert_same(policy.choose_target(hero.target),near)
	chosen.queue_free()
	await get_tree().process_frame
	assert_same(policy.choose_target(null),near)
	near.remove_from_group("combat_units")
	assert_null(policy.choose_target(near),"A despawned/unavailable target is not retained")

func test_independent_timers_last_order_and_no_preparation_or_pause_time() -> void:
	var one := spawn(0)
	var two := spawn(0,Vector2(0,90))
	var a := executor(one,[order(),order("defense"),order("hunt")])
	var b := executor(two,[order("assault","nearest","time",5),order("hunt")])
	one.combat_started=false
	a.tick(10)
	assert_eq(a.elapsed,0.0)
	one.combat_started=true
	get_tree().paused=true
	a.tick(10)
	assert_eq(a.elapsed,0.0)
	get_tree().paused=false
	a.tick(2)
	b.tick(2)
	assert_eq(a.index,1)
	assert_eq(b.index,0)
	await get_tree().process_frame
	a.tick(2)
	assert_eq(a.index,2)
	await get_tree().process_frame
	a.tick(100)
	assert_eq(a.index,2,"Last order has no transition or loop")

func test_each_event_timeout_and_no_extra_stat_penalty() -> void:
	for condition in ["damage_dealt","damage_taken","personal_kill","hp_below_50"]:
		var hero := spawn(0,Vector2(-400,0))
		var policy := executor(hero,[order("assault","nearest",condition),order("defense")])
		var hp := hero.hp
		var damage := hero.damage
		policy.tick(2)
		assert_eq(policy.index,1,condition)
		assert_eq(policy.journal.filter(func(row: Dictionary):return row.kind=="end")[0].reason,"timeout")
		assert_eq(hero.hp,hp)
		assert_eq(hero.damage,damage)
		await get_tree().process_frame

func test_real_damage_taken_and_hp_entry() -> void:
	var hero := spawn(0)
	var policy := executor(hero,[order("assault","nearest","damage_taken"),order("defense")])
	hero.take_damage(0)
	assert_eq(policy.index,0)
	hero.take_damage(1)
	assert_eq(policy.index,1)
	await get_tree().process_frame
	var second := spawn(0,Vector2(0,100))
	second.hp=second.max_hp*0.5
	var hp_policy := executor(second,[order("assault","nearest","hp_below_50"),order("defense")])
	assert_eq(hp_policy.index,1,"HP is checked immediately on entry")

func test_actual_damage_personal_kill_aoe_and_one_transition_per_event_frame() -> void:
	var hero := spawn(0)
	var ally := spawn(0,Vector2(0,120))
	var foe := spawn(1,Vector2(50,0))
	var second := spawn(1,Vector2(70,0))
	foe.hp=2
	second.hp=2
	hero.splash_radius=100
	hero.splash_damage_multiplier=1
	var policy := executor(hero,[order("assault","nearest","damage_dealt"),order("hunt","nearest","personal_kill"),order("defense")])
	var other := executor(ally,[order("assault","nearest","personal_kill"),order("defense")])
	hero.target=foe
	hero._attack_target()
	assert_eq(policy.kills,2,"Both actual AoE victims attributed to this hero")
	assert_eq(other.kills,0)
	assert_eq(policy.index,1,"No stage cascade from lethal damage + AoE in the same frame")
	assert_eq(other.index,0)
	policy.tick(2)
	assert_eq(policy.index,1,"Coincident timer cannot advance twice")
	await get_tree().process_frame
	policy.tick(0.001)
	assert_eq(policy.index,2)

func test_personal_kill_event_and_damage_from_before_stage_does_not_replay() -> void:
	var hero := spawn(0)
	var foe := spawn(1,Vector2(50,0))
	var policy := executor(hero,[order("assault","nearest","personal_kill"),order("defense","nearest","damage_dealt"),order("hunt")])
	foe.hp=1
	hero._attack_target()
	assert_eq(policy.index,1)
	await get_tree().process_frame
	policy.tick(0.1)
	assert_eq(policy.index,1,"Old killing hit does not satisfy the next stage")

func test_defense_does_not_chase_far_assigned_enemy_and_anchor_never_teleports() -> void:
	var hero := spawn(0)
	var far := spawn(1,Vector2(400,0))
	var first := order("defense")
	first.target=weakref(far)
	var policy := executor(hero,[first])
	assert_null(hero.target)
	for _step in range(60): hero._process(1.0/60.0)
	assert_eq(hero.position,Vector2.ZERO,"No reachable foe: hold without artificial damage")
	hero.position=Vector2(70,20)
	policy.disconnect_unit()
	var second := executor(hero,[order(),order("defense")])
	second.tick(2)
	assert_eq(second.anchor,Vector2(70,20))
	assert_eq(hero.position,Vector2(70,20),"Transition never changes position")
	far.position=Vector2(200,20)
	for _step in range(60): hero._process(1.0/60.0)
	assert_lte(hero.global_position.distance_to(second.anchor),EXEC.HOLD_RADIUS+0.001)

func test_hunt_and_assault_have_distinct_real_movement_without_stat_buffs() -> void:
	var hero := spawn(0)
	spawn(1,Vector2(100,0))
	var healer := spawn(1,Vector2(400,0))
	healer.support_heal_interval=2
	var assault := executor(hero,[order("assault","support")])
	hero._process(0.1)
	var direct := hero.position
	assault.disconnect_unit()
	hero.position=Vector2.ZERO
	var base_damage := hero.damage
	var hunt := executor(hero,[order("hunt","support")])
	hero._process(0.1)
	assert_lt(hero.position.y,direct.y-1.0,"Hunter locally flanks the intervening body")
	assert_same(hero.target,healer)
	assert_eq(hero.damage,base_damage)
	assert_eq(hunt.orders[0].tactic,"hunt")

func test_death_stops_plan_and_unplanned_units_keep_legacy_policy() -> void:
	var hero := spawn(0)
	var policy := executor(hero,[order(),order("defense")])
	hero.take_damage(hero.hp+1)
	policy.tick(100)
	assert_false(policy.active)
	assert_eq(policy.index,0)
	assert_eq(policy.journal.filter(func(row: Dictionary):return row.kind=="death").size(),1)
	var legacy := spawn(0,Vector2(0,90))
	var foe := spawn(1,Vector2(60,90))
	assert_null(legacy.plan_executor)
	assert_same(legacy.get_preview_target(),foe)

func test_hp_predicate_is_latched_at_entry_without_cascading_the_trigger_event() -> void:
	var hero := spawn(0)
	hero.hp=50
	var policy := executor(hero,[order(),order("defense","nearest","hp_below_50"),order("hunt")])
	policy.tick(2)
	assert_eq(policy.index,1,"One timer completes only one stage")
	hero.heal(100)
	await get_tree().process_frame
	policy.tick(0.01)
	assert_eq(policy.index,2,"HP was already satisfied when the second stage began")
