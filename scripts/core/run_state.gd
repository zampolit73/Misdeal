extends Node

const ACT_CARD_TARGET: int = 12
const MAX_DEALS: int = ACT_CARD_TARGET
const BOSS_CARD_ID := "bone_warden"
const DEFAULT_ENCOUNTER_PATH := "res://resources/encounters/graveyard_ambush.tres"

const ARTIFACT_PATHS := {
	"dead_mans_shield": "res://resources/artifacts/dead_mans_shield.tres",
	"blind_quiver": "res://resources/artifacts/blind_quiver.tres",
	"cracked_focus": "res://resources/artifacts/cracked_focus.tres",
	"broken_crown": "res://resources/artifacts/broken_crown.tres"
}

const CARD_PATHS := {
	"bone_patrol": "res://resources/cards/bone_patrol.tres",
	"graveyard_ambush": "res://resources/cards/graveyard_ambush.tres",
	"whispering_well": "res://resources/cards/whispering_well.tres",
	"ash_rest": "res://resources/cards/ash_rest.tres",
	"debtor_bones": "res://resources/cards/debtor_bones.tres",
	"rattling_bridge": "res://resources/cards/rattling_bridge.tres",
	"lost_purse": "res://resources/cards/lost_purse.tres",
	"candle_seller": "res://resources/cards/candle_seller.tres",
	"gallows_volley": "res://resources/cards/gallows_volley.tres",
	"grave_bell": "res://resources/cards/grave_bell.tres",
	"bone_crush": "res://resources/cards/bone_crush.tres",
	"black_altar": "res://resources/cards/black_altar.tres",
	"chained_prisoner": "res://resources/cards/chained_prisoner.tres",
	"gravedigger_shop": "res://resources/cards/gravedigger_shop.tres",
	"curse_forge": "res://resources/cards/curse_forge.tres",
	"bone_tax": "res://resources/cards/bone_tax.tres",
	"crypt_guard": "res://resources/cards/crypt_guard.tres",
	"faceless_card": "res://resources/cards/faceless_card.tres",
	"wizard_tithe": "res://resources/cards/wizard_tithe.tres",
	"ossuary_gate": "res://resources/cards/ossuary_gate.tres",
	"blood_ledger": "res://resources/cards/blood_ledger.tres",
	"broken_crown": "res://resources/cards/broken_crown.tres",
	"last_camp": "res://resources/cards/last_camp.tres",
	"death_wager": "res://resources/cards/death_wager.tres",
	"bone_warden": "res://resources/cards/bone_warden.tres"
}

const ACT1_CARD_IDS := [
	"bone_patrol",
	"graveyard_ambush",
	"whispering_well",
	"ash_rest",
	"debtor_bones",
	"rattling_bridge",
	"lost_purse",
	"candle_seller",
	"gallows_volley",
	"grave_bell",
	"bone_crush",
	"black_altar",
	"chained_prisoner",
	"gravedigger_shop",
	"curse_forge",
	"bone_tax",
	"crypt_guard",
	"faceless_card",
	"wizard_tithe",
	"ossuary_gate",
	"blood_ledger",
	"broken_crown",
	"last_camp",
	"death_wager"
]

var gold: int = 0
var deals_survived: int = 0
var cards_resolved: int = 0
var party_hp_bonus: float = 0.0
var party_damage_bonus: float = 0.0
var last_battle_won := false
var selected_encounter_path: String = DEFAULT_ENCOUNTER_PATH
var whispering_well_resolved := false
var wizard_debt_active := false
var boss_defeated := false

var remaining_card_ids: Array[String] = []
var current_offer_ids: Array[String] = []
var rejected_card_ids: Array[String] = []
var resolved_card_ids: Array[String] = []
var active_card_id: String = ""
var artifact_ids: Array[String] = []

func _ready() -> void:
	if remaining_card_ids.is_empty() and resolved_card_ids.is_empty() and active_card_id.is_empty():
		reset_run()

func reset_run() -> void:
	gold = 0
	deals_survived = 0
	cards_resolved = 0
	party_hp_bonus = 0.0
	party_damage_bonus = 0.0
	last_battle_won = false
	selected_encounter_path = DEFAULT_ENCOUNTER_PATH
	whispering_well_resolved = false
	wizard_debt_active = false
	boss_defeated = false
	active_card_id = ""
	artifact_ids.clear()
	remaining_card_ids.clear()
	current_offer_ids.clear()
	rejected_card_ids.clear()
	resolved_card_ids.clear()

	for card_id in ACT1_CARD_IDS:
		remaining_card_ids.append(card_id)

func get_artifact(artifact_id: String) -> ArtifactData:
	var path: String = ARTIFACT_PATHS.get(artifact_id, "")
	if path.is_empty():
		push_warning("Unknown artifact id: %s" % artifact_id)
		return null

	var loaded := load(path)
	if loaded is ArtifactData:
		return loaded as ArtifactData

	push_warning("Could not load ArtifactData: %s" % path)
	return null

func has_artifact(artifact_id: String) -> bool:
	return artifact_ids.has(artifact_id)

func add_artifact(artifact_id: String) -> bool:
	if has_artifact(artifact_id):
		return false

	var artifact := get_artifact(artifact_id)
	if artifact == null:
		return false

	artifact_ids.append(artifact_id)
	return true

func get_available_artifact_ids() -> Array[String]:
	var available: Array[String] = []
	for artifact_id in ARTIFACT_PATHS.keys():
		var id := String(artifact_id)
		if has_artifact(id):
			continue

		var artifact := get_artifact(id)
		if artifact != null and artifact.general_pool:
			available.append(id)
	return available

func add_random_available_artifact() -> String:
	var available := get_available_artifact_ids()
	if available.is_empty():
		return ""

	available.shuffle()
	var artifact_id := available[0]
	add_artifact(artifact_id)
	return artifact_id

func get_artifacts_for_role(role: String) -> Array[ArtifactData]:
	var result: Array[ArtifactData] = []
	for artifact_id in artifact_ids:
		var artifact := get_artifact(artifact_id)
		if artifact != null and (artifact.target_role == role or artifact.target_role == "*"):
			result.append(artifact)
	return result

func get_artifact_titles_text() -> String:
	if artifact_ids.is_empty():
		return "нет"

	var titles: Array[String] = []
	for artifact_id in artifact_ids:
		var artifact := get_artifact(artifact_id)
		if artifact != null:
			titles.append(artifact.title)

	return ", ".join(titles)

func get_card(card_id: String) -> RunCardData:
	var path: String = CARD_PATHS.get(card_id, "")
	if path.is_empty():
		push_warning("Unknown run card id: %s" % card_id)
		return null

	var loaded := load(path)
	if loaded is RunCardData:
		return loaded as RunCardData

	push_warning("Could not load RunCardData: %s" % path)
	return null

func get_active_card() -> RunCardData:
	if active_card_id.is_empty():
		return null
	return get_card(active_card_id)

func has_active_card() -> bool:
	return not active_card_id.is_empty()

func is_boss_due() -> bool:
	return cards_resolved >= ACT_CARD_TARGET and not boss_defeated

func get_progress_text() -> String:
	if is_boss_due() or active_card_id == BOSS_CARD_ID:
		return "БОСС"
	return "КАРТА %d/%d" % [mini(cards_resolved + 1, ACT_CARD_TARGET), ACT_CARD_TARGET]

func get_offer_cards() -> Array[RunCardData]:
	_ensure_current_offers()

	var cards: Array[RunCardData] = []
	for card_id in current_offer_ids:
		var card := get_card(card_id)
		if card != null:
			cards.append(card)
	return cards

func _ensure_current_offers() -> void:
	if not active_card_id.is_empty():
		current_offer_ids.clear()
		current_offer_ids.append(active_card_id)
		return

	if not current_offer_ids.is_empty():
		return

	if is_boss_due():
		current_offer_ids.clear()
		current_offer_ids.append(BOSS_CARD_ID)
		return

	var tier := mini(int(cards_resolved / 4), 2)
	var candidates: Array[String] = []

	for card_id in remaining_card_ids:
		var card := get_card(card_id)
		if card != null and card.tier == tier:
			candidates.append(card_id)

	if candidates.size() < 2:
		candidates.clear()
		for card_id in remaining_card_ids:
			candidates.append(card_id)

	candidates.shuffle()
	var offer_count := mini(2, candidates.size())
	for index in range(offer_count):
		current_offer_ids.append(candidates[index])

func choose_card(card_id: String) -> bool:
	if active_card_id == card_id:
		return true

	if not active_card_id.is_empty():
		return false

	_ensure_current_offers()
	if not current_offer_ids.has(card_id):
		push_warning("Attempted to choose card outside the current offer: %s" % card_id)
		return false

	for offered_id in current_offer_ids:
		var remaining_index := remaining_card_ids.find(offered_id)
		if remaining_index >= 0:
			remaining_card_ids.remove_at(remaining_index)

		if offered_id != card_id:
			rejected_card_ids.append(offered_id)

	active_card_id = card_id
	current_offer_ids.clear()

	var card := get_active_card()
	if card != null and card.resolution_type == "combat":
		select_encounter(card.target_path)

	return true

func complete_active_card() -> void:
	var card := get_active_card()
	if card == null:
		push_warning("No active run card to complete.")
		return

	resolved_card_ids.append(card.card_id)

	if card.card_id == BOSS_CARD_ID:
		boss_defeated = true
	else:
		cards_resolved += 1

	if card.resolution_type == "combat":
		deals_survived += 1

	active_card_id = ""
	current_offer_ids.clear()
	selected_encounter_path = DEFAULT_ENCOUNTER_PATH

func select_encounter(encounter_path: String) -> void:
	selected_encounter_path = encounter_path

func is_run_complete() -> bool:
	return boss_defeated

func resolve_whispering_well() -> void:
	whispering_well_resolved = true

func activate_wizard_debt() -> void:
	wizard_debt_active = true

func get_enemy_damage_multiplier() -> float:
	return 1.25 if wizard_debt_active else 1.0

func get_reward_multiplier() -> int:
	return 2 if wizard_debt_active else 1

func get_run_condition_text() -> String:
	return "ДОЛГ ВОЛШЕБНИКУ" if wizard_debt_active else ""

func apply_reward(reward_id: String) -> void:
	var multiplier := get_reward_multiplier()

	match reward_id:
		"blood_coin":
			gold += 25 * multiplier
		"iron_ward":
			party_hp_bonus += 20.0 * multiplier
		"tempered_steel":
			party_damage_bonus += 3.0 * multiplier
		_:
			push_warning("Unknown reward id: %s" % reward_id)
			return

	if wizard_debt_active:
		wizard_debt_active = false
