extends Control

# D198: strict LIVE 37/45 Black Crossing release smoke, using production RunState APIs.
# Does NOT launch a fake battle or grant release. One button starts the REAL
# playtest: Battle → Reward → Table, including the ordinary reward UI.
# This copy is strict LIVE-only; D197's original QA preflight stays available.
const CARD_ID := "black_crossing"
const ENCOUNTER_PATH := "res://resources/encounters/black_crossing.tres"
const ART_PATH := "res://assets/pixel/card_unification_v1/run/black_crossing_approved_v1.webp.b64"
const ARENA_PATH := "res://assets/pixel/battle/arenas/black_crossing_storm_pier_approved_v1.webp.b64"
const PLAYTEST_SCENE := "res://scenes/dev/black_crossing_playtest.tscn"

var issues: Array[String] = []
var is_live := false
var sampled_deals := 0
var crossing_offers := 0


func _ready() -> void:
	var heading := Label.new()
	heading.position = Vector2(75, 105)
	heading.size = Vector2(1130, 74)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 28)
	add_child(heading)

	var report := Label.new()
	report.position = Vector2(105, 208)
	report.size = Vector2(1070, 280)
	report.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	report.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	report.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	report.add_theme_font_size_override("font_size", 20)
	add_child(report)

	_run_checks()
	if issues.is_empty():
		_check_full_pool_random_deals()
	# Do not leave a forced offer or artificially completed card in the user's
	# real run. The button below opens a brand-new real battle fixture.
	RunState.reset_run()
	if not issues.is_empty():
		heading.text = "D198 / BLACK CROSSING — RELEASE FAIL"
		report.text = "\n".join(issues.slice(0, 8))
		report.add_theme_color_override("font_color", Color(0.96, 0.39, 0.33))
		push_error(report.text)
		return

	heading.text = "D198 / BLACK CROSSING — RELEASE PASS"
	report.add_theme_color_override("font_color", Color(0.64, 0.89, 0.74))
	var pool_label := "37/45 • LIVE • %d/80 проверок раздачи" % sampled_deals
	report.text = ("%s\n"
		+ "Уникальные карты, оригинальные ресурсы и Tier1-раздача проверены.\n"
		+ "Выбор карты ведёт к правильному бою.\n"
		+ "Результат записывается в Расклад судьбы; босс XIII сохранён.\n"
		+ "Реальная 37-карточная колода предлагает карту №37.\n"
		+ "Это release smoke раздачи, не повторная симуляция боя.") % pool_label

	var play_button := Button.new()
	play_button.text = "ПРОЙТИ РЕАЛЬНЫЙ БОЙ → НАГРАДА → СТОЛ"
	play_button.position = Vector2(355, 535)
	play_button.size = Vector2(570, 70)
	play_button.add_theme_font_size_override("font_size", 19)
	play_button.pressed.connect(_play_real_battle)
	add_child(play_button)


func _run_checks() -> void:
	is_live = RunState.ACT1_CARD_IDS.has(CARD_ID)
	if not is_live:
		issues.append("D198 requires Black Crossing to be LIVE")
	var expected_count := 37
	if RunState.ACT1_CARD_IDS.size() != expected_count:
		issues.append("Act1 card count mismatch: expected %d" % expected_count)

	var known := {}
	for card_id in RunState.ACT1_CARD_IDS:
		if known.has(card_id):
			issues.append("Duplicate card in Act1: " + card_id)
		known[card_id] = true
		if RunState.get_card(card_id) == null:
			issues.append("Unloaded Act1 card: " + card_id)
	if known.size() != expected_count:
		issues.append("Pool contains duplicates or missing cards")
	for prior in ["funeral_procession", "defiled_laboratory", "threadbare_theatre"]:
		if not known.has(prior):
			issues.append("Previous released encounter missing: " + prior)

	var card: RunCardData = RunState.get_card(CARD_ID)
	if card == null:
		issues.append("Black Crossing card resource missing")
		return
	if card.tier != 1 or card.resolution_type != "combat" or card.target_path != ENCOUNTER_PATH:
		issues.append("Black Crossing must remain a Tier1 original combat card")

	for art_path in [ART_PATH, ARENA_PATH]:
		if not FileAccess.file_exists(art_path):
			issues.append("Approved art missing: " + art_path)

	var encounter: EncounterData = load(ENCOUNTER_PATH) as EncounterData
	if encounter == null or encounter.encounter_id != CARD_ID:
		issues.append("Original Black Crossing encounter missing or misrouted")
		return
	if encounter.get_formation_count() != 2:
		issues.append("Black Crossing must retain both authored formations")
	if encounter.enemy_unit_paths != PackedStringArray([
		"res://resources/units/drowned_ferryman.tres",
		"res://resources/units/drowned_hand.tres",
		"res://resources/units/drowned_hand.tres"
	]):
		issues.append("Original Ferryman + two Drowned roster changed")

	RunState.reset_run()
	if not RunState.choose_protagonist("knight"):
		issues.append("Cannot choose Knight")
		return
	if RunState.remaining_card_ids.size() != expected_count:
		issues.append("New run received wrong Act1 card count")
	if RunState.remaining_card_ids.has(CARD_ID) != is_live:
		issues.append("Black Crossing release pool membership inconsistent")

	# Mirror real Tier1 offer/choose/complete APIs without relying on
	# randomness or on the QA-only card being in the live random pool.
	RunState.remaining_card_ids.clear()
	RunState.remaining_card_ids.append(CARD_ID)
	RunState.remaining_card_ids.append("defiled_laboratory")
	RunState.cards_resolved = 4
	RunState.forced_combat_slots[1] = 0
	RunState.wizard_meddling_slots.clear()
	RunState.wizard_wager_slots.clear()
	RunState.wizard_mark_slots.clear()
	RunState.current_offer_ids.clear()
	var offers: Array[RunCardData] = RunState.get_offer_cards()
	if offers.size() != 2 or not RunState.current_offer_ids.has(CARD_ID):
		issues.append("Normal Tier1 offer excluded Black Crossing")
		return
	if not RunState.choose_card(CARD_ID):
		issues.append("Production choice rejected Black Crossing")
		return
	if RunState.active_card_id != CARD_ID or RunState.selected_encounter_path != ENCOUNTER_PATH:
		issues.append("Card selection did not route to original encounter")
		return

	RunState.complete_active_card()
	if RunState.cards_resolved != 5 or RunState.active_card_id != "":
		issues.append("Completion did not resume normal progression")
	if not RunState.resolved_card_ids.has(CARD_ID) or RunState.fate_choice_history.size() != 1:
		issues.append("Fate Spread did not record Black Crossing")
	if RunState.selected_encounter_path != RunState.DEFAULT_ENCOUNTER_PATH:
		issues.append("Encounter selection not reset after completion")
	if RunState.deals_survived != 1:
		issues.append("Battle completion not counted as a survived deal")

	RunState.reset_run()
	RunState.cards_resolved = RunState.ACT_CARD_TARGET
	var boss_offer: Array[RunCardData] = RunState.get_offer_cards()
	if boss_offer.size() != 1 or boss_offer[0].card_id != RunState.BOSS_CARD_ID:
		issues.append("XIII boss offer not preserved after 12 resolutions")


# Unlike D197's two-card fixture this samples the COMPLETE 37-card pool.
# Only normal Tier1 progression and deterministic RNG seeds are used.
func _check_full_pool_random_deals() -> void:
	for trial in range(80):
		RunState.reset_run()
		if not RunState.choose_protagonist("knight"):
			issues.append("Cannot start native release-deal sample")
			return
		if RunState.remaining_card_ids.size() != 37 or not RunState.remaining_card_ids.has(CARD_ID):
			issues.append("Full new-run pool does not contain exactly 37 cards including #37")
			return
		RunState.cards_resolved = 4
		RunState.forced_combat_slots[1] = 0
		RunState.wizard_meddling_slots.clear()
		RunState.wizard_wager_slots.clear()
		RunState.wizard_mark_slots.clear()
		seed(198000 + trial)
		var offered: Array[RunCardData] = RunState.get_offer_cards()
		sampled_deals += 1
		if offered.size() != 2:
			issues.append("Ordinary full-pool Tier1 offer must contain two cards")
			return
		if RunState.current_offer_ids.has(CARD_ID):
			crossing_offers += 1
	if crossing_offers == 0:
		issues.append("Black Crossing never appeared in 80 real-pool Tier1 offers")


func _play_real_battle() -> void:
	RunState.reset_run()
	get_tree().change_scene_to_file(PLAYTEST_SCENE)
