extends CanvasLayer

const DATA := preload("res://scripts/battle/planning/hero_battle_plan.gd")
const DS3 := preload("res://scripts/ui/misdeal_ds3.gd")
const SKIN := preload("res://scripts/battle/planning/battle_plan_skin.gd")
const STAGES := ["I", "II", "III"]
const PRIORITIES := ["Ближайший", "Слабейший", "Самый дальний", "Поддержка"]
const CONDITIONS := ["По времени", "После нанесения урона", "После получения урона", "После личного убийства", "При здоровье ≤ 50%"]
const TACTIC_HINTS := ["Быстро сближается с целью.", "Удерживает позицию, с которой начал приказ.", "Преследует цель и старается обойти врагов."]
const PREPARATION_WIDTH := 1224.0
const PREPARATION_BOTTOM := 714.0

enum PreparationMode { HIDDEN, OVERVIEW, EDIT, PICK_TARGET }

var pilot: Node
var preparation: Panel
var overview: Control
var detail: Control
var picker: Control
var start_button: Button
var back_button: Button
var cancel_button: Button
var hud: Panel
var report_panel: Panel
var tactic: OptionButton
var priority: OptionButton
var condition: OptionButton
var limit: SpinBox
var target_button: Button
var clear_button: Button
var title: Label
var explanation: Label
var transition_label: Label
var limit_label: Label
var board_hint: Label
var notice: Label
var live_text: Label
var hover_text: Label
var hero_roles: Array[String] = []
var slot := 0
var selected_role := ""
var refreshing := false
var tiles: Dictionary = {}
var pick_markers: Dictionary = {}
var hud_stages: Dictionary = {}
var hero_caption: Dictionary = {}
var remove_buttons: Dictionary = {}
var tile_headings: Dictionary = {}
var tile_endings: Dictionary = {}
var tile_stages: Dictionary = {}
var notice_time := 0.0
var fallback_message := ""
var history_button: Button
var report_reading: RichTextLabel
var plan_marker: Node2D
var hovered_plan_unit: BattleUnit
var hover_source: Control
var panel_font: Font
var order_font: Font
var banners: Array[TextureRect] = []
var bottom_seal: TextureRect

func panel(at: Vector2, dimensions: Vector2) -> Panel:
	var item := Panel.new()
	item.position=at
	item.size=dimensions
	DS3.apply_surface(item,"dossier")
	add_child(item)
	return item

func label(parent: Node, text: String, at: Vector2, dimensions: Vector2, font_size: int=14) -> Label:
	var item := Label.new()
	item.text=text
	item.position=at
	item.size=dimensions
	item.add_theme_font_size_override("font_size",font_size)
	item.add_theme_color_override("font_color",DS3.PARCHMENT)
	item.mouse_filter=Control.MOUSE_FILTER_IGNORE
	parent.add_child(item)
	return item

func button(parent: Node, text: String, at: Vector2, dimensions: Vector2, action: Callable) -> Button:
	var item := Button.new()
	item.text=text
	item.position=at
	item.size=dimensions
	item.add_theme_font_size_override("font_size",14)
	DS3.apply_action(item,false)
	parent.add_child(item)
	item.pressed.connect(action)
	return item

func option(parent: Node, names: Array, at: Vector2, dimensions: Vector2) -> OptionButton:
	var item := OptionButton.new()
	for title in names: item.add_item(str(title))
	item.position=at
	item.size=dimensions
	item.add_theme_font_size_override("font_size",14)
	parent.add_child(item)
	return item

func build(owner_pilot: Node) -> void:
	pilot = owner_pilot
	layer = 40
	plan_marker = Node2D.new()
	plan_marker.name = "PlanHoverMarker"
	add_child(plan_marker)
	plan_marker.draw.connect(_draw_plan_marker)
	preparation = panel(Vector2(28, 563), Vector2(PREPARATION_WIDTH, 151))
	panel_font = SKIN.serif()
	order_font = SKIN.serif(true)
	var banner := SKIN.FRAGMENTS.get_fragment("banner")
	banners = [
		SKIN.mount(preparation, banner, Vector2(-5, 27), Vector2(43, 119)),
		SKIN.mount(preparation, banner, Vector2(1187, 27), Vector2(43, 119), true),
	]
	bottom_seal = SKIN.mount(preparation, SKIN.SEAL, Vector2(600, 139), Vector2(24, 24))
	overview = _preparation_content()
	detail = _preparation_content()
	picker = _preparation_content()
	var title_plate := Panel.new()
	title_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title_plate.position = Vector2(22, 0)
	title_plate.size = Vector2(222, 32)
	title_plate.add_theme_stylebox_override("panel", SKIN.textured(SKIN.slice(SKIN.METAL_SOURCE, SKIN.METAL), 12))
	overview.add_child(title_plate)
	SKIN.mount(overview, SKIN.FRAGMENTS.get_fragment("medallion"), Vector2(22, -1), Vector2(34, 43))
	var board_title := _etched_label(overview, "БОЕВОЙ ПЛАН", Vector2(62, 4), Vector2(176, 26), 19)
	board_title.add_theme_color_override("font_color", SKIN.PALE)
	board_hint = _etched_label(overview, "", Vector2(255, 6), Vector2(437, 24), 13)
	board_hint.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	var header_engraving := Control.new()
	header_engraving.position = Vector2(698, 8)
	header_engraving.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overview.add_child(header_engraving)
	header_engraving.draw.connect(func():
		for index in range(4):
			SKIN.glyph(header_engraving, "end", Vector2(10 + index * 20, 8), 0.65, Color(SKIN.GILT, 0.53))
	)
	var hub := button(overview, "Классика" if pilot.has_method("is_production_mode") and pilot.is_production_mode() else "В хаб · F10", Vector2(790, 1), Vector2(114, 31), pilot.return_to_hub)
	var settings := button(overview, "Сброс плана" if pilot.has_method("is_production_mode") and pilot.is_production_mode() else "Настройки", Vector2(911, 1), Vector2(118, 31), pilot.show_setup)
	start_button = button(overview, "Начать бой", Vector2(1036, 1), Vector2(164, 31), pilot.start_planned_battle)
	SKIN.action(hub, panel_font)
	SKIN.action(settings, panel_font)
	SKIN.action(start_button, panel_font, true)
	start_button.add_theme_font_size_override("font_size", 17)
	start_button.draw.connect(func(): SKIN.glyph(start_button, "assault", Vector2(20, 16), 0.70, SKIN.PALE))
	back_button = button(detail, "← К плану", Vector2(43, 8), Vector2(120, 29), close_detail)
	SKIN.action(back_button, panel_font)
	title = _etched_label(detail, "", Vector2(178, 9), Vector2(1000, 28), 19)
	_etched_label(detail, "Тактика", Vector2(43, 43), Vector2(160, 18), 14)
	_etched_label(detail, "Приоритет", Vector2(213, 43), Vector2(164, 18), 14)
	_etched_label(detail, "Конкретная цель", Vector2(389, 43), Vector2(240, 18), 14)
	tactic = option(detail, DATA.TACTIC_NAMES, Vector2(43, 63), Vector2(158, 32))
	priority = option(detail, PRIORITIES, Vector2(213, 63), Vector2(164, 32))
	priority.tooltip_text = "Поддержка: целитель, затем стрелок, затем ближайший враг. Приоритет действует и при потере назначенной цели."
	target_button = button(detail, "Выбрать цель", Vector2(389, 63), Vector2(225, 32), pilot.arm_target)
	clear_button = button(detail, "Снять", Vector2(621, 63), Vector2(62, 32), _clear_target)
	SKIN.action(target_button, panel_font)
	SKIN.action(clear_button, panel_font)
	transition_label = _etched_label(detail, "Когда перейти дальше", Vector2(696, 43), Vector2(278, 18), 14)
	condition = option(detail, CONDITIONS, Vector2(696, 63), Vector2(276, 32))
	limit_label = _etched_label(detail, "", Vector2(988, 43), Vector2(170, 18), 14)
	limit = SpinBox.new()
	limit.min_value = 2
	limit.max_value = 12
	limit.step = 1
	limit.suffix = "сек."
	limit.position = Vector2(988, 63)
	limit.size = Vector2(104, 32)
	detail.add_child(limit)
	SKIN.field(limit.get_line_edit(), panel_font)
	limit.get_line_edit().draw.connect(SKIN.etched_border.bind(limit.get_line_edit()))
	for choice in [tactic, priority, condition]:
		SKIN.field(choice, panel_font)
		choice.draw.connect(SKIN.etched_border.bind(choice))
		choice.item_selected.connect(func(_n: int): _edited())
	limit.value_changed.connect(func(_n: float): _edited())
	explanation = _etched_label(detail, "", Vector2(43, 98), Vector2(1137, 23), 14)
	for item in [tactic, priority, condition]:
		item.fit_to_longest_item = false
	hover_text = _etched_label(picker, "", Vector2(12, 6), Vector2(665, 30), 16)
	_etched_label(picker, "Клик по врагу · Esc / ПКМ — отмена", Vector2(689, 6), Vector2(376, 30), 14)
	cancel_button = button(picker, "Отмена", Vector2(1078, 6), Vector2(134, 30), pilot.cancel_target)
	SKIN.action(cancel_button, panel_font)
	hud = panel(Vector2(838, 160), Vector2(414, 88))
	DS3.apply_surface(hud, "battle")
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	live_text = label(hud, "", Vector2(12, 9), Vector2(390, 68), 15)
	notice = label(hud, "", Vector2(12, 89), Vector2(390, 50), 13)
	notice.add_theme_constant_override("outline_size", 6)
	notice.add_theme_color_override("font_outline_color", DS3.OBSIDIAN)
	_set_preparation_mode(PreparationMode.HIDDEN)
	hud.hide()

func _etched_label(parent: Node, value: String, at: Vector2, dimensions: Vector2, font_size: int, bold: bool = false) -> Label:
	var item := label(parent, value, at, dimensions, font_size)
	item.add_theme_font_override("font", order_font if bold else panel_font)
	return item

func _preparation_content() -> Control:
	var content := Control.new()
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preparation.add_child(content)
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	return content

func _set_preparation_mode(mode: PreparationMode) -> void:
	_clear_plan_hover()
	overview.visible = mode == PreparationMode.OVERVIEW
	detail.visible = mode == PreparationMode.EDIT
	picker.visible = mode == PreparationMode.PICK_TARGET
	preparation.visible = mode != PreparationMode.HIDDEN
	var height := 37.0 + hero_roles.size() * 38.0
	if mode == PreparationMode.EDIT:
		height = 130.0
	elif mode == PreparationMode.PICK_TARGET:
		height = 44.0
	preparation.size.y = height
	preparation.position.y = PREPARATION_BOTTOM - height
	preparation.add_theme_stylebox_override("panel", SKIN.frame(mode == PreparationMode.PICK_TARGET))
	for banner in banners:
		banner.visible = mode != PreparationMode.PICK_TARGET and height >= 75
		banner.size.y = maxf(38.0, height - 26)
	bottom_seal.visible = mode in [PreparationMode.OVERVIEW, PreparationMode.EDIT]
	bottom_seal.position.y = height - 20

func hide_preparation() -> void:
	_set_preparation_mode(PreparationMode.HIDDEN)

func current_role() -> String:
	return selected_role

func current_plan() -> Resource:
	return pilot.plans.get(selected_role)

func set_heroes(roles: Array[String]) -> void:
	_clear_plan_hover()
	hero_roles = roles.duplicate()
	if selected_role not in hero_roles:
		selected_role = ""
		slot = 0
	else:
		slot = mini(slot, pilot.plans[selected_role].orders.size() - 1)
	for role in tiles:
		for tile in tiles[role]:
			tile.queue_free()
		hero_caption[role].get_parent().queue_free()
	tiles.clear()
	tile_headings.clear()
	tile_endings.clear()
	tile_stages.clear()
	hero_caption.clear()
	remove_buttons.clear()
	hud_stages.clear()
	notice_time = 0.0
	for row in range(roles.size()):
		var role := roles[row]
		var y := 32 + row * 38
		var identity := Control.new()
		identity.position = Vector2(42, y)
		identity.size = Vector2(178, 35)
		identity.mouse_filter = Control.MOUSE_FILTER_IGNORE
		overview.add_child(identity)
		SKIN.mount(identity, SKIN.slice(SKIN.METAL_SOURCE, SKIN.METAL), Vector2.ZERO, identity.size)
		var badge := Control.new()
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		badge.position = Vector2(3, 2)
		badge.size = Vector2(31, 31)
		identity.add_child(badge)
		badge.draw.connect(SKIN.emblem.bind(badge, role))
		var caption := _etched_label(identity, pilot.role_name(role), Vector2(44, 3), Vector2(98, 25), 16)
		caption.mouse_filter = Control.MOUSE_FILTER_PASS
		caption.mouse_entered.connect(_hover_hero.bind(role, caption))
		caption.mouse_exited.connect(_exit_plan_hover.bind(caption))
		hero_caption[role] = caption
		var remove := button(identity, "", Vector2(145, 5), Vector2(25, 24), _remove_last.bind(role))
		SKIN.action(remove, panel_font)
		remove.draw.connect(_draw_remove_icon.bind(remove))
		remove_buttons[role] = remove
		var row_tiles: Array[Button] = []
		var headings: Array[Label] = []
		var endings: Array[Label] = []
		var numerals: Array[Label] = []
		for stage in range(3):
			var tile := button(overview, "", Vector2(225 + stage * 315, y), Vector2(311, 35), select_order.bind(role, stage))
			tile.mouse_entered.connect(_hover_order.bind(role, stage, tile))
			tile.mouse_exited.connect(_exit_plan_hover.bind(tile))
			tile.draw.connect(_draw_order.bind(tile, role, stage))
			var numeral := _etched_label(tile, STAGES[stage], Vector2(8, 5), Vector2(31, 25), 17, true)
			numeral.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			numeral.add_theme_color_override("font_color", SKIN.INK)
			numerals.append(numeral)
			var heading := _etched_label(tile, "", Vector2(70, 0), Vector2(233, 18), 14, true)
			heading.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			headings.append(heading)
			endings.append(_etched_label(tile, "", Vector2(84, 16), Vector2(219, 18), 14))
			row_tiles.append(tile)
		tiles[role] = row_tiles
		tile_headings[role] = headings
		tile_endings[role] = endings
		tile_stages[role] = numerals
	if pilot.editable():
		show_overview()

func show_overview() -> void:
	_set_preparation_mode(PreparationMode.OVERVIEW)
	refresh_board()

func select_order(role: String, stage: int) -> void:
	if not pilot.editable() or role not in hero_roles:
		return
	var count: int = pilot.plans[role].orders.size()
	if stage < 0 or stage >= 3 or stage > count:
		return
	if stage == count:
		pilot.resize_plan(role, stage + 1)
	selected_role = role
	slot = stage
	_set_preparation_mode(PreparationMode.EDIT)
	refresh()

func close_detail() -> void:
	limit.apply()
	show_overview()

func _remove_last(role: String) -> void:
	if not pilot.editable():
		return
	var count: int = pilot.plans[role].orders.size()
	if count <= 1:
		return
	pilot.resize_plan(role, count - 1)
	if selected_role == role and slot >= count - 1:
		slot = count - 2
	refresh_board()

func _draw_remove_icon(control: Button) -> void:
	var color := DS3.PARCHMENT if control.is_hovered() else DS3.TEXT
	var center := control.size * 0.5
	control.draw_polyline(PackedVector2Array([
		center + Vector2(-5, -3), center + Vector2(-4, 6),
		center + Vector2(4, 6), center + Vector2(5, -3),
	]), color, 1.5, true)
	control.draw_line(center + Vector2(-7, -3), center + Vector2(7, -3), color, 1.5, true)
	control.draw_polyline(PackedVector2Array([
		center + Vector2(-2, -3), center + Vector2(-2, -6),
		center + Vector2(2, -6), center + Vector2(2, -3),
	]), color, 1.5, true)

func _hover_hero(role: String, source: Control) -> void:
	for unit in pilot.battle.units:
		if is_instance_valid(unit) and unit.team == 0 and unit.visual_role == role:
			_set_plan_hover(unit, source)
			return
	_clear_plan_hover()

func _hover_order(role: String, stage: int, source: Control) -> void:
	var orders: Array = pilot.plans[role].orders
	_set_plan_hover(DATA.target_of(orders[stage]) if stage < orders.size() else null, source)

func _set_plan_hover(unit: BattleUnit, source: Control) -> void:
	hovered_plan_unit = unit
	hover_source = source
	_update_plan_marker()
	plan_marker.queue_redraw()

func _exit_plan_hover(source: Control) -> void:
	if hover_source == source:
		_clear_plan_hover()

func _clear_plan_hover() -> void:
	hovered_plan_unit = null
	hover_source = null
	plan_marker.hide()

func _update_plan_marker() -> void:
	var unit := hovered_plan_unit
	if not is_instance_valid(unit) or not unit.alive or not unit.is_visible_in_tree() or unit.dragging \
			or not is_instance_valid(hover_source) or not hover_source.is_visible_in_tree() \
			or not overview.is_visible_in_tree() or not pilot.editable() or pilot.battle.combat_live:
		_clear_plan_hover()
		return
	# Follow the existing contact position without changing the unit or its sprites.
	plan_marker.position = unit.get_global_transform_with_canvas() * Vector2(0, 36)
	plan_marker.show()

func _draw_plan_marker() -> void:
	if not is_instance_valid(hovered_plan_unit):
		return
	var radius := maxf(22.0, hovered_plan_unit.body_radius * 1.05) + 12.0
	for offset in [0.0, PI]:
		var points := PackedVector2Array()
		for index in range(13):
			var sample := Vector2.from_angle(offset + lerpf(-0.82, 0.82, index / 12.0)) * radius
			points.append(Vector2(sample.x, sample.y * 0.32))
		plan_marker.draw_polyline(points, DS3.OBSIDIAN, 4.0, true)
		plan_marker.draw_polyline(points, Color(DS3.PARCHMENT, 0.95), 2.0, true)

func _summary_end(order: Dictionary, final: bool) -> String:
	if final:
		return "До конца боя"
	if order.condition == "time":
		return "Через %d с" % order.limit
	const TRIGGERS := {
		"damage_dealt": "Нанесёт урон",
		"damage_taken": "Получит урон",
		"personal_kill": "Убьёт врага",
		"hp_below_50": "HP ≤ 50%",
	}
	return "%s · до %d с" % [TRIGGERS[order.condition], order.limit]

func _draw_order(tile: Button, role: String, stage: int) -> void:
	var orders: Array = pilot.plans[role].orders
	if stage >= orders.size():
		return
	var selected := role == selected_role and stage == slot
	SKIN.etched_border(tile, selected)
	SKIN.glyph(tile, orders[stage].tactic, Vector2(50, 17), 0.90, SKIN.INK)
	var foe := DATA.target_of(orders[stage])
	var marker := "end" if stage == orders.size() - 1 else "time"
	if is_instance_valid(foe) and foe.alive:
		marker = "hunt"
	SKIN.glyph(tile, marker, Vector2(74, 25), 0.53, SKIN.INK)

func refresh_board() -> void:
	if board_hint == null:
		return
	board_hint.text = fallback_message if not fallback_message.is_empty() else "Приказы идут по порядку. Нажмите на приказ, чтобы изменить его."
	for role in hero_roles:
		if not tiles.has(role):
			continue
		var orders: Array = pilot.plans[role].orders
		hero_caption[role].add_theme_color_override("font_color", DS3.PARCHMENT if role == selected_role else DS3.TEXT)
		var remove: Button = remove_buttons[role]
		remove.visible = orders.size() > 1
		remove.tooltip_text = "Убрать приказ " + STAGES[orders.size() - 1]
		remove.accessibility_name = pilot.role_name(role) + " · " + remove.tooltip_text
		for stage in range(3):
			var tile: Button = tiles[role][stage]
			var heading: Label = tile_headings[role][stage]
			var ending: Label = tile_endings[role][stage]
			tile_stages[role][stage].visible = stage < orders.size()
			tile.visible = stage <= orders.size()
			var selected := role == selected_role and stage == slot
			SKIN.order(tile, stage < orders.size(), selected)
			tile.queue_redraw()
			if stage >= orders.size():
				heading.text = "+ Приказ " + STAGES[stage]
				heading.position.y = 9
				heading.add_theme_color_override("font_color", SKIN.PALE)
				ending.text = ""
				tile.tooltip_text = "Добавить приказ " + STAGES[stage]
				tile.accessibility_name = tile.tooltip_text
				continue
			var order: Dictionary = orders[stage]
			var foe := DATA.target_of(order)
			var assigned := is_instance_valid(foe) and foe.alive
			var target_text: String = pilot.enemy_label(foe) if assigned else PRIORITIES[DATA.PRIORITIES.find(order.priority)]
			var end := _summary_end(order, stage == orders.size() - 1)
			var tactic_name: String = DATA.TACTIC_NAMES[DATA.TACTICS.find(order.tactic)]
			heading.text = "%s · %s" % [tactic_name, end if assigned else target_text]
			heading.add_theme_font_size_override("font_size", 13 if assigned else 14)
			heading.position.y = 0
			heading.add_theme_color_override("font_color", SKIN.INK)
			ending.text = target_text if assigned else end
			ending.add_theme_color_override("font_color", Color("#60261a") if assigned else SKIN.INK)
			tile.tooltip_text = "%s · %s\n%s%s\n%s" % [STAGES[stage], tactic_name,
				"Цель: " if assigned else "Приоритет: ", target_text, end]
			tile.accessibility_name = pilot.role_name(role) + " · " + tile.tooltip_text

func refresh() -> void:
	refresh_board()
	var plan := current_plan()
	if not detail.visible or plan == null:
		return
	refreshing = true
	var order: Dictionary = plan.orders[slot]
	var last: bool = slot == plan.orders.size() - 1
	title.text = "%s · Приказ %s" % [pilot.role_name(selected_role), STAGES[slot]]
	tactic.select(DATA.TACTICS.find(order.tactic))
	priority.select(DATA.PRIORITIES.find(order.priority))
	condition.select(DATA.CONDITIONS.find(order.condition))
	limit.set_value_no_signal(order.limit)
	transition_label.visible = not last
	condition.visible = not last
	limit.visible = not last
	limit_label.visible = not last
	var timed: bool = order.condition == "time"
	limit_label.text = "Длительность" if timed else "Если не выполнено"
	var foe := DATA.target_of(order)
	var assigned := is_instance_valid(foe) and foe.alive
	target_button.text = pilot.enemy_label(foe) if assigned else "Выбрать цель"
	target_button.tooltip_text = "Заменить назначенную цель" if assigned else "Назначить конкретного врага на арене"
	target_button.disabled = pilot.battle.wave_intermission
	if target_button.disabled:
		target_button.text = "Враги ещё не появились"
		target_button.tooltip_text = "На следующей волне действует приоритет цели."
	target_button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	clear_button.visible = assigned
	var next := "Действует до конца боя."
	if not last:
		var seconds := "%d %s" % [order.limit, "секунды" if int(order.limit) in [2, 3, 4] else "секунд"]
		next = "Через %s перейти к следующему приказу." % seconds if timed else "%s или через %s." % [CONDITIONS[condition.selected], seconds]
	explanation.text = TACTIC_HINTS[tactic.selected] + "  " + next
	refreshing = false

func _edited() -> void:
	if refreshing or not pilot.editable() or not detail.visible or selected_role.is_empty():
		return
	var order: Dictionary = current_plan().orders[slot]
	order.tactic = DATA.TACTICS[tactic.selected]
	order.priority = DATA.PRIORITIES[priority.selected]
	order.condition = DATA.CONDITIONS[condition.selected]
	order.limit = int(limit.value)
	refresh()

func _clear_target() -> void:
	if pilot.editable() and not selected_role.is_empty():
		pilot.clear_assignment(current_plan().orders[slot])
		refresh()

func set_picking(active: bool) -> void:
	_set_preparation_mode(PreparationMode.PICK_TARGET if active else PreparationMode.EDIT)
	if active:
		for enemy in pilot.battle.units:
			if enemy.team == 1 and enemy.alive:
				var marker := panel(enemy.global_position + Vector2(-13, 4), Vector2(26, 24))
				marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
				label(marker, str(pilot.first_wave_enemies.find(enemy) + 1), Vector2.ZERO, Vector2(26, 24), 14).horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				pick_markers[enemy] = marker
		update_hover(null)
	else:
		for marker in pick_markers.values():
			marker.hide()
			marker.queue_free()
		pick_markers.clear()
		refresh()

func update_hover(enemy: BattleUnit) -> void:
	hover_text.text = "Выбрать цель · " + (pilot.enemy_label(enemy) if enemy != null else pilot.role_name(selected_role))
	for candidate in pick_markers:
		var marker: Panel = pick_markers[candidate]
		marker.modulate = Color.WHITE if candidate == enemy else Color(0.87, 0.79, 0.70)
		DS3.apply_surface(marker, "dossier" if candidate == enemy else "table")
		marker.scale = Vector2.ONE * (1.14 if candidate == enemy else 1.0)

func update_live(delta: float) -> void:
	if hover_source != null:
		_update_plan_marker()
	hud.visible = pilot.battle.combat_live and not pilot.battle.battle_finished
	if not hud.visible:
		return
	var rows: Array[String] = []
	var changes: Array[String] = []
	for role in hero_roles:
		var executor: RefCounted = pilot.executors.get(role)
		if executor == null or executor.index < 0 or not executor.unit().alive:
			continue
		var order: Dictionary = executor.orders[executor.index]
		var stage: String = STAGES[executor.index]
		var active_tactic: String = DATA.TACTIC_NAMES[DATA.TACTICS.find(order.tactic)]
		var remaining := "до конца" if executor.index == executor.orders.size() - 1 else "%.1f с" % maxf(0, float(order.limit) - executor.elapsed)
		rows.append("%s  ·  %s  %s  ·  %s" % [pilot.role_name(role), stage, active_tactic, remaining])
		if hud_stages.has(role) and hud_stages[role] != executor.index:
			var reason := ""
			for entry in executor.journal.duplicate().slice(-8):
				if entry.kind == "end" and entry.stage == executor.index:
					reason = " · лимит истёк" if entry.reason == "timeout" else " · " + CONDITIONS[DATA.CONDITIONS.find(entry.reason)].to_lower()
			changes.append("%s → %s %s%s" % [pilot.role_name(role), stage, active_tactic, reason])
		hud_stages[role] = executor.index
	live_text.text = "\n".join(rows)
	hud.size.y = 20 + rows.size() * 22
	notice.position.y = hud.size.y + 4
	if not changes.is_empty():
		notice.text = "\n".join(changes)
		notice_time = 2.7
	notice_time = maxf(0, notice_time - delta)
	notice.visible = notice_time > 0

func show_report(heading: String, metadata: String, summary: String, chronology: String) -> void:
	hide_preparation()
	hud.hide()
	var scrim := ColorRect.new()
	scrim.color = Color(0.02, 0.012, 0.014, 0.40)
	add_child(scrim)
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	report_panel = panel(Vector2(126, 150), Vector2(1028, 508))
	label(report_panel, heading, Vector2(24, 14), Vector2(978, 40), 27)
	label(report_panel, metadata, Vector2(24, 55), Vector2(978, 24))
	var reading := RichTextLabel.new()
	report_reading = reading
	reading.position = Vector2(24, 100)
	reading.size = Vector2(980, 300)
	reading.text = summary
	reading.selection_enabled = true
	reading.add_theme_color_override("default_color", DS3.TEXT)
	reading.add_theme_font_size_override("normal_font_size", 16)
	report_panel.add_child(reading)
	var toggle := button(report_panel, "Подробная хронология", Vector2(24, 408), Vector2(242, 29), func(): pass)
	history_button = toggle
	toggle.toggle_mode = true
	toggle.toggled.connect(func(expanded: bool):
		reading.text = chronology if expanded else summary
		reading.scroll_to_line(0)
		toggle.text = "Вернуться к итогу" if expanded else "Подробная хронология"
	)
	button(report_panel, "Повторить бой", Vector2(24, 451), Vector2(215, 39), pilot.replay)
	DS3.apply_action(button(report_panel, "Изменить план", Vector2(249, 451), Vector2(224, 39), pilot.edit_again), true)
	var comparison := "Сравнить с автобоем" if pilot.planned else "Сравнить с боевым планом"
	button(report_panel, comparison, Vector2(483, 451), Vector2(306, 39), pilot.compare_mode)
	button(report_panel, "Настройки", Vector2(799, 451), Vector2(205, 39), pilot.show_setup)
