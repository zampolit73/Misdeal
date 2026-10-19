extends "res://scripts/dev/black_lantern_road_battle_matrix.gd"

# D258 native Godot 4.7 CI gate: executes the EXISTING 54-case BattleUnit
# combat matrix with live #38 roster and authored lanternlight. No art swap,
# release flags or battle balance modifications; reports real numeric outcomes.
func _ready() -> void:
	await super._ready()
	var report := {
		"test": "D258_BLACK_LANTERN_54_CASE",
		"completed": completed,
		"victories": victories,
		"defeats": defeats,
		"timeouts": timeouts,
		"wins_party_size": wins_per_size,
		"wins_protagonist": wins_per_class,
		"hero_losses_party_size": fallen_per_size,
		"light_warnings": light_warnings,
		"light_active_steps": light_active_steps,
		"lit_enemy_attacks": lit_enemy_attacks,
		"enemy_attacks": enemy_attacks,
		"failure_count": failures.size(),
		"failures": failures
	}
	var success: bool = failures.is_empty() and completed == TOTAL_CASES and victories + defeats + timeouts == TOTAL_CASES
	print("D258_MATRIX_RESULT ", JSON.stringify(report))
	get_tree().quit(0 if success else 1)
