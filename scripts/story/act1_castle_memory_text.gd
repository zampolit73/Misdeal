extends RefCounted
# A1M1: concise, run-local narrative. The historical truth is shared by all
# protagonists; each role notices a different detail, not a different past.


static func moon_seal_observation(role: String) -> String:
	match role:
		"knight":
			return "Рыцарь узнаёт гарнизонный знак: его ставили под приказами об обороне."
		"ranger":
			return "Следопыт узнаёт метку гонца, который должен был ехать северной дорогой."
		"mage":
			return "Маг чувствует на воске след старого ритуала военной печати."
		_:
			return ""


static func blood_ledger_observation(role: String) -> String:
	match role:
		"knight":
			return "Гарнизонный знак помогает оспорить строку о приказе."
		"ranger":
			return "Маршрут гонца не совпадает с записью в книге."
		"mage":
			return "Печати на двух записях не совпадают."
		_:
			return "Противоречивые приказы позволяют оспорить запись."


static func event_memory_hint(card_id: String, facts: Dictionary) -> String:
	# Narrative hints only. A clue is not granted until a real choice resolves.
	match card_id:
		"ash_rest":
			return "В пепле сохранились следы полков, уходивших на юг."
		"rattling_bridge":
			return "На мостовых цепях есть отметки южной колонны."
		"debtor_bones":
			return "На долговых костях выбит номер складской ведомости."
		"candle_seller":
			return "На старом счёте торговца видны скрытые списки пайков."
		"gravedigger_shop":
			return "За монетами лежит перечень удержанных припасов."
		"chained_prisoner":
			return "На цепях выцарапан номер закрытого судебного дела."
		"bone_tax":
			if facts.has("rations_hidden"):
				return "Складская ведомость доказывает завышенную пошлину."
		"last_camp":
			if facts.has("southern_march"):
				return "Знакомый обходной маршрут ведёт к лекарю дешевле."
		"broken_crown":
			if facts.has("silenced_witness"):
				return "Судебная запись упоминает запрещённые показания."
	return ""


static func wizard_line_for_fact(fact_id: String) -> String:
	match fact_id:
		"promise_heard":
			return "Обещали помощь к рассвету. В этом замке её до сих пор ждут."
		"orders_conflict":
			return "У одной ночи было два рассвета. Какой из них ты предпочитаешь?"
		"rations_hidden":
			return "Они скрывали голод за красивыми складскими печатями."
		"southern_march":
			return "Все дороги вели к замку. Кроме дороги твоей армии."
		"silenced_witness":
			return "Тех, кто говорил о приказе, тоже заставили замолчать."
		_:
			return ""
