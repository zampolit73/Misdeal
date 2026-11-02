extends SceneTree

const RULES := preload("res://scripts/alternative/veil_rules.gd")

func _initialize() -> void:
	call_deferred("_run")


func _score(card: Dictionary, state: Dictionary) -> int:
	var kind := str(card["kind"])
	var hurt := false
	for hero in state["party"]:
		if int(hero["hp"]) * 2 < int(hero["max_hp"]):
			hurt = true
	match kind:
		"recruit": return -90 if (state["party"] as Array).size() < 3 else 8
		"rest": return -65 if hurt else 5
		"shop": return -50 if hurt and int(state["gold"]) >= 8 else 22
		"cleanse": return -42 if int(state["debt"]) > 0 and int(state["gold"]) >= 8 else 10
		"sacrifice": return -25 if int(state["party"][0]["hp"]) > 18 else 60
		"seal": return -20 if int(state["party"][0]["hp"]) > 18 else 60
		"fight": return 25 + int(card["danger"]) * 6
		"gold": return 20
		_: return 50


func _run() -> void:
	var wins := 0
	var reached_boss := 0
	var total := 0
	for role in ["knight", "ranger", "mage"]:
		var role_wins := 0
		var role_boss := 0
		for seed in range(1, 26):
			total += 1
			var s: Dictionary = RULES.new_run(role, seed)
			var stopped := false
			for iteration in range(180):
				var phase := str(s["phase"])
				match phase:
					"deal":
						var options: Array[Dictionary] = RULES.offer(s)
						if options.size() != 2:
							push_error("ALTERNATIVE_ROUTE_FAIL: no deal offers")
							quit(1)
							return
						var pick: Dictionary = options[0] if _score(options[0], s) <= _score(options[1], s) else options[1]
						RULES.choose(s, pick)
					"prep":
						var order := "ritual" if int(s["seals"]) > 0 else "shield"
						RULES.begin_combat(s, order)
					"battle":
						RULES.tick(s)
					"boss_gate":
						role_boss += 1
						RULES.start_boss(s)
					"finished":
						stopped = true
						break
					_:
						push_error("ALTERNATIVE_ROUTE_FAIL: unknown phase %s" % phase)
						quit(1)
						return
			if str(s["phase"]) == "finished":
				stopped = true
			if not stopped:
				push_error("ALTERNATIVE_ROUTE_FAIL: turn cap role=%s seed=%d" % [role,seed])
				quit(1)
				return
			if bool(s["won"]):
				role_wins += 1
		wins += role_wins
		reached_boss += role_boss
		print("ALTERNATIVE_ROUTE_STATS role=%s boss=%d wins=%d" % [role,role_boss,role_wins])
	print("ALTERNATIVE_ROUTE_COMPLETE runs=%d boss=%d wins=%d" % [total,reached_boss,wins])
	quit(0)
