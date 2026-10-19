extends "res://scripts/dev/black_lantern_road_battle_matrix.gd"

# D260 data-only balance assessment of ORIGINAL real BattleUnit/RunState combat.
# Expected 37-card hold BEFORE release. Avoid adjusting shared stats to win QA.
func _ready() -> void:
	await super._ready()
	var average_hp := [
		snappedf(hp_per_size[0] / 18.0, 0.0001),
		snappedf(hp_per_size[1] / 18.0, 0.0001),
		snappedf(hp_per_size[2] / 18.0, 0.0001),
	]
	var avg_seconds := [
		snappedf(duration_per_size[0] / 18.0, 0.0001),
		snappedf(duration_per_size[1] / 18.0, 0.0001),
		snappedf(duration_per_size[2] / 18.0, 0.0001),
	]
	var result := {
		"version": "D260_PRE_RELEASE",
		"completed": completed,
		"wins_by_party_size": wins_per_size,
		"wins_by_protagonist": wins_per_class,
		"victories": victories,
		"defeats": defeats,
		"timeouts": timeouts,
		"average_hero_hp_fraction_by_party_size": average_hp,
		"lowest_hero_hp_fraction_by_party_size": worst_hp,
		"average_seconds_by_party_size": avg_seconds,
		"fallen_heroes_by_party_size": fallen_per_size,
		"light_warnings": light_warnings,
		"lit_enemy_attacks": lit_enemy_attacks,
		"all_enemy_attacks": enemy_attacks,
		"failures": failures,
	}
	print("D260_BALANCE_DIAGNOSTICS ", JSON.stringify(result))
	get_tree().quit(0 if failures.is_empty() and completed == TOTAL_CASES and timeouts == 0 else 1)
