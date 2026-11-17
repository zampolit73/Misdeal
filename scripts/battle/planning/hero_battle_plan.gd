extends Resource
## Transient pilot data. Enemy references are weak, encounter-local and never saved.
const TACTICS := ["assault","defense","hunt"]
const PRIORITIES := ["nearest","weakest","farthest","support"]
const CONDITIONS := ["time","damage_dealt","damage_taken","personal_kill","hp_below_50"]
const TACTIC_NAMES := ["Натиск","Оборона","Охота"]
const PRIORITY_NAMES := ["Ближайший","Меньше HP","Дальний","Целитель → стрелок"]
const CONDITION_NAMES := ["Время","Нанёс урон","Получил урон","Личное убийство","HP ≤ 50%"]
var orders: Array[Dictionary] = [{"tactic":"assault","priority":"nearest","condition":"time","limit":4,"target":null}]

func copy_orders() -> Array[Dictionary]:
	var result: Array[Dictionary]=[]
	for raw in orders.slice(0,3):
		result.append({"tactic":raw.get("tactic","assault") if raw.get("tactic","assault") in TACTICS else "assault",
			"priority":raw.get("priority","nearest") if raw.get("priority","nearest") in PRIORITIES else "nearest",
			"condition":raw.get("condition","time") if raw.get("condition","time") in CONDITIONS else "time",
			"limit":clampi(int(raw.get("limit",4)),2,12),"target":raw.get("target") if raw.get("target") is WeakRef else null})
	if result.is_empty(): result.append({"tactic":"assault","priority":"nearest","condition":"time","limit":4,"target":null})
	return result

func resize_orders(count: int) -> void:
	orders=copy_orders()
	while orders.size()<clampi(count,1,3): orders.append({"tactic":"assault","priority":"nearest","condition":"time","limit":4,"target":null})
	orders.resize(clampi(count,1,3))

static func target_of(order: Dictionary) -> BattleUnit:
	var reference: Variant=order.get("target")
	return reference.get_ref() as BattleUnit if reference is WeakRef else null

static func describe(order: Dictionary) -> String:
	return TACTIC_NAMES[TACTICS.find(order.tactic)]+" / "+PRIORITY_NAMES[PRIORITIES.find(order.priority)]
