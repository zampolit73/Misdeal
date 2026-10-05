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
		"black_altar":
			_configure_black_altar()
		"chained_prisoner":
			_configure_chained_prisoner()
		"debtor_bones":
			_configure_debtor_bones()
		"wizard_tithe":
			_configure_wizard_tithe()
		"faceless_card":
			_configure_faceless_card()
		"blood_ledger":
			_configure_blood_ledger()
		"broken_crown":
			_configure_broken_crown()
		"last_camp":
			_configure_last_camp()
		"rattling_bridge":
			_configure_rattling_bridge()
		"lost_purse":
			_configure_lost_purse()
		"candle_seller":
			_configure_candle_seller()
		"bone_tax":
			_configure_bone_tax()
		_:
			push_warning("Unsupported act choice card: %s" % active_card.card_id)
			leave_button.text = "ВЕРНУТЬСЯ К СТОЛУ"
			_set_choices_visible(false)

func _configure_ash_rest() -> void:
	_set_role_upgrade_button(choice_a, "knight", "ПОДЛАТАТЬ ДОСПЕХ")
	_set_role_upgrade_button(choice_b, "ranger", "ПРОВЕРИТЬ ТЕТИВУ")
	_set_role_upgrade_button(choice_c, "mage", "РАЗДУТЬ УГЛИ")
	leave_button.text = "НЕ ЗАДЕРЖИВАТЬСЯ"

	choice_a.pressed.connect(_resolve_ash_rest.bind("knight"))
	choice_b.pressed.connect(_resolve_ash_rest.bind("ranger"))
	choice_c.pressed.connect(_resolve_ash_rest.bind("mage"))

func _configure_shop() -> void:
	_set_role_upgrade_button(choice_a, "knight", "МОГИЛЬНЫЙ УРОК — 35")
	_set_role_upgrade_button(choice_b, "ranger", "ОХОТНИЧЬЯ СХЕМА — 35")
	_set_role_upgrade_button(choice_c, "mage", "ЗАПРЕТНАЯ ЗАПИСКА — 35")
	leave_button.text = "НИЧЕГО НЕ ПОКУПАТЬ"

	choice_a.disabled = choice_a.disabled or RunState.gold < 35
	choice_b.disabled = choice_b.disabled or RunState.gold < 35
	choice_c.disabled = choice_c.disabled or RunState.gold < 35

	choice_a.pressed.connect(_resolve_shop.bind("knight"))
	choice_b.pressed.connect(_resolve_shop.bind("ranger"))
	choice_c.pressed.connect(_resolve_shop.bind("mage"))

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

func _configure_black_altar() -> void:
	_set_role_upgrade_button(choice_a, "knight", "КРОВЬ РЫЦАРЯ", "-20 здоровья отряду")
	_set_role_upgrade_button(choice_b, "ranger", "КРОВЬ СЛЕДОПЫТА", "-15 здоровья отряду")
	_set_role_upgrade_button(choice_c, "mage", "КРОВЬ МАГА", "-20 здоровья отряду")
	leave_button.text = "НЕ КАСАТЬСЯ АЛТАРЯ"

	choice_a.pressed.connect(_resolve_black_altar.bind("knight"))
	choice_b.pressed.connect(_resolve_black_altar.bind("ranger"))
	choice_c.pressed.connect(_resolve_black_altar.bind("mage"))

func _configure_chained_prisoner() -> void:
	_set_least_developed_upgrade_button(choice_a, "ОСВОБОДИТЬ — 25", "Пленник обучит самого отстающего героя.")
	choice_a.disabled = choice_a.disabled or RunState.gold < 25

	if RunState.get_available_artifact_ids().is_empty():
		choice_b.text = "СОРВАТЬ ЦЕПИ\n\n-15 здоровья отряду\n+35 золота — реликвий больше нет"
	else:
		choice_b.text = "СОРВАТЬ ЦЕПИ\n\n-15 здоровья отряду\nСлучайная реликвия"

	choice_c.text = "ОБЫСКАТЬ ПЛЕННИКА\n\n+25 золота\n-10 здоровья отряду"
	leave_button.text = "ОСТАВИТЬ В ЦЕПЯХ"

	choice_a.pressed.connect(_resolve_chained_prisoner.bind("mentor"))
	choice_b.pressed.connect(_resolve_chained_prisoner.bind("chains"))
	choice_c.pressed.connect(_resolve_chained_prisoner.bind("loot"))

func _configure_debtor_bones() -> void:
	choice_a.text = "БРОСИТЬ КОСТИ\n\n50%: +45 золота\n50%: проклятие"
	choice_b.text = "ВЗЯТЬ МЕЛОЧЬ\n\nГарантированно +15 золота"
	choice_c.text = "РАЗБИТЬ КОСТИ\n\n+25 золота\n-10 здоровья"
	leave_button.text = "НЕ ТРОГАТЬ ДОЛГ"

	choice_a.pressed.connect(_resolve_debtor_bones.bind("gamble"))
	choice_b.pressed.connect(_resolve_debtor_bones.bind("safe"))
	choice_c.pressed.connect(_resolve_debtor_bones.bind("break"))

func _configure_wizard_tithe() -> void:
	choice_a.text = "ЗАПЛАТИТЬ 30 ЗОЛОТА\n\nДолг закрыт сразу"
	choice_b.text = "ЗАПЛАТИТЬ КРОВЬЮ\n\n-20 здоровья отряду"
	choice_c.text = "ОТКАЗАТЬ\n\nВраги +25% урона\nСледующая обычная награда x2"
	choice_a.disabled = RunState.gold < 30
	leave_button.visible = false

	choice_a.pressed.connect(_resolve_wizard_tithe.bind("gold"))
	choice_b.pressed.connect(_resolve_wizard_tithe.bind("blood"))
	choice_c.pressed.connect(_resolve_wizard_tithe.bind("refuse"))

func _configure_faceless_card() -> void:
	choice_a.text = "ПЕРЕВЕРНУТЬ КАРТУ\n\nИсход неизвестен:\nзолото, реликвия или развитие"

	_set_least_developed_upgrade_button(choice_b, "ПОДКУПИТЬ СУДЬБУ — 30", "Гарантированное развитие самого отстающего героя.")
	choice_b.disabled = choice_b.disabled or RunState.gold < 30

	if RunState.wizard_debt_active:
		choice_c.text = "СЖЕЧЬ КАРТУ\n\nСнять ДОЛГ ВОЛШЕБНИКУ"
	else:
		choice_c.text = "СЖЕЧЬ КАРТУ\n\n+20 золота"

	leave_button.text = "НЕ ТРОГАТЬ КАРТУ"

	choice_a.pressed.connect(_resolve_faceless_card.bind("reveal"))
	choice_b.pressed.connect(_resolve_faceless_card.bind("bribe"))
	choice_c.pressed.connect(_resolve_faceless_card.bind("burn"))

func _configure_blood_ledger() -> void:
	_set_least_developed_upgrade_button(choice_a, "ПОДПИСАТЬ ЗОЛОТОМ — 40", "Книга усилит самого отстающего героя.")
	choice_a.disabled = choice_a.disabled or RunState.gold < 40

	if RunState.get_available_artifact_ids().is_empty():
		_set_least_developed_upgrade_button(choice_b, "ПОДПИСАТЬ КРОВЬЮ", "-25 здоровья. Реликвий больше нет — книга предложит развитие.")
	else:
		choice_b.text = "ПОДПИСАТЬ КРОВЬЮ\n\n-25 здоровья отряду\nСлучайная реликвия"

	var last_upgrade_id := RunState.get_last_hero_upgrade_id()
	if last_upgrade_id.is_empty():
		choice_c.text = "ВЫЧЕРКНУТЬ ИМЯ\n\nНечего стирать"
		choice_c.disabled = true
	else:
		var last_upgrade := RunState.get_hero_upgrade(last_upgrade_id)
		choice_c.text = "ВЫЧЕРКНУТЬ: %s\n\nПотерять последнее развитие\n+70 золота" % last_upgrade.title

	leave_button.text = "ЗАКРЫТЬ КНИГУ"

	choice_a.pressed.connect(_resolve_blood_ledger.bind("gold"))
	choice_b.pressed.connect(_resolve_blood_ledger.bind("blood"))
	choice_c.pressed.connect(_resolve_blood_ledger.bind("erase"))

func _configure_broken_crown() -> void:
	choice_a.text = "НАДЕТЬ КОРОНУ\n\n+22% урона всей партии\n-10 здоровья каждому герою"
	choice_a.disabled = RunState.has_artifact("broken_crown")
	choice_b.text = "РАЗЛОМАТЬ КОРОНУ\n\n+40 золота"
	_set_least_developed_upgrade_button(choice_c, "ПЕРЕПЛАВИТЬ ОСКОЛКИ", "Осколки станут развитием самого отстающего героя.")
	leave_button.text = "ОСТАВИТЬ КОРОНУ"

	choice_a.pressed.connect(_resolve_broken_crown.bind("wear"))
	choice_b.pressed.connect(_resolve_broken_crown.bind("break"))
	choice_c.pressed.connect(_resolve_broken_crown.bind("melt"))

func _configure_last_camp() -> void:
	_set_role_upgrade_button(choice_a, "knight", "ГОТОВИТЬ РЫЦАРЯ")
	_set_role_upgrade_button(choice_b, "ranger", "ГОТОВИТЬ СЛЕДОПЫТА")
	_set_role_upgrade_button(choice_c, "mage", "ГОТОВИТЬ МАГА")
	leave_button.text = "ИДТИ ДАЛЬШЕ СРАЗУ"

	choice_a.pressed.connect(_resolve_last_camp.bind("knight"))
	choice_b.pressed.connect(_resolve_last_camp.bind("ranger"))
	choice_c.pressed.connect(_resolve_last_camp.bind("mage"))

func _configure_rattling_bridge() -> void:
	choice_a.text = "ПЕРЕБЕЖАТЬ\n\n50%: +25 золота\n50%: -20 здоровья"
	choice_b.text = "СОБРАТЬ МОНЕТЫ С ПЕРИЛ\n\n+15 золота\n-5 здоровья"
	choice_c.text = "ИДТИ МЕДЛЕННО\n\nБез награды и без риска"
	leave_button.visible = false

	choice_a.pressed.connect(_resolve_rattling_bridge.bind("rush"))
	choice_b.pressed.connect(_resolve_rattling_bridge.bind("scavenge"))
	choice_c.pressed.connect(_resolve_rattling_bridge.bind("careful"))

func _configure_lost_purse() -> void:
	choice_a.text = "ВЗЯТЬ ВЕРХНИЕ МОНЕТЫ\n\n+15 золота"
	choice_b.text = "ЗАПУСТИТЬ РУКУ ГЛУБЖЕ\n\n+35 золота\n-10 здоровья"
	choice_c.text = "ВЫРВАТЬ КОШЕЛЬ ЦЕЛИКОМ\n\n+55 золота\n-25 здоровья"
	leave_button.text = "ОСТАВИТЬ МЕРТВЕЦУ"

	choice_a.pressed.connect(_resolve_lost_purse.bind("safe"))
	choice_b.pressed.connect(_resolve_lost_purse.bind("greedy"))
	choice_c.pressed.connect(_resolve_lost_purse.bind("all_in"))

func _configure_candle_seller() -> void:
	_set_role_upgrade_button(choice_a, "knight", "СИНЯЯ СВЕЧА — 25")
	_set_role_upgrade_button(choice_b, "ranger", "ЗЕЛЁНАЯ СВЕЧА — 25")
	_set_role_upgrade_button(choice_c, "mage", "ФИОЛЕТОВАЯ СВЕЧА — 25")
	choice_a.disabled = choice_a.disabled or RunState.gold < 25
	choice_b.disabled = choice_b.disabled or RunState.gold < 25
	choice_c.disabled = choice_c.disabled or RunState.gold < 25
	leave_button.text = "НИЧЕГО НЕ ПОКУПАТЬ"

	choice_a.pressed.connect(_resolve_candle_seller.bind("knight"))
	choice_b.pressed.connect(_resolve_candle_seller.bind("ranger"))
	choice_c.pressed.connect(_resolve_candle_seller.bind("mage"))

func _configure_bone_tax() -> void:
	choice_a.text = "ЗАПЛАТИТЬ 25 ЗОЛОТА\n\nПройти без последствий"
	choice_a.disabled = RunState.gold < 25
	choice_b.text = "ЗАПЛАТИТЬ КРОВЬЮ\n\n-15 здоровья отряду"
	_set_least_developed_upgrade_button(choice_c, "ПРОРВАТЬСЯ СИЛОЙ", "-25 здоровья, но драка закалит самого отстающего героя.")
	leave_button.visible = false

	choice_a.pressed.connect(_resolve_bone_tax.bind("gold"))
	choice_b.pressed.connect(_resolve_bone_tax.bind("blood"))
	choice_c.pressed.connect(_resolve_bone_tax.bind("force"))

func _get_role_label(role: String) -> String:
	match role:
		"knight":
			return "РЫЦАРЬ"
		"ranger":
			return "СЛЕДОПЫТ"
		"mage":
			return "МАГ"
		_:
			return "ГЕРОЙ"

func _set_role_upgrade_button(button: Button, role: String, heading: String, extra_text: String = "") -> void:
	var upgrade_id := RunState.get_next_available_hero_upgrade_id(role)
	if upgrade_id.is_empty():
		button.text = "%s\n\n%s: все пути развития уже освоены" % [heading, _get_role_label(role)]
		button.disabled = true
		return

	var upgrade := RunState.get_hero_upgrade(upgrade_id)
	var tail := ""
	if not extra_text.is_empty():
		tail = "\n\n%s" % extra_text

	button.text = "%s\n\n%s — %s\n%s%s" % [
		heading,
		_get_role_label(role),
		upgrade.title,
		upgrade.description,
		tail
	]

func _set_least_developed_upgrade_button(button: Button, heading: String, extra_text: String = "") -> void:
	var role := RunState.get_least_developed_available_role()
	if role.is_empty():
		button.text = "%s\n\nВсе известные пути развития уже освоены" % heading
		button.disabled = true
		return

	_set_role_upgrade_button(button, role, heading, extra_text)

func _grant_role_upgrade(role: String) -> String:
	return RunState.add_next_available_hero_upgrade(role)

func _grant_least_developed_upgrade() -> String:
	return RunState.add_upgrade_to_least_developed_role()

func _format_upgrade_gain(upgrade_id: String) -> String:
	if upgrade_id.is_empty():
		return "Новых путей развития не осталось."

	var upgrade := RunState.get_hero_upgrade(upgrade_id)
	if upgrade == null:
		return "Развитие изменилось."
	return "%s получает развитие: %s." % [_get_role_label(upgrade.target_role), upgrade.title]

func _resolve_ash_rest(role: String) -> void:
	if resolved:
		return

	var upgrade_id := _grant_role_upgrade(role)
	if upgrade_id.is_empty():
		return
	_finish("У костра рождается новый приём. %s" % _format_upgrade_gain(upgrade_id))

func _resolve_shop(role: String) -> void:
	if resolved or RunState.gold < 35:
		return

	var upgrade_id := _grant_role_upgrade(role)
	if upgrade_id.is_empty():
		return

	RunState.gold -= 35
	_finish("Могильщик берёт монеты и передаёт чужой секрет. %s" % _format_upgrade_gain(upgrade_id))

func _resolve_forge(artifact_id: String) -> void:
	if resolved or RunState.has_artifact(artifact_id):
		return

	if not RunState.add_artifact(artifact_id):
		return

	var artifact := RunState.get_artifact(artifact_id)
	_finish("Кузница принимает выбор. Получен артефакт: %s." % artifact.title)

func _resolve_black_altar(role: String) -> void:
	if resolved:
		return

	var hp_cost := -15.0 if role == "ranger" else -20.0
	var upgrade_id := _grant_role_upgrade(role)
	if upgrade_id.is_empty():
		return

	RunState.party_hp_bonus += hp_cost
	_finish("Алтарь принимает кровь. Здоровье отряда %d. %s" % [int(hp_cost), _format_upgrade_gain(upgrade_id)])

func _resolve_chained_prisoner(choice: String) -> void:
	if resolved:
		return

	match choice:
		"mentor":
			if RunState.gold < 25:
				return
			var upgrade_id := _grant_least_developed_upgrade()
			if upgrade_id.is_empty():
				return
			RunState.gold -= 25
			_finish("Пленник покупает свободу знанием. %s" % _format_upgrade_gain(upgrade_id))
		"chains":
			RunState.party_hp_bonus -= 15.0
			var artifact_id := RunState.add_random_available_artifact()
			if artifact_id.is_empty():
				RunState.gold += 35
				_finish("Цепи ломаются, но тайник пуст. Здоровье -15, получено 35 золота.")
			else:
				var artifact := RunState.get_artifact(artifact_id)
				_finish("За цепями спрятана реликвия: %s. Здоровье отряда -15." % artifact.title)
		"loot":
			RunState.gold += 25
			RunState.party_hp_bonus -= 10.0
			_finish("Монеты ваши. Цепи оставляют след. Получено 25 золота, здоровье -10.")

func _resolve_debtor_bones(choice: String) -> void:
	if resolved:
		return

	match choice:
		"gamble":
			if randf() < 0.5:
				RunState.gold += 45
				_finish("Кости падают удачно. Получено 45 золота.")
			else:
				RunState.party_hp_bonus -= 15.0
				RunState.party_damage_bonus -= 1.0
				_finish("Кости помнят старого должника. Здоровье -15, урон отряда -1.")
		"safe":
			RunState.gold += 15
			_finish("Вы берёте только мелочь. Получено 15 золота.")
		"break":
			RunState.gold += 25
			RunState.party_hp_bonus -= 10.0
			_finish("Кости трескаются вместе с обещаниями. +25 золота, здоровье -10.")

func _resolve_wizard_tithe(choice: String) -> void:
	if resolved:
		return

	match choice:
		"gold":
			if RunState.gold < 30:
				return
			RunState.gold -= 30
			_finish("Волшебник пересчитывает монеты и кивает. На этот раз вы квиты.")
		"blood":
			RunState.party_hp_bonus -= 20.0
			_finish("Кровь исчезает с ладони хозяина стола. Здоровье отряда -20.")
		"refuse":
			RunState.activate_wizard_debt()
			_finish("Волшебник улыбается. До следующей обычной награды враги наносят +25% урона, зато награда будет удвоена.")

func _resolve_faceless_card(choice: String) -> void:
	if resolved:
		return

	match choice:
		"reveal":
			var outcome := randi_range(0, 2)
			match outcome:
				0:
					RunState.gold += 60
					_finish("На карте проступает золотая маска. Получено 60 золота.")
				1:
					var artifact_id := RunState.add_random_available_artifact()
					if artifact_id.is_empty():
						RunState.gold += 35
						_finish("Лицо на карте пусто. Реликвий не осталось: получено 35 золота.")
					else:
						var artifact := RunState.get_artifact(artifact_id)
						_finish("На карте проступает реликвия: %s." % artifact.title)
				_:
					var upgrade_id := _grant_least_developed_upgrade()
					if upgrade_id.is_empty():
						RunState.gold += 35
						_finish("Карта не находит, что ещё изменить. Получено 35 золота.")
					else:
						_finish("Карта показывает возможное будущее. %s" % _format_upgrade_gain(upgrade_id))
		"bribe":
			if RunState.gold < 30:
				return
			var upgrade_id := _grant_least_developed_upgrade()
			if upgrade_id.is_empty():
				return
			RunState.gold -= 30
			_finish("Монеты исчезают под картой. %s" % _format_upgrade_gain(upgrade_id))
		"burn":
			if RunState.wizard_debt_active:
				RunState.clear_wizard_debt()
				_finish("Карта вспыхивает чёрным пламенем. ДОЛГ ВОЛШЕБНИКУ исчезает вместе с ней.")
			else:
				RunState.gold += 20
				_finish("Карта горит без дыма. В пепле остаётся 20 золота.")

func _resolve_blood_ledger(choice: String) -> void:
	if resolved:
		return

	match choice:
		"gold":
			if RunState.gold < 40:
				return
			var upgrade_id := _grant_least_developed_upgrade()
			if upgrade_id.is_empty():
				return
			RunState.gold -= 40
			_finish("Книга принимает сорок монет и вписывает новый исход. %s" % _format_upgrade_gain(upgrade_id))
		"blood":
			RunState.party_hp_bonus -= 25.0
			var artifact_id := RunState.add_random_available_artifact()
			if artifact_id.is_empty():
				var upgrade_id := _grant_least_developed_upgrade()
				if upgrade_id.is_empty():
					RunState.gold += 40
					_finish("Книга забирает кровь, но страниц больше нет. Здоровье -25, получено 40 золота.")
				else:
					_finish("Книга забирает кровь и переписывает героя. Здоровье -25. %s" % _format_upgrade_gain(upgrade_id))
			else:
				var artifact := RunState.get_artifact(artifact_id)
				_finish("Книга забирает кровь и выдаёт реликвию: %s. Здоровье -25." % artifact.title)
		"erase":
			var removed_id := RunState.remove_last_hero_upgrade()
			if removed_id.is_empty():
				return
			var removed := RunState.get_hero_upgrade(removed_id)
			RunState.gold += 70
			_finish("Строка исчезает из книги. Потеряно развитие %s. Получено 70 золота." % removed.title)

func _resolve_broken_crown(choice: String) -> void:
	if resolved:
		return

	match choice:
		"wear":
			if not RunState.add_artifact("broken_crown"):
				return
			_finish("Корона садится слишком плотно. Получен артефакт: СЛОМАННАЯ КОРОНА.")
		"break":
			RunState.gold += 40
			_finish("Корона раскалывается окончательно. В оправе спрятано 40 золота.")
		"melt":
			var upgrade_id := _grant_least_developed_upgrade()
			if upgrade_id.is_empty():
				RunState.gold += 30
				_finish("Осколки уже не могут улучшить отряд. Получено 30 золота.")
			else:
				_finish("Осколки переплавлены в новый приём. %s" % _format_upgrade_gain(upgrade_id))

func _resolve_last_camp(role: String) -> void:
	if resolved:
		return

	var upgrade_id := _grant_role_upgrade(role)
	if upgrade_id.is_empty():
		return

	_finish("Последняя ночь перед надзирателем не проходит зря. %s" % _format_upgrade_gain(upgrade_id))

func _resolve_rattling_bridge(choice: String) -> void:
	if resolved:
		return

	match choice:
		"rush":
			if randf() < 0.5:
				RunState.gold += 25
				_finish("Мост выдерживает. Между костями нашлось 25 золота.")
			else:
				RunState.party_hp_bonus -= 20.0
				_finish("Мост кусается за ноги. Здоровье отряда -20.")
		"scavenge":
			RunState.gold += 15
			RunState.party_hp_bonus -= 5.0
			_finish("Переход занимает вечность. Получено 15 золота, здоровье -5.")
		"careful":
			_finish("Вы переходите мост медленно и скучно. Даже волшебник зевает.")

func _resolve_lost_purse(choice: String) -> void:
	if resolved:
		return

	match choice:
		"safe":
			RunState.gold += 15
			_finish("Вы берёте только то, что лежит сверху. Получено 15 золота.")
		"greedy":
			RunState.gold += 35
			RunState.party_hp_bonus -= 10.0
			_finish("Мёртвые пальцы сжимаются. +35 золота, здоровье -10.")
		"all_in":
			RunState.gold += 55
			RunState.party_hp_bonus -= 25.0
			_finish("Кошель ваш. Кусок руки тоже. +55 золота, здоровье -25.")

func _resolve_candle_seller(role: String) -> void:
	if resolved or RunState.gold < 25:
		return

	var upgrade_id := _grant_role_upgrade(role)
	if upgrade_id.is_empty():
		return

	RunState.gold -= 25
	_finish("Свеча сгорает за секунду, оставляя знание вместо воска. %s" % _format_upgrade_gain(upgrade_id))

func _resolve_bone_tax(choice: String) -> void:
	if resolved:
		return

	match choice:
		"gold":
			if RunState.gold < 25:
				return
			RunState.gold -= 25
			_finish("Пошлина уплачена. Страж даже не притворяется благодарным.")
		"blood":
			RunState.party_hp_bonus -= 15.0
			_finish("Страж принимает кровь вместо монет. Здоровье отряда -15.")
		"force":
			var upgrade_id := _grant_least_developed_upgrade()
			if upgrade_id.is_empty():
				return
			RunState.party_hp_bonus -= 25.0
			_finish("Пошлина превращается в драку. Здоровье -25. %s" % _format_upgrade_gain(upgrade_id))

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
		"black_altar":
			_finish("Вы не касаетесь камня. Алтарь продолжает ждать следующего.")
		"chained_prisoner":
			_finish("Цепи звенят за спиной. Волшебник ничего не комментирует — и это хуже.")
		"debtor_bones":
			_finish("Вы оставляете чужой долг лежать в пыли.")
		"faceless_card":
			_finish("Карта остаётся лежать лицом вниз. Волшебник явно считает это скучным.")
		"blood_ledger":
			_finish("Книга закрывается сама. Вашего имени внутри пока нет.")
		"broken_crown":
			_finish("Корона остаётся без хозяина. Возможно, это самый разумный исход.")
		"last_camp":
			_finish("Вы не задерживаетесь. До надзирателя остаётся совсем немного.")
		"lost_purse":
			_finish("Вы оставляете кошель мертвецу. Волшебник разочарован вашей сдержанностью.")
		"candle_seller":
			_finish("Свечи остаются у торговца. Темнота — у вас.")
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
	artifacts_label.text = "РАЗВИТИЕ: %d   |   РЕЛИКВИИ: %s" % [
		RunState.hero_upgrade_ids.size(),
		RunState.get_artifact_titles_text()
	]
	var condition_text := RunState.get_run_condition_text()
	if not condition_text.is_empty():
		artifacts_label.text += "   |   %s" % condition_text

func _return_to_table() -> void:
	continue_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")
