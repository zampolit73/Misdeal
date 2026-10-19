extends Control

# D259: F6-only full real Battle -> Reward -> Table QA using the GAME LIBRARY.
# The full original five-role cast is staged in MisdealUnitAnimationLibrary.
# No temporary sprite injection, no change to the ordinary 37-card pool.
const BATTLE_SCENE: PackedScene = preload("res://scenes/battle/battle.tscn")
const ANIMATION_LIBRARY := preload("res://scripts/battle/unit_animation_library.gd")
const ENCOUNTER_PATH := "res://resources/encounters/black_lantern_road.tres"
const CARD_ID := "black_lantern_road"
const ENEMY_ROLES: Array[String] = ["extinguished_guide", "lantern_bearer", "road_sentinel", "oil_acolyte", "lantern_archer"]

var party_picker: OptionButton
var formation_picker: OptionButton
var error_label: Label
var menu: Control
var running := false


func _ready() -> void:
	_build_menu()
	if RunState.ACT1_CARD_IDS.size() != 37 or RunState.ACT1_CARD_IDS.has(CARD_ID):
		_fail("QA заблокирован: #38 не должна быть в обычной колоде 37/45.")
		return
	if RunState.get_card(CARD_ID) == null:
		_fail("Не найден RunCardData #38 в QA-каталоге.")
		return


func _build_menu() -> void:
	var background := ColorRect.new()
	background.color = Color(0.025, 0.017, 0.027)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	menu = PanelContainer.new()
	menu.position = Vector2(295, 112)
	menu.size = Vector2(690, 495)
	add_child(menu)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 15)
	menu.add_child(content)

	var title := _label("D259 · ДОРОГА ЧЁРНЫХ ФОНАРЕЙ", 28)
	content.add_child(title)
	content.add_child(_label("НАСТОЯЩИЙ BATTLE → REWARD → TABLE · ТОЛЬКО QA", 17))
	content.add_child(_label("Карта №38 не добавлена в обычную колоду. Этот F6-запуск создаёт отдельный тестовый забег, без сохранения игрового прогресса.", 15))

	content.add_child(_label("Состав отряда", 18))
	party_picker = OptionButton.new()
	party_picker.add_item("1 герой · Рыцарь", 1)
	party_picker.add_item("2 героя · Рыцарь + Следопыт", 2)
	party_picker.add_item("3 героя · Рыцарь + Следопыт + Маг", 3)
	party_picker.select(2)
	content.add_child(party_picker)

	content.add_child(_label("Расстановка врагов", 18))
	formation_picker = OptionButton.new()
	formation_picker.add_item("Марш", 0)
	formation_picker.add_item("Перекрёсток", 1)
	content.add_child(formation_picker)

	var launch := Button.new()
	launch.text = "ЗАПУСТИТЬ НАСТОЯЩИЙ БОЙ"
	launch.custom_minimum_size = Vector2(0, 46)
	launch.pressed.connect(_launch_real_battle)
	content.add_child(launch)
	content.add_child(_label("ВСЕ ПЯТЬ из игровой библиотеки: D257 + D244/D224, БЕЗ подмены кадров. Карта #38 всё ещё только QA.", 14))

	error_label = _label("", 15)
	error_label.add_theme_color_override("font_color", Color(1.0, 0.45, 0.38))
	content.add_child(error_label)


func _label(message: String, font_size: int) -> Label:
	var result := Label.new()
	result.text = message
	result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result.add_theme_font_size_override("font_size", font_size)
	result.add_theme_color_override("font_color", Color(0.91, 0.82, 0.69))
	return result


func _launch_real_battle() -> void:
	if running:
		return
	if RunState.ACT1_CARD_IDS.size() != 37 or RunState.ACT1_CARD_IDS.has(CARD_ID):
		_fail("Изоляция нарушена: #38 оказалась в живой колоде.")
		return

	# Validate the actual library for all five roles BEFORE changing RunState.
	for role in ENEMY_ROLES:
		var frames: SpriteFrames = ANIMATION_LIBRARY.get_frames(role)
		if frames == null:
			_fail("Не найден оригинальный игровой атлас: " + role)
			return
		for state in ["idle", "walk", "attack", "hit", "death"]:
			if not frames.has_animation(state) or frames.get_frame_count(state) < 3:
				_fail("Неполная анимация " + state + " / " + role)
				return

	# F6 is an independent Godot game process. This does not touch the user's
	# normal run or any persistent save data; restarting the normal game resets it.
	RunState.reset_run()
	if not RunState.choose_protagonist("knight"):
		_fail("Не удалось выбрать стартового Рыцаря.")
		return
	var count: int = party_picker.get_selected_id()
	for index in range(1, count):
		var role: String = RunState.HERO_ROLES[index]
		RunState.party_roles.append(role)
		RunState.hero_fates[role] = RunState.FATE_JOINED
		RunState.hero_fate_notes[role] = "QA D259: временно принят в отряд для теста боя."

	RunState.active_card_id = CARD_ID
	RunState.select_encounter(ENCOUNTER_PATH)
	RunState.combat_formation_by_card[CARD_ID] = formation_picker.get_selected_id()
	if RunState.get_active_card() == null:
		_fail("QA RunCardData недоступна после настройки.")
		return

	running = true
	menu.visible = false
	var battle := BATTLE_SCENE.instantiate() as Control
	if battle == null:
		running = false
		menu.visible = true
		_fail("Не удалось создать настоящую сцену Battle.")
		return
	add_child(battle)
	battle.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# IMPORTANT: no per-instance replacement. Verify native game library is used.
	var role_seen: Array[String] = []
	var stage_units: Array = battle.get("units")
	for candidate in stage_units:
		var actor := candidate as BattleUnit
		if actor == null or actor.team != 1:
			continue
		if not ENEMY_ROLES.has(actor.visual_role) or actor.sprite_frames == null:
			_fail("Боевой актёр без оригинального игрового атласа: " + actor.visual_role)
			return
		if actor.sprite_frames != ANIMATION_LIBRARY.get_frames(actor.visual_role):
			_fail("Неверная библиотека игровых кадров: " + actor.visual_role)
			return
		role_seen.append(actor.visual_role)
	role_seen.sort()
	var expected := ENEMY_ROLES.duplicate()
	expected.sort()
	if role_seen != expected:
		_fail("В реальном Battle неполный оригинальный состав: %s" % [role_seen])
		return
	print("D259_PRODUCTION_LIBRARY_BATTLE_READY: 5 original 25-pose roles in real Battle; no sprite injection; #38 still unreleased.")

func _fail(message: String) -> void:
	error_label.text = message
	push_error("D259: " + message)
