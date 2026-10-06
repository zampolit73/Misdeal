extends Control

const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const DEFAULT_ENCOUNTER: EncounterData = preload("res://resources/encounters/graveyard_ambush.tres")

const COMBAT_BOUNDS := Rect2(Vector2.ZERO, Vector2(1240, 465))
const PLAYER_PLACEMENT_BOUNDS := Rect2(Vector2(35, 82), Vector2(545, 326))

const TACTICAL_ORDER_ASSAULT := "assault"
const TACTICAL_ORDER_HUNT := "hunt"
const TACTICAL_ORDER_FORMATION := "formation"

@onready var title_label: Label = $Title
@onready var deal_label: Label = $DealLabel
@onready var enemy_label: Label = $EnemyLabel
@onready var arena_visual: Control = $Arena
@onready var combat_audio: Node = $CombatAudio
@onready var units_layer: Node2D = $UnitsLayer
@onready var status_label: Label = $Status
@onready var fight_button: Button = $FightButton
@onready var restart_button: Button = $RestartButton
@onready var continue_button: Button = $ContinueButton
@onready var result_scrim: ColorRect = $ResultOverlay/ResultScrim
@onready var result_backdrop: Panel = $ResultOverlay/ResultBackdrop
@onready var result_label: Label = $ResultOverlay/Result
@onready var result_subtitle: Label = $ResultOverlay/ResultSubtitle
@onready var placement_hint: Label = $PlacementHint
@onready var order_label: Label = $OrderLabel
@onready var assault_order_button: Button = $AssaultOrderButton
@onready var hunt_order_button: Button = $HuntOrderButton
@onready var formation_order_button: Button = $FormationOrderButton
@onready var order_description_label: Label = $OrderDescription

var encounter: EncounterData
var units: Array[BattleUnit] = []
var combat_started := false
var battle_finished := false
var boss_reinforcements_spawned := false
var tactical_order := TACTICAL_ORDER_ASSAULT

func _ready() -> void:
	if not RunState.has_chosen_protagonist():
		get_tree().change_scene_to_file("res://scenes/class_select/class_select.tscn")
		return

	fight_button.pressed.connect(_on_fight_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	assault_order_button.pressed.connect(_on_assault_order_pressed)
	hunt_order_button.pressed.connect(_on_hunt_order_pressed)
	formation_order_button.pressed.connect(_on_formation_order_pressed)
	assault_order_button.tooltip_text = "Ближайшая цель и +15% скорость движения."
	hunt_order_button.tooltip_text = "Сначала поддержка и дальние враги."
	formation_order_button.tooltip_text = "Фокус угрозы рядом с самым уязвимым союзником."
	restart_button.disabled = true
	continue_button.visible = false
	continue_button.disabled = true
	encounter = _load_selected_encounter()
	if arena_visual.has_method("set_arena_id"):
		arena_visual.call("set_arena_id", encounter.arena_id)
	if arena_visual.has_method("set_boss_mode"):
		arena_visual.call("set_boss_mode", _is_boss_encounter())
	title_label.text = "MISDEAL — %s" % encounter.title
	deal_label.text = RunState.get_progress_text()
	if _is_boss_encounter():
		enemy_label.text = "БОСС • ФАЗА I"
		title_label.add_theme_color_override("font_color", Color(1.0, 0.72, 0.42, 1.0))
	elif _is_death_wager_encounter():
		enemy_label.text = "СТАВКА"
	elif _is_elite_encounter():
		enemy_label.text = "ЭЛИТА"
	else:
		enemy_label.text = "НЕЖИТЬ"
	result_scrim.visible = false
	result_backdrop.visible = false
	_spawn_encounter()
	_begin_preparation_phase()

func _is_boss_encounter() -> bool:
	return encounter != null and encounter.encounter_id == "bone_warden"

func _is_elite_encounter() -> bool:
	return encounter != null and encounter.encounter_id == "crypt_guard"

func _is_death_wager_encounter() -> bool:
	return encounter != null and encounter.encounter_id == "death_wager"

func _load_selected_encounter() -> EncounterData:
	if not RunState.selected_encounter_path.is_empty():
		var loaded := load(RunState.selected_encounter_path)
		if loaded is EncounterData:
			return loaded as EncounterData

	push_warning("Could not load selected encounter, using Graveyard Ambush.")
	return DEFAULT_ENCOUNTER

func _spawn_encounter() -> void:
	var party_positions := _get_party_spawn_positions()
	for index in range(RunState.party_roles.size()):
		var role := RunState.party_roles[index]
		var hero_data := RunState.get_hero_unit_data(role)
		if hero_data == null:
			push_warning("Could not load party UnitData for role: %s" % role)
			continue

		var position_index: int = mini(index, party_positions.size() - 1)
		var spawn_position: Vector2 = party_positions[position_index]
		_spawn_unit(hero_data, 0, spawn_position)

	var enemy_count: int = mini(encounter.enemy_unit_paths.size(), encounter.enemy_positions.size())

	for index in range(enemy_count):
		var enemy_data := load(encounter.enemy_unit_paths[index]) as UnitData
		if enemy_data == null:
			push_warning("Could not load enemy UnitData: %s" % encounter.enemy_unit_paths[index])
			continue

		var enemy_name := enemy_data.unit_name
		if index < encounter.enemy_names.size() and not encounter.enemy_names[index].is_empty():
			enemy_name = encounter.enemy_names[index]

		_spawn_unit(enemy_data, 1, encounter.enemy_positions[index], enemy_name)

func _get_party_spawn_positions() -> Array[Vector2]:
	match RunState.get_party_size():
		1:
			return [Vector2(270, 245)]
		2:
			return [
				Vector2(235, 180),
				Vector2(235, 315)
			]
		_:
			return [
				Vector2(280, 140),
				Vector2(210, 245),
				Vector2(280, 355)
			]

func _spawn_unit(
	data: UnitData,
	team: int,
	spawn_position: Vector2,
	name_override: String = ""
) -> void:
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.configure(data, team, spawn_position, name_override)

	if team == 0:
		unit.max_hp += RunState.party_hp_bonus
		unit.damage += RunState.party_damage_bonus
		_apply_hero_upgrades_to_unit(unit)
		_apply_artifacts_to_unit(unit)
		unit.max_hp *= RunState.get_party_hp_multiplier()
		unit.damage *= RunState.get_party_damage_multiplier()
		unit.attack_interval = maxf(0.2, unit.attack_interval * RunState.get_party_attack_interval_multiplier())
		unit.move_speed *= RunState.get_party_move_speed_multiplier()
		unit.max_hp = maxf(20.0, unit.max_hp)
		unit.damage = maxf(1.0, unit.damage)
	else:
		unit.damage *= RunState.get_enemy_damage_multiplier()

	if team == 0:
		unit.set_tactical_order(tactical_order)

	unit.set_combat_bounds(COMBAT_BOUNDS)
	unit.died.connect(_on_unit_died)
	unit.placement_rejected.connect(_on_placement_rejected)
	if unit.is_boss:
		unit.boss_enraged.connect(_on_boss_enraged)
	units_layer.add_child(unit)
	units.append(unit)

	if combat_started:
		unit.start_combat()

func _apply_hero_upgrades_to_unit(unit: BattleUnit) -> void:
	for upgrade in RunState.get_hero_upgrades_for_role(unit.visual_role):
		unit.max_hp += upgrade.hp_bonus
		unit.damage *= upgrade.damage_multiplier
		unit.attack_interval = maxf(0.2, unit.attack_interval * upgrade.attack_interval_multiplier)
		unit.attack_range += upgrade.attack_range_bonus
		unit.minimum_range += upgrade.minimum_range_bonus
		unit.splash_radius += upgrade.splash_radius_bonus
		unit.splash_damage_multiplier += upgrade.splash_damage_bonus
		unit.move_speed *= upgrade.move_speed_multiplier

func _apply_artifacts_to_unit(unit: BattleUnit) -> void:
	for artifact in RunState.get_artifacts_for_role(unit.visual_role):
		unit.max_hp += artifact.hp_bonus
		unit.damage *= artifact.damage_multiplier
		unit.attack_interval = maxf(0.2, unit.attack_interval * artifact.attack_interval_multiplier)
		unit.attack_range += artifact.attack_range_bonus
		unit.minimum_range += artifact.minimum_range_bonus
		unit.splash_radius += artifact.splash_radius_bonus
		unit.splash_damage_multiplier += artifact.splash_damage_bonus
		unit.move_speed *= artifact.move_speed_multiplier

func _begin_preparation_phase() -> void:
	if _is_boss_encounter():
		status_label.text = "БОСС — надзиратель бьёт по площади. На половине здоровья начнётся вторая фаза."
	elif _is_death_wager_encounter():
		status_label.text = "СТАВКА НА СМЕРТЬ — пять врагов и усиленная награда. Лучников лучше не оставлять без внимания."
	elif _is_elite_encounter():
		status_label.text = "ЭЛИТА — страж бьёт по площади. Не собирайте героев в одну точку."
	elif encounter.encounter_id == "grave_bell":
		status_label.text = "МОГИЛЬНЫЙ ЗВОН — звонарь периодически лечит ближайшую нежить."
	elif encounter.encounter_id == "bone_crush":
		status_label.text = "КОСТЯНАЯ ДАВКА — пять слабых врагов. Маг особенно полезен против толпы."
	elif encounter.encounter_id == "ossuary_gate":
		status_label.text = "ВРАТА ОССУАРИЯ — страж держит фронт, звонарь лечит, лучник давит с тыла."
	else:
		status_label.text = "ПОДГОТОВКА — расставьте героев и нажмите «БОЙ»."

	if RunState.wizard_debt_active:
		status_label.text += "  ДОЛГ ВОЛШЕБНИКУ: враги наносят +25% урона."

	var party_strength := RunState.get_party_strength_text()
	if not party_strength.is_empty():
		status_label.text += "  %s." % party_strength

	placement_hint.visible = true

	for unit in units:
		if unit.team == 0:
			unit.enable_placement(PLAYER_PLACEMENT_BOUNDS)

	_select_tactical_order(tactical_order, false)

func _on_assault_order_pressed() -> void:
	_select_tactical_order(TACTICAL_ORDER_ASSAULT)

func _on_hunt_order_pressed() -> void:
	_select_tactical_order(TACTICAL_ORDER_HUNT)

func _on_formation_order_pressed() -> void:
	_select_tactical_order(TACTICAL_ORDER_FORMATION)

func _select_tactical_order(order_id: String, announce: bool = true) -> void:
	if combat_started or battle_finished:
		return

	tactical_order = order_id
	assault_order_button.button_pressed = tactical_order == TACTICAL_ORDER_ASSAULT
	hunt_order_button.button_pressed = tactical_order == TACTICAL_ORDER_HUNT
	formation_order_button.button_pressed = tactical_order == TACTICAL_ORDER_FORMATION
	order_description_label.text = _get_tactical_order_description(tactical_order)

	for unit in units:
		if unit.team == 0:
			unit.set_tactical_order(tactical_order)

	if announce:
		order_description_label.modulate = Color(1.0, 0.88, 0.66, 1.0)
		_play_battle_audio("order")

func _get_tactical_order_description(order_id: String) -> String:
	match order_id:
		TACTICAL_ORDER_HUNT:
			return "ОХОТА — сначала поддержка и дальние враги."
		TACTICAL_ORDER_FORMATION:
			return "СТРОЙ — фокус угрозы рядом с самым уязвимым союзником."
		_:
			return "НАТИСК — ближайшая цель, +15% скорость движения."

func _lock_tactical_orders() -> void:
	assault_order_button.disabled = true
	hunt_order_button.disabled = true
	formation_order_button.disabled = true
	order_description_label.text = "ПРИКАЗ ЗАКРЕПЛЁН: %s" % _get_tactical_order_description(tactical_order)

func _on_boss_enraged(_unit: BattleUnit) -> void:
	if not _is_boss_encounter() or boss_reinforcements_spawned:
		return

	boss_reinforcements_spawned = true
	enemy_label.text = "БОСС • ЯРОСТЬ"
	status_label.text = "ФАЗА II — надзиратель зовёт подкрепление!"
	if arena_visual.has_method("set_boss_phase_two"):
		arena_visual.call("set_boss_phase_two", true)

	_show_boss_phase_flash()

	var count := mini(encounter.reinforcement_unit_paths.size(), encounter.reinforcement_positions.size())
	for index in range(count):
		var reinforcement_data := load(encounter.reinforcement_unit_paths[index]) as UnitData
		if reinforcement_data == null:
			continue

		var reinforcement_name := reinforcement_data.unit_name
		if index < encounter.reinforcement_names.size() and not encounter.reinforcement_names[index].is_empty():
			reinforcement_name = encounter.reinforcement_names[index]

		_spawn_unit(reinforcement_data, 1, encounter.reinforcement_positions[index], reinforcement_name)

func _show_boss_phase_flash() -> void:
	var phase_label := Label.new()
	phase_label.text = "ФАЗА II — ПРИЗЫВ"
	phase_label.position = Vector2(390.0, 195.0)
	phase_label.size = Vector2(500.0, 52.0)
	phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	phase_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	phase_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	phase_label.z_index = 3000
	phase_label.add_theme_font_size_override("font_size", 28)
	phase_label.add_theme_color_override("font_color", Color(1.0, 0.56, 0.28, 1.0))
	phase_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.95))
	phase_label.add_theme_constant_override("shadow_offset_x", 2)
	phase_label.add_theme_constant_override("shadow_offset_y", 2)
	add_child(phase_label)

	var tween := phase_label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(phase_label, "position", phase_label.position + Vector2(0.0, -18.0), 0.9)
	tween.tween_property(phase_label, "modulate:a", 0.0, 0.9)
	tween.chain().tween_callback(phase_label.queue_free)

func _on_placement_rejected(unit: BattleUnit) -> void:
	status_label.text = "%s нельзя поставить поверх другого героя." % unit.display_name

func _on_fight_pressed() -> void:
	if combat_started or battle_finished:
		return

	combat_started = true
	fight_button.disabled = true
	fight_button.text = "БОЙ..."
	status_label.text = "Ставка сделана. Назад пути нет."
	placement_hint.visible = false
	_lock_tactical_orders()
	_play_battle_audio("start")

	for unit in units:
		if unit.alive:
			unit.start_combat()

func _on_unit_died(_unit: BattleUnit) -> void:
	if battle_finished:
		return

	var heroes_alive := 0
	var enemies_alive := 0

	for unit in units:
		if not unit.alive:
			continue
		if unit.team == 0:
			heroes_alive += 1
		else:
			enemies_alive += 1

	if enemies_alive == 0:
		_finish_battle(true)
	elif heroes_alive == 0:
		_finish_battle(false)

func _finish_battle(player_won: bool) -> void:
	battle_finished = true
	RunState.last_battle_won = player_won

	for unit in units:
		unit.combat_started = false
		unit.disable_placement()

	placement_hint.visible = false
	order_label.visible = false
	assault_order_button.visible = false
	hunt_order_button.visible = false
	formation_order_button.visible = false
	order_description_label.visible = false

	if player_won:
		_play_battle_audio("victory")
		result_label.text = "ПОБЕДА"
		if _is_boss_encounter():
			result_subtitle.text = "Волшебник впервые перестаёт улыбаться."
		elif _is_death_wager_encounter():
			result_subtitle.text = "Похоже, волшебник только что проиграл собственную ставку."
		elif _is_elite_encounter():
			result_subtitle.text = "Склеп открыт. Внутри осталось кое-что ценное."
		elif encounter.encounter_id == "grave_bell":
			result_subtitle.text = "Колокол наконец замолчал."
		elif encounter.encounter_id == "ossuary_gate":
			result_subtitle.text = "Последние врата перед надзирателем открыты."
		else:
			result_subtitle.text = "Волшебник выглядит слегка раздражённым."
		status_label.text = "Карта пережита. Пока что."
		continue_button.text = "ЗАБРАТЬ НАГРАДУ"
	else:
		RunState.record_wizard_memory("battle_defeat", encounter.encounter_id)
		_play_battle_audio("defeat")
		result_label.text = "ПОРАЖЕНИЕ"
		result_subtitle.text = "Волшебник улыбается."
		status_label.text = "Стол забирает ещё один отряд."
		continue_button.text = "ВЕРНУТЬСЯ К СТОЛУ"

	result_scrim.visible = true
	result_backdrop.visible = true
	result_label.visible = true
	result_subtitle.visible = true
	fight_button.visible = false
	restart_button.disabled = false
	continue_button.visible = true
	continue_button.disabled = false
	fight_button.text = "БОЙ ОКОНЧЕН"

func _play_battle_audio(event_name: String) -> void:
	if combat_audio != null and combat_audio.has_method("play_event"):
		combat_audio.call("play_event", event_name)

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_continue_pressed() -> void:
	continue_button.disabled = true

	if RunState.last_battle_won:
		get_tree().change_scene_to_file("res://scenes/reward/reward.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/table/table.tscn")
