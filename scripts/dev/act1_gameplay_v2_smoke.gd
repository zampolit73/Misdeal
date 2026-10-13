extends Control

# Run as an isolated F6 scene in Godot 4.7.x; never used in normal gameplay.
# Exercises live RunState draws, the Wizard's pending actions, and boss handoff.
const RUNS := 48
const ACT_SLOTS := 12


func _ready() -> void:
	var problems: Array[String] = []
	var mixed_offers := 0
	var combat_slots_checked := 0
	var roles: Array[String] = ["knight", "ranger", "mage"]

	for trial in range(RUNS):
		seed(20700 + trial)
		RunState.reset_run()
		if not RunState.choose_protagonist(roles[trial % roles.size()]):
			problems.append("Cannot choose protagonist on trial %d" % trial)
			break
		# Include solo, duo and trio runs without modifying balance constants.
		var expected_party := trial % 3 + 1
		for role in roles:
			if RunState.get_party_size() >= expected_party:
				break
			if role != RunState.protagonist_role:
				RunState.recruit_companion(role, "F6 gameplay simulation")
		if RunState.get_party_size() != expected_party:
			problems.append("Party size mismatch in trial %d" % trial)
			break
		var enemy_hp: float = [0.82, 0.92, 1.0][expected_party - 1]
		var enemy_damage: float = [0.80, 0.90, 1.0][expected_party - 1]
		if not is_equal_approx(RunState.get_enemy_hp_multiplier(), enemy_hp) or not is_equal_approx(RunState.get_enemy_base_damage_multiplier(), enemy_damage):
			problems.append("Enemy pressure changed for party size %d" % expected_party)
			break
		var chosen_ids: Dictionary = {}
		for slot in range(ACT_SLOTS):
			var offers := RunState.get_offer_cards()
			if RunState.has_pending_wizard_meddling():
				RunState.apply_pending_wizard_meddling()
			if RunState.has_pending_wizard_wager():
				RunState.decline_pending_wizard_wager()
			offers = RunState.get_offer_cards()
			if offers.size() != 2:
				problems.append("Trial %d slot %d: got %d offers" % [trial, slot, offers.size()])
				break

			if offers[0].card_id == offers[1].card_id:
				problems.append("Duplicate offered card in trial %d slot %d" % [trial, slot])
				break
			var tier := int(slot / 4)
			for card in offers:
				if card.tier != tier:
					problems.append("Wrong tier at trial %d slot %d" % [trial, slot])
					break
			if not problems.is_empty():
				break

			if offers[0].resolution_type != offers[1].resolution_type:
				mixed_offers += 1

			if slot % 4 == RunState.forced_combat_slots[tier]:
				combat_slots_checked += 1
				if offers[0].resolution_type != "combat" or offers[1].resolution_type != "combat":
					problems.append("Missing required combat offer at trial %d slot %d" % [trial, slot])
					break

			var choice: RunCardData = offers[(trial + slot) % offers.size()]
			if chosen_ids.has(choice.card_id):
				problems.append("Repeated chosen ID at trial %d slot %d" % [trial, slot])
				break
			chosen_ids[choice.card_id] = true
			if not RunState.choose_card(choice.card_id):
				problems.append("Card choice rejected at trial %d slot %d" % [trial, slot])
				break
			RunState.complete_active_card()
		if not problems.is_empty():
			break
		if RunState.cards_resolved != ACT_SLOTS or not RunState.is_boss_due():
			problems.append("Boss not due after 12 choices in trial %d" % trial)
			break
		var final_offer := RunState.get_offer_cards()
		if final_offer.size() != 1 or final_offer[0].card_id != RunState.BOSS_CARD_ID:
			problems.append("Unexpected boss deal in trial %d" % trial)
			break

	RunState.reset_run()
	RunState.cards_resolved = 0
	if RunState.get_wizard_mark_gold_reward() != 20:
		problems.append("Tier 0 Mark reward incorrect")
	RunState.cards_resolved = 4
	if RunState.get_wizard_mark_gold_reward() != 30:
		problems.append("Tier 1 Mark reward incorrect")
	RunState.cards_resolved = 8
	if RunState.get_wizard_mark_gold_reward() != 40:
		problems.append("Tier 2 Mark reward incorrect")
	RunState.reset_run()

	if mixed_offers == 0:
		problems.append("No varied combat/event offers")
	if combat_slots_checked < RUNS * 3 and problems.is_empty():
		problems.append("Some mandatory combat windows were not reached")

	var title := Label.new()
	title.position = Vector2(55, 75)
	title.size = Vector2(1170, 160)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 29)
	title.add_theme_color_override("font_color", Color(0.91, 0.77, 0.56))
	add_child(title)

	var info := Label.new()
	info.position = Vector2(65, 260)
	info.size = Vector2(1150, 350)
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.add_theme_font_size_override("font_size", 20)
	add_child(info)

	if problems.is_empty():
		title.text = "ACT 1 GAMEPLAY 2.0 — PASS"
		info.text = "%d симулированных забегов по 12 картам.\n%d раз предложены разные типы карт.\n%d обязательных боевых окон сохранены.\nБосс XIII: доступен. Печать: 20 / 30 / 40 золота." % [RUNS, mixed_offers, combat_slots_checked]
		info.add_theme_color_override("font_color", Color(0.56, 0.84, 0.69))
	else:
		title.text = "ACT 1 GAMEPLAY 2.0 — FAIL"
		info.text = "\n".join(problems)
		info.add_theme_color_override("font_color", Color(0.94, 0.45, 0.38))
		push_error(info.text)
