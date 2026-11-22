extends RefCounted
## Optional purchases, mandatory visits. A stop is scheduled by a resolved
## card and shares its Table checkpoint, independently of the Fate Spread.

const REST_SLOTS := [4, 12]
const SHOP_SLOT := 8
const REST_HEAL := 0.40
const RITE_HP_COST := 0.20
const SHOP_HEAL := 0.35
const RELIC_PRICE := 50
const UPGRADE_PRICE := 45
const HEAL_PRICE := 25
const CHARTER := preload("res://scripts/core/run_charter.gd")


static func open(state: Node, slot: int) -> Dictionary:
	if slot not in REST_SLOTS and slot != SHOP_SLOT:
		return {}
	var relics: Array[String] = state.get_available_artifact_ids()
	relics.sort()
	var premium := ""
	if slot == SHOP_SLOT:
		for id in relics.duplicate():
			var artifact: ArtifactData = state.get_artifact(id)
			if artifact.effect == "scar_strength" and state.rescue_scar_roles.is_empty():
				relics.erase(id)
			elif artifact.effect == "wave_heal" and not state.remaining_card_ids.has("firing_square"):
				relics.erase(id)
			elif artifact.merchant_price > 0:
				premium = id
				relics.erase(id)
	# The selection stays stable and does not consume combat or deck RNG.
	var stock: Array[String] = []
	if not relics.is_empty():
		var offset: int = (slot + state.resolved_card_ids.size() + state.gold) % relics.size()
		var capacity := 3 if premium.is_empty() else 2
		for index in range(mini(relics.size(), capacity if slot == SHOP_SLOT else 1)):
			stock.append("relic/" + relics[(offset + index) % relics.size()])
	if slot == SHOP_SLOT:
		if not premium.is_empty():
			stock.append("relic/" + premium)
		var trainee: String = state.get_least_developed_extra_role()
		if not trainee.is_empty():
			stock.append("upgrade/" + trainee)
		stock.append("heal")
	return {"slot": slot, "stock": stock, "sold": []}


static func is_valid(stop: Dictionary, values: Dictionary, state: Node) -> bool:
	if stop.is_empty():
		return true
	var slot: Variant = stop.get("slot")
	if not slot is int or slot != values.cards_resolved or (slot not in REST_SLOTS and slot != SHOP_SLOT):
		return false
	if not values.active_card_id.is_empty() or not stop.get("stock") is Array or not stop.get("sold") is Array:
		return false
	var listed := {}
	for item in stop.stock:
		if not item is String or listed.has(item):
			return false
		listed[item] = true
		match item.get_slice("/", 0):
			"relic":
				if not state.ARTIFACT_PATHS.has(item.get_slice("/", 1)): return false
			"heal", "upgrade":
				if slot != SHOP_SLOT: return false
				if item.begins_with("upgrade/") and item.get_slice("/", 1) not in values.party_roles: return false
			_:
				return false
	var sold := {}
	for item in stop.sold:
		if slot != SHOP_SLOT or not listed.has(item) or sold.has(item): return false
		sold[item] = true
	return true


static func price(state: Node, item: String) -> int:
	var base_price := 0
	match item.get_slice("/", 0):
		"relic":
			var artifact: ArtifactData = state.get_artifact(item.get_slice("/", 1))
			base_price = artifact.merchant_price if artifact != null and artifact.merchant_price > 0 else RELIC_PRICE
		"upgrade": base_price = UPGRADE_PRICE
		"heal": base_price = HEAL_PRICE
	return state.get_merchant_price(base_price)


static func rest_fraction(state: Node) -> float:
	return CHARTER.SCARS_REST if CHARTER.oath_applies(state.oath_rank, 2) else REST_HEAL


static func has_wounds(state: Node) -> bool:
	for role in state.party_roles:
		if state.get_hero_current_hp(role) < state.get_hero_max_hp(role):
			return true
	return false


static func restriction(state: Node, action: String) -> String:
	var stop: Dictionary = state.camp_stop
	if stop.is_empty(): return "Остановка завершена"
	if action == "leave": return "" if stop.slot == SHOP_SLOT else "Выберите действие"
	var id := action.get_slice("/", 1)
	if stop.slot == SHOP_SLOT:
		if action not in stop.stock: return "Нет в продаже"
		if action in stop.sold: return "Куплено"
		if state.gold < price(state, action): return "Не хватает золота"
		match action.get_slice("/", 0):
			"relic": return "Уже есть" if state.has_artifact(id) else ""
			"upgrade": return "Развитие исчерпано" if state.get_next_extra_hero_upgrade_id(id).is_empty() else ""
			"heal": return "Отряд здоров" if not has_wounds(state) else ""
		return "Нет в продаже"
	if action == "rest": return ""
	if action == "rite":
		if stop.stock.is_empty() or state.has_artifact(String(stop.stock[0]).get_slice("/", 1)):
			return "Нет подходящей реликвии"
		var role: String = state.protagonist_role
		return "Не хватает здоровья" if state.get_hero_current_hp(role) < rite_cost(state) + 1.0 else ""
	if action.begins_with("upgrade/") and id in state.party_roles:
		return "Развитие исчерпано" if state.get_next_extra_hero_upgrade_id(id).is_empty() else ""
	return "Действие недоступно"


static func rite_cost(state: Node) -> float:
	return ceilf(state.get_hero_max_hp(state.protagonist_role) * RITE_HP_COST)


static func apply(state: Node, action: String) -> bool:
	if not restriction(state, action).is_empty():
		return false
	var is_shop: bool = state.camp_stop.slot == SHOP_SLOT
	var id := action.get_slice("/", 1)
	match action.get_slice("/", 0):
		"rest", "heal":
			var fraction := SHOP_HEAL if is_shop else rest_fraction(state)
			for role in state.party_roles:
				state.change_hero_hp(role, state.get_hero_max_hp(role) * fraction)
		"upgrade":
			if String(state.add_next_extra_hero_upgrade(id)).is_empty(): return false
		"rite":
			var cost := rite_cost(state)
			if not state.add_artifact(String(state.camp_stop.stock[0]).get_slice("/", 1)): return false
			state.change_hero_hp(state.protagonist_role, -cost)
		"relic":
			if not state.add_artifact(id): return false
	if is_shop and action != "leave":
		state.gold -= price(state, action)
		state.camp_stop.sold.append(action)
	else:
		state.camp_stop.clear()
	state.clamp_party_health()
	return true
