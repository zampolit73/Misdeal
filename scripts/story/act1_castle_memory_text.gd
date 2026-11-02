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


static func wizard_line_for_fact(fact_id: String) -> String:
	match fact_id:
		"promise_heard":
			return "Обещали помощь к рассвету. В этом замке её до сих пор ждут."
		"orders_conflict":
			return "У одной ночи было два рассвета. Какой из них ты предпочитаешь?"
		_:
			return ""
