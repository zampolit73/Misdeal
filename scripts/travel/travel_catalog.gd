extends RefCounted
## Session-only presentation switch; never serialized into a run save.
static var enabled := true
const DEFAULT_LOCATION := "res://resources/travel/ruined_castle_road.tres"
const LOCATIONS := {
	"unsent_letters":"res://resources/travel/last_dawn_posthouse.tres",
	"banner_seamstress":"res://resources/travel/last_dressing_station.tres",
	"borrowed_boots":"res://resources/travel/campfire_without_master.tres",
	"false_weights":"res://resources/travel/dead_rations_granary.tres"}
static func resource_for(context: Dictionary) -> String:
	return str(LOCATIONS.get(str(context.get("resolved_card_id","")),DEFAULT_LOCATION))
const TEXT := {
	"banner_seamstress": {"bandages":"Знамя стало повязками. Швея вернулась к капитану, которому уже не помочь.","standard":"Знамя осталось целым. Под ним всё ещё ждут обещанного рассвета.","passed":"За спиной швея снова ищет раны на костях капитана."},
	"unsent_letters": {"release":"Письмо наконец покинуло крепость. Но те, кому оно предназначалось, давно перестали ждать.","read":"В письмах обещали спасение. Но армия уже уходила на юг, прочь от этих стен.","passed":"Письма остались заперты. И вместе с ними — слова, которых так никто и не услышал."},
	"borrowed_boots": {"repair":"Лёгкая обувь оставляет новые следы. Оруженосец всё ещё готовит сапоги хозяину.","hobnails":"Тяжёлые подмётки глухо стучат по камню. За спиной снова раскладывают снаряжение.","passed":"Сапоги ждут хозяина. На дороге давно нет его следов."},
	"false_weights": {"fair":"Ведомость выдала скрытые запасы. Интендант уже зовёт следующее чучело.","silence":"Монеты купили молчание. На весах остался камень.","passed":"На складах считают пайки. Солдат, которым они предназначались, больше нет."},
	"last_signal": {"truth":"Ваше обещание разорвано. На башне по-прежнему ждут ответного огня.","salvage":"Сигнальная чаша снята. Дозорный поднимает пустой шест.","passed":"Жаровня давно остыла. Дозорный продолжает ждать ответного сигнала."}}
static func context_for(id: String, outcome: String, roles: Array, wizard: String = "", victory: bool = false) -> Dictionary:
	if not is_enabled() or roles.is_empty() or id == "bone_warden": return {}
	var narration := ""
	if TEXT.has(id) and TEXT[id].has(outcome): narration = TEXT[id][outcome]
	elif victory: narration = "Шум боя остался за спиной. Дорога вдоль мёртвых стен продолжается."
	if narration.is_empty(): return {}
	return {"resolved_card_id":id,"outcome_id":outcome,"party_roles":roles.duplicate(),"narration_text":narration,"wizard_line":wizard,"duration_sec":4.0}

static func is_enabled() -> bool:
	return enabled and bool(ProjectSettings.get_setting("misdeal/travel/enabled",true))
