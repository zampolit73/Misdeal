extends RefCounted
## Session-only presentation switch; never serialized into a run save.
static var enabled := true
const BATCH02 := preload("res://scripts/travel/batch_02_catalog.gd")
const BATCH03 := preload("res://scripts/travel/batch_03_catalog.gd")
const DEFAULT_LOCATION := "res://resources/travel/ruined_castle_road.tres"
const LOCATIONS := {
	"candle_seller":"res://resources/travel/batch_02/candle_seller.tres",
	"blood_ledger":"res://resources/travel/batch_02/blood_ledger.tres",
	"debtor_bones":"res://resources/travel/batch_02/debtor_bones.tres",
	"wizard_tithe":"res://resources/travel/batch_02/wizard_tithe.tres",
	"broken_crown":"res://resources/travel/batch_02/broken_crown.tres",
	"curse_forge":"res://resources/travel/batch_02/curse_forge.tres",
	"rattling_bridge":"res://resources/travel/batch_02/rattling_bridge.tres",

	"unsent_letters":"res://resources/travel/last_dawn_posthouse.tres",
	"banner_seamstress":"res://resources/travel/last_dressing_station.tres",
	"borrowed_boots":"res://resources/travel/campfire_without_master.tres",
	"false_weights":"res://resources/travel/dead_rations_granary.tres",
	"last_signal":"res://resources/travel/pilot_01/last_signal.tres",
	"gravedigger_shop":"res://resources/travel/pilot_01/gravedigger_shop.tres",
	"lost_purse":"res://resources/travel/pilot_01/lost_purse.tres"}
static func resource_for(context: Dictionary) -> String:
	var id := str(context.get("resolved_card_id", ""))
	if not BATCH03.scene_for(id).is_empty():
		return "res://resources/travel/batch_03/%s.tres" % id
	return str(LOCATIONS.get(id, DEFAULT_LOCATION))
const TEXT := {
	"gravedigger_shop": {"knight":"Могильщик затягивает обмотку. Чужой опыт теперь лежит в вашей ладони.","ranger":"Стрелы снова уложены. Могильщик прячет полученные монеты.","mage":"Камень опускается на поднос. Могильщик уже убирает инструменты.","leave":"Монеты остались при вас. Могильщик продолжает свою работу."},
	"lost_purse": {"safe":"Верхние монеты сняты. Мёртвая рука по-прежнему держит кошель.","greedy":"Пальцы сжались крепче. За лишние монеты пришлось заплатить.","all_in":"На камне остался след кошеля. Дальше вы идёте с добычей.","untouched":"Мёртвые монеты остались у хозяина. Вода продолжает свой путь."},
	"banner_seamstress": {"bandages":"Знамя стало повязками. Швея вернулась к капитану, которому уже не помочь.","standard":"Знамя осталось целым. Под ним всё ещё ждут обещанного рассвета.","passed":"За спиной швея снова ищет раны на костях капитана."},
	"unsent_letters": {"release":"Письмо наконец покинуло крепость. Но те, кому оно предназначалось, давно перестали ждать.","read":"В письмах обещали спасение. Но армия уже уходила на юг, прочь от этих стен.","passed":"Письма остались заперты. И вместе с ними — слова, которых так никто и не услышал."},
	"borrowed_boots": {"repair":"Лёгкая обувь оставляет новые следы. Оруженосец всё ещё готовит сапоги хозяину.","hobnails":"Тяжёлые подмётки глухо стучат по камню. За спиной снова раскладывают снаряжение.","passed":"Сапоги ждут хозяина. На дороге давно нет его следов."},
	"false_weights": {"fair":"Ведомость выдала скрытые запасы. Интендант уже зовёт следующее чучело.","silence":"Монеты купили молчание. На весах остался камень.","passed":"На складах считают пайки. Солдат, которым они предназначались, больше нет."},
	"last_signal": {"truth":"Ваше обещание разорвано. На башне по-прежнему ждут ответного огня.","salvage":"Сигнальная чаша снята. Дозорный поднимает пустой шест.","passed":"Жаровня давно остыла. Дозорный продолжает ждать ответного сигнала."}}
static func context_for(id: String, outcome: String, roles: Array, wizard: String = "", victory: bool = false, presentation: Dictionary = {}) -> Dictionary:
	if not is_enabled() or roles.is_empty() or id == "bone_warden": return {}
	if not BATCH03.scene_for(id).is_empty():
		var action := str(presentation.get("batch_03_action", ""))
		var state := BATCH03.action_for(id, action, roles)
		if state.is_empty():
			return {}
		var jack: bool = (id == "jack" and action == "recruited") or (
			id != "jack" and "ranger" in roles and bool(presentation.get("jack_companion", false)))
		return {
			"resolved_card_id": id,
			"outcome_id": outcome,
			"visual_action": action,
			"party_roles": roles.duplicate(),
			"jack_companion": jack,
			"narration_text": state.narration,
			"wizard_line": wizard,
			"duration_sec": 4.0,
		}
	if BATCH02.ACTIONS.has(id):
		var visual := BATCH02.action_for(id,outcome,roles,presentation)
		if visual.is_empty(): return {}
		var result := {"resolved_card_id":id,"outcome_id":outcome,"visual_action":visual,"party_roles":roles.duplicate(),"narration_text":BATCH02.narration(id,visual),"wizard_line":wizard,"duration_sec":4.0}
		result["jack_companion"] = "ranger" in roles and bool(presentation.get("jack_companion", false))
		return result
	var action := outcome
	if id=="gravedigger_shop":
		var role := str(presentation.get("choice_role",""))
		action=role if outcome=="bought" and role in ["knight","ranger","mage"] and role in roles else "leave"
	var narration := ""
	if TEXT.has(id) and TEXT[id].has(action): narration = TEXT[id][action]
	elif victory: narration = "Шум боя остался за спиной. Дорога вдоль мёртвых стен продолжается."
	if narration.is_empty(): return {}
	var result := {"resolved_card_id":id,"outcome_id":outcome,"party_roles":roles.duplicate(),"narration_text":narration,"wizard_line":wizard,"duration_sec":4.0}

	result["jack_companion"] = "ranger" in roles and bool(presentation.get("jack_companion", false))
	if id in ["last_signal","gravedigger_shop","lost_purse","borrowed_boots"]:
		result["visual_action"]=action
		if id=="gravedigger_shop" and action!="leave": result["choice_role"]=action
	return result

static func is_enabled() -> bool:
	return enabled and bool(ProjectSettings.get_setting("misdeal/travel/enabled",true))
