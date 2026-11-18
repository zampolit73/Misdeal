extends SceneTree
## Native production-route smoke: full encounter roster, solo/duo/trio,
## special-order fallback, real combat startup, wave replanning and result.
const BATTLE_SCENE := "res://scenes/battle/battle.tscn"
const ENCOUNTERS := [
	"black_crossing", "black_lantern_road", "bone_crush", "bone_patrol",
	"bone_ritual", "bone_shepherd", "bone_swarm", "bone_warden",
	"court_of_the_mute", "crypt_guard", "death_wager", "defiled_laboratory",
	"firing_square", "funeral_procession", "gallows_volley", "grave_bell",
	"grave_crossfire", "graveyard_ambush", "iron_wall", "last_bell",
	"ossuary_gate", "threadbare_theatre"
]
var count := 0

func _initialize() -> void:
	call_deferred("_run")

func verify(condition: bool, explanation: String) -> bool:
	if condition:
		return true
	push_error("COMBAT_PLANNING_CAMPAIGN_FAIL: " + explanation)
	quit(1)
	return false

func spawn_battle(encounter_id: String, roles: Array[String]) -> Control:
	var state: Node = root.get_node("RunState")
	state.call("reset_run")
	state.call("choose_protagonist", roles[0])
	for role in roles.slice(1):
		state.call("recruit_companion", role, "Campaign Planning QA")
	state.call("select_encounter", "res://resources/encounters/%s.tres" % encounter_id)
	var battle := (load(BATTLE_SCENE) as PackedScene).instantiate()
	root.add_child(battle)
	return battle

func cleanup_battle(battle: Control) -> void:
	battle.queue_free()
	await process_frame
	await process_frame

func _run() -> void:
	# Standalone SceneTree scripts register RunState before Battle is loaded.
	# This mirrors the existing native D291/D306 regression runners.
	if root.get_node_or_null("RunState") == null:
		var state := (load("res://scripts/core/run_state.gd") as Script).new() as Node
		state.name = "RunState"
		root.add_child(state)
	# Every authored battle uses one campaign controller, never the QA wrapper.
	for encounter_id in ENCOUNTERS:
		var battle := spawn_battle(encounter_id, ["knight"])
		await process_frame
		var driver: Node = battle.combat_plan_controller
		if not verify(driver != null, encounter_id + " has no campaign planner"): return
		if not verify(driver.ui != null and driver.ui.overview.visible, encounter_id + " overview missing"): return
		if not verify(driver.plans.has("knight") and driver.plans.size() == 1, encounter_id + " solo roles wrong"): return
		if not verify(driver.first_wave_enemies.size() >= 1, encounter_id + " enemy roster empty"): return
		if not verify(driver.ui.preparation.position.y >= 559.0, encounter_id + " panel outside lower strip"): return
		count += 1
		await cleanup_battle(battle)

	# Verify all party sizes and live executor ownership against real battle.
	for party in [["ranger"], ["knight", "mage"], ["knight", "ranger", "mage"]]:
		var roles: Array[String] = []
		roles.assign(party)
		var battle := spawn_battle("grave_bell", roles)
		await process_frame
		var driver: Node = battle.combat_plan_controller
		if not verify(driver.plans.size() == roles.size(), "wrong party planning count"): return
		driver.plans[roles[0]].resize_orders(2)
		driver.plans[roles[0]].orders[0].condition = "time"
		driver.plans[roles[0]].orders[0].limit = 2
		driver.start_planned_battle()
		await create_timer(1.4).timeout
		if not verify(battle.combat_started and battle.combat_live, "normal battle failed to start"): return
		for role in roles:
			if not verify(driver.executors.has(role), "missing executor " + role): return
			if not verify(driver.executors[role].unit().plan_executor == driver.executors[role], "executor not attached"): return
		await cleanup_battle(battle)

	# The exceptional one-use order remains reachable from the classic view.
	var classic := spawn_battle("bone_patrol", ["knight"])
	await process_frame
	var classic_driver: Node = classic.combat_plan_controller
	root.get_node("RunState").set("sacrifice_order_ready", true)
	classic.sacrifice_order_unlocked = true
	classic_driver.return_to_hub()
	if not verify(classic_driver.using_classic and classic.assault_order_button.visible, "classic fallback inaccessible"): return
	if not verify(classic.sacrifice_order_button.visible, "special order inaccessible"): return
	classic_driver.show_planning()
	if not verify(not classic_driver.using_classic and classic_driver.ui.overview.visible, "cannot return to planning"): return
	await cleanup_battle(classic)

	# The existing Iron Wall encounter must preserve re-planning for survivors.
	var waves := spawn_battle("iron_wall", ["knight", "ranger", "mage"])
	await process_frame
	var wave_driver: Node = waves.combat_plan_controller
	wave_driver.start_planned_battle()
	await create_timer(1.4).timeout
	if not verify(waves.combat_live, "iron wall intro failed"): return
	var first: Array[BattleUnit] = []
	for unit in waves.units:
		if unit.team == 1 and unit.alive:
			first.append(unit)
	for enemy in first:
		if enemy.alive:
			enemy.take_damage(enemy.hp + 10000.0)
		await process_frame
	if not verify(waves.wave_intermission, "iron wall wave break did not begin"): return
	if not verify(wave_driver.ui.overview.visible, "wave break did not offer replanning"): return
	wave_driver.start_planned_battle()
	await create_timer(1.4).timeout
	if not verify(waves.battle_wave_index == 2 and waves.combat_live, "wave II did not begin"): return
	await cleanup_battle(waves)

	print("COMBAT_PLANNING_CAMPAIGN_NATIVE_PASS: %d encounters + solo/duo/trio + special fallback + two-wave handoff" % count)
	quit(0)
