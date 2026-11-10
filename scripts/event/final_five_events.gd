extends RefCounted
## Five independent siege stories. State is stored in existing event_outcomes.
const IDS := ["banner_seamstress", "unsent_letters", "borrowed_boots", "false_weights", "last_signal"]
const CHOICES := {
	"banner_seamstress": [
		["bandages", "РАЗРЕЗАТЬ ЗНАМЯ\n\nМакс. HP героев +12.\nУрон героев -0.5 до конца забега.", "Швея режет герб на полосы. Ткань служит живым: макс. HP героев +12, урон -0.5 до конца забега."],
		["standard", "ПОДНЯТЬ ЗНАМЯ\n\nУрон героев +0.75.\nМакс. HP героев -6 до конца забега.", "Знамя снова видно со стены. Бинтов не осталось: урон героев +0.75, макс. HP -6 до конца забега."],
		["passed", "ОСТАВИТЬ ШВЕЕ\n\nБез изменений.\nОна сама решит, что сохранить.", "Вы оставляете ткань и решение швее. Ничего не получено и не потеряно."]],
	"unsent_letters": [
		["release", "ОТПРАВИТЬ ВЕСТИ\n\n-10 золота на корм.\nПодготовить «Неповиновение».", "Голубятник выпускает птиц без разрешения комендатуры. -10 золота; «Неповиновение» готово к одному бою."],
		["read", "ПРОЧИТАТЬ КОПИИ\n\nУлика о южном марше.\nБез золота и усилений.", "В копиях перечислены южные станции. Войско шло от замка. Получена улика о южном марше; птицы остаются."],
		["passed", "ЗАКРЫТЬ СТАВНЮ\n\nБез изменений.\nВести останутся здесь.", "Вы закрываете ставню. Птицы ждут. Ничего не получено и не потеряно."]],
	"borrowed_boots": [
		["repair", "ПОДОГНАТЬ ОБУВЬ\n\n-18 золота.\nСкорость героев +8% до конца забега.", "Сапожник подгоняет чужую обувь по вашим ногам. -18 золота; скорость героев +8% до конца забега."],
		["hobnails", "ВЗЯТЬ ТЯЖЁЛЫЕ\n\nМакс. HP героев +8.\nСкорость -4% до конца забега.", "Тяжёлые подмётки берегут ноги, но замедляют шаг. Макс. HP героев +8, скорость -4% до конца забега."],
		["passed", "ОСТАВИТЬ ХОЗЯЕВАМ\n\nБез изменений.\nМастер всё ещё ждёт их.", "Вы не берёте чужие сапоги. Ничего не получено и не потеряно."]],
	"false_weights": [
		["fair", "ВОЗМЕСТИТЬ ПАЙКИ\n\n-12 золота. Макс. HP героев +16.\nУлика о скрытых запасах.", "Вы оплачиваете недовес и ломаете ложную гирю. -12 золота; макс. HP героев +16 до конца забега. Получена улика о пайках."],
		["silence", "ПРИНЯТЬ ОТКУП\n\n+18 золота.\nМакс. HP героев -6 до конца забега.", "Пекарь покупает ваше молчание. +18 золота; скудный паёк снижает макс. HP героев на6 до конца забега."],
		["passed", "ОТОЙТИ ОТ ПРИЛАВКА\n\nБез изменений.\nОчередь продолжает ждать.", "Вы отходите от прилавка. Ничего не получено и не потеряно."]],
	"last_signal": [
		["truth", "ПОГАСИТЬ ЛОЖНЫЙ СИГНАЛ\n\nСнять долг Волшебника.\n-20 золота; без двойной награды.", "Вы прекращаете обещать помощь пустому горизонту. -20 золота; долг Волшебника снят вместе с его будущей двойной наградой."],
		["salvage", "СНЯТЬ ОПРАВУ\n\n+22 золота.\nСигнал больше не зажечь.", "Вы снимаете медную оправу. +22 золота. Дозорный остаётся у погасшего огня."],
		["passed", "ОСТАВИТЬ ОГОНЬ\n\nБез изменений.\nДозорный продолжит ждать.", "Вы не трогаете сигнальный огонь. Ничего не получено и не потеряно."]]
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
