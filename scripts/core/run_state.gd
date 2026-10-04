extends Node

const MAX_DEALS: int = 3
const DEFAULT_ENCOUNTER_PATH := "res://resources/encounters/graveyard_ambush.tres"

var gold: int = 0
var deals_survived: int = 0
var party_hp_bonus: float = 0.0
var party_damage_bonus: float = 0.0
var last_battle_won := false
var selected_encounter_path: String = DEFAULT_ENCOUNTER_PATH
var whispering_well_resolved := false

func reset_run() -> void:
	gold = 0
	deals_survived = 0
	party_hp_bonus = 0.0
	party_damage_bonus = 0.0
	last_battle_won = false
	selected_encounter_path = DEFAULT_ENCOUNTER_PATH
	whispering_well_resolved = false

func select_encounter(encounter_path: String) -> void:
	selected_encounter_path = encounter_path

func is_run_complete() -> bool:
	return deals_survived >= MAX_DEALS

func resolve_whispering_well() -> void:
	whispering_well_resolved = true

func apply_reward(reward_id: String) -> void:
	match reward_id:
		"blood_coin":
			gold += 25
		"iron_ward":
			party_hp_bonus += 20.0
		"tempered_steel":
			party_damage_bonus += 3.0
		_:
			push_warning("Unknown reward id: %s" % reward_id)
			return

	deals_survived += 1
