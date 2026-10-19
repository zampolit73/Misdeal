extends Control

# D258: F6-only test harness for the ACTUAL Battle -> Reward -> Table route.
# The unreleased #38 card is addressable by ID, never put in ACT1_CARD_IDS.
# This scene starts a clean, throwaway local QA run, not the normal game.
# Only the three unfinished character arts are injected into this Battle
# instance, without enabling any unfinished global animation roles.
const BATTLE_SCENE: PackedScene = preload("res://scenes/battle/battle.tscn")
const D258_ART := preload("res://scripts/dev/black_lantern_d258_qa_art.gd")
const ENCOUNTER_PATH := "res://resources/encounters/black_lantern_road.tres"
const CARD_ID := "black_lantern_road"
const TEMP_ART := {
	"extinguished_guide": "res://assets/pixel/units/black_lantern_road_qa/extinguished_guide_d257_seam_recovery_qa.webp.b64",
	"oil_acolyte": "res://assets/pixel/units/black_lantern_road_qa/oil_acolyte_d257_seam_recovery_qa.webp.b64",
	"lantern_archer": "res://assets/pixel/units/black_lantern_road_qa/lantern_archer_d257_seam_recovery_qa.webp.b64"
}

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

	var title := _label("D258 · ДОРОГА ЧЁРНЫХ ФОНАРЕЙ", 28)
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
	content.add_child(_label("Проводник, Служка и Стрелок: новые полные D257 (только QA), Страж и Носильщик: D244/D224.", 14))

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

	# Validate original 25-cel temporary art BEFORE resetting any state.
	var temp_frames: Dictionary = {}
	for role in TEMP_ART.keys():
		var frames := D258_ART.get_frames(str(role))
		if frames == null:
			_fail("Не найден оригинальный QA-атлас: " + str(role))
			return
		temp_frames[role] = frames

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
		RunState.hero_fate_notes[role] = "QA D258: временно принят в отряд для теста боя."

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

	var injected: int = 0
	var stage_units: Array = battle.get("units")
	for candidate in stage_units:
		var actor := candidate as BattleUnit
		if actor == null or actor.team != 1 or not temp_frames.has(actor.visual_role):
			continue
		var sprite_set: SpriteFrames = temp_frames[actor.visual_role]
		actor.sprite_frames = sprite_set
		actor.frame_state = "idle"
		actor.frame_time = 0.0
		actor.frame_one_shot_time = 0.0
		actor.art_sprite.texture = sprite_set.get_frame_texture("idle", 0)
		actor.art_sprite.position = actor._art_rest_position()
		actor.rim_sprite.texture = actor.art_sprite.texture
		injected += 1

	if injected != TEMP_ART.size():
		push_error("D258: full original D257 role injection failed (%d/3)." % injected)
		# Keep the battle visible for diagnosis, never claim the preview passed.
	else:
		print("D258: actual Battle started with party %d, formation %d, 3 recovered D257 art packs (QA only)." % [
			count, formation_picker.get_selected_id()
		])


func _fail(message: String) -> void:
	error_label.text = message
	push_error("D258: " + message)
