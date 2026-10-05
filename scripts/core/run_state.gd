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

const HERO_ROLES: Array[String] = ["knight", "ranger", "mage"]
const HERO_UPGRADE_PATHS := {
	"knight_iron_oath": "res://resources/upgrades/knight_iron_oath.tres",
	"knight_executioner": "res://resources/upgrades/knight_executioner.tres",
	"knight_cleaver": "res://resources/upgrades/knight_cleaver.tres",
	"ranger_longshot": "res://resources/upgrades/ranger_longshot.tres",
	"ranger_arrowstorm": "res://resources/upgrades/ranger_arrowstorm.tres",
	"ranger_beast_trail": "res://resources/upgrades/ranger_beast_trail.tres",
	"mage_wildfire": "res://resources/upgrades/mage_wildfire.tres",
	"mage_glass_heart": "res://resources/upgrades/mage_glass_heart.tres",
	"mage_overload": "res://resources/upgrades/mage_overload.tres"
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
var hero_upgrade_ids: Array[String] = []
var claimed_upgrade_tiers: Array[int] = []
var current_major_upgrade_offer_ids: Array[String] = []
var current_bonus_upgrade_offer_ids: Array[String] = []
var forced_combat_slots: Array[int] = []

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
	hero_upgrade_ids.clear()
	claimed_upgrade_tiers.clear()
	current_major_upgrade_offer_ids.clear()
	current_bonus_upgrade_offer_ids.clear()
	forced_combat_slots.clear()
	remaining_card_ids.clear()
	current_offer_ids.clear()
	rejected_card_ids.clear()
	resolved_card_ids.clear()

	for card_id in ACT1_CARD_IDS:
		remaining_card_ids.append(card_id)

	for _tier in range(3):
		forced_combat_slots.append(randi_range(0, 2))

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

func get_hero_upgrade(upgrade_id: String) -> HeroUpgradeData:
	var path: String = HERO_UPGRADE_PATHS.get(upgrade_id, "")
	if path.is_empty():
		push_warning("Unknown hero upgrade id: %s" % upgrade_id)
		return null

	var loaded := load(path)
	if loaded is HeroUpgradeData:
		return loaded as HeroUpgradeData

	push_warning("Could not load HeroUpgradeData: %s" % path)
	return null

func has_hero_upgrade(upgrade_id: String) -> bool:
	return hero_upgrade_ids.has(upgrade_id)

func add_hero_upgrade(upgrade_id: String) -> bool:
	if has_hero_upgrade(upgrade_id):
		return false

	var upgrade := get_hero_upgrade(upgrade_id)
	if upgrade == null:
		return false

	hero_upgrade_ids.append(upgrade_id)
	return true

func get_hero_upgrades_for_role(role: String) -> Array[HeroUpgradeData]:
	var result: Array[HeroUpgradeData] = []
	for upgrade_id in hero_upgrade_ids:
		var upgrade := get_hero_upgrade(upgrade_id)
		if upgrade != null and upgrade.target_role == role:
			result.append(upgrade)
	return result

func get_available_hero_upgrade_ids_for_role(role: String) -> Array[String]:
	var available: Array[String] = []
	for upgrade_id_value in HERO_UPGRADE_PATHS.keys():
		var upgrade_id := String(upgrade_id_value)
		if has_hero_upgrade(upgrade_id):
			continue

		var upgrade := get_hero_upgrade(upgrade_id)
		if upgrade != null and upgrade.target_role == role:
			available.append(upgrade_id)

	return available

func get_hero_upgrade_titles_text() -> String:
	if hero_upgrade_ids.is_empty():
		return "нет"

	var titles: Array[String] = []
	for upgrade_id in hero_upgrade_ids:
		var upgrade := get_hero_upgrade(upgrade_id)
		if upgrade != null:
			titles.append(upgrade.title)

	return ", ".join(titles)

func get_role_upgrade_count(role: String) -> int:
	var count := 0
	for upgrade_id in hero_upgrade_ids:
		var upgrade := get_hero_upgrade(upgrade_id)
		if upgrade != null and upgrade.target_role == role:
			count += 1
	return count

func get_next_available_hero_upgrade_id(role: String) -> String:
	var available := get_available_hero_upgrade_ids_for_role(role)
	if available.is_empty():
		return ""

	available.sort()
	return available[0]

func add_next_available_hero_upgrade(role: String) -> String:
	var upgrade_id := get_next_available_hero_upgrade_id(role)
	if upgrade_id.is_empty():
		return ""
	if not add_hero_upgrade(upgrade_id):
		return ""
	return upgrade_id

func get_least_developed_available_role() -> String:
	var best_role := ""
	var best_count := 999

	for role in HERO_ROLES:
		if get_next_available_hero_upgrade_id(role).is_empty():
			continue

		var count := get_role_upgrade_count(role)
		if count < best_count:
			best_count = count
			best_role = role

	return best_role

func add_upgrade_to_least_developed_role() -> String:
	var role := get_least_developed_available_role()
	if role.is_empty():
		return ""
	return add_next_available_hero_upgrade(role)

func get_last_hero_upgrade_id() -> String:
	if hero_upgrade_ids.is_empty():
		return ""
	return hero_upgrade_ids[hero_upgrade_ids.size() - 1]

func remove_last_hero_upgrade() -> String:
	var upgrade_id := get_last_hero_upgrade_id()
	if upgrade_id.is_empty():
		return ""

	hero_upgrade_ids.remove_at(hero_upgrade_ids.size() - 1)
	return upgrade_id

func clear_wizard_debt() -> void:
	wizard_debt_active = false

func is_major_upgrade_due_for_active_card() -> bool:
	var card := get_active_card()
	if card == null or card.resolution_type != "combat" or card.card_id == BOSS_CARD_ID:
		return false
	if card.tier < 0 or card.tier > 2:
		return false
	return not claimed_upgrade_tiers.has(card.tier)

func get_major_upgrade_offer_ids() -> Array[String]:
	if not is_major_upgrade_due_for_active_card():
		current_major_upgrade_offer_ids.clear()
		return []

	if not current_major_upgrade_offer_ids.is_empty():
		return current_major_upgrade_offer_ids.duplicate()

	for role in HERO_ROLES:
		var available := get_available_hero_upgrade_ids_for_role(role)
		if available.is_empty():
			continue
		available.shuffle()
		current_major_upgrade_offer_ids.append(available[0])

	return current_major_upgrade_offer_ids.duplicate()

func claim_major_upgrade(upgrade_id: String) -> bool:
	if not is_major_upgrade_due_for_active_card():
		return false

	var offer := get_major_upgrade_offer_ids()
	if not offer.has(upgrade_id):
		return false
	if not add_hero_upgrade(upgrade_id):
		return false

	var card := get_active_card()
	if card != null and not claimed_upgrade_tiers.has(card.tier):
		claimed_upgrade_tiers.append(card.tier)

	current_major_upgrade_offer_ids.clear()
	current_bonus_upgrade_offer_ids.clear()
	return true

func get_bonus_upgrade_offer_ids() -> Array[String]:
	if not current_bonus_upgrade_offer_ids.is_empty():
		return current_bonus_upgrade_offer_ids.duplicate()

	for role in HERO_ROLES:
		var available := get_available_hero_upgrade_ids_for_role(role)
		if available.is_empty():
			continue
		available.shuffle()
		current_bonus_upgrade_offer_ids.append(available[0])

	if current_bonus_upgrade_offer_ids.size() < 3:
		var all_available: Array[String] = []
		for upgrade_id_value in HERO_UPGRADE_PATHS.keys():
			var upgrade_id := String(upgrade_id_value)
			if has_hero_upgrade(upgrade_id) or current_bonus_upgrade_offer_ids.has(upgrade_id):
				continue
			all_available.append(upgrade_id)
		all_available.shuffle()
		for upgrade_id in all_available:
			if current_bonus_upgrade_offer_ids.size() >= 3:
				break
			current_bonus_upgrade_offer_ids.append(upgrade_id)

	return current_bonus_upgrade_offer_ids.duplicate()

func claim_bonus_upgrade(upgrade_id: String) -> bool:
	var offer := get_bonus_upgrade_offer_ids()
	if not offer.has(upgrade_id):
		return false
	if not add_hero_upgrade(upgrade_id):
		return false
	current_bonus_upgrade_offer_ids.clear()
	return true

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
	var slot_in_tier := cards_resolved % 4
	var tier_candidates: Array[String] = []

	for card_id in remaining_card_ids:
		var card := get_card(card_id)
		if card != null and card.tier == tier:
			tier_candidates.append(card_id)

	var candidates: Array[String] = []
	var forced_slot := forced_combat_slots[tier] if tier < forced_combat_slots.size() else 0

	if slot_in_tier < forced_slot:
		for card_id in tier_candidates:
			if not _is_combat_card_id(card_id):
				candidates.append(card_id)
	elif slot_in_tier == forced_slot:
		for card_id in tier_candidates:
			if _is_combat_card_id(card_id):
				candidates.append(card_id)
	else:
		candidates = tier_candidates.duplicate()

	if candidates.size() < 2:
		candidates = tier_candidates.duplicate()

	if candidates.size() < 2:
		candidates.clear()
		for card_id in remaining_card_ids:
			candidates.append(card_id)

	candidates.shuffle()
	var offer_count := mini(2, candidates.size())
	for index in range(offer_count):
		current_offer_ids.append(candidates[index])

func _is_combat_card_id(card_id: String) -> bool:
	var card := get_card(card_id)
	return card != null and card.resolution_type == "combat"

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
