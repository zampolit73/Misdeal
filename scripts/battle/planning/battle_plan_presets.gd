extends RefCounted
const IDS := ["custom","assault","defense","hunt","staged"]
const NAMES := ["Свой план","Общий натиск","Удерживать позицию","Охота на поддержку","Прикрытие → охота"]
const DESCRIPTIONS := [
	"Продолжить свой сценарий. Новые герои начинают с одного приказа «Натиск».",
	"Все герои сближаются с ближайшими врагами до конца боя.",
	"Все герои держат свои позиции и атакуют врагов в пределах досягаемости.",
	"Герои преследуют целителей, затем стрелков. Остальным врагам уделяют внимание по близости.",
	"Редактируемый пример: рыцарь держит позицию, следопыт ищет поддержку, маг меняет тактику после первого попадания.",
]

static func step(tactic: String, priority: String="nearest", condition: String="time", limit: int=4) -> Dictionary:
	return {"tactic":tactic,"priority":priority,"condition":condition,"limit":limit,"target":null}

static func apply(plans: Dictionary, id: String) -> void:
	if id=="custom": return
	for role in plans:
		var orders: Array=[step(id,"support" if id=="hunt" else "nearest")]
		if id=="staged":
			match str(role):
				"knight": orders=[step("defense","nearest","time",5),step("hunt","support","personal_kill",8),step("assault")]
				"ranger": orders=[step("hunt","support","damage_dealt",8),step("defense","weakest","time",3),step("hunt","support")]
				"mage": orders=[step("assault","support","damage_dealt",6),step("defense")]
		plans[role].orders.assign(orders)
