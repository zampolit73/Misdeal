extends RefCounted
## Misdeal: Цена клятвы — isolated alternate ruleset.
## Original RunState, battle engine, cards and save data are never modified.

const ROLES := ["knight", "ranger", "mage"]
const CARDS := [
	{"id":"bone_watch","title":"КОСТЯНОЙ ДОЗОР","kind":"fight","text":"Патруль мёртвых. Победа приносит золото, но долг усилит врага.","danger":1},
	{"id":"black_crossing","title":"ЧЁРНАЯ ПЕРЕПРАВА","kind":"fight","text":"Под мостом шевелится стража. Сильный противник, достойная добыча.","danger":2},
	{"id":"ash_tribunal","title":"ПЕПЕЛЬНЫЙ ТРИБУНАЛ","kind":"fight","text":"Судьи без лиц требуют боя. Большая опасность, большая награда.","danger":3},
	{"id":"camp","title":"ПЕПЕЛЬНЫЙ ПРИВАЛ","kind":"rest","text":"Перевяжи раны всех уцелевших героев. Колдун запишет это в книгу.","danger":0},
	{"id":"grave_tithe","title":"КОСТЯНАЯ ДЕСЯТИНА","kind":"gold","text":"Возьми 12 монет сейчас. В конце пути Колдун потребует плату.","danger":1},
	{"id":"oath_shrine","title":"АЛТАРЬ ОБЕТОВ","kind":"seal","text":"Обмени пять единиц здоровья героя на боевую печать.","danger":1},
	{"id":"ransom","title":"ВЫКУП ЗА ДУШУ","kind":"recruit","text":"Здесь может ждать товарищ из прошлой жизни. Ты решаешь, спасать ли его.","danger":1},
	{"id":"gravedigger","title":"ЛАВКА МОГИЛЬЩИКА","kind":"shop","text":"Отдай восемь монет и исцели отряд. Если денег нет — уйдёшь с пустыми руками.","danger":0},
	{"id":"forgotten_ledger","title":"ЗАБЫТАЯ КНИГА","kind":"cleanse","text":"Потрать восемь монет, чтобы стереть единицу долга. Или получи две монеты.","danger":0},
	{"id":"broken_crown","title":"РАЗБИТАЯ КОРОНА","kind":"sacrifice","text":"Пожертвуй частью здоровья и усили каждого живого героя.","danger":2}
]

static func make_hero(role: String) -> Dictionary:
	match role:
		"knight":
			return {"id":role,"name":"РЫЦАРЬ","hp":58,"max_hp":58,"attack":10}
		"ranger":
			return {"id":role,"name":"СЛЕДОПЫТ","hp":43,"max_hp":43,"attack":13}
		"mage":
			return {"id":role,"name":"МАГ","hp":36,"max_hp":36,"attack":16}
		_:
			return make_hero("knight")


static func new_run(role: String, seed: int = 0) -> Dictionary:
	var actual_seed := seed if seed != 0 else randi()
	return {
		"seed":actual_seed, "stage":0, "party":[make_hero(role)],
		"gold":12, "debt":0, "seals":0,
		"phase":"deal", "enemy_hp":0, "enemy_max_hp":0,
		"enemy_attack":0, "enemy_name":"", "round":0,
		"stance":"shield", "ritual_bonus":0, "is_boss":false,
		"won":false, "history":[], "last":"Колдун сдаёт две карты. Выбор всегда за тобой."
	}


static func offer(state: Dictionary) -> Array[Dictionary]:
	var choices: Array[Dictionary] = []
	if str(state.get("phase", "")) != "deal":
		return choices
	var rng := RandomNumberGenerator.new()
	rng.seed = int(state["seed"]) + int(state["stage"]) * 7919
	var first: int = rng.randi_range(0, CARDS.size() - 1)
	var second: int = rng.randi_range(0, CARDS.size() - 2)
	if second >= first:
		second += 1
	choices.append(CARDS[first].duplicate(true))
	choices.append(CARDS[second].duplicate(true))
	# At two milestones the player is guaranteed a CHOICE to save a companion,
	# never an automatically recruited party member.
	if int(state["stage"]) in [2, 6] and (state["party"] as Array).size() < 3:
		choices[0] = CARDS[6].duplicate(true)
		if str(choices[1]["id"]) == "ransom":
			choices[1] = CARDS[1].duplicate(true)
	# Four authored battle gates: the safest possible path still has combat.
	if int(state["stage"]) in [1, 4, 8, 11]:
		choices[0] = CARDS[0].duplicate(true)
		choices[1] = CARDS[1 if int(state["stage"]) < 8 else 2].duplicate(true)
	return choices


static func pledge(state: Dictionary) -> bool:
	if str(state.get("phase","")) != "deal":
		return false
	var party: Array = state["party"]
	if party.is_empty():
		return false
	var hero: Dictionary = party[0]
	if int(hero["max_hp"]) <= 12 or int(hero["hp"]) <= 6:
		return false
	hero["max_hp"] = int(hero["max_hp"]) - 5
	hero["hp"] = min(int(hero["hp"]), int(hero["max_hp"]))
	state["debt"] = int(state["debt"]) + 1
	state["seals"] = int(state["seals"]) + 1
	return true


static func choose(state: Dictionary, card: Dictionary) -> void:
	if str(state["phase"]) != "deal":
		return
	var title := str(card["title"])
	var kind := str(card["kind"])
	state["last"] = title
	match kind:
		"fight":
			_start_fight(state, title, int(card["danger"]), false)
		"rest":
			_heal(state, 13)
			_advance(state, title)
		"gold":
			state["gold"] = int(state["gold"]) + 12
			state["debt"] = int(state["debt"]) + 1
			_advance(state, title)
		"seal":
			_hurt_front(state, 5)
			state["seals"] = int(state["seals"]) + 1
			_advance(state, title)
		"recruit":
			var missing: Array[String] = []
			for role in ROLES:
				var found := false
				for hero in state["party"]:
					if str(hero["id"]) == role:
						found = true
				if not found:
					missing.append(role)
			if missing.is_empty():
				state["seals"] = int(state["seals"]) + 1
			else:
				state["party"].append(make_hero(missing[0]))
			_advance(state, title)
		"shop":
			if int(state["gold"]) >= 8:
				state["gold"] = int(state["gold"]) - 8
				_heal(state, 18)
			_advance(state, title)
		"cleanse":
			if int(state["debt"]) > 0 and int(state["gold"]) >= 8:
				state["gold"] = int(state["gold"]) - 8
				state["debt"] = int(state["debt"]) - 1
			else:
				state["gold"] = int(state["gold"]) + 2
			_advance(state, title)
		"sacrifice":
			_hurt_front(state, 7)
			for hero in state["party"]:
				hero["attack"] = int(hero["attack"]) + 3
			_advance(state, title)
		_:
			_advance(state, title)


static func _heal(state: Dictionary, amount: int) -> void:
	for hero in state["party"]:
		hero["hp"] = min(int(hero["max_hp"]), int(hero["hp"]) + amount)


static func _hurt_front(state: Dictionary, amount: int) -> void:
	var party: Array = state["party"]
	if party.is_empty():
		return
	var hero: Dictionary = party[0]
	hero["hp"] = max(1, int(hero["hp"]) - amount)


static func _advance(state: Dictionary, title: String) -> void:
	state["history"].append(title)
	state["stage"] = int(state["stage"]) + 1
	state["phase"] = "boss_gate" if int(state["stage"]) >= 12 else "deal"


static func _start_fight(state: Dictionary, title: String, danger: int, boss: bool) -> void:
	var debt: int = int(state["debt"])
	var depth: int = int(state["stage"])
	var hp: int = 95 + debt * 14 if boss else 21 + danger * 12 + depth * 3 + debt * 3
	var attack: int = 11 + debt * 2 if boss else 5 + danger * 2 + int(depth / 4.0) + debt
	state["phase"] = "prep"
	state["enemy_hp"] = hp
	state["enemy_max_hp"] = hp
	state["enemy_attack"] = attack
	state["enemy_name"] = "КОСТЯНОЙ СТРАЖ XIII" if boss else title
	state["round"] = 0
	state["is_boss"] = boss
	state["ritual_bonus"] = 0


static func start_boss(state: Dictionary) -> void:
	if str(state["phase"]) == "boss_gate":
		_start_fight(state, "КОСТЯНОЙ СТРАЖ XIII", 3, true)


static func rotate_front(state: Dictionary) -> void:
	if str(state.get("phase", "")) != "prep":
		return
	var party: Array = state["party"]
	if party.size() > 1:
		party.append(party.pop_front())


static func begin_combat(state: Dictionary, stance: String) -> void:
	if str(state["phase"]) != "prep":
		return
	if stance not in ["shield","blade","ritual"]:
		stance = "shield"
	state["stance"] = stance
	state["ritual_bonus"] = 0
	if stance == "ritual" and int(state["seals"]) > 0:
		state["seals"] = int(state["seals"]) - 1
		state["ritual_bonus"] = 9
	state["phase"] = "battle"


static func tick(state: Dictionary) -> String:
	if str(state["phase"]) != "battle":
		return ""
	state["round"] = int(state["round"]) + 1
	var round_no: int = int(state["round"])
	var attack: int = 0
	for hero in state["party"]:
		attack += int(hero["attack"])
	var stance := str(state["stance"])
	match stance:
		"shield":
			attack = int(ceil(attack * 0.82))
		"blade":
			attack = int(ceil(attack * 1.32))
		"ritual":
			attack += int(state["ritual_bonus"])
	# Small deterministic variance, so the same seed remains reproducible.
	attack += (round_no + int(state["seed"])) % 3
	state["enemy_hp"] = max(0, int(state["enemy_hp"]) - attack)
	if int(state["enemy_hp"]) == 0:
		if bool(state["is_boss"]):
			state["phase"] = "finished"
			state["won"] = true
			return "Раунд %d: %d урона. Страж XIII пал. Клятва исполнена." % [round_no, attack]
		state["gold"] = int(state["gold"]) + 6 + int(int(state["stage"]) / 4.0)
		var title: String = str(state["enemy_name"])
		_advance(state, title)
		return "Раунд %d: %d урона. Победа, добыча получена." % [round_no, attack]
	var damage: int = int(state["enemy_attack"])
	if stance == "shield":
		damage = int(ceil(damage * 0.65))
	elif stance == "blade":
		damage = int(ceil(damage * 1.22))
	elif stance == "ritual":
		damage = int(ceil(damage * 0.94))
	var party: Array = state["party"]
	# Enemy focuses the foremost living character: an explicit formation tradeoff.
	var front: Dictionary = party[0]
	front["hp"] = max(0, int(front["hp"]) - damage)
	var result: String = "Раунд %d: нанесено %d, получено %d." % [round_no, attack, damage]
	if int(front["hp"]) <= 0:
		result += " %s погибает навсегда." % str(front["name"])
		party.remove_at(0)
	if party.is_empty():
		state["phase"] = "finished"
		state["won"] = false
		result += " Партия проиграна."
	return result
