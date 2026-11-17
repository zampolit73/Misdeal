extends RefCounted
## Optional BattleUnit policy; it uses the existing movement/attack pipeline.
const PLAN := preload("res://scripts/battle/planning/hero_battle_plan.gd")
const HOLD_RADIUS := 90.0
var owner_ref: WeakRef
var orders: Array[Dictionary]=[]
var index := -1
var elapsed := 0.0
var clock := 0.0
var active := false
var anchor := Vector2.ZERO
var journal: Array[Dictionary]=[]
var last_transition_frame := -1
var selected_ref: WeakRef
var target_observed := false
var waypoint := Vector2.INF
var kills := 0
var wave := 1
var hp_condition_met := false

func _init(hero: BattleUnit, plan: Resource, wave_number: int=1) -> void:
	owner_ref=weakref(hero)
	orders=plan.copy_orders()
	wave=wave_number
	hero.diagnostic_damage.connect(_on_dealt)
	hero.damage_received.connect(_on_received)
	hero.died.connect(_on_death)

func unit() -> BattleUnit: return owner_ref.get_ref() as BattleUnit

func record(kind: String, details: Dictionary={}) -> void:
	var row: Dictionary={"kind":kind,"time":clock,"stage":index+1,"wave":wave}
	row.merge(details,true)
	journal.append(row)

func begin() -> void:
	active=true
	_enter(0)
	# Entry HP is evaluated immediately; at most one transition in this frame.
	check_hp()

func _enter(next: int) -> void:
	index=next
	elapsed=0.0
	anchor=unit().global_position
	waypoint=Vector2.INF
	selected_ref=null
	target_observed=false
	var tactic: String=orders[index].tactic
	# Latch the entry predicate even if a heal lands before the next frame.
	# Frame guarding still prevents a single hit/timeout from cascading stages.
	hp_condition_met=orders[index].condition=="hp_below_50" and unit().hp<=unit().max_hp*0.5
	unit().set_tactical_order("formation" if tactic=="defense" else tactic)
	record("start",{"order":PLAN.describe(orders[index]),"assigned":name_of(PLAN.target_of(orders[index]))})
	unit().target=choose_target(null)

func tick(delta: float) -> void:
	var hero := unit()
	if not active or hero==null or not hero.alive or not hero.combat_started or hero.get_tree().paused: return
	clock+=delta
	elapsed+=delta
	if check_hp(): return
	if index<orders.size()-1 and elapsed>=float(orders[index].limit):
		advance("time" if orders[index].condition=="time" else "timeout")

func check_hp() -> bool:
	if active and index<orders.size()-1 and orders[index].condition=="hp_below_50" and (hp_condition_met or unit().hp<=unit().max_hp*0.5):
		return advance("hp_below_50")
	return false

func advance(reason: String) -> bool:
	if not active or index>=orders.size()-1 or last_transition_frame==Engine.get_process_frames(): return false
	last_transition_frame=Engine.get_process_frames()
	record("end",{"reason":reason,"elapsed":elapsed})
	_enter(index+1)
	return true

func event(kind: String) -> void:
	if not active or unit()==null or not unit().alive or not unit().combat_started or unit().hp<=0: return
	if index<orders.size()-1 and orders[index].condition==kind: advance(kind)

func _on_dealt(attacker: BattleUnit, victim: BattleUnit, amount: float) -> void:
	if not active or amount<=0 or attacker!=unit(): return
	var killed := not victim.alive
	if killed:
		kills+=1
		record("kill",{"target":name_of(victim),"amount":amount})
	# One real damage event can complete only one stage, even on a lethal hit.
	event("personal_kill" if killed and orders[index].condition=="personal_kill" else "damage_dealt")

func _on_received(_victim: BattleUnit, amount: float) -> void:
	if not active or amount<=0: return
	if orders[index].condition=="hp_below_50" and unit().hp<=unit().max_hp*0.5:
		hp_condition_met=true
		event("hp_below_50")
	else: event("damage_taken")

func _on_death(_hero: BattleUnit) -> void:
	if active: record("death")
	active=false

func finish(won: bool) -> void:
	record("result",{"won":won,"kills":kills})
	active=false

func disconnect_unit() -> void:
	var hero := unit()
	if hero==null: return
	if hero.diagnostic_damage.is_connected(_on_dealt): hero.diagnostic_damage.disconnect(_on_dealt)
	if hero.damage_received.is_connected(_on_received): hero.damage_received.disconnect(_on_received)
	if hero.died.is_connected(_on_death): hero.died.disconnect(_on_death)
	if hero.plan_executor==self: hero.plan_executor=null

static func name_of(candidate: BattleUnit) -> String:
	return "%s [#%d]" % [candidate.display_name,candidate.get_index()] if is_instance_valid(candidate) else "—"

func eligible(candidate: BattleUnit) -> bool:
	var hero := unit()
	if not is_instance_valid(candidate) or not candidate.is_inside_tree() or not candidate.alive or candidate.team==hero.team: return false
	if candidate.get_parent()!=hero.get_parent() or not candidate.is_in_group("combat_units"): return false
	return orders[index].tactic!="defense" or anchor.distance_to(candidate.global_position)<=HOLD_RADIUS+hero.attack_range+candidate.body_radius

func choose_target(current: BattleUnit) -> BattleUnit:
	if eligible(current): return current
	var choice: BattleUnit=PLAN.target_of(orders[index])
	if not eligible(choice):
		choice=null
		var score := INF
		var best_distance := INF
		for node in unit().get_tree().get_nodes_in_group("combat_units"):
			if not node is BattleUnit or not eligible(node): continue
			var distance: float=unit().global_position.distance_squared_to(node.global_position)
			var candidate_score := distance
			match str(orders[index].priority):
				"weakest": candidate_score=node.hp
				"farthest": candidate_score=-distance
				"support": candidate_score=0.0 if node.support_heal_interval>0 else (1.0 if node.minimum_range>0 or node.attack_range>=100 else 2.0)
			if candidate_score<score or (is_equal_approx(candidate_score,score) and distance<best_distance):
				score=candidate_score
				best_distance=distance
				choice=node
	var previous: Variant=selected_ref.get_ref() if selected_ref!=null else null
	if choice!=previous or not target_observed:
		waypoint=Vector2.INF
		record("target",{"assigned":name_of(PLAN.target_of(orders[index])),"actual":name_of(choice)})
	target_observed=true
	selected_ref=weakref(choice) if choice!=null else null
	return choice

func constrain_velocity(velocity: Vector2, delta: float) -> Vector2:
	var hero := unit()
	if orders[index].tactic=="defense":
		if hero.target==null and hero.global_position.distance_to(anchor)>4.0:
			velocity=hero.global_position.direction_to(anchor)*minf(hero._get_current_move_speed(),hero.global_position.distance_to(anchor)/maxf(delta,0.001))+hero._get_separation_velocity()
		var next := hero.global_position+velocity*delta
		if next.distance_to(anchor)>HOLD_RADIUS:
			next=anchor+(next-anchor).limit_length(HOLD_RADIUS)
			velocity=(next-hero.global_position)/maxf(delta,0.001)
	elif orders[index].tactic=="hunt" and is_instance_valid(hero.target) and hero.global_position.distance_to(hero.target.global_position)>hero.attack_range+hero.target.body_radius:
		# Local steering around an intervening body; never a new navigation graph.
		if waypoint==Vector2.INF:
			var direction := hero.global_position.direction_to(hero.target.global_position)
			for node in hero.get_tree().get_nodes_in_group("combat_units"):
				if not node is BattleUnit or node==hero or node==hero.target or not node.alive: continue
				var offset: Vector2=node.global_position-hero.global_position
				if offset.dot(direction)>0 and offset.length()<145 and absf(offset.cross(direction))<node.body_radius+hero.body_radius+14:
					var center_y: float=hero.get_parent().to_global(hero.combat_bounds.get_center()).y if hero.combat_bounds.size!=Vector2.ZERO else node.global_position.y
					var side := -1.0 if node.global_position.y>=center_y else 1.0
					waypoint=node.global_position+Vector2(0,side*(node.body_radius+hero.body_radius+24))
					if hero.combat_bounds.size!=Vector2.ZERO:
						waypoint=hero.get_parent().to_global(hero._clamped_combat_position(hero.get_parent().to_local(waypoint)))
					break
		if waypoint!=Vector2.INF:
			if hero.global_position.distance_to(waypoint)<20: waypoint=Vector2.INF
			else: velocity=hero.global_position.direction_to(waypoint)*hero._get_current_move_speed()+hero._get_separation_velocity()
	return velocity
