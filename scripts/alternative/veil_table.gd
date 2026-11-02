extends Control
## Misdeal: Цена клятвы — F6 playable alternate vertical slice.
## Scene has independent state: no changes to the original main game.

const RULES = preload("res://scripts/alternative/veil_rules.gd")
const BG := Color(0.035, 0.030, 0.047)
const PANEL := Color(0.085, 0.075, 0.092)
const BORDER := Color(0.39, 0.28, 0.22)
const GOLD := Color(0.89, 0.72, 0.43)
const IVORY := Color(0.93, 0.86, 0.73)
const MUTED := Color(0.66, 0.61, 0.61)
const RED := Color(0.77, 0.32, 0.31)

var game: Dictionary = {}
var choices: Array[Dictionary] = []
var pledged := false
var stance := "shield"
var logs: Array[String] = []

var status: Label
var wizard: Label
var detail: Label
var party_info: Label
var journal: Label
var phase_title: Label
var health_bar: ProgressBar
var offer_buttons: Array[Button] = []
var role_buttons: Array[Button] = []
var pledge_button: Button
var stance_buttons: Array[Button] = []
var rotate_button: Button
var fight_button: Button
var boss_button: Button
var restart_button: Button
var battle_timer: Timer


func _ready() -> void:
	_build()
	battle_timer = Timer.new()
	battle_timer.wait_time = 0.6
	add_child(battle_timer)
	battle_timer.timeout.connect(_combat_tick)
	_refresh()


func _panel(x: float, y: float, w: float, h: float) -> void:
	var p := Panel.new()
	p.position = Vector2(x, y)
	p.size = Vector2(w, h)
	var skin := StyleBoxFlat.new()
	skin.bg_color = PANEL
	skin.border_color = BORDER
	skin.set_border_width_all(1)
	skin.set_corner_radius_all(8)
	p.add_theme_stylebox_override("panel", skin)
	add_child(p)


func _label(t: String, x: float, y: float, w: float, h: float, font_size: int = 18, tint: Color = IVORY) -> Label:
	var n := Label.new()
	n.text = t
	n.position = Vector2(x, y)
	n.size = Vector2(w, h)
	n.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	n.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	n.add_theme_color_override("font_color", tint)
	n.add_theme_font_size_override("font_size", font_size)
	add_child(n)
	return n


func _button(t: String, x: float, y: float, w: float, h: float, callback: Callable, font_size: int = 17) -> Button:
	var b := Button.new()
	b.text = t
	b.position = Vector2(x, y)
	b.size = Vector2(w, h)
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.add_theme_font_size_override("font_size", font_size)
	b.add_theme_color_override("font_color", IVORY)
	b.add_theme_color_override("font_hover_color", GOLD)
	b.add_theme_color_override("font_pressed_color", GOLD)
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.16, 0.12, 0.14)
	normal.border_color = BORDER
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(6)
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(0.22, 0.15, 0.13)
	hover.border_color = GOLD
	var focus := normal.duplicate() as StyleBoxFlat
	focus.bg_color = Color(0.18, 0.13, 0.12)
	focus.border_color = GOLD
	b.add_theme_stylebox_override("normal", normal)
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("pressed", hover)
	b.add_theme_stylebox_override("focus", focus)
	b.pressed.connect(callback)
	add_child(b)
	return b


func _build() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = BG
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)

	_label("MISDEAL  /  ЦЕНА КЛЯТВЫ", 28, 12, 900, 58, 31, GOLD)
	_label("АЛЬТЕРНАТИВНАЯ ИГРА  ·  ЭКСПЕРИМЕНТАЛЬНЫЙ ПРОЛОГ", 800, 20, 446, 42, 13, MUTED)
	_panel(22, 92, 266, 586)
	_panel(306, 92, 666, 586)
	_panel(990, 92, 268, 586)
	_label("РАСКЛАД СУДЬБЫ", 43, 115, 222, 32, 19, GOLD)
	status = _label("", 42, 155, 228, 100, 16)
	_label("I — XII  ·  XIII", 68, 294, 188, 30, 16, MUTED)
	_label("СОСТАВ ОТРЯДА", 43, 515, 225, 25, 18, GOLD)
	party_info = _label("", 43, 546, 225, 108, 15)
	phase_title = _label("", 330, 113, 612, 45, 26, GOLD)
	wizard = _label("", 330, 165, 608, 86, 18, IVORY)
	detail = _label("", 330, 556, 615, 100, 17, MUTED)

	_label("ЗАПИСКИ КОЛДУНА", 1010, 115, 230, 32, 19, GOLD)
	_label("Каждый выбор останется
на игровом столе.", 1010, 158, 230, 71, 16, MUTED)
	journal = _label("", 1010, 254, 227, 394, 15)
	journal.vertical_alignment = VERTICAL_ALIGNMENT_TOP

	role_buttons.append(_button("РЫЦАРЬ\n58 HP  ·  10 атака", 334, 318, 194, 118, _choose_role.bind("knight"), 17))
	role_buttons.append(_button("СЛЕДОПЫТ\n43 HP  ·  13 атака", 541, 318, 194, 118, _choose_role.bind("ranger"), 17))
	role_buttons.append(_button("МАГ\n36 HP  ·  16 атака", 748, 318, 194, 118, _choose_role.bind("mage"), 17))
	offer_buttons.append(_button("", 332, 281, 302, 207, _choose_card.bind(0), 17))
	offer_buttons.append(_button("", 646, 281, 302, 207, _choose_card.bind(1), 17))
	pledge_button = _button("◈ ЗАЛОЖИТЬ 5 МАКС. HP  →  +1 ПЕЧАТЬ, +1 ДОЛГ", 395, 498, 497, 44, _toggle_pledge, 15)

	stance_buttons.append(_button("ЩИТ\nМеньше урона", 333, 341, 190, 102, _set_stance.bind("shield"), 17))
	stance_buttons.append(_button("КЛИНОК\nУдар сильнее", 541, 341, 190, 102, _set_stance.bind("blade"), 17))
	stance_buttons.append(_button("РИТУАЛ\nПотратить печать", 749, 341, 190, 102, _set_stance.bind("ritual"), 17))
	rotate_button = _button("ПОМЕНЯТЬ ПЕРЕДНИЙ РЯД", 456, 449, 364, 42, _rotate_front, 16)
	fight_button = _button("НАЧАТЬ АВТОБОЙ", 490, 497, 294, 52, _begin_fight, 19)
	boss_button = _button("ОТКРЫТЬ ПЕЧАТЬ XIII", 458, 371, 340, 69, _start_boss, 19)
	restart_button = _button("НОВАЯ ПАРТИЯ", 470, 385, 320, 65, _restart, 21)

	health_bar = ProgressBar.new()
	health_bar.position = Vector2(354, 266)
	health_bar.size = Vector2(568, 22)
	health_bar.show_percentage = false
	add_child(health_bar)


func _draw() -> void:
	var center := Vector2(154, 399)
	draw_arc(center, 88, -PI / 2.0, TAU - PI / 2.0, 80, BORDER, 2.0, true)
	var current: int = int(game.get("stage", 0))
	for i in range(12):
		var angle: float = TAU * (float(i) / 12.0) - PI / 2.0
		var pt: Vector2 = center + Vector2(cos(angle), sin(angle)) * 87.0
		var col: Color = GOLD if i < current else Color(0.25, 0.22, 0.26)
		draw_circle(pt, 8.0, col)
	draw_circle(center, 23.0, RED if bool(game.get("won", false)) else Color(0.25, 0.12, 0.15))


func _hide_actions() -> void:
	for b in role_buttons:
		b.visible = false
	for b in offer_buttons:
		b.visible = false
	for b in stance_buttons:
		b.visible = false
	pledge_button.visible = false
	rotate_button.visible = false
	fight_button.visible = false
	boss_button.visible = false
	restart_button.visible = false
	health_bar.visible = false


func _refresh() -> void:
	_hide_actions()
	queue_redraw()
	if game.is_empty():
		phase_title.text = "КТО ОСТАНЕТСЯ ЗА СТОЛОМ?"
		wizard.text = "«В прежней жизни ты уже проиграл.\nНа этот раз цену клятвы назначишь сам»."
		detail.text = "Выбери героя. Двое остальных могут встретиться позже: их придётся спасать. Побеждённые союзники погибают навсегда."
		status.text = "0 / 12 карт\nXIII запечатана\n\nЗолото: —\nДолг: —\nПечати: —"
		party_info.text = "Никого за столом."
		for b in role_buttons:
			b.visible = true
		journal.text = "Книга пуста."
		return

	var stage: int = int(game["stage"])
	status.text = "%d / 12 карт\nXIII: %s\n\nЗолото: %d\nДолг: %d\nПечати: %d" % [
		stage, "ОТКРЫТА" if stage == 12 else "ЗАПЕЧАТАНА",
		int(game["gold"]), int(game["debt"]), int(game["seals"])]
	party_info.text = _party_text()
	journal.text = "\n\n".join(logs.slice(max(0, logs.size() - 8)))
	var phase: String = str(game["phase"])

	match phase:
		"deal":
			choices = RULES.offer(game)
			phase_title.text = "РАЗДАЧА %s" % _roman(stage + 1)
			wizard.text = "«Одна карта — твоя. Вторая сгорит.\nЗаложишь здоровье ради печати — я запомню долг»."
			for i in range(2):
				offer_buttons[i].visible = true
				var card: Dictionary = choices[i]
				offer_buttons[i].text = "%s\n\n%s\n\n%s" % [
					str(card["title"]), str(card["text"]),
					"ОПАСНОСТЬ %d" % int(card["danger"]) if int(card["danger"]) > 0 else "БЕЗ ПРЯМОГО БОЯ"]
			pledge_button.visible = true
			pledge_button.disabled = int(game["party"][0]["hp"]) <= 6 or int(game["party"][0]["max_hp"]) <= 12
			pledge_button.text = "◈ КЛЯТВА ПРИНЯТА — ПЕЧАТЬ БУДЕТ ОПЛАЧЕНА" if pledged else "◈ ЗАЛОЖИТЬ 5 МАКС. HP → +1 ПЕЧАТЬ И +1 ДОЛГ"
			detail.text = "Любой неуплаченный долг усилит Стража XIII. Печати полезны в ритуальном боевом приказе."
		"prep":
			phase_title.text = "ПЕРЕД БОЕМ: %s" % str(game["enemy_name"])
			wizard.text = "«Сам сражаться не будешь. Выбирай приказ: как героям встретить свою судьбу?»"
			for i in range(3):
				stance_buttons[i].visible = true
				stance_buttons[i].disabled = false
			rotate_button.visible = (game["party"] as Array).size() > 1
			fight_button.visible = true
			health_bar.visible = true
			_update_enemy_bar()
			detail.text = _stance_hint()
		"battle":
			phase_title.text = "СРАЖЕНИЕ: %s" % str(game["enemy_name"])
			wizard.text = "«Теперь только наблюдай: отряд выполняет выбранный приказ»."
			health_bar.visible = true
			_update_enemy_bar()
			detail.text = "Раунд %d  ·  %s\n%s" % [int(game["round"]), _stance_name(), str(game["last"])]
		"boss_gate":
			phase_title.text = "ДВЕНАДЦАТЬ КАРТ СЫГРАНЫ"
			wizard.text = "«Твой долг: %d. Теперь я назову цену. Страж XIII ждёт»." % int(game["debt"])
			boss_button.visible = true
			detail.text = "Страж получит +14 HP и +2 атаки за каждую единицу долга. Союзники, золото и печати — всё, что удалось сохранить."
		"finished":
			phase_title.text = "КЛЯТВА ИСПОЛНЕНА" if bool(game["won"]) else "КЛЯТВА РАЗОРВАНА"
			wizard.text = "«Я впервые проиграл тебе. Но стол останется здесь»." if bool(game["won"]) else "«Карты помнят каждого, кто сюда садился»."
			detail.text = "Финал достигнут. Начни новую партию другим героем и попробуй иную цену риска."
			restart_button.visible = true


func _party_text() -> String:
	var lines: Array[String] = []
	var idx := 0
	for hero in game["party"]:
		lines.append("%s%s  %d/%d HP\n   Атака %d" % [
			"→ " if idx == 0 else "   ", str(hero["name"]), int(hero["hp"]), int(hero["max_hp"]), int(hero["attack"])])
		idx += 1
	return "\n".join(lines)


func _roman(value: int) -> String:
	var names := ["I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII"]
	return names[clampi(value - 1, 0, 11)]


func _stance_name() -> String:
	match stance:
		"shield": return "ЩИТ"
		"blade": return "КЛИНОК"
		_: return "РИТУАЛ"


func _stance_hint() -> String:
	match stance:
		"shield": return "ЩИТ: исходящий урон ×0.82; входящий ×0.65. Передний герой защищён лучше."
		"blade": return "КЛИНОК: исходящий урон ×1.32; входящий ×1.22. Ускоряет победу, но опасен."
		_: return "РИТУАЛ: если есть печать, потратит одну для +9 урона каждый раунд. Без печати эффекта нет."


func _update_enemy_bar() -> void:
	health_bar.max_value = max(1, int(game["enemy_max_hp"]))
	health_bar.value = int(game["enemy_hp"])


func _choose_role(role: String) -> void:
	game = RULES.new_run(role)
	logs.clear()
	_log("I. Начинается новая партия: %s." % str(game["party"][0]["name"]))
	pledged = false
	stance = "shield"
	_refresh()


func _toggle_pledge() -> void:
	if not pledged:
		pledged = true
		_refresh()
		# Pledge is charged only once, when an actual card is selected.


func _choose_card(index: int) -> void:
	if str(game["phase"]) != "deal" or index < 0 or index >= choices.size():
		return
	var chosen: Dictionary = choices[index]
	if pledged:
		if RULES.pledge(game):
			_log("Принята клятва: -5 макс. HP, +1 печать, +1 долг.")
	RULES.choose(game, chosen)
	_log("%s. %s" % [_roman(min(12, int(game["stage"]) + 1)), str(chosen["title"])])
	pledged = false
	stance = "shield"
	_refresh()


func _set_stance(next: String) -> void:
	stance = next
	_refresh()


func _rotate_front() -> void:
	RULES.rotate_front(game)
	_refresh()


func _begin_fight() -> void:
	if str(game["phase"]) != "prep":
		return
	RULES.begin_combat(game, stance)
	_log("Приказ отдан: %s." % _stance_name())
	battle_timer.start()
	_refresh()


func _combat_tick() -> void:
	if str(game.get("phase", "")) != "battle":
		battle_timer.stop()
		return
	var result: String = RULES.tick(game)
	game["last"] = result
	if result != "":
		_log(result)
	if str(game["phase"]) != "battle":
		battle_timer.stop()
	_refresh()


func _start_boss() -> void:
	RULES.start_boss(game)
	stance = "shield"
	_log("XIII. Колдун вскрывает печать Костяного Стража.")
	_refresh()


func _restart() -> void:
	battle_timer.stop()
	game.clear()
	choices.clear()
	logs.clear()
	pledged = false
	stance = "shield"
	_refresh()


func _log(line: String) -> void:
	logs.append(line)
	if logs.size() > 40:
		logs.remove_at(0)
