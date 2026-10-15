extends Control

# D180: actual RunState normal offer and choice smoke for release card #36.
const D153_ID := "threadbare_theatre"
const D153_ENCOUNTER := "res://resources/encounters/threadbare_theatre.tres"
const EXPECTED_CARD_COUNT := 36
var issues: Array[String] = []


func _ready() -> void:
	var heading := Label.new()
	heading.position = Vector2(72, 108)
	heading.size = Vector2(1136, 70)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 27)
	add_child(heading)
	var report := Label.new()
	report.position = Vector2(90, 215)
	report.size = Vector2(1100, 345)
	report.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	report.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	report.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	report.add_theme_font_size_override("font_size", 20)
	add_child(report)
	_run_checks()
	RunState.reset_run()
	if issues.is_empty():
		heading.text = "D153 / ACT 1 RELEASE — PASS"
		report.text = ("36 уникальных карт • D153 присутствует в колоде\n"
			+ "Tier1-раздача показывает Театр оборванных нитей\n"
			+ "Выбор карты открывает правильный бой\n"
			+ "Завершение записывается в Расклад судьбы\n"
			+ "После 12 решений предлагается только босс XIII\n"
			+ "Проверка регистрации/маршрута, не симуляция боя.")
		report.add_theme_color_override("font_color", Color(0.63, 0.90, 0.70))
	else:
		heading.text = "D153 / ACT 1 RELEASE — FAIL"
		report.text = "\n".join(issues.slice(0, 8))
		report.add_theme_color_override("font_color", Color(0.98, 0.40, 0.33))
		push_error(report.text)


func _run_checks() -> void:
	if RunState.ACT1_CARD_IDS.size() != EXPECTED_CARD_COUNT:
		issues.append("Act1 must contain exactly 36 cards")
	if not RunState.ACT1_CARD_IDS.has(D153_ID):
		issues.append("D153 missing from live pool")
	var seen: Dictionary = {}
	for card_id in RunState.ACT1_CARD_IDS:
		if seen.has(card_id):
			issues.append("Duplicate Act1 card: " + card_id)
		seen[card_id] = true
		if RunState.get_card(card_id) == null:
			issues.append("Cannot load card: " + card_id)
	if seen.size() != EXPECTED_CARD_COUNT:
		issues.append("Act1 pool has missing or duplicate IDs")
	var card: RunCardData = RunState.get_card(D153_ID)
	if card == null:
		issues.append("Cannot load D153 card")
		return
	if card.tier != 1 or card.resolution_type != "combat" or card.target_path != D153_ENCOUNTER:
		issues.append("D153 must target the original Tier1 theatre battle")
		return

	RunState.reset_run()
	if not RunState.choose_protagonist("knight"):
		issues.append("Cannot choose protagonist")
		return
	if RunState.remaining_card_ids.size() != EXPECTED_CARD_COUNT:
		issues.append("New run must start with 36 cards")
	if not RunState.remaining_card_ids.has(D153_ID):
		issues.append("New run does not include theatre")
	# Two real Tier1 combat candidates, forced into a controlled fixture.
	# Offer/choose/complete still invoke the production RunState APIs.
	RunState.remaining_card_ids.clear()
	RunState.remaining_card_ids.append(D153_ID)
	RunState.remaining_card_ids.append("defiled_laboratory")
	RunState.cards_resolved = 4
	RunState.forced_combat_slots[1] = 0
	RunState.wizard_meddling_slots.clear()
	RunState.wizard_wager_slots.clear()
	RunState.wizard_mark_slots.clear()
	RunState.current_offer_ids.clear()
	var offered: Array[RunCardData] = RunState.get_offer_cards()
	if offered.size() != 2 or not RunState.current_offer_ids.has(D153_ID):
		issues.append("Normal Tier1 dealing did not offer theatre")
		return
	if not RunState.choose_card(D153_ID):
		issues.append("Theatre could not be chosen from its offer")
		return
	if RunState.active_card_id != D153_ID or RunState.selected_encounter_path != D153_ENCOUNTER:
		issues.append("Theatre choice did not select encounter")
		return
	RunState.complete_active_card()
	if RunState.cards_resolved != 5 or not RunState.resolved_card_ids.has(D153_ID):
		issues.append("Completing theatre did not advance Fate Spread")
	if RunState.fate_choice_history.size() != 1:
		issues.append("Fate Spread did not record choice")
	RunState.reset_run()
	RunState.cards_resolved = RunState.ACT_CARD_TARGET
	var boss_offer: Array[RunCardData] = RunState.get_offer_cards()
	if boss_offer.size() != 1:
		issues.append("Boss XIII must be offered alone after 12 resolutions")
	elif boss_offer[0].card_id != RunState.BOSS_CARD_ID:
		issues.append("Wrong boss XIII offer")
