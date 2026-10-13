extends Control

# Godot F6 only. Tests real EncounterData, BattleUnit target previews and
# party-size pressure without changing combat stats or the user's live run.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const HERO_ROLES: Array[String] = ["knight", "ranger", "mage"]
const ENCOUNTER_PATHS: Array[String] = [
	"res://resources/encounters/bone_swarm.tres",
	"res://resources/encounters/iron_wall.tres",
	"res://resources/encounters/grave_bell.tres"
]
const EXPECTED_ROLES := {
	"bone_swarm": ["bone_thrall", "bone_thrall", "bone_thrall", "bone_thrall"],
	"iron_wall": ["crypt_guard", "crypt_guard", "bone_archer"],
	"grave_bell": ["skeleton", "skeleton", "grave_bellkeeper"]
}
const HUNT_PRIORITY := {
	"iron_wall": "bone_archer",
	"grave_bell": "grave_bellkeeper"
}
const ORDER_IDS: Array[String] = ["assault", "hunt", "formation"]
const EXPECTED_ENEMY_HP := [0.82, 0.92, 1.0]
const EXPECTED_ENEMY_DAMAGE := [0.80, 0.90, 1.0]

var problems: Array[String] = []
var setups_checked := 0
var target_checks := 0
var differentiated_orders := 0


func _ready() -> void:
	var heading := Label.new()
	heading.position = Vector2(50, 76)
	heading.size = Vector2(1180, 130)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 29)
	heading.add_theme_color_override("font_color", Color(0.91, 0.77, 0.56))
	add_child(heading)

	var info := Label.new()
	info.position = Vector2(70, 228)
	info.size = Vector2(1140, 395)
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.add_theme_font_size_override("font_size", 20)
	add_child(info)
	heading.text = "TACTICAL GAMEPLAY 2.1 — CHECKING"
	info.text = "Проверка карт, построений и реальных начальных целей..."
	await _run_suite()

	if problems.is_empty():
		heading.text = "TACTICAL GAMEPLAY 2.1 — PASS"
		info.text = "%d построения × составы и герои.\n%d проверок начальных целей для трёх приказов.\n%d раз ОХОТА отличалась от НАТИСКА.\nВраги соответствуют картам; повторы сохраняют построение.\nЭто тест подготовки, не симуляция победы в бою." % [setups_checked, target_checks, differentiated_orders]
		info.add_theme_color_override("font_color", Color(0.56, 0.84, 0.69))
	else:
		heading.text = "TACTICAL GAMEPLAY 2.1 — FAIL"
		info.text = "\n".join(problems.slice(0, 8))
		info.add_theme_color_override("font_color", Color(0.94, 0.45, 0.38))
		push_error(info.text)
	RunState.reset_run()


func _run_suite() -> void:
	for path in ENCOUNTER_PATHS:
		var encounter := load(path) as EncounterData
		if encounter == null:
			problems.append("Missing encounter: %s" % path)
			return
		if encounter.get_formation_count() != 2:
			problems.append("%s: expected two authored formations" % encounter.encounter_id)
			return
		var expected: Array = EXPECTED_ROLES[encounter.encounter_id]
		if encounter.enemy_unit_paths.size() != expected.size():
			problems.append("%s: enemy roster size changed" % encounter.encounter_id)
			return

		for i in range(expected.size()):
			var enemy_data := load(encounter.enemy_unit_paths[i]) as UnitData
			if enemy_data == null or enemy_data.visual_role != String(expected[i]):
				problems.append("%s: enemy %d no longer matches its card" % [encounter.encounter_id, i])
				return

		for variant in range(2):
			var positions: PackedVector2Array = encounter.get_enemy_positions_for_formation(variant)
			if positions.size() != expected.size() or encounter.get_formation_hint(variant).is_empty():
				problems.append("%s: broken formation %d" % [encounter.encounter_id, variant])
				return
			for i in range(positions.size()):
				if positions[i].x < 760.0 or positions[i].x > 1150.0 or positions[i].y < 125.0 or positions[i].y > 405.0:
					problems.append("%s: unsafe spawn %d in formation %d" % [encounter.encounter_id, i, variant])
					return
				for j in range(i + 1, positions.size()):
					if positions[i].distance_to(positions[j]) < 48.0:
						problems.append("%s: overlapping spawns in formation %d" % [encounter.encounter_id, variant])
						return

		for party_size in range(1, 4):
			for protagonist in HERO_ROLES:
				seed(21700 + setups_checked)
				RunState.reset_run()
				if not RunState.choose_protagonist(protagonist):
					problems.append("Cannot select %s" % protagonist)
					return
				for role in HERO_ROLES:
					if RunState.get_party_size() >= party_size:
						break
					if role != protagonist:
						RunState.recruit_companion(role, "F6 tactical check")
				if RunState.get_party_size() != party_size:
					problems.append("Party %d not assembled" % party_size)
					return
				if not is_equal_approx(RunState.get_enemy_hp_multiplier(), EXPECTED_ENEMY_HP[party_size - 1]) or not is_equal_approx(RunState.get_enemy_base_damage_multiplier(), EXPECTED_ENEMY_DAMAGE[party_size - 1]):
					problems.append("Party %d: enemy pressure unexpectedly changed" % party_size)
					return

				var sampled_variant: int = RunState.get_combat_formation_variant(encounter.encounter_id, 2)
				if sampled_variant != RunState.get_combat_formation_variant(encounter.encounter_id, 2):
					problems.append("%s: deployment changed on retry" % encounter.encounter_id)
					return

				for variant in range(2):
					var battlefield := Node2D.new()
					battlefield.visible = false
					add_child(battlefield)
					var heroes: Array[BattleUnit] = []
					var enemies: Array[BattleUnit] = []
					var positions: PackedVector2Array = encounter.get_enemy_positions_for_formation(variant)

					for index in range(party_size):
						var role: String = RunState.party_roles[index]
						var data := RunState.get_hero_unit_data(role)
						if data == null:
							problems.append("Hero resource missing: %s" % role)
							break
						var hero := UNIT_SCENE.instantiate() as BattleUnit
						hero.configure(data, 0, Vector2(210.0 + index * 130.0, 235.0 + index * 65.0))
						battlefield.add_child(hero)
						heroes.append(hero)

					for index in range(encounter.enemy_unit_paths.size()):
						var data := load(encounter.enemy_unit_paths[index]) as UnitData
						var foe := UNIT_SCENE.instantiate() as BattleUnit
						foe.configure(data, 1, positions[index])
						battlefield.add_child(foe)
						enemies.append(foe)

					if problems.is_empty():
						for hero in heroes:
							var assault_target: BattleUnit = null
							for order_id in ORDER_IDS:
								hero.set_tactical_order(order_id)
								var chosen: BattleUnit = hero.get_preview_target()
								target_checks += 1
								if chosen == null or not enemies.has(chosen):
									problems.append("%s: %s has invalid %s target" % [encounter.encounter_id, hero.visual_role, order_id])
									break
								if order_id == "assault":
									assault_target = chosen
								if order_id == "hunt" and HUNT_PRIORITY.has(encounter.encounter_id):
									if chosen.visual_role != String(HUNT_PRIORITY[encounter.encounter_id]):
										problems.append("%s: HUNT ignores the authored ranged/support threat" % encounter.encounter_id)
										break
									if chosen != assault_target:
										differentiated_orders += 1
							if not problems.is_empty():
								break
					setups_checked += 1
					battlefield.queue_free()
					await get_tree().process_frame
					if not problems.is_empty():
						return

	if differentiated_orders == 0:
		problems.append("HUNT and ASSAULT never diverged")
