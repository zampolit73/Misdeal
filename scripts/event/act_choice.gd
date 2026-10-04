extends Control

@onready var title_label: Label = $Panel/Title
@onready var type_label: Label = $Panel/Type
@onready var description_label: Label = $Panel/Description
@onready var wizard_line: Label = $Panel/WizardLine
@onready var gold_label: Label = $Panel/Gold
@onready var artifacts_label: Label = $Panel/Artifacts
@onready var choice_a: Button = $Panel/Choices/ChoiceA
@onready var choice_b: Button = $Panel/Choices/ChoiceB
@onready var choice_c: Button = $Panel/Choices/ChoiceC
@onready var leave_button: Button = $Panel/LeaveButton
@onready var result_label: Label = $Panel/Result
@onready var continue_button: Button = $Panel/ContinueButton

var active_card: RunCardData
var resolved := false

func _ready() -> void:
	active_card = RunState.get_active_card()
	if active_card == null:
		push_warning("Act choice scene opened without an active run card.")
		get_tree().change_scene_to_file("res://scenes/table/table.tscn")
		return

	continue_button.pressed.connect(_return_to_table)
	leave_button.pressed.connect(_resolve_leave)

	title_label.text = active_card.title
	type_label.text = active_card.type_label
	description_label.text = active_card.card_text
	wizard_line.text = active_card.wizard_line
	_refresh_run_labels()
	_configure_card()

func _configure_card() -> void:
	match active_card.card_id:
		"ash_rest":
			_configure_ash_rest()
		"gravedigger_shop":
			_configure_shop()
		"curse_forge":
			_configure_curse_forge()
		_:
			push_warning("Unsupported act choice card: %s" % active_card.card_id)
			leave_button.text = "ВЕРНУТЬСЯ К СТОЛУ"
			_set_choices_visible(false)

func _configure_ash_rest() -> void:
	choice_a.text = "ОТДОХНУТЬ\n\n+15 здоровья каждому герою"
	choice_b.text = "РАЗГРЕСТИ ПЕПЕЛ\n\nНайти 15 золота"
	choice_c.text = "РАЗЖЕЧЬ УГЛИ\n\n+1 урона всему отряду"
	leave_button.text = "НЕ ЗАДЕРЖИВАТЬСЯ"
	choice_a.pressed.connect(_resolve_ash_rest.bind("rest"))
	choice_b.pressed.connect(_resolve_ash_rest.bind("gold"))
	choice_c.pressed.connect(_resolve_ash_rest.bind("damage"))

func _configure_shop() -> void:
	choice_a.text = "ЖЕЛЕЗНЫЕ ПЛАСТИНЫ — 25\n\n+20 здоровья каждому герою"
	choice_b.text = "ТОЧИЛЬНЫЙ КАМЕНЬ — 35\n\n+3 урона всему отряду"
	choice_c.text = "ЗАПЕЧАТАННАЯ РЕЛИКВИЯ — 45\n\nСлучайный артефакт"
	leave_button.text = "НИЧЕГО НЕ ПОКУПАТЬ"

	choice_a.disabled = RunState.gold < 25
	choice_b.disabled = RunState.gold < 35
	choice_c.disabled = RunState.gold < 45 or RunState.get_available_artifact_ids().is_empty()

	choice_a.pressed.connect(_resolve_shop.bind("hp"))
	choice_b.pressed.connect(_resolve_shop.bind("damage"))
	choice_c.pressed.connect(_resolve_shop.bind("artifact"))

func _configure_curse_forge() -> void:
	var artifact_ids := ["dead_mans_shield", "blind_quiver", "cracked_focus"]
	var buttons := [choice_a, choice_b, choice_c]

	for index in range(buttons.size()):
		var artifact_id: String = artifact_ids[index]
		var artifact := RunState.get_artifact(artifact_id)
		var button: Button = buttons[index]

		if artifact == null:
			button.visible = false
			continue

		button.text = "%s\n\n%s" % [artifact.title, artifact.description]
		button.disabled = RunState.has_artifact(artifact_id)
		button.pressed.connect(_resolve_forge.bind(artifact_id))

	leave_button.text = "ОТКАЗАТЬСЯ ОТ КОВКИ"

func _resolve_ash_rest(choice: String) -> void:
	if resolved:
		return

	match choice:
		"rest":
			RunState.party_hp_bonus += 15.0
			_finish("Тепло въедается в кости. Здоровье каждого героя +15.")
		"gold":
			RunState.gold += 15
			_finish("В пепле нашлись чужие монеты. Получено 15 золота.")
		"damage":
			RunState.party_damage_bonus += 1.0
			_finish("Вы уносите с собой жар углей. Урон отряда +1.")

func _resolve_shop(choice: String) -> void:
	if resolved:
		return

	match choice:
		"hp":
			if RunState.gold < 25:
				return
			RunState.gold -= 25
			RunState.party_hp_bonus += 20.0
			_finish("Могильщик забирает монеты. Здоровье каждого героя +20.")
		"damage":
			if RunState.gold < 35:
				return
			RunState.gold -= 35
			RunState.party_damage_bonus += 3.0
			_finish("Лезвия становятся острее. Урон отряда +3.")
		"artifact":
			if RunState.gold < 45:
				return
			var artifact_id := RunState.add_random_available_artifact()
			if artifact_id.is_empty():
				return
			RunState.gold -= 45
			var artifact := RunState.get_artifact(artifact_id)
			_finish("Печать ломается. Получен артефакт: %s." % artifact.title)

func _resolve_forge(artifact_id: String) -> void:
	if resolved or RunState.has_artifact(artifact_id):
		return

	if not RunState.add_artifact(artifact_id):
		return

	var artifact := RunState.get_artifact(artifact_id)
	_finish("Кузница принимает выбор. Получен артефакт: %s." % artifact.title)

func _resolve_leave() -> void:
	if resolved:
		return

	match active_card.card_id:
		"ash_rest":
			_finish("Вы оставляете пепел остывать. Волшебник выглядит разочарованным.")
		"gravedigger_shop":
			_finish("Монеты остаются при вас. Могильщик пожимает плечами.")
		"curse_forge":
			_finish("Вы уходите без артефакта. Молот за спиной ударяет сам собой.")
		_:
			_finish("Вы возвращаетесь к столу.")

func _finish(message: String) -> void:
	resolved = true
	_disable_choices()
	RunState.complete_active_card()
	result_label.text = message
	result_label.visible = true
	continue_button.visible = true
	_refresh_run_labels()

func _disable_choices() -> void:
	choice_a.disabled = true
	choice_b.disabled = true
	choice_c.disabled = true
	leave_button.disabled = true

func _set_choices_visible(value: bool) -> void:
	choice_a.visible = value
	choice_b.visible = value
	choice_c.visible = value

func _refresh_run_labels() -> void:
	gold_label.text = "ЗОЛОТО: %d" % RunState.gold
	artifacts_label.text = "АРТЕФАКТЫ: %s" % RunState.get_artifact_titles_text()

func _return_to_table() -> void:
	continue_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")
