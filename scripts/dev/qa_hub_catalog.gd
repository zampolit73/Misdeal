extends RefCounted
## F6-only index: current authored tools + every live card + labelled historical previews.
const GROUPS := ["ВСЁ","ИГРА","КАРТЫ","СОБЫТИЯ","TRAVEL","БОЙ","АНИМАЦИИ","ИНТЕРФЕЙС","АРХИВ"]

static func entries() -> Array[Dictionary]:
	var rows: Array[Dictionary]=[]
	# Load after autoload initialization; preloading RunState from an F6 scene
	# creates a cycle through RunMenu while its singleton name is unavailable.
	var registry: Dictionary=(load("res://scripts/core/run_state.gd") as Script).get_script_constant_map().CARD_PATHS
	var tools := [
		["ИГРА","Начало партии","scenes/main/main.tscn","Настоящее главное меню: новая QA-партия, продолжение QA-сохранения.",""],
		["ИГРА","Выбор героя","scenes/class_select/class_select.tscn","Три героя и настоящий выбор протагониста.",""],
		["ИГРА","Игровой стол","scenes/table/table.tscn","Настоящая раздача и Расклад Судьбы. Параметры отряда справа.","party"],
		["КАРТЫ","Все карты — галерея DS3","scenes/dev/d315_card_ds3_gallery.tscn","Все карточные изображения, полный текст, рамки и оптические центры.",""],
		["СОБЫТИЯ","Пять историй «Эхо осады»","scenes/dev/final_five_playtest.tscn","Настоящие события, выбор, последствия и продолжение к столу.",""],
		["СОБЫТИЯ","Джек — событие и спутник","scenes/dev/jack_event_playtest.tscn","Встреча Джека при Следопыте и переход к настоящей игре.",""],
		["БОЙ","Засада на кладбище","scenes/battle/battle.tscn","Настоящий бой: подготовка, расстановка, награда и стол.","graveyard"],
		["БОЙ","Суд Безмолвных — пускатель","scenes/dev/court_of_the_mute_d268_real_battle_preview.tscn","Авторский пускатель настоящего боя и расстановок.",""],
		["БОЙ","Чёрные фонари — пускатель","scenes/dev/black_lantern_d260_released_battle_preview.tscn","Пять врагов, состав отряда и Battle → Reward → Table.",""],
		["БОЙ","Костяной пастырь — пускатель","scenes/dev/bone_shepherd_playtest.tscn","Настоящий бой с Костяным пастырем.",""],
		["БОЙ","Чёрная переправа — пускатель","scenes/dev/black_crossing_playtest.tscn","Арена и реальный бой на переправе.",""],
		["БОЙ","Изношенный театр — пускатель","scenes/dev/threadbare_theatre_playtest.tscn","Арена, состав и настоящее столкновение.",""],
		["БОЙ","Погребальная процессия — пускатель","scenes/dev/funeral_procession_playtest.tscn","Постановка и настоящее столкновение процессии.",""],
		["АНИМАЦИИ","Герои D412 — действующие анимации","scenes/dev/d412_three_hero_animation_preview.tscn","Три принятых героя: позы и ходьба при масштабе 1×.",""],
		["АНИМАЦИИ","Персонажи Суда — 25 кадров","scenes/dev/court_of_the_mute_d267_three_animation_preview.tscn","Idle, Walk, Attack, Hit и Death авторских персонажей.",""],
		["АНИМАЦИИ","Pack 1 — анимации юнитов","scenes/dev/unit_animation_pack1_preview.tscn","Сравнение состояний первого набора.",""],
		["АНИМАЦИИ","Pack 2 — анимации и кандидаты","scenes/dev/unit_animation_pack2_preview.tscn","Существующие игровые спрайты и отдельно обозначенные кандидаты.",""],
		["ИНТЕРФЕЙС","Досье отряда — действующее окно","scenes/dev/d413_squad_dossier_preview.tscn","Настоящее досье со стола, герои, реликвии и развитие.",""],
		["ИНТЕРФЕЙС","Награда — настоящее развитие героя","scenes/reward/reward.tscn","Живые карточки развития и реальные обработчики выбора. Награды остаются в QA-партии.","reward_major"],
		["ИНТЕРФЕЙС","Награда — настоящая обычная добыча","scenes/reward/reward.tscn","Живые варианты обычной добычи после боя.","reward_loot"],
		["ИНТЕРФЕЙС","Расклад Судьбы — 4 карты","scenes/table/fate_spread_overlay.tscn","Настоящий просмотрщик Расклада, четыре завершённых карты.","fate4"],
		["ИНТЕРФЕЙС","Расклад Судьбы — 12 карт","scenes/table/fate_spread_overlay.tscn","Настоящий Расклад I–XII и запечатанный XIII перед боссом.","fate12"],
		["ИНТЕРФЕЙС","Конец забега — победа","scenes/run_end/run_end.tscn","Настоящий итог победного QA-забега.","end_win"],
		["ИНТЕРФЕЙС","Конец забега — поражение","scenes/run_end/run_end.tscn","Настоящий итог поражения; новая игра затрагивает только QA-профиль.","end_loss"],
		["ИНТЕРФЕЙС","Витраж Памяти — 0 / 7 / 24","scenes/dev/a1v2_memory_preview.tscn","F1/F2/F3 — число осколков, F4 — открыть просмотрщик. Только QA-профиль.",""],
		["ИНТЕРФЕЙС","Награды — QA-превью","scenes/dev/design_system_v2_reward_preview.tscn","Существующее превью наград и кнопок; историческая DS2-оболочка подписана в сцене.",""],
		["ИНТЕРФЕЙС","Панель Волшебника","scenes/dev/d308_wizard_panel_preview.tscn","Условия и рисованная панель Волшебника.",""],
		["ИНТЕРФЕЙС","Компоненты дизайн-системы","scenes/dev/design_system_components_preview.tscn","Существующие материалы, типографика, кнопки и состояния.",""],
		["TRAVEL","Тропа вдоль мёртвых стен","scenes/dev/travel_transition_playtest.tscn","Оригинальная дорога; 1/2/3 — состав, P — пауза, R — повтор.",""],
		["TRAVEL","Почта последнего рассвета","scenes/dev/posthouse_playtest.tscn","Три исхода: release / read / passed.",""],
		["TRAVEL","Последний перевязочный пункт","scenes/dev/dressing_station_playtest.tscn","Три исхода, задний ракурс и перспективный маршрут.",""],
		["TRAVEL","Костёр без хозяина","scenes/dev/campfire_playtest.tscn","repair / hobnails / passed и движение по дороге.",""],
		["TRAVEL","Склад мёртвых пайков","scenes/dev/dead_rations_granary_playtest.tscn","fair / silence / passed; раскрытые запасы и откуп.",""],
		["TRAVEL","Pilot Batch 01 — 11 исходов","scenes/dev/travel_pilot_batch01_playtest.tscn","Сигнал, могильщик и кошель. ←/→ — исход, 1/2/3 — состав.",""],
		["TRAVEL","Batch 02 V2 — 31 исход","scenes/dev/travel_batch02_playtest.tscn","Все семь новых Travel-сцен. ←/→ — исход, 1/2/3 — состав, P/R — пауза/повтор.",""]]
	var used := {}
	for row in tools:
		var path: String="res://"+row[2]
		if not ResourceLoader.exists(path,"PackedScene"): continue
		rows.append({"id":"scene:"+path+":"+str(row[4]),"group":row[0],"title":row[1],"scene":path,"desc":row[3],"prep":row[4]})
		used[path]=true
	# Individual authored locations are searchable by their real title, while
	# the complete batch launchers remain available for sequential review.
	for batch in [1,2]:
		var driver_path: String="res://scripts/dev/travel_pilot_batch01_playtest.gd" if batch==1 else "res://scripts/dev/travel_batch02_playtest.gd"
		if not ResourceLoader.exists(driver_path): continue
		var cases: Array=(load(driver_path) as Script).get_script_constant_map().CASES
		var start := 0
		while start<cases.size():
			var id: String=cases[start][0]
			var count := 1
			while start+count<cases.size() and cases[start+count][0]==id: count+=1
			var catalog: Script=load("res://scripts/travel/travel_catalog.gd")
			var resource: Resource=load(catalog.resource_for({"resolved_card_id":id}))
			var path := "res://scenes/dev/qa_hub_travel_preview.tscn"
			rows.append({"id":"travel:"+id,"group":"TRAVEL","title":str(resource.title)+" · "+str(count)+" исхода","scene":path,"desc":"Прямой просмотр этой локации. ←/→ — её исходы, 1/2/3 — состав, P — пауза, R — повтор.","prep":"","search":id,"batch":batch,"case_start":start,"case_count":count})
			used[path]=true
			start+=count
	var ids: Array=registry.keys()
	ids.sort()
	for id in ids:
		var card: Resource=load(registry[id])
		if card==null: continue
		var battle: bool=card.resolution_type=="combat"
		rows.append({"id":"card:"+str(id),"group":"БОЙ" if battle else "СОБЫТИЯ","title":str(card.title),"scene":"res://scenes/battle/battle.tscn" if battle else str(card.target_path),"desc":str(card.card_text),"prep":"card","card_id":str(id),"search":str(id)+" "+str(card.type_label)})
	# All remaining authored F6 scenes remain reachable, clearly separated from
	# the current tools so rejected historical art is not presented as live art.
	var files:=DirAccess.get_files_at("res://scenes/dev")
	files.sort()
	for file in files:
		var path: String="res://scenes/dev/"+file
		if not file.ends_with(".tscn") or used.has(path) or file=="qa_hub.tscn": continue
		rows.append({"id":"scene:"+path,"group":"АРХИВ","title":file.get_basename().replace("_"," "),"scene":path,"desc":"Исторический QA-пускатель или художественный кандидат. Его наличие не означает утверждение или использование в игре.","prep":""})
	return rows
