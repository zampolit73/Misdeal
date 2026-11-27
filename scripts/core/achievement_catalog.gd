extends RefCounted
## Permanent, cosmetic-only milestones. Stable IDs are saved; titles are live.
## Keep the first four entries in their original cabinet positions.
const ENTRIES := [
	["solo_xiii", "Один против XIII", "Победить надзирателя с одним героем в отряде."],
	["trio_xiii", "Три судьбы", "Победить надзирателя полным отрядом."],
	["no_last_deal", "Без второй попытки", "Победить надзирателя без Последней сделки."],
	["oath_v_victory", "Вопреки последней ставке", "Победить с пятой клятвой."],
	["first_step", "Первая печать", "Разрешить первую карту забега."],
	["four_cards", "Камни первого пути", "Разрешить четыре карты в одном забеге."],
	["eight_cards", "Путь через проклятие", "Разрешить восемь карт в одном забеге."],
	["twelve_cards", "У порога XIII", "Разрешить все двенадцать карт перед надзирателем."],
	["first_battle", "Первая кровь", "Победить в бою и завершить его карту."],
	["first_defeat", "Пепел первой судьбы", "Завершить забег поражением."],
	["first_victory", "Надзиратель пал", "Впервые одолеть надзирателя."],
	["first_relic", "Осколок прошлого", "Найти первую реликвию в любом забеге."],
	["three_relics", "Три сокровища", "Обладать тремя реликвиями одновременно."],
	["six_relics", "Хранитель реликвий", "Открыть шесть разных реликвий в Реликварии."],
	["all_relics", "Сокровищница теней", "Открыть все 13 реликвий первого акта."],
	["ten_enemies", "Знаток мёртвых", "Встретить десять разных противников."],
	["all_enemies", "Летописец нежити", "Открыть все 26 противников в Бестиарии."],
	["first_companion", "Не один", "Собрать отряд из двух героев."],
	["trio_formed", "Союз трёх", "Собрать отряд из трёх героев."],
	["gold_100", "Сотня мертвецов", "Иметь не менее 100 золота в одном забеге."],
	["first_upgrade", "Стать сильнее", "Получить первое улучшение героя."],
	["first_wager", "Цена искушения", "Принять ставку Волшебника."],
	["first_hold", "Придержать судьбу", "Впервые удержать карту."],
	["last_deal_accepted", "Ещё один ход", "Принять Последнюю сделку."],
]


static func title(id: String) -> String:
	for entry in ENTRIES:
		if entry[0] == id: return entry[1]
	return id


static func condition(id: String) -> String:
	for entry in ENTRIES:
		if entry[0] == id: return entry[2]
	return ""


static func eligible(state: Dictionary, relic_count: int, enemy_count: int, history: Dictionary) -> Array[String]:
	var progress := int(state.get("cards_resolved", 0))
	var party: int = state.get("party_roles", []).size()
	var artifacts: int = state.get("artifact_ids", []).size()
	var used_last_deal := bool(state.get("last_deal_used", false))
	var won := false
	var lost := false
	var solo := false
	var trio := false
	var no_deal := false
	var oath_v := false
	# History is sufficient for legacy results, but never infer gold,
	# development or one-time actions absent from recorded data.
	for record: Dictionary in history.values():
		party = maxi(party, record.party.size())
		artifacts = maxi(artifacts, record.relics.size())
		used_last_deal = used_last_deal or record.last_deal
		progress = maxi(progress, 12 if record.won else maxi(0, int(record.card) - 1))
		if record.won:
			won = true
			solo = solo or record.party.size() == 1
			trio = trio or record.party.size() == 3
			no_deal = no_deal or not record.last_deal
			oath_v = oath_v or int(record.oath) == 5
		else:
			lost = true
	var flags := [solo, trio, no_deal, oath_v,
		progress >= 1, progress >= 4, progress >= 8, progress >= 12,
		int(state.get("deals_survived", 0)) > 0 or won, lost, won,
		relic_count >= 1, artifacts >= 3, relic_count >= 6, relic_count >= 13,
		enemy_count >= 10, enemy_count >= 26, party >= 2, party >= 3,
		int(state.get("gold", 0)) >= 100, not state.get("hero_upgrade_ids", []).is_empty(),
		int(state.get("wizard_wagers_accepted", 0)) > 0, bool(state.get("fate_hold_used", false)), used_last_deal]
	var result: Array[String] = []
	for index in ENTRIES.size():
		if flags[index]:
			result.append(ENTRIES[index][0])
	return result
