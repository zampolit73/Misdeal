extends GutTest

const RULES := preload("res://scripts/alternative/veil_rules.gd")


func test_fate_deal_is_deterministic_and_offers_two_different_cards() -> void:
	var a: Dictionary = RULES.new_run("knight", 1414)
	var b: Dictionary = RULES.new_run("knight", 1414)
	var first: Array[Dictionary] = RULES.offer(a)
	var second: Array[Dictionary] = RULES.offer(b)
	assert_eq(first.size(), 2)
	assert_eq(first, second)
	assert_ne(str(first[0]["id"]), str(first[1]["id"]))


func test_pledge_trades_permanent_health_for_debt_and_seal() -> void:
	var s: Dictionary = RULES.new_run("knight", 12)
	assert_true(RULES.pledge(s))
	assert_eq(int(s["party"][0]["max_hp"]), 53)
	assert_eq(int(s["debt"]), 1)
	assert_eq(int(s["seals"]), 1)


func test_companion_is_offered_but_not_automatically_granted() -> void:
	var s: Dictionary = RULES.new_run("knight", 21)
	s["stage"] = 2
	var offered: Array[Dictionary] = RULES.offer(s)
	assert_eq(str(offered[0]["kind"]), "recruit")
	assert_eq(s["party"].size(), 1)
	RULES.choose(s, offered[0])
	assert_eq(s["party"].size(), 2)
	assert_eq(str(s["party"][1]["id"]), "ranger")


func test_boss_scales_with_wizard_debt() -> void:
	var s: Dictionary = RULES.new_run("mage", 13)
	s["stage"] = 12
	s["phase"] = "boss_gate"
	s["debt"] = 3
	RULES.start_boss(s)
	assert_eq(str(s["phase"]), "prep")
	assert_eq(int(s["enemy_hp"]), 137)
	assert_eq(int(s["enemy_attack"]), 17)


func test_twelve_cleared_cards_reveal_boss_and_boss_can_be_defeated() -> void:
	var s: Dictionary = RULES.new_run("ranger", 10)
	s["stage"] = 11
	RULES.choose(s, {"title":"КОСТЯНОЙ ДОЗОР","kind":"fight","danger":1})
	s["enemy_hp"] = 1
	RULES.begin_combat(s, "shield")
	RULES.tick(s)
	assert_eq(int(s["stage"]), 12)
	assert_eq(str(s["phase"]), "boss_gate")
	RULES.start_boss(s)
	s["enemy_hp"] = 1
	RULES.begin_combat(s, "blade")
	RULES.tick(s)
	assert_eq(str(s["phase"]), "finished")
	assert_true(bool(s["won"]))


func test_frontline_death_is_permanent_and_can_end_the_run() -> void:
	var s: Dictionary = RULES.new_run("mage", 88)
	RULES.choose(s, {"title":"СУД","kind":"fight","danger":3})
	s["party"][0]["hp"] = 1
	s["enemy_hp"] = 999
	RULES.begin_combat(s, "blade")
	RULES.tick(s)
	assert_eq(s["party"].size(), 0)
	assert_eq(str(s["phase"]), "finished")
	assert_false(bool(s["won"]))
