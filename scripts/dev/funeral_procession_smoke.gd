extends Control

# D151 isolated simulated combat matrix. Runs real BattleUnit AI and Last Rite,
# not the main game UI, and does not alter the shipped 33-card deal pool.
const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/funeral_procession.tres")
const RITE_DATA: LastRiteData = preload("res://resources/encounters/last_rite.tres")
const RITE_CONTROLLER := preload("res://scripts/battle/last_rite.gd")
const ANIMATIONS := preload("res://scripts/battle/unit_animation_library.gd")
const ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")

const HERO_ROLES: Array[String] = ["knight", "ranger", "mage"]
const TACTICS: Array[String] = ["assault", "hunt", "formation"]
const STEP := 1.0 / 30.0
const MAX_SECONDS := 80.0
const COMBAT_BOUNDS := Rect2(Vector2(90, 284), Vector2(1080, 158))

var headline: Label
var summary: Label
var errors: Array[String] = []
var completed := 0
var victories := 0
var defeats := 0
var total_warnings := 0
var total_revives := 0
var total_furies := 0


func _ready() -> void:
	headline = Label.new()
	headline.text = "DECK EXPANSION 03 / FUNERAL PROCESSION — RUNNING"
	headline.position = Vector2(55, 100)
	headline.size = Vector2(1165, 100)
	headline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	headline.add_theme_font_size_override("font_size", 28)
	add_child(headline)

	summary = Label.new()
	summary.position = Vector2(75, 220)
	summary.size = Vector2(1130, 370)
	summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	summary.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	summary.add_theme_font_size_override("font_size", 19)
	add_child(summary)

	await _run_matrix()


func _run_matrix() -> void:
	_validate_assets()
	if errors.is_empty():
		_validate_facing()
	if errors.is_empty():
		for formation in range(2):
			for protagonist in range(3):
				for size in range(1, 4):
					for tactic in TACTICS:
						seed(51000 + formation * 1000 + protagonist * 100 + size * 10)
						var battle: Dictionary = await _fight(formation, protagonist, size, tactic)
						if battle.is_empty():
							break
						completed += 1
						if battle["outcome"] == "win":
							victories += 1
						else:
							defeats += 1
						total_warnings += int(battle["warnings"])
						total_revives += int(battle["revives"])
						total_furies += int(battle["furies"])
						summary.text = "%d/54 • %s • %d героя • %s\nПобед: %d • Поражений: %d" % [
							completed, HERO_ROLES[protagonist], size, tactic, victories, defeats]
						if not errors.is_empty():
							break
					if not errors.is_empty():
						break
				if not errors.is_empty():
					break
			if not errors.is_empty():
				break
	RunState.reset_run()
	if errors.is_empty() and completed != 54:
		errors.append("Only %d/54 battles completed" % completed)
	if errors.is_empty():
		headline.text = "DECK EXPANSION 03 / FUNERAL PROCESSION — PASS"
		summary.text = ("%d/54 боёв завершено • %d побед / %d поражений.\n"
			+ "Предупреждений: %d • воскрешений: %d • усилений: %d.\n"
			+ "Оригинальные ресурсы и оба атласа загружены.\n"
			+ "Это диагностический боевой smoke, НЕ оценка баланса.\n"
			+ "Реальный бой → награда → стол проверяется отдельно.") % [
			completed, victories, defeats, total_warnings, total_revives, total_furies]
		summary.add_theme_color_override("font_color", Color(0.56, 0.86, 0.68))
	else:
		headline.text = "DECK EXPANSION 03 / FUNERAL PROCESSION — FAIL"
		summary.text = "\n".join(errors.slice(0, 8))
		summary.add_theme_color_override("font_color", Color(0.96, 0.38, 0.36))
		push_error(summary.text)


func _validate_assets() -> void:
	var card := RunState.get_card("funeral_procession")
	if card == null or card.resolution_type != "combat" or card.tier != 1:
		errors.append("D151 card must be a Tier1 combat card in CARD_PATHS")
	if RunState.ACT1_CARD_IDS.size() != 33 or RunState.ACT1_CARD_IDS.has("funeral_procession"):
		errors.append("D151 should still be absent from the live 33-card deal pool")
	if ENCOUNTER.encounter_id != "funeral_procession" or ENCOUNTER.get_formation_count() != 2:
		errors.append("Missing both authored original formations")
	var expected := PackedStringArray([
		"res://resources/units/funeral_priest.tres",
		"res://resources/units/pallbearer.tres",
		"res://resources/units/pallbearer.tres"])
	if ENCOUNTER.enemy_unit_paths != expected:
		errors.append("Original 1+2 enemy roster changed")
	var card_art := ART_CATALOG.get_run_card_texture("funeral_procession")
	if card_art == null or card_art.get_size() != Vector2(448, 274):
		errors.append("Original D151 448×274 illustration missing")
	for role in ["funeral_priest", "pallbearer"]:
		var frames := ANIMATIONS.get_frames(role)
		if frames == null:
			errors.append("Animation atlas rejected or missing for " + role)
			continue
		for pair in [["idle", 4], ["walk", 6], ["attack", 6], ["hit", 3], ["death", 6]]:
			if frames.get_frame_count(String(pair[0])) != int(pair[1]):
				errors.append("Incomplete %s animation: %s" % [role, String(pair[0])])


# D151 regression: the new texture sheets face LEFT in their source frames,
# unlike legacy right-facing art. Check both deployment and combat retargeting.
func _validate_facing() -> void:
	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var hero_data := load("res://resources/units/knight.tres") as UnitData
	var old_enemy_data := load("res://resources/units/skeleton.tres") as UnitData
	if hero_data == null or old_enemy_data == null:
		errors.append("Facing QA fixture resources missing")
		arena.queue_free()
		return
	var hero := _make_unit(arena, hero_data, 0, Vector2(260, 350), "assault")
	var old_enemy := _make_unit(arena, old_enemy_data, 1, Vector2(820, 350), "assault")
	if hero.art_sprite.flip_h or not old_enemy.art_sprite.flip_h:
		errors.append("Hero or legacy skeleton deployment orientation changed")
	for resource_path in [
		"res://resources/units/funeral_priest.tres",
		"res://resources/units/pallbearer.tres",
	]:
		var data := load(resource_path) as UnitData
		if data == null:
			errors.append("Facing QA unit data missing: " + resource_path)
			continue
		var enemy := _make_unit(arena, data, 1, Vector2(800, 350), "assault")
		if enemy.art_sprite.flip_h:
			errors.append("D151 native-left enemy is mirrored away during deployment: " + data.visual_role)
		enemy.combat_started = true
		enemy.target = hero
		enemy._update_unit_facing()
		if enemy.art_sprite.flip_h:
			errors.append("D151 enemy is mirrored away from hero on left: " + data.visual_role)
		hero.position.x = 1090.0
		enemy._update_unit_facing()
		if not enemy.art_sprite.flip_h:
			errors.append("D151 enemy failed to turn toward target on right: " + data.visual_role)
		hero.position.x = 260.0
		legacy_facing_reset(enemy)
	arena.queue_free()


func legacy_facing_reset(enemy: BattleUnit) -> void:
	enemy.target = null
	enemy.combat_started = false


func _make_unit(arena: Node2D, data: UnitData, team: int, pos: Vector2, tactic: String) -> BattleUnit:
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.configure(data, team, pos)
	if team == 0:
		unit.max_hp *= RunState.get_party_hp_multiplier()
		unit.damage *= RunState.get_party_damage_multiplier()
		unit.attack_interval *= RunState.get_party_attack_interval_multiplier()
		unit.move_speed *= RunState.get_party_move_speed_multiplier()
		unit.set_tactical_order(tactic)
	else:
		unit.max_hp *= RunState.get_enemy_hp_multiplier()
		unit.damage *= RunState.get_enemy_damage_multiplier()
	unit.set_combat_bounds(COMBAT_BOUNDS)
	unit.set_process(false)
	arena.add_child(unit)
	return unit


func _fixture(formation: int, protagonist: int, size: int, tactic: String) -> Dictionary:
	RunState.reset_run()
	RunState.choose_protagonist(HERO_ROLES[protagonist])
	for teammate in range(1, size):
		RunState.recruit_companion(HERO_ROLES[(protagonist + teammate) % 3], "D151 QA")
	var arena := Node2D.new()
	arena.visible = false
	add_child(arena)
	var heroes: Array[BattleUnit] = []
	var enemies: Array[BattleUnit] = []
	var spawns := [Vector2(280, 340), Vector2(320, 411), Vector2(335, 305)]
	for i in range(RunState.party_roles.size()):
		var data := RunState.get_hero_unit_data(RunState.party_roles[i])
		heroes.append(_make_unit(arena, data, 0, spawns[i], tactic))
	var enemy_spawns := ENCOUNTER.get_enemy_positions_for_formation(formation)
	for i in range(3):
		var data := load(ENCOUNTER.enemy_unit_paths[i]) as UnitData
		var depth: float = clampf((enemy_spawns[i].y - 130.0) / 275.0, 0.0, 1.0)
		enemies.append(_make_unit(arena, data, 1,
			Vector2(enemy_spawns[i].x, lerpf(316.0, 410.0, depth)), tactic))
	var controller := RITE_CONTROLLER.new() as LastRiteController
	arena.add_child(controller)
	var bearers: Array[BattleUnit] = [enemies[1], enemies[2]]
	controller.configure(enemies[0], bearers, RITE_DATA)
	controller.set_process(false)
	return {"arena": arena, "heroes": heroes, "enemies": enemies, "controller": controller}


func _fight(formation: int, protagonist: int, size: int, tactic: String) -> Dictionary:
	var state := _fixture(formation, protagonist, size, tactic)
	var all_units: Array[BattleUnit] = []
	all_units.append_array(state["heroes"])
	all_units.append_array(state["enemies"])
	var controller: LastRiteController = state["controller"]
	for unit in all_units:
		unit.start_combat()
	controller.start_rite()
	controller.set_process(false)
	var elapsed := 0.0
	var frames := 0
	var verdict := ""
	while elapsed < MAX_SECONDS:
		for unit in all_units:
			if unit.alive:
				unit._process(STEP)
		controller.advance_battle(STEP)
		elapsed += STEP
		frames += 1
		var living_heroes := 0
		var living_enemies := 0
		for unit in all_units:
			if not unit.alive:
				continue
			if unit.team == 0:
				living_heroes += 1
			else:
				living_enemies += 1
		if living_enemies == 0:
			verdict = "win"
			break
		if living_heroes == 0:
			verdict = "loss"
			break
		if frames % 90 == 0:
			await get_tree().process_frame
	if verdict.is_empty():
		errors.append("Timeout: %d / %s / size %d / %s" % [
			formation, HERO_ROLES[protagonist], size, tactic])
	var effects := {
		"warnings": controller.warning_count,
		"revives": controller.revive_count,
		"furies": controller.fury_count}
	controller.stop_rite()
	(state["arena"] as Node2D).queue_free()
	await get_tree().process_frame
	if verdict.is_empty():
		return {}
	effects["outcome"] = verdict
	return effects
