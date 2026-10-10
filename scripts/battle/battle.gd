extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")

const UNIT_SCENE := preload("res://scenes/battle/unit.tscn")
const DEFAULT_ENCOUNTER: EncounterData = preload("res://resources/encounters/graveyard_ambush.tres")
const MISDEAL_UI_KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")
const TARGET_PREVIEW_SCRIPT := preload("res://scripts/battle/target_preview.gd")

const COMBAT_BOUNDS := Rect2(Vector2.ZERO, Vector2(1240, 465))
const GALLOWS_VOLLEY_COMBAT_BOUNDS := Rect2(Vector2(0, 185), Vector2(1240, 255))
const BONE_CRUSH_COMBAT_BOUNDS := Rect2(Vector2(0, 105), Vector2(1240, 335))
const PLAYER_PLACEMENT_BOUNDS := Rect2(Vector2(35, 82), Vector2(545, 326))

const TACTICAL_ORDER_ASSAULT := "assault"
const TACTICAL_ORDER_HUNT := "hunt"
const TACTICAL_ORDER_FORMATION := "formation"
const TACTICAL_ORDER_SACRIFICE := "sacrifice"
const TACTICAL_ORDER_DEFIANCE := "defiance"
const SACRIFICE_DAMAGE_MULTIPLIER := 1.40
const SACRIFICE_ATTACK_SPEED_MULTIPLIER := 1.20
const SACRIFICE_HP_DRAIN_PER_SECOND := 0.02
const DEFIANCE_DAMAGE_MULTIPLIER := 0.85
const DEFIANCE_INCOMING_DAMAGE_MULTIPLIER := 0.80
const SIDE_OBJECTIVE_GOLD := 15
const BONE_CRUSH_TIME_LIMIT := 16.0

@onready var title_label: Label = $Title
@onready var deal_label: Label = $DealLabel
@onready var run_condition_label: Label = $RunConditionLabel
@onready var enemy_label: Label = $EnemyLabel
@onready var battle_backdrop: TextureRect = $BattleBackdrop
@onready var arena_visual: Control = $Arena
@onready var combat_audio: Node = $CombatAudio
@onready var bottom_hud_panel: Panel = $BottomHudPanel
@onready var wizard_commentary_panel: Panel = $WizardCommentaryPanel
@onready var wizard_commentary_label: Label = $WizardCommentary
@onready var intro_scrim: ColorRect = $BattleIntroOverlay/IntroScrim
@onready var intro_title: Label = $BattleIntroOverlay/IntroTitle
@onready var intro_encounter: Label = $BattleIntroOverlay/IntroEncounter
@onready var units_layer: Node2D = $UnitsLayer
@onready var status_label: Label = $Status
@onready var fight_button: Button = $FightButton
@onready var restart_button: Button = $RestartButton
@onready var continue_button: Button = $ContinueButton
@onready var result_scrim: ColorRect = $ResultOverlay/ResultScrim
@onready var result_backdrop: Panel = $ResultOverlay/ResultBackdrop
@onready var result_label: Label = $ResultOverlay/Result
@onready var result_subtitle: Label = $ResultOverlay/ResultSubtitle
@onready var last_deal_price_label: Label = $ResultOverlay/LastDealPrice
@onready var last_deal_accept_button: Button = $ResultOverlay/LastDealAccept
@onready var last_deal_refuse_button: Button = $ResultOverlay/LastDealRefuse
@onready var placement_hint: Label = $PlacementHint
@onready var side_objective_panel: Panel = $SideObjectivePanel
@onready var side_objective_label: Label = $SideObjectivePanel/ObjectiveLabel
@onready var deployment_zone_a: Panel = $DeploymentZoneA
@onready var deployment_zone_b: Panel = $DeploymentZoneB
@onready var order_label: Label = $OrderLabel
@onready var assault_order_button: Button = $AssaultOrderButton
@onready var hunt_order_button: Button = $HuntOrderButton
@onready var formation_order_button: Button = $FormationOrderButton
@onready var sacrifice_order_button: Button = $SacrificeOrderButton
@onready var defiance_order_button: Button = $DefianceOrderButton
@onready var order_description_label: Label = $OrderDescription
@onready var target_preview_button: Button = $TargetPreviewButton

var encounter: EncounterData
var units: Array[BattleUnit] = []
var combat_started := false
var combat_live := false
var battle_finished := false
var boss_reinforcements_spawned := false
var tactical_order := TACTICAL_ORDER_ASSAULT
var wizard_critical_line_shown := false
var sacrifice_order_unlocked := false
var defiance_order_unlocked := false
var side_objective_id := ""
var side_objective_failed := false
var first_enemy_death_seen := false
var combat_elapsed := 0.0
var target_preview: BattleTargetPreview
var result_motion_tween: Tween

func _ready() -> void:
	if not RunState.has_chosen_protagonist():
		SCENE_ROUTER.change_to(self, "res://scenes/class_select/class_select.tscn")
		return

	_apply_ui_kit()
	fight_button.pressed.connect(_on_fight_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	last_deal_accept_button.pressed.connect(_on_last_deal_accept_pressed)
	last_deal_refuse_button.pressed.connect(_on_last_deal_refuse_pressed)
	assault_order_button.pressed.connect(_on_assault_order_pressed)
	hunt_order_button.pressed.connect(_on_hunt_order_pressed)
	formation_order_button.pressed.connect(_on_formation_order_pressed)
	sacrifice_order_button.pressed.connect(_on_sacrifice_order_pressed)
	defiance_order_button.pressed.connect(_on_defiance_order_pressed)
	target_preview_button.toggled.connect(_on_target_preview_toggled)
	assault_order_button.tooltip_text = "Ближайшая цель и +15% скорость движения."
	hunt_order_button.tooltip_text = "Сначала поддержка и дальние враги."
	formation_order_button.tooltip_text = "Фокус угрозы рядом с самым уязвимым союзником."
	sacrifice_order_button.tooltip_text = "+40% урона, +20% скорость атак, но герои теряют 2% макс. HP каждую секунду."
	defiance_order_button.tooltip_text = "-20% входящего урона, но -15% собственного урона."
	sacrifice_order_unlocked = RunState.has_sacrifice_order_for_next_battle()
	defiance_order_unlocked = RunState.has_defiance_order_for_next_battle()
	_configure_tactical_order_buttons()
	restart_button.disabled = true
	continue_button.visible = false
	continue_button.disabled = true
	encounter = _load_selected_encounter()
	if battle_backdrop.has_method("set_arena_id"):
		battle_backdrop.call("set_arena_id", encounter.arena_id)
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
	last_deal_price_label.visible = false
	last_deal_accept_button.visible = false
	last_deal_refuse_button.visible = false
	restart_button.visible = false
	wizard_commentary_panel.visible = false
	wizard_commentary_label.visible = false
	intro_scrim.visible = false
	intro_title.visible = false
	intro_encounter.visible = false
	_configure_side_objective()
	_spawn_encounter()
	_setup_target_preview()
	_begin_preparation_phase()

func _setup_target_preview() -> void:
	target_preview = TARGET_PREVIEW_SCRIPT.new() as BattleTargetPreview
	if target_preview == null:
		return
	units_layer.add_child(target_preview)
	_sync_target_preview_button()
	target_preview.set_active(RunState.battle_target_preview_enabled)


func _on_target_preview_toggled(enabled: bool) -> void:
	RunState.battle_target_preview_enabled = enabled
	_sync_target_preview_button()
	if target_preview != null and not combat_started and not battle_finished:
		target_preview.set_active(enabled)


func _sync_target_preview_button() -> void:
	if target_preview_button == null:
		return
	target_preview_button.set_pressed_no_signal(RunState.battle_target_preview_enabled)
	target_preview_button.text = "ЦЕЛИ: ВКЛ" if RunState.battle_target_preview_enabled else "ЦЕЛИ: ВЫКЛ"
	target_preview_button.tooltip_text = (
		"Скрыть линии первых целей."
		if RunState.battle_target_preview_enabled
		else "Показать первые цели героев и врагов при текущей расстановке."
	)


func _apply_ui_kit() -> void:
	MISDEAL_UI_KIT.apply_panel(bottom_hud_panel, MISDEAL_UI_KIT.BRONZE, false)
	MISDEAL_UI_KIT.apply_panel(wizard_commentary_panel, MISDEAL_UI_KIT.BRONZE, false)
	MISDEAL_UI_KIT.apply_panel(side_objective_panel, MISDEAL_UI_KIT.GOLD, false)
	MISDEAL_UI_KIT.apply_panel(result_backdrop, MISDEAL_UI_KIT.BRONZE, true)
	MISDEAL_UI_KIT.apply_title(title_label, MISDEAL_UI_KIT.GOLD)
	MISDEAL_UI_KIT.apply_subtitle(wizard_commentary_label, MISDEAL_UI_KIT.BRONZE)

	for button in [assault_order_button, hunt_order_button, formation_order_button]:
		MISDEAL_UI_KIT.apply_action_button(button, MISDEAL_UI_KIT.BRONZE, false)
	MISDEAL_UI_KIT.apply_action_button(sacrifice_order_button, MISDEAL_UI_KIT.EMBER, false)
	MISDEAL_UI_KIT.apply_action_button(defiance_order_button, MISDEAL_UI_KIT.STEEL, false)
	MISDEAL_UI_KIT.apply_action_button(target_preview_button, MISDEAL_UI_KIT.STEEL, false)
	MISDEAL_UI_KIT.apply_action_button(fight_button, MISDEAL_UI_KIT.EMBER, true)
	MISDEAL_UI_KIT.apply_action_button(restart_button, MISDEAL_UI_KIT.STEEL, false)
	MISDEAL_UI_KIT.apply_action_button(continue_button, MISDEAL_UI_KIT.GOLD, true)
	MISDEAL_UI_KIT.apply_action_button(last_deal_accept_button, MISDEAL_UI_KIT.EMBER, true)
	MISDEAL_UI_KIT.apply_action_button(last_deal_refuse_button, MISDEAL_UI_KIT.STEEL, false)


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
	match encounter.encounter_id:
		"gallows_volley":
			match RunState.get_party_size():
				1:
					return [Vector2(220, 305)]
				2:
					return [Vector2(220, 245), Vector2(220, 365)]
				_:
					return [Vector2(220, 225), Vector2(220, 305), Vector2(220, 385)]
		"bone_crush":
			match RunState.get_party_size():
				1:
					return [Vector2(240, 220)]
				2:
					return [Vector2(210, 165), Vector2(210, 335)]
				_:
					return [Vector2(170, 165), Vector2(170, 335), Vector2(390, 335)]
		"ossuary_gate":
			match RunState.get_party_size():
				1:
					return [Vector2(145, 245)]
				2:
					return [Vector2(145, 160), Vector2(425, 325)]
				_:
					return [Vector2(145, 150), Vector2(145, 335), Vector2(425, 245)]
		"bone_warden":
			match RunState.get_party_size():
				1:
					return [Vector2(250, 245)]
				2:
					return [Vector2(220, 175), Vector2(220, 315)]
				_:
					return [Vector2(205, 165), Vector2(310, 245), Vector2(205, 325)]
		_:
			match RunState.get_party_size():
				1:
					return [Vector2(270, 245)]
				2:
					return [Vector2(235, 180), Vector2(235, 315)]
				_:
					return [Vector2(280, 140), Vector2(210, 245), Vector2(280, 355)]

func _get_placement_regions() -> Array[Rect2]:
	match encounter.encounter_id:
		"gallows_volley":
			return [Rect2(Vector2(35, 195), Vector2(430, 205))]
		"bone_crush":
			return [
				Rect2(Vector2(35, 115), Vector2(480, 130)),
				Rect2(Vector2(35, 270), Vector2(480, 130))
			]
		"ossuary_gate":
			return [
				Rect2(Vector2(35, 82), Vector2(215, 326)),
				Rect2(Vector2(325, 82), Vector2(215, 326))
			]
		"bone_warden":
			return [Rect2(Vector2(65, 105), Vector2(440, 280))]
		_:
			return [PLAYER_PLACEMENT_BOUNDS]

func _configure_deployment_zones(regions: Array[Rect2]) -> void:
	var panels: Array[Panel] = [deployment_zone_a, deployment_zone_b]
	for index in range(panels.size()):
		var panel: Panel = panels[index]
		if index >= regions.size():
			panel.visible = false
			continue
		var region: Rect2 = regions[index]
		panel.position = units_layer.position + region.position
		panel.size = region.size
		panel.visible = true

func _get_placement_hint_text() -> String:
	match encounter.encounter_id:
		"gallows_volley":
			return "РАССТАНОВКА: ГЛУБОКАЯ ЛИНИЯ — разнесите героев по вертикали"
		"bone_crush":
			return "РАССТАНОВКА: ДВЕ ПОЛОСЫ — решите, как разделить отряд"
		"ossuary_gate":
			return "РАССТАНОВКА: ДВА КАРМАНА — центр закрыт"
		"bone_warden":
			return "РАССТАНОВКА: ТЕСНЫЙ КРУГ — не подарите боссу удобный AOE"
		_:
			return "ПЕРЕТАСКИВАЙТЕ ГЕРОЕВ ДЛЯ РАССТАНОВКИ"

func _spawn_unit(
	data: UnitData,
	team: int,
	spawn_position: Vector2,
	name_override: String = ""
) -> void:
	var unit := UNIT_SCENE.instantiate() as BattleUnit
	unit.configure(data, team, spawn_position, name_override)
	unit.set_arena_presentation(encounter.arena_id)

	if team == 0:
		unit.max_hp += RunState.party_hp_bonus
		unit.damage += RunState.party_damage_bonus
		_apply_hero_upgrades_to_unit(unit)
		_apply_artifacts_to_unit(unit)
		unit.max_hp *= RunState.get_party_hp_multiplier()
		unit.damage *= RunState.get_party_damage_multiplier()
		unit.attack_interval = maxf(0.2, unit.attack_interval * RunState.get_party_attack_interval_multiplier())
		unit.move_speed *= RunState.get_party_move_speed_multiplier()
		if unit.visual_role == RunState.protagonist_role:
			unit.max_hp -= RunState.get_total_protagonist_hp_penalty()
		unit.max_hp = maxf(20.0, unit.max_hp)
		unit.damage = maxf(1.0, unit.damage)
		unit.set_meta("order_base_damage", unit.damage)
		unit.set_meta("order_base_attack_interval", unit.attack_interval)
	else:
		unit.max_hp *= RunState.get_enemy_hp_multiplier()
		unit.damage *= RunState.get_enemy_damage_multiplier()
		unit.support_heal_amount *= RunState.get_enemy_hp_multiplier()

	if team == 0:
		unit.set_tactical_order(tactical_order)

	unit.set_combat_bounds(_get_combat_bounds())
	unit.died.connect(_on_unit_died)
	unit.health_critical.connect(_on_unit_health_critical)
	unit.placement_rejected.connect(_on_placement_rejected)
	if unit.is_boss:
		unit.boss_enraged.connect(_on_boss_enraged)
	units_layer.add_child(unit)
	units.append(unit)

	if combat_started:
		unit.start_combat()

func _get_combat_bounds() -> Rect2:
	if encounter != null:
		match encounter.encounter_id:
			"gallows_volley":
				return GALLOWS_VOLLEY_COMBAT_BOUNDS
			"bone_crush":
				return BONE_CRUSH_COMBAT_BOUNDS
	return COMBAT_BOUNDS


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



func _configure_side_objective() -> void:
	side_objective_id = ""
	side_objective_failed = false
	first_enemy_death_seen = false
	combat_elapsed = 0.0
	side_objective_panel.visible = false

	match encounter.encounter_id:
		"grave_bell":
			side_objective_id = "bell_first"
			side_objective_label.text = "УСЛОВИЕ ВОЛШЕБНИКА\nЗвонарь должен пасть первым • +%d золота" % SIDE_OBJECTIVE_GOLD
		"gallows_volley":
			side_objective_id = "no_critical"
			side_objective_label.text = "УСЛОВИЕ ВОЛШЕБНИКА\nНикто не ниже 25%% HP • +%d золота" % SIDE_OBJECTIVE_GOLD
		"bone_crush":
			side_objective_id = "fast_crush"
			side_objective_label.text = "УСЛОВИЕ ВОЛШЕБНИКА\nПобедить за %.0f сек • +%d золота" % [BONE_CRUSH_TIME_LIMIT, SIDE_OBJECTIVE_GOLD]

	side_objective_panel.visible = not side_objective_id.is_empty()

func _fail_side_objective(message: String) -> void:
	if side_objective_failed:
		return
	side_objective_failed = true
	side_objective_label.text = message
	side_objective_label.add_theme_color_override("font_color", Color(0.82, 0.38, 0.30, 1.0))

func _claim_side_objective_reward() -> String:
	if side_objective_id.is_empty() or side_objective_failed:
		return ""

	if side_objective_id == "bell_first" and not first_enemy_death_seen:
		return ""
	if side_objective_id == "fast_crush" and combat_elapsed > BONE_CRUSH_TIME_LIMIT:
		return ""

	RunState.gold += SIDE_OBJECTIVE_GOLD
	return "УСЛОВИЕ ВОЛШЕБНИКА выполнено: +%d золота." % SIDE_OBJECTIVE_GOLD


func _begin_preparation_phase() -> void:
	if _is_boss_encounter():
		status_label.text = "НАДЗИРАТЕЛЬ — удары по площади. На 50% HP: ярость и подкрепление."
		var verdict := RunState.get_act1_reckoning_label()
		if not verdict.is_empty():
			status_label.text += " ПРИГОВОР: %s." % verdict
	elif _is_death_wager_encounter():
		status_label.text = "СТАВКА НА СМЕРТЬ — 5 врагов. Страж держит центр; лучники — главная угроза."
	elif _is_elite_encounter():
		status_label.text = "ЭЛИТА — страж бьёт по площади. Разведите героев и не стойте плотной группой."
	elif encounter.encounter_id == "grave_bell":
		status_label.text = "МОГИЛЬНЫЙ ЗВОН — звонарь лечит нежить. «ОХОТА» помогает быстрее добраться до поддержки."
	elif encounter.encounter_id == "bone_crush":
		status_label.text = "КОСТЯНАЯ ДАВКА — РАЗДЕЛЁННАЯ РАССТАНОВКА. Две полосы, пять хрупких целей."
	elif encounter.encounter_id == "ossuary_gate":
		status_label.text = "ВРАТА ОССУАРИЯ — ДВА КАРМАНА РАССТАНОВКИ. Страж впереди, звонарь лечит."
	elif encounter.encounter_id == "gallows_volley":
		status_label.text = "ЗАЛП С ВИСЕЛИЦЫ — ГЛУБОКАЯ ЛИНИЯ. Разведите героев по высоте против двух лучников."
	else:
		status_label.text = "ПОДГОТОВКА — расставьте героев, выберите приказ и запускайте бой."

	var placement_regions: Array[Rect2] = _get_placement_regions()
	_configure_deployment_zones(placement_regions)
	run_condition_label.text = _build_battle_condition_text()
	run_condition_label.visible = not run_condition_label.text.is_empty()
	placement_hint.text = _get_placement_hint_text()
	placement_hint.visible = true
	side_objective_panel.visible = not side_objective_id.is_empty()

	for unit in units:
		if unit.team == 0:
			unit.enable_placement_regions(placement_regions)

	_select_tactical_order(tactical_order, false)
	target_preview_button.visible = true
	_sync_target_preview_button()
	if target_preview != null:
		target_preview.set_active(RunState.battle_target_preview_enabled)

func _on_assault_order_pressed() -> void:
	_select_tactical_order(TACTICAL_ORDER_ASSAULT)

func _on_hunt_order_pressed() -> void:
	_select_tactical_order(TACTICAL_ORDER_HUNT)

func _on_formation_order_pressed() -> void:
	_select_tactical_order(TACTICAL_ORDER_FORMATION)

func _on_sacrifice_order_pressed() -> void:
	if not sacrifice_order_unlocked:
		return
	_select_tactical_order(TACTICAL_ORDER_SACRIFICE)



func _on_defiance_order_pressed() -> void:
	if not defiance_order_unlocked:
		return
	_select_tactical_order(TACTICAL_ORDER_DEFIANCE)

func _select_tactical_order(order_id: String, announce: bool = true) -> void:
	if combat_started or battle_finished:
		return
	if order_id == TACTICAL_ORDER_SACRIFICE and not sacrifice_order_unlocked:
		return
	if order_id == TACTICAL_ORDER_DEFIANCE and not defiance_order_unlocked:
		return

	tactical_order = order_id
	assault_order_button.button_pressed = tactical_order == TACTICAL_ORDER_ASSAULT
	hunt_order_button.button_pressed = tactical_order == TACTICAL_ORDER_HUNT
	formation_order_button.button_pressed = tactical_order == TACTICAL_ORDER_FORMATION
	sacrifice_order_button.button_pressed = tactical_order == TACTICAL_ORDER_SACRIFICE
	defiance_order_button.button_pressed = tactical_order == TACTICAL_ORDER_DEFIANCE
	order_description_label.text = _get_tactical_order_description(tactical_order)
	_apply_tactical_order_stats()

	for unit in units:
		if unit.team == 0:
			unit.set_tactical_order(tactical_order)

	if announce:
		if tactical_order == TACTICAL_ORDER_SACRIFICE:
			order_description_label.modulate = Color(1.0, 0.50, 0.32, 1.0)
		elif tactical_order == TACTICAL_ORDER_DEFIANCE:
			order_description_label.modulate = Color(0.48, 0.78, 1.0, 1.0)
		else:
			order_description_label.modulate = Color(1.0, 0.88, 0.66, 1.0)
		_play_tactical_order_feedback(tactical_order)
		_play_battle_audio("order")

func _get_tactical_order_description(order_id: String) -> String:
	match order_id:
		TACTICAL_ORDER_HUNT:
			return "ОХОТА — сначала поддержка и дальние враги."
		TACTICAL_ORDER_FORMATION:
			return "СТРОЙ — фокус угрозы рядом с самым уязвимым союзником."
		TACTICAL_ORDER_SACRIFICE:
			return "ЖЕРТВА — +40% урона, +20% скорость атак, -2% макс. HP/сек."
		TACTICAL_ORDER_DEFIANCE:
			return "НЕПОВИНОВЕНИЕ — -20% входящего урона, но -15% собственного."
		_:
			return "НАТИСК — ближайшая цель, +15% скорость движения."

func _configure_tactical_order_buttons() -> void:
	sacrifice_order_button.visible = sacrifice_order_unlocked
	defiance_order_button.visible = defiance_order_unlocked

	var buttons: Array[Button] = [
		assault_order_button,
		hunt_order_button,
		formation_order_button
	]
	if sacrifice_order_unlocked:
		buttons.append(sacrifice_order_button)
	if defiance_order_unlocked:
		buttons.append(defiance_order_button)

	if buttons.size() <= 3:
		return

	var spacing := 78.0 if buttons.size() == 4 else 76.0
	for index in range(buttons.size()):
		var button: Button = buttons[index]
		button.position = Vector2(46.0 + float(index) * spacing, 626.0)
		button.size = Vector2(72.0, 42.0)
		button.add_theme_font_size_override("font_size", 10 if buttons.size() == 5 else 11)


func _apply_tactical_order_stats() -> void:
	for unit in units:
		if unit.team != 0:
			continue
		var base_damage: float = float(unit.get_meta("order_base_damage", unit.damage))
		var base_interval: float = float(unit.get_meta("order_base_attack_interval", unit.attack_interval))
		unit.damage = base_damage
		unit.attack_interval = base_interval
		unit.damage_taken_multiplier = 1.0
		if tactical_order == TACTICAL_ORDER_SACRIFICE:
			unit.damage = maxf(1.0, base_damage * SACRIFICE_DAMAGE_MULTIPLIER)
			unit.attack_interval = maxf(0.2, base_interval / SACRIFICE_ATTACK_SPEED_MULTIPLIER)
		elif tactical_order == TACTICAL_ORDER_DEFIANCE:
			unit.damage = maxf(1.0, base_damage * DEFIANCE_DAMAGE_MULTIPLIER)
			unit.damage_taken_multiplier = DEFIANCE_INCOMING_DAMAGE_MULTIPLIER

func _build_battle_condition_text() -> String:
	var lines: Array[String] = []
	match RunState.get_party_size():
		1:
			lines.append("СОЛО • HP ×2.2 • УРОН ×1.9 • АТАКИ ×1.25")
			lines.append("ДАВЛЕНИЕ ВРАГОВ • HP -18% • УРОН -20%")
		2:
			lines.append("ДУО • HP +20% • УРОН +15%")
			lines.append("ДАВЛЕНИЕ ВРАГОВ • HP -8% • УРОН -10%")
		_:
			lines.append("ОТРЯД 3/3 • ПОЛНОЕ ДАВЛЕНИЕ")

	if RunState.wizard_debt_active:
		lines.append("ДОЛГ • ВРАГИ +25%")
	if RunState.wizard_mark_danger_active:
		lines.append("ПЕЧАТЬ • ВРАГИ +15%")
	if sacrifice_order_unlocked:
		lines.append("ЖЕРТВА ДОСТУПНА")
	if defiance_order_unlocked:
		lines.append("НЕПОВИНОВЕНИЕ ДОСТУПНО")
	if RunState.last_deal_used and not sacrifice_order_unlocked and not defiance_order_unlocked:
		lines.append("ПОСЛЕДНЯЯ СДЕЛКА • ИСПОЛЬЗОВАНА")

	return "\n".join(lines)


func _lock_tactical_orders() -> void:
	assault_order_button.disabled = true
	hunt_order_button.disabled = true
	formation_order_button.disabled = true
	sacrifice_order_button.disabled = true
	defiance_order_button.disabled = true
	order_description_label.text = "ПРИКАЗ ЗАКРЕПЛЁН: %s" % _get_tactical_order_description(tactical_order)

func _get_boss_phase_two_reinforcements() -> Array[Dictionary]:
	match RunState.get_act1_reckoning_profile():
		"witnessless":
			return [
				{"path": "res://resources/units/bone_thrall.tres", "name": "Безымянный раб", "position": Vector2(1070, 125)},
				{"path": "res://resources/units/bone_thrall.tres", "name": "Безымянный раб", "position": Vector2(1040, 385)}
			]
		"scarred":
			return [
				{"path": "res://resources/units/grave_bellkeeper.tres", "name": "Могильный исповедник", "position": Vector2(1050, 245)}
			]
		"riskbound":
			return [
				{"path": "res://resources/units/bone_archer.tres", "name": "Сборщик ставки", "position": Vector2(1070, 125)},
				{"path": "res://resources/units/bone_archer.tres", "name": "Сборщик ставки", "position": Vector2(1040, 385)}
			]
		_:
			var default_plan: Array[Dictionary] = []
			var count := mini(encounter.reinforcement_unit_paths.size(), encounter.reinforcement_positions.size())
			for index in range(count):
				var unit_name := ""
				if index < encounter.reinforcement_names.size():
					unit_name = encounter.reinforcement_names[index]
				default_plan.append({
					"path": encounter.reinforcement_unit_paths[index],
					"name": unit_name,
					"position": encounter.reinforcement_positions[index]
				})
			return default_plan

func _get_boss_phase_two_wizard_line() -> String:
	match RunState.get_act1_reckoning_profile():
		"witnessless":
			return "Без свидетелей пришёл — без свидетелей и останешься. Надзиратель, выпусти рабов."
		"scarred":
			return "Столько шрамов. Посмотрим, сумеет ли колокол удержать моего надзирателя на ногах."
		"riskbound":
			return "Любишь ставки? Тогда вот тебе две стрелы, которые тоже любят проценты."
		_:
			return "Вот теперь надзиратель вспомнил, зачем я его держу."


func _on_boss_enraged(_unit: BattleUnit) -> void:
	if not _is_boss_encounter() or boss_reinforcements_spawned:
		return

	boss_reinforcements_spawned = true
	enemy_label.text = "БОСС • ЯРОСТЬ"
	var verdict := RunState.get_act1_reckoning_label()
	status_label.text = "ФАЗА II — надзиратель зовёт подкрепление!"
	if not verdict.is_empty():
		status_label.text += " ПРИГОВОР: %s." % verdict
	_show_wizard_line(_get_boss_phase_two_wizard_line(), true)
	if arena_visual.has_method("set_boss_phase_two"):
		arena_visual.call("set_boss_phase_two", true)

	_show_boss_phase_flash()

	var plan: Array[Dictionary] = _get_boss_phase_two_reinforcements()
	for entry in plan:
		var reinforcement_data := load(String(entry.get("path", ""))) as UnitData
		if reinforcement_data == null:
			continue
		var reinforcement_name: String = String(entry.get("name", reinforcement_data.unit_name))
		if reinforcement_name.is_empty():
			reinforcement_name = reinforcement_data.unit_name
		var reinforcement_position: Vector2 = entry.get("position", Vector2(1040, 245))
		_spawn_unit(reinforcement_data, 1, reinforcement_position, reinforcement_name)

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

	var arena_tween := arena_visual.create_tween()
	arena_tween.tween_property(arena_visual, "modulate", Color(1.0, 0.58, 0.46, 1.0), 0.08)
	arena_tween.tween_property(arena_visual, "modulate", Color.WHITE, 0.34)

	var backdrop_tween := battle_backdrop.create_tween()
	backdrop_tween.tween_property(battle_backdrop, "modulate", Color(1.0, 0.78, 0.70, 1.0), 0.08)
	backdrop_tween.tween_property(battle_backdrop, "modulate", Color.WHITE, 0.32)

	var tween := phase_label.create_tween()
	phase_label.pivot_offset = phase_label.size * 0.5
	phase_label.scale = Vector2(0.92, 0.92)
	tween.set_parallel(true)
	tween.tween_property(phase_label, "position", phase_label.position + Vector2(0.0, -18.0), 0.9)
	tween.tween_property(phase_label, "modulate:a", 0.0, 0.9)
	tween.tween_property(phase_label, "scale", Vector2(1.04, 1.04), 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(phase_label.queue_free)

func _on_placement_rejected(unit: BattleUnit) -> void:
	status_label.text = "%s нельзя поставить поверх другого героя." % unit.display_name




func _on_fight_pressed() -> void:
	if combat_started or battle_finished:
		return

	combat_started = true
	combat_live = false
	combat_elapsed = 0.0
	if target_preview != null:
		target_preview.set_active(false)
	fight_button.disabled = true
	placement_hint.visible = false
	_lock_tactical_orders()
	await _play_fight_commit_feedback()
	_hide_preparation_hud()
	side_objective_panel.visible = not side_objective_id.is_empty()

	if sacrifice_order_unlocked:
		RunState.consume_sacrifice_order_for_battle()
		sacrifice_order_unlocked = false
	if defiance_order_unlocked:
		RunState.consume_defiance_order_for_battle()
		defiance_order_unlocked = false
	if tactical_order == TACTICAL_ORDER_SACRIFICE:
		RunState.record_wizard_memory("sacrifice_order")
	elif tactical_order == TACTICAL_ORDER_DEFIANCE:
		RunState.record_wizard_memory("defiance_order")

	await _play_combat_intro()
	if battle_finished:
		return

	if tactical_order == TACTICAL_ORDER_SACRIFICE:
		status_label.text = "ЖЕРТВА — сила растёт, жизнь уходит каждую секунду."
		_show_wizard_line("Вот так. Сгорите быстрее, чем они успеют вас убить.", true)
	elif tactical_order == TACTICAL_ORDER_DEFIANCE:
		status_label.text = "НЕПОВИНОВЕНИЕ — вы держите удар, но отвечаете слабее."
		_show_wizard_line("Сопротивляйся. Мне даже любопытно, сколько это продлится.", true)
	else:
		status_label.text = "Ставка сделана. Назад пути нет."
		_show_wizard_line(_get_combat_start_wizard_line())
	_play_battle_audio("start")

	for unit in units:
		if unit.alive:
			unit.start_combat()
	combat_live = true

func _hide_preparation_hud() -> void:
	bottom_hud_panel.visible = false
	run_condition_label.visible = false
	placement_hint.visible = false
	deployment_zone_a.visible = false
	deployment_zone_b.visible = false
	order_label.visible = false
	assault_order_button.visible = false
	hunt_order_button.visible = false
	formation_order_button.visible = false
	sacrifice_order_button.visible = false
	defiance_order_button.visible = false
	order_description_label.visible = false
	target_preview_button.visible = false
	fight_button.visible = false
	restart_button.visible = false

func _play_combat_intro() -> void:
	intro_scrim.visible = true
	intro_title.visible = true
	intro_encounter.visible = true
	intro_title.text = "СХВАТКА"
	intro_encounter.text = encounter.title
	intro_scrim.modulate.a = 0.0
	intro_title.modulate.a = 0.0
	intro_encounter.modulate.a = 0.0
	intro_title.scale = Vector2(0.92, 0.92)
	intro_title.pivot_offset = intro_title.size * 0.5

	var appear := create_tween()
	appear.set_parallel(true)
	appear.tween_property(intro_scrim, "modulate:a", 1.0, 0.16)
	appear.tween_property(intro_title, "modulate:a", 1.0, 0.16)
	appear.tween_property(intro_encounter, "modulate:a", 1.0, 0.22)
	appear.tween_property(intro_title, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await appear.finished

	await get_tree().create_timer(0.36).timeout

	var disappear := create_tween()
	disappear.set_parallel(true)
	disappear.tween_property(intro_scrim, "modulate:a", 0.0, 0.20)
	disappear.tween_property(intro_title, "modulate:a", 0.0, 0.20)
	disappear.tween_property(intro_encounter, "modulate:a", 0.0, 0.18)
	await disappear.finished

	intro_scrim.visible = false
	intro_title.visible = false
	intro_encounter.visible = false

func _get_combat_start_wizard_line() -> String:
	match encounter.encounter_id:
		"graveyard_ambush":
			return "Кладбище любит тех, кто приходит неподготовленным."
		"gallows_volley":
			return "Бегите к лучникам. Они это обожают."
		"grave_bell":
			return "Послушаем, по кому сегодня звонит колокол."
		"bone_crush":
			return "Толпа костей. Почти нечестно. Почти."
		"crypt_guard":
			return "Стражу велено не пропускать живых. Удобное правило."
		"ossuary_gate":
			return "За этими вратами я уже почти слышу ваши кости."
		"death_wager":
			return "Вы сами выбрали ставку. Не разочаруйте меня слишком быстро."
		"bone_warden":
			return "Надзиратель редко оставляет мне что-нибудь после себя."
		_:
			return "Ну же. Покажите мне, зачем я вас вернул."

func _play_tactical_order_feedback(order_id: String) -> void:
	var selected_button := _get_tactical_order_button(order_id)
	if selected_button != null and selected_button.visible:
		selected_button.pivot_offset = selected_button.size * 0.5
		var button_tween := selected_button.create_tween()
		button_tween.tween_property(selected_button, "scale", Vector2(1.07, 0.94), 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		button_tween.tween_property(selected_button, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	order_description_label.pivot_offset = order_description_label.size * 0.5
	var description_tween := order_description_label.create_tween()
	description_tween.tween_property(order_description_label, "scale", Vector2(1.018, 1.018), 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	description_tween.tween_property(order_description_label, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _get_tactical_order_button(order_id: String) -> Button:
	match order_id:
		TACTICAL_ORDER_HUNT:
			return hunt_order_button
		TACTICAL_ORDER_FORMATION:
			return formation_order_button
		TACTICAL_ORDER_SACRIFICE:
			return sacrifice_order_button
		TACTICAL_ORDER_DEFIANCE:
			return defiance_order_button
		_:
			return assault_order_button


func _play_fight_commit_feedback() -> void:
	if not fight_button.visible:
		return

	fight_button.pivot_offset = fight_button.size * 0.5
	var button_tween := fight_button.create_tween()
	button_tween.tween_property(fight_button, "scale", Vector2(0.96, 0.94), 0.055).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	button_tween.tween_property(fight_button, "scale", Vector2(1.035, 1.035), 0.075).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	button_tween.tween_property(fight_button, "scale", Vector2.ONE, 0.055)
	await button_tween.finished


func _animate_result_overlay(player_won: bool) -> void:
	if not is_inside_tree():
		return

	if result_motion_tween != null and result_motion_tween.is_valid():
		result_motion_tween.kill()

	result_backdrop.pivot_offset = result_backdrop.size * 0.5
	result_label.pivot_offset = result_label.size * 0.5
	result_scrim.modulate.a = 0.0
	result_backdrop.modulate.a = 0.0
	result_backdrop.scale = Vector2(0.965, 0.965)
	result_label.modulate.a = 0.0
	result_label.scale = Vector2(0.92, 0.92)
	result_subtitle.modulate.a = 0.0

	for control in [continue_button, last_deal_price_label, last_deal_accept_button, last_deal_refuse_button]:
		if control.visible:
			control.modulate.a = 0.0

	result_motion_tween = create_tween()
	result_motion_tween.set_parallel(true)
	result_motion_tween.tween_property(result_scrim, "modulate:a", 1.0, 0.16)
	result_motion_tween.tween_property(result_backdrop, "modulate:a", 1.0, 0.18).set_delay(0.04)
	result_motion_tween.tween_property(result_backdrop, "scale", Vector2.ONE, 0.22).set_delay(0.04).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	result_motion_tween.tween_property(result_label, "modulate:a", 1.0, 0.15).set_delay(0.10)
	result_motion_tween.tween_property(result_label, "scale", Vector2.ONE, 0.18).set_delay(0.10).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	result_motion_tween.tween_property(result_subtitle, "modulate:a", 1.0, 0.18).set_delay(0.16)

	var focus_color := Color(0.94, 1.04, 0.90, 1.0) if player_won else Color(1.08, 0.82, 0.78, 1.0)
	var title_focus := result_label.create_tween()
	title_focus.tween_property(result_label, "modulate", focus_color, 0.09).set_delay(0.13)
	title_focus.tween_property(result_label, "modulate", Color.WHITE, 0.22)

	var reveal_delay := 0.24
	for control in [last_deal_price_label, continue_button, last_deal_accept_button, last_deal_refuse_button]:
		if not control.visible:
			continue
		var control_tween := control.create_tween()
		control_tween.tween_property(control, "modulate:a", 1.0, 0.15).set_delay(reveal_delay)
		reveal_delay += 0.045

	if last_deal_accept_button.visible:
		call_deferred("_pulse_last_deal_after_reveal")


func _pulse_last_deal_after_reveal() -> void:
	await get_tree().create_timer(0.34).timeout
	if not is_inside_tree() or not last_deal_accept_button.visible:
		return

	last_deal_price_label.pivot_offset = last_deal_price_label.size * 0.5
	var price_tween := last_deal_price_label.create_tween()
	price_tween.tween_property(last_deal_price_label, "scale", Vector2(1.04, 1.04), 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	price_tween.tween_property(last_deal_price_label, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _animate_result_choice_commit(button: Button) -> void:
	if button == null or not button.visible:
		return

	button.pivot_offset = button.size * 0.5
	var tween := button.create_tween()
	tween.tween_property(button, "scale", Vector2(0.96, 0.94), 0.055).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(button, "scale", Vector2(1.04, 1.04), 0.075).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", Vector2.ONE, 0.06)
	await tween.finished


func _show_wizard_line(message: String, urgent: bool = false) -> void:
	if message.is_empty():
		return

	wizard_commentary_panel.visible = true
	wizard_commentary_label.visible = true
	wizard_commentary_label.text = "ВОЛШЕБНИК: %s" % message
	wizard_commentary_label.modulate = Color(1.0, 0.72, 0.52, 1.0) if urgent else Color(0.84, 0.68, 0.62, 1.0)
	wizard_commentary_panel.modulate.a = 0.0
	wizard_commentary_label.modulate.a = 0.0

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(wizard_commentary_panel, "modulate:a", 1.0, 0.16)
	tween.tween_property(wizard_commentary_label, "modulate:a", 1.0, 0.16)


func _on_unit_health_critical(unit: BattleUnit) -> void:
	if battle_finished or unit.team != 0:
		return

	if side_objective_id == "no_critical" and not side_objective_failed:
		_fail_side_objective("УСЛОВИЕ ПРОВАЛЕНО • герой опустился ниже 25% HP")

	if wizard_critical_line_shown:
		return

	wizard_critical_line_shown = true
	_show_wizard_line("%s уже слышит, как стол считает последнюю карту." % unit.display_name, true)


func _process(delta: float) -> void:
	if not combat_started or not combat_live or battle_finished:
		return

	combat_elapsed += delta
	if side_objective_id == "fast_crush" and not side_objective_failed:
		if combat_elapsed > BONE_CRUSH_TIME_LIMIT:
			_fail_side_objective("УСЛОВИЕ ПРОВАЛЕНО • время вышло")
		else:
			side_objective_label.text = "УСЛОВИЕ ВОЛШЕБНИКА\nПобедить за %.1f сек • +%d золота" % [
				maxf(0.0, BONE_CRUSH_TIME_LIMIT - combat_elapsed),
				SIDE_OBJECTIVE_GOLD
			]

	if tactical_order != TACTICAL_ORDER_SACRIFICE:
		return

	for unit in units:
		if battle_finished:
			return
		if unit.team == 0 and unit.alive:
			unit.take_attrition_damage(unit.max_hp * SACRIFICE_HP_DRAIN_PER_SECOND * delta)


func _on_unit_died(dead_unit: BattleUnit) -> void:
	if battle_finished:
		return

	if dead_unit.team == 1 and side_objective_id == "bell_first" and not first_enemy_death_seen:
		first_enemy_death_seen = true
		if dead_unit.visual_role == "grave_bellkeeper":
			side_objective_label.text = "УСЛОВИЕ ВЫПОЛНЕНО\nЗвонарь пал первым • награда после победы"
		else:
			_fail_side_objective("УСЛОВИЕ ПРОВАЛЕНО • первым пал не звонарь")
	elif dead_unit.team == 0 and side_objective_id == "no_critical" and not side_objective_failed:
		_fail_side_objective("УСЛОВИЕ ПРОВАЛЕНО • герой погиб")

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
	elif dead_unit.team == 0:
		_show_wizard_line("Один уже понял правила. Остальные — следом.", true)

func _show_last_deal_offer() -> void:
	result_label.text = "ПОСЛЕДНЯЯ СДЕЛКА"
	result_subtitle.text = "«Не спеши умирать. У меня ещё есть к тебе предложение.»"
	last_deal_price_label.text = RunState.get_last_deal_price_text()
	last_deal_price_label.visible = true
	last_deal_accept_button.visible = true
	last_deal_accept_button.disabled = false
	last_deal_refuse_button.visible = true
	last_deal_refuse_button.disabled = false
	restart_button.visible = false
	continue_button.visible = false
	status_label.text = "Один раз за забег Волшебник может продать тебе право повторить этот бой."

func _show_final_defeat() -> void:
	result_label.text = "ПОРАЖЕНИЕ"
	result_subtitle.text = "«Я уже продал тебе одну смерть. Второй не будет.»"
	last_deal_price_label.text = "ПОСЛЕДНЯЯ СДЕЛКА УЖЕ ИСПОЛЬЗОВАНА"
	last_deal_price_label.visible = true
	last_deal_accept_button.visible = false
	last_deal_refuse_button.text = "ЗАВЕРШИТЬ ЗАБЕГ"
	last_deal_refuse_button.position = Vector2(512.0, 404.0)
	last_deal_refuse_button.size = Vector2(256.0, 52.0)
	last_deal_refuse_button.visible = true
	last_deal_refuse_button.disabled = false
	restart_button.visible = false
	continue_button.visible = false
	status_label.text = "Эта версия партии закончилась."

func _on_last_deal_accept_pressed() -> void:
	last_deal_accept_button.disabled = true
	last_deal_refuse_button.disabled = true
	await _animate_result_choice_commit(last_deal_accept_button)
	if not RunState.accept_last_deal():
		last_deal_accept_button.disabled = false
		last_deal_refuse_button.disabled = false
		return
	SCENE_ROUTER.reload_current(self)

func _on_last_deal_refuse_pressed() -> void:
	last_deal_accept_button.disabled = true
	last_deal_refuse_button.disabled = true
	await _animate_result_choice_commit(last_deal_refuse_button)
	var reason := "Вы приняли поражение в бою «%s»." % encounter.title
	if RunState.last_deal_pending:
		RunState.refuse_last_deal(reason)
	else:
		RunState.end_run_in_defeat(reason)
	SCENE_ROUTER.change_to(self, "res://scenes/run_end/run_end.tscn")


func _finish_battle(player_won: bool) -> void:
	battle_finished = true
	combat_live = false
	if target_preview != null:
		target_preview.set_active(false)
	RunState.last_battle_won = player_won

	for unit in units:
		unit.combat_started = false
		unit.disable_placement()

	placement_hint.visible = false
	deployment_zone_a.visible = false
	deployment_zone_b.visible = false
	order_label.visible = false
	assault_order_button.visible = false
	hunt_order_button.visible = false
	formation_order_button.visible = false
	sacrifice_order_button.visible = false
	defiance_order_button.visible = false
	side_objective_panel.visible = false
	order_description_label.visible = false
	bottom_hud_panel.visible = false
	wizard_commentary_panel.visible = false
	wizard_commentary_label.visible = false
	restart_button.visible = false
	continue_button.visible = false
	last_deal_price_label.visible = false
	last_deal_accept_button.visible = false
	last_deal_refuse_button.visible = false

	if player_won:
		var side_objective_reward_text := _claim_side_objective_reward()
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
		if not side_objective_reward_text.is_empty():
			result_subtitle.text += "\n%s" % side_objective_reward_text
		status_label.text = "Карта пережита. Пока что."
		continue_button.text = "ЗАБРАТЬ НАГРАДУ"
		continue_button.visible = true
		continue_button.disabled = false
	else:
		RunState.record_wizard_memory("battle_defeat", encounter.encounter_id)
		_play_battle_audio("defeat")
		if RunState.begin_last_deal():
			_show_last_deal_offer()
		else:
			_show_final_defeat()

	result_scrim.visible = true
	result_backdrop.visible = true
	result_label.visible = true
	result_subtitle.visible = true
	fight_button.visible = false
	fight_button.text = "БОЙ ОКОНЧЕН"
	call_deferred("_animate_result_overlay", player_won)

func _play_battle_audio(event_name: String) -> void:
	if combat_audio != null and combat_audio.has_method("play_event"):
		combat_audio.call("play_event", event_name)


func _on_restart_pressed() -> void:
	# Free combat retries are intentionally disabled. Kept only as a legacy signal target.
	if battle_finished and not RunState.last_battle_won:
		return
	SCENE_ROUTER.reload_current(self)


func _on_continue_pressed() -> void:
	continue_button.disabled = true
	await _animate_result_choice_commit(continue_button)

	if RunState.last_battle_won:
		SCENE_ROUTER.change_to(self, "res://scenes/reward/reward.tscn")
		return

	RunState.end_run_in_defeat("Вы проиграли бой «%s»." % encounter.title)
	SCENE_ROUTER.change_to(self, "res://scenes/run_end/run_end.tscn")

