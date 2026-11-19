extends RefCounted
## Deterministic decisions using the same offers and information shown to the player.

static func card_score(card: RunCardData, strategy: String, state: Node) -> int:
	var score := 0
	if card.resolution_type == "combat":
		score = 12 if strategy == "aggressive" else -10
		if strategy == "adaptive":
			score = 10 if not state.claimed_upgrade_tiers.has(int(state.cards_resolved / 4.0) + 1) else -3
	elif card.card_id in ["chained_prisoner", "black_altar", "ash_rest", "last_camp", "whispering_well", "jack"]:
		score = 15 if strategy == "adaptive" else 4
	if card.card_id == state.wizard_mark_card_id:
		score += 8 if strategy == "aggressive" else -8
	return score


static func event_score(text: String, strategy: String, state: Node) -> int:
	var score := 0
	var copy := text.to_lower().replace("−", "-")
	var declines := _mentions(copy, ["уйти", "отказ", "пройти мимо", "не вмеш", "оставить", "без награды"])
	var injury := _mentions(copy, ["-10", "-15", "-20", "-25", "жертв", "проклят", "в долг"])
	var gold := _mentions(copy, ["золот", "монет", "добыч"])
	var development := _mentions(copy, ["улучш", "обуч", "реликви", "артефакт", "усилен", "урон"])
	var recruitment := _mentions(copy, ["присоединится", "взять с собой", "забрать джека", "в отряд"])
	var loss := _mentions(copy, ["будет потерян", "погибнет"])
	if declines:
		score += 15 if strategy == "defensive" else -8
	if injury:
		score += 3 if strategy == "aggressive" else -12
	if gold:
		score += 5 if strategy != "adaptive" or state.gold < 35 else 2
	if development:
		score += 8
	if recruitment:
		score += 15 if strategy == "adaptive" else 5
	if loss:
		score -= 14 if strategy == "adaptive" else 3
	if strategy == "aggressive" and _mentions(copy, ["бросить", "силой", "вскрыть", "сорвать"]):
		score += 12
	return score


static func reward_score(id: String, copy: String, strategy: String, state: Node) -> int:
	var upgrade: HeroUpgradeData = state.get_hero_upgrade(id)
	if upgrade == null:
		return event_score(copy, strategy, state)
	var tempo := upgrade.damage_multiplier / maxf(upgrade.attack_interval_multiplier, 0.1) - 1.0
	var hp_weight := 0.52 if strategy == "defensive" else (0.23 if strategy == "adaptive" else 0.08)
	var score := tempo * 50.0 + upgrade.hp_bonus * hp_weight
	if strategy == "adaptive":
		score += (upgrade.splash_radius_bonus + upgrade.attack_range_bonus) * 0.28
	return roundi(score)


static func _mentions(text: String, terms: Array[String]) -> bool:
	for term in terms:
		if term in text:
			return true
	return false


static func orders(strategy: String, hero: BattleUnit, battle: Control) -> Array[Dictionary]:
	var support := false
	for unit: BattleUnit in battle.units:
		if unit.team == 1 and unit.alive and unit.support_heal_interval > 0.0:
			support = true
	match strategy:
		"assault", "hunt":
			return [_order(strategy, "support")]
		"aggressive":
			return [_order("assault", "weakest", "personal_kill", 5), _order("hunt", "support")]
		"defensive":
			return [_order("defense", "nearest", "time", 5), _order("assault", "nearest")]
		_:
			if battle.wave_intermission:
				return [_order("defense", "nearest", "time", 2), _order("assault", "weakest")]
			if support:
				if hero.visual_role == "knight":
					return [_order("hunt", "support", "personal_kill", 7), _order("assault", "weakest")]
				return [_order("assault", "support", "damage_taken", 6), _order("defense", "nearest", "time", 3), _order("assault", "weakest")]
			return [_order("assault", "nearest")]


static func _order(tactic: String, priority: String, condition: String = "time", limit: int = 4) -> Dictionary:
	return {"tactic": tactic, "priority": priority, "condition": condition, "limit": limit, "target": null}


static func deploy(strategy: String, unit: BattleUnit) -> void:
	if not unit.placement_enabled or unit.visual_role == "jack" or strategy in ["assault", "hunt"]:
		return
	var old := unit.position
	var direction := 1.0 if strategy == "aggressive" else -1.0
	if strategy == "adaptive" and unit.visual_role == "knight":
		direction = 1.0
	unit.position = unit._clamp_to_placement_regions(old + Vector2(52.0 * direction, 0.0))
	if unit._overlaps_friendly_unit():
		unit.position = old
	unit.z_index = int(unit.position.y)
