extends RefCounted
## Five independent siege stories. State is stored in existing event_outcomes.
const IDS := ["banner_seamstress", "unsent_letters", "borrowed_boots", "false_weights", "last_signal"]
const SCENES := {
	"banner_seamstress": "Полумёртвая швея режет знамя и вновь бинтует скелета. «Потерпите, капитан. Ещё немного. Подкрепление обещали к утру».",
	"unsent_letters": "Мёртвый почтмейстер запирает письма. Рядом один скелетный голубь. «Без разрешения комендатуры ничего не отправлять. Я должен дождаться печати».",
	"borrowed_boots": "Юный полумёртвый оруженосец натягивает огромный сапог. «Господин велел приготовить снаряжение к возвращению. Я уже почти закончил».",
	"false_weights": "«Следующий! По приказу комендатуры каждому положен полный паёк!» Мёртвый интендант кладёт камень на весы перед чучелами. «Вот и хорошо. Никто не жалуется».",
	"last_signal": "Дозорный-скелет поднимает потухшую жаровню над разрушенной башней. Ответных огней нет. «Ещё раз. Они обязательно увидят»."
}
const CHOICES := {
	"banner_seamstress": [
		["bandages", "ЗАБРАТЬ БИНТЫ\n\nМакс. HP героев +12.\nУрон героев -0.5 до конца забега.", "Швея отдаёт полосы ткани и снова ищет раны на костях капитана. Макс. HP героев +12, урон −0,5 до конца забега."],
		["standard", "СОХРАНИТЬ ЗНАМЯ\n\nУрон героев +0.75.\nМакс. HP героев -6 до конца забега.", "Вы сохраняете знамя. Швея поправляет старые повязки. Урон героев +0,75, макс. HP −6 до конца забега."],
		["passed", "НЕ ТРЕВОЖИТЬ ШВЕЮ\n\nБез изменений.", "Швея продолжает перевязку. Капитан терпит. Без изменений."]
	],
	"unsent_letters": [
		["release", "ОТПРАВИТЬ ПИСЬМО\n\n-10 золота.\nПодготовить «Неповиновение».", "Единственный костяной голубь уносит письмо. Почтмейстер проверяет замок. −10 золота; «Неповиновение» готово к одному бою."],
		["read", "ПРОЧИТАТЬ ЗАДЕРЖАННЫЕ ПИСЬМА\n\nУлика о южном марше.\nБез золота и усилений.", "Армия уходила на юг, прочь от замка. Почтмейстер прячет письма обратно. Получена улика о южном марше. Без золота и усилений."],
		["passed", "ЗАПЕРЕТЬ СУНДУК\n\nБез изменений.", "Замок щёлкает. Почтмейстер снова ждёт печати. Без изменений."]
	],
	"borrowed_boots": [
		["repair", "ВЫКУПИТЬ ЛЁГКУЮ ПАРУ\n\n-18 золота.\nСкорость героев +8% до конца забега.", "Оруженосец подгоняет ремни лёгкой пары, затем возвращается к огромному сапогу. −18 золота; скорость героев +8% до конца забега."],
		["hobnails", "ВЗЯТЬ ТЯЖЁЛЫЕ САПОГИ\n\nМакс. HP героев +8.\nСкорость -4% до конца забега.", "Вы забираете тяжёлую пару. Оруженосец раскладывает оставшееся снаряжение. Макс. HP героев +8, скорость −4% до конца забега."],
		["passed", "ОСТАВИТЬ САПОГИ ХОЗЯИНУ\n\nБез изменений.", "Оруженосец затягивает ремни: хозяин может вернуться в любую минуту. Без изменений."]
	],
	"false_weights": [
		["fair", "ПОТРЕБОВАТЬ ЧЕСТНЫЙ ПАЁК\n\n-12 золота. Макс. HP героев +16.\nУлика о скрытых запасах.", "В ведомости скрыты запасы. Вы забираете положенное; интендант зовёт следующее чучело. −12 золота; макс. HP героев +16 до конца забега. Получена улика о пайках."],
		["silence", "ПРИНЯТЬ ОТКУП\n\n+18 золота.\nМакс. HP героев -6 до конца забега.", "Интендант платит за молчание и выдаёт скудный паёк. «Следующий!» +18 золота; макс. HP героев −6 до конца забега."],
		["passed", "НЕ ВМЕШИВАТЬСЯ\n\nБез изменений.", "Камень остаётся на весах. Интендант зовёт следующее чучело. Без изменений."]
	],
	"last_signal": [
		["truth", "РАЗОРВАТЬ ОБЕЩАНИЕ\n\nСнять долг Волшебника.\n-20 золота; без двойной награды.", "Вы разрываете своё обещание Волшебнику. Дозорный всё ещё ждёт ответа. −20 золота; ваш долг снят вместе с будущей двойной наградой."],
		["salvage", "ЗАБРАТЬ СИГНАЛЬНУЮ ЧАШУ\n\n+22 золота.", "Вы снимаете сигнальную чашу. Дозорный вновь поднимает пустой шест. +22 золота."],
		["passed", "ОСТАВИТЬ ДОЗОРНОГО\n\nБез изменений.", "Дозорный вновь поднимает потухшую жаровню. Горизонт молчит. Без изменений."]
	]
}

static func available(state: Node, id: String, choice: String) -> bool:
	if not IDS.has(id) or state.active_card_id != id or state.has_event_outcome(id):
		return false
	var known := false
	for entry in CHOICES[id]:
		if entry[0] == choice: known = true
	if not known: return false
	match id + ":" + choice:
		"unsent_letters:release": return state.gold >= 10 and not state.defiance_order_ready
		"borrowed_boots:repair": return state.gold >= 18
		"false_weights:fair": return state.gold >= 12
		"last_signal:truth": return state.gold >= 20 and state.wizard_debt_active
	return true

static func resolve(state: Node, id: String, choice: String) -> bool:
	if not available(state, id, choice): return false
	match id + ":" + choice:
		"banner_seamstress:bandages":
			state.party_hp_bonus += 12.0
			state.party_damage_bonus -= 0.5
		"banner_seamstress:standard":
			state.party_hp_bonus -= 6.0
			state.party_damage_bonus += 0.75
		"unsent_letters:release":
			state.gold -= 10
			state.defiance_order_ready = true
		"unsent_letters:read": state.record_castle_fact(state.CASTLE_FACT_MARCH, id)
		"borrowed_boots:repair": state.gold -= 18
		"borrowed_boots:hobnails": state.party_hp_bonus += 8.0
		"false_weights:fair":
			state.gold -= 12
			state.party_hp_bonus += 16.0
			state.record_castle_fact(state.CASTLE_FACT_RATIONS, id)
		"false_weights:silence":
			state.gold += 18
			state.party_hp_bonus -= 6.0
		"last_signal:truth":
			state.gold -= 20
			state.wizard_debt_active = false
			state.record_wizard_memory("debt_cleared", id)
		"last_signal:salvage": state.gold += 22
	state.set_event_outcome(id, choice)
	return true

static func movement_multiplier(state: Node) -> float:
	match state.get_event_outcome("borrowed_boots"):
		"repair": return 1.08
		"hobnails": return 0.96
	return 1.0
