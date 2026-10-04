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

func _configure_black_altar() -> void:
	choice_a.text = "КАПЛЯ КРОВИ\n\n-15 здоровья отряду\n+2 урона"
	choice_b.text = "ПОЛНАЯ ЧАША\n\n-30 здоровья отряду\n+4 урона"
	choice_c.text = "ОТКУПИТЬСЯ — 25\n\n+15 здоровья отряду"
	choice_c.disabled = RunState.gold < 25
	leave_button.text = "НЕ КАСАТЬСЯ АЛТАРЯ"

	choice_a.pressed.connect(_resolve_black_altar.bind("small_blood"))
	choice_b.pressed.connect(_resolve_black_altar.bind("deep_blood"))
	choice_c.pressed.connect(_resolve_black_altar.bind("coin"))

func _configure_chained_prisoner() -> void:
	choice_a.text = "ОСВОБОДИТЬ — 25\n\n+15 здоровья\n+1 урона отряду"
	choice_b.text = "СОРВАТЬ ЦЕПИ\n\n-10 здоровья\n+2 урона отряду"
	choice_c.text = "ОБЫСКАТЬ ПЛЕННИКА\n\n+25 золота\n-10 здоровья"
	choice_a.disabled = RunState.gold < 25
	leave_button.text = "ОСТАВИТЬ В ЦЕПЯХ"

	choice_a.pressed.connect(_resolve_chained_prisoner.bind("free"))
	choice_b.pressed.connect(_resolve_chained_prisoner.bind("break"))
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
	choice_a.text = "ПЕРЕВЕРНУТЬ КАРТУ\n\nИсход неизвестен"
	choice_b.text = "ПОДКУПИТЬ СУДЬБУ — 30\n\n+20 здоровья\n+2 урона отряду"
	choice_c.text = "СЖЕЧЬ КАРТУ\n\nГарантированно +1 урона"
	choice_b.disabled = RunState.gold < 30
	leave_button.text = "НЕ ТРОГАТЬ КАРТУ"

	choice_a.pressed.connect(_resolve_faceless_card.bind("reveal"))
	choice_b.pressed.connect(_resolve_faceless_card.bind("bribe"))
	choice_c.pressed.connect(_resolve_faceless_card.bind("burn"))

func _configure_blood_ledger() -> void:
	choice_a.text = "ПОДПИСАТЬ ЗОЛОТОМ — 40\n\n+4 урона отряду"
	choice_a.disabled = RunState.gold < 40

	if RunState.get_available_artifact_ids().is_empty():
		choice_b.text = "ПОДПИСАТЬ КРОВЬЮ\n\n-25 здоровья\n+3 урона отряду"
	else:
		choice_b.text = "ПОДПИСАТЬ КРОВЬЮ\n\n-25 здоровья\nСлучайный артефакт"

	choice_c.text = "ВЫЧЕРКНУТЬ ИМЯ\n\n+25 здоровья\n-2 урона отряду"
	leave_button.text = "ЗАКРЫТЬ КНИГУ"

	choice_a.pressed.connect(_resolve_blood_ledger.bind("gold"))
	choice_b.pressed.connect(_resolve_blood_ledger.bind("blood"))
	choice_c.pressed.connect(_resolve_blood_ledger.bind("erase"))

func _configure_broken_crown() -> void:
	choice_a.text = "НАДЕТЬ КОРОНУ\n\n+22% урона всей партии\n-10 здоровья каждому герою"
	choice_a.disabled = RunState.has_artifact("broken_crown")
	choice_b.text = "РАЗЛОМАТЬ КОРОНУ\n\n+40 золота"
	choice_c.text = "ПЕРЕПЛАВИТЬ ОСКОЛКИ\n\n+20 здоровья\n+1 урона отряду"
	leave_button.text = "ОСТАВИТЬ КОРОНУ"

	choice_a.pressed.connect(_resolve_broken_crown.bind("wear"))
	choice_b.pressed.connect(_resolve_broken_crown.bind("break"))
	choice_c.pressed.connect(_resolve_broken_crown.bind("melt"))

func _configure_last_camp() -> void:
	choice_a.text = "УКРЕПИТЬ ЛАГЕРЬ\n\n+30 здоровья каждому герою"
	choice_b.text = "ЗАТОЧИТЬ ОРУЖИЕ\n\n+3 урона отряду"
	choice_c.text = "СОБРАТЬ ПРИПАСЫ\n\n+25 золота"
	leave_button.text = "ИДТИ ДАЛЬШЕ СРАЗУ"

	choice_a.pressed.connect(_resolve_last_camp.bind("fortify"))
	choice_b.pressed.connect(_resolve_last_camp.bind("sharpen"))
	choice_c.pressed.connect(_resolve_last_camp.bind("supplies"))

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
	choice_a.text = "БЕЛАЯ СВЕЧА — 10\n\n+10 здоровья отряду"
	choice_b.text = "КРАСНАЯ СВЕЧА — 15\n\n+1 урона отряду"
	choice_c.text = "УКРАСТЬ ЯЩИК\n\n+20 золота\n-10 здоровья"
	choice_a.disabled = RunState.gold < 10
	choice_b.disabled = RunState.gold < 15
	leave_button.text = "НИЧЕГО НЕ ПОКУПАТЬ"

	choice_a.pressed.connect(_resolve_candle_seller.bind("white"))
	choice_b.pressed.connect(_resolve_candle_seller.bind("red"))
	choice_c.pressed.connect(_resolve_candle_seller.bind("steal"))

func _configure_bone_tax() -> void:
	choice_a.text = "ЗАПЛАТИТЬ 25 ЗОЛОТА\n\nПройти без последствий"
	choice_b.text = "ЗАПЛАТИТЬ КРОВЬЮ\n\n-15 здоровья отряду"
	choice_c.text = "ПРОРВАТЬСЯ СИЛОЙ\n\n-25 здоровья\n+2 урона отряду"
	choice_a.disabled = RunState.gold < 25
	leave_button.visible = false

	choice_a.pressed.connect(_resolve_bone_tax.bind("gold"))
	choice_b.pressed.connect(_resolve_bone_tax.bind("blood"))
	choice_c.pressed.connect(_resolve_bone_tax.bind("force"))

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

func _resolve_black_altar(choice: String) -> void:
	if resolved:
		return

	match choice:
		"small_blood":
			RunState.party_hp_bonus -= 15.0
			RunState.party_damage_bonus += 2.0
			_finish("Алтарь принимает кровь. Здоровье отряда -15, урон +2.")
		"deep_blood":
			RunState.party_hp_bonus -= 30.0
			RunState.party_damage_bonus += 4.0
			_finish("Камень пьёт жадно. Здоровье отряда -30, урон +4.")
		"coin":
			if RunState.gold < 25:
				return
			RunState.gold -= 25
			RunState.party_hp_bonus += 15.0
			_finish("Золото чернеет и плавится. Здоровье отряда +15.")

func _resolve_chained_prisoner(choice: String) -> void:
	if resolved:
		return

	match choice:
		"free":
			if RunState.gold < 25:
				return
			RunState.gold -= 25
			RunState.party_hp_bonus += 15.0
			RunState.party_damage_bonus += 1.0
			_finish("Пленник уходит, оставив полезные советы. Здоровье +15, урон +1.")
		"break":
			RunState.party_hp_bonus -= 10.0
			RunState.party_damage_bonus += 2.0
			_finish("Цепи поддаются не сразу. Здоровье -10, урон отряда +2.")
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
					RunState.party_damage_bonus += 4.0
					_finish("На карте появляется ваше лицо — чуть более жестокое. Урон отряда +4.")
				_:
					RunState.party_hp_bonus -= 25.0
					RunState.party_damage_bonus -= 2.0
					_finish("На карте оказывается лицо мертвеца. Здоровье -25, урон отряда -2.")
		"bribe":
			if RunState.gold < 30:
				return
			RunState.gold -= 30
			RunState.party_hp_bonus += 20.0
			RunState.party_damage_bonus += 2.0
			_finish("Монеты исчезают под картой. Здоровье +20, урон +2.")
		"burn":
			RunState.party_damage_bonus += 1.0
			_finish("Карта горит без дыма. Пепел остаётся на оружии: урон +1.")

func _resolve_blood_ledger(choice: String) -> void:
	if resolved:
		return

	match choice:
		"gold":
			if RunState.gold < 40:
				return
			RunState.gold -= 40
			RunState.party_damage_bonus += 4.0
			_finish("Книга принимает сорок монет и переписывает исход. Урон отряда +4.")
		"blood":
			RunState.party_hp_bonus -= 25.0
			var artifact_id := RunState.add_random_available_artifact()
			if artifact_id.is_empty():
				RunState.party_damage_bonus += 3.0
				_finish("Кровь впитывается в пустые страницы. Артефактов не осталось: здоровье -25, урон +3.")
			else:
				var artifact := RunState.get_artifact(artifact_id)
				_finish("Книга забирает кровь и выдаёт реликвию: %s. Здоровье -25." % artifact.title)
		"erase":
			RunState.party_hp_bonus += 25.0
			RunState.party_damage_bonus -= 2.0
			_finish("Ваше имя исчезает со страницы. Здоровье +25, урон отряда -2.")

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
			RunState.party_hp_bonus += 20.0
			RunState.party_damage_bonus += 1.0
			_finish("Металл идёт на доспехи и клинки. Здоровье +20, урон +1.")

func _resolve_last_camp(choice: String) -> void:
	if resolved:
		return

	match choice:
		"fortify":
			RunState.party_hp_bonus += 30.0
			_finish("Последний лагерь становится крепостью на одну ночь. Здоровье отряда +30.")
		"sharpen":
			RunState.party_damage_bonus += 3.0
			_finish("К утру лезвия становятся тоньше терпения волшебника. Урон отряда +3.")
		"supplies":
			RunState.gold += 25
			_finish("В забытых сумках нашлось 25 золота.")

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

func _resolve_candle_seller(choice: String) -> void:
	if resolved:
		return

	match choice:
		"white":
			if RunState.gold < 10:
				return
			RunState.gold -= 10
			RunState.party_hp_bonus += 10.0
			_finish("Белая свеча горит ровно. Здоровье отряда +10.")
		"red":
			if RunState.gold < 15:
				return
			RunState.gold -= 15
			RunState.party_damage_bonus += 1.0
			_finish("Красный воск капает на оружие. Урон отряда +1.")
		"steal":
			RunState.gold += 20
			RunState.party_hp_bonus -= 10.0
			_finish("Торговец оказывается не настолько слеп. +20 золота, здоровье -10.")

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
			RunState.party_hp_bonus -= 25.0
			RunState.party_damage_bonus += 2.0
			_finish("Пошлина превращается в драку. Здоровье -25, урон отряда +2.")

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
	artifacts_label.text = "АРТЕФАКТЫ: %s" % RunState.get_artifact_titles_text()
	var condition_text := RunState.get_run_condition_text()
	if not condition_text.is_empty():
		artifacts_label.text += "   |   %s" % condition_text

func _return_to_table() -> void:
	continue_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")
