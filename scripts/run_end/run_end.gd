extends Control

const ARCHIVE := preload("res://scripts/core/wizard_archive.gd")
const ACHIEVEMENTS := preload("res://scripts/core/achievement_catalog.gd")
const MEMORY := preload("res://scripts/memory/memory_profile.gd")
const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const DOSSIER := preload("res://scripts/ui/squad_dossier_v3.gd")
const LAYOUT := preload("res://assets/pixel/run_end/visual_v2/layout_1280x720.json")
const VICTORY := preload("res://assets/pixel/run_end/visual_v2/runtime/victory_plate.webp")
const DEFEAT := preload("res://assets/pixel/run_end/visual_v2/runtime/defeat_plate.webp")
const HOVER := preload("res://assets/pixel/run_end/visual_v2/runtime/states/new_run_hover.png")
const PRESSED := preload("res://assets/pixel/run_end/visual_v2/runtime/states/new_run_pressed.png")
const BONE := Color("#e5ccac")
const MUTED := Color("#baa68c")
const INK := Color("#301f18")
const DEFEAT_TEXT := Color("#e3a695")

var _new_run: Button


func _ready() -> void:
	SAVE.instance().write_slot(RunState)
	var design: Dictionary = LAYOUT.data
	var regions: Dictionary = design.regions
	var failed := RunState.run_failed
	var backdrop := UI.picture(self, DEFEAT if failed else VICTORY, Rect2(0, 0, 1280, 720))
	backdrop.name = "BackdropArt"
	_caption(self, regions.title, "ПРИГОВОР ВОЛШЕБНИКА", 29, BONE)
	var title := _caption(self, regions.result, "ПОРАЖЕНИЕ" if failed else "ПОБЕДА", 39,
		DEFEAT_TEXT if failed else BONE)
	title.name = "Title"
	var quote := "Двенадцать карт и мой надзиратель. Пожалуй, ты заслужил ещё одну партию."
	if failed:
		quote = RunState.run_end_reason if not RunState.run_end_reason.is_empty() else \
			"Эта версия жизни закончилась раньше, чем ты рассчитывал."
	var details := _layer("Details")
	_scroll_copy(details, "WizardQuote", regions.quote, quote, 17, BONE)
	_build_stats(details, design.stats_cells)

	var collection := _layer("Collection")
	_caption(collection, regions.party_heading, "ОТРЯД", 18, BONE)
	_caption(collection, regions.relics_heading, "РЕЛИКВИИ", 18, BONE)
	_build_party(collection, design.party_slots)
	_build_relics(collection, design.relic_slots)

	_caption(details, regions.upgrade_heading, "РАЗВИТИЕ ГЕРОЕВ", 18, BONE)
	_caption(details, regions.hp_bonus, "Бонус здоровья " + _signed_bonus(RunState.party_hp_bonus), 18, INK)
	_caption(details, regions.damage_bonus, "Бонус урона " + _signed_bonus(RunState.party_damage_bonus), 18, INK)
	var development := "Улучшения: " + RunState.get_hero_upgrade_titles_text()
	if RunState.has_jack_companion():
		development += "\nСпутник следопыта: Джек"
	elif RunState.get_event_outcome("jack") == "token":
		development += "\nОхотничий жетон: урон следопыта +10%"
	_scroll_copy(self, "SummaryScroll", regions.upgrade_text, development, 16, BONE)
	var payment := "не использована"
	if RunState.last_deal_used:
		payment = RunState.last_deal_payment_text if not RunState.last_deal_payment_text.is_empty() else "принята"
	_scroll_copy(details, "LastDeal", regions.last_deal, "Последняя сделка: " + payment, 16, INK)
	_build_action(regions.new_run)
	_build_achievement_summary(ARCHIVE.instance().achievements_for_run(MEMORY.instance().run_uid))

	_fade(backdrop, 0.0, 0.34)
	_fade(title, 0.12, 0.25)
	_fade(details, 0.26, 0.32)
	_fade($SummaryScroll, 0.26, 0.32)
	_fade(collection, 0.44, 0.30)
	_new_run.disabled = true
	var action_tween := _fade(_new_run, 0.62, 0.28)
	action_tween.finished.connect(_enable_new_run)


func _build_achievement_summary(ids: Array[String]) -> void:
	if ids.is_empty(): return
	# Use the upper-left architectural area, not the existing result panel,
	# defeated boss/hero foreground or the New Run action.
	var panel := UI.VISUAL.plaque(self, Rect2(24, 25, 558, 116))
	panel.name = "NewAchievements"
	UI.caption(panel, Rect2(12, 6, 534, 28), "ДОСТИЖЕНИЯ ЭТОГО ЗАБЕГА · +%d" % ids.size(), 19, UI.GOLD)
	var scroll := ScrollContainer.new()
	scroll.name = "AchievementList"
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.focus_mode = Control.FOCUS_ALL
	UI.put(panel, scroll, Rect2(19, 35, 520, 72))
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 0)
	scroll.add_child(list)
	var names: Array[String] = []
	for id in ids:
		var title := "✦ " + ACHIEVEMENTS.title(id)
		names.append(title)
		var label := Label.new()
		label.text = title
		label.add_theme_font_override("font", UI.CARD_SKIN.heading_font())
		label.add_theme_font_size_override("font_size", 17)
		label.add_theme_color_override("font_color", UI.COPY)
		list.add_child(label)
	scroll.tooltip_text = "\n".join(names)
	_fade(panel, 0.44, 0.30)


func _build_stats(parent: Control, cells: Array) -> void:
	var headings := ["Пройдено карт", "Побед в боях", "Золото"]
	var values := ["%d/%d" % [RunState.cards_resolved, RunState.ACT_CARD_TARGET],
		str(RunState.deals_survived), str(RunState.gold)]
	for i in cells.size():
		var area: Array = cells[i]
		_caption(parent, [area[0], area[1] + 3, area[2], 20], headings[i], 17, INK)
		_caption(parent, [area[0], area[1] + 22, area[2], 32], values[i], 26, INK)


func _build_party(parent: Control, slots: Array) -> void:
	for i in slots.size():
		var slot: Dictionary = slots[i]
		var role: String = RunState.HERO_ROLES[i]
		var fate := RunState.get_companion_fate(role)
		var protagonist := role == RunState.protagonist_role
		var joined := protagonist or fate == RunState.FATE_JOINED
		var portrait_path := String(DOSSIER.PORTRAITS[role]).replace(".webp", "_thumb.webp")
		var portrait := UI.picture(parent, load(portrait_path) as Texture2D, UI.rect(slot.portrait_rect))
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		if not joined:
			portrait.modulate = Color("#786a63")
		_caption(parent, slot.name_rect, RunState.get_hero_unit_data(role).unit_name, 14, INK)
		var status := "Не встречен"
		if protagonist:
			status = "Главный герой"
		elif joined:
			status = "В отряде"
		elif fate == RunState.FATE_LOST:
			status = "Потерян"
		_caption(parent, slot.fate_rect, status, 13, MUTED).name = "Fate_" + role


func _build_relics(parent: Control, slots: Array) -> void:
	if RunState.artifact_ids.is_empty():
		_caption(parent, [927, 410, 324, 30], "Реликвии не получены", 15, MUTED)
	for i in mini(slots.size(), RunState.artifact_ids.size()):
		var id: String = RunState.artifact_ids[i]
		var artifact := RunState.get_artifact(id)
		var texture := ArtifactArtCatalog.get_reliquary_texture(id)
		if artifact == null or texture == null:
			continue
		var pixels := texture.get_image()
		var icon := ImageTexture.create_from_image(pixels.get_region(pixels.get_used_rect()))
		var area := UI.rect(slots[i].rect).grow(-4)
		var picture := UI.picture(parent, icon, area)
		picture.name = "Relic_" + id
		picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		picture.mouse_filter = Control.MOUSE_FILTER_PASS
		picture.tooltip_text = "%s\n%s" % [artifact.title, artifact.description]


func _build_action(bounds: Array) -> void:
	_new_run = UI.hotspot(self, UI.rect(bounds), "Новый забег")
	_new_run.name = "NewRunButton"
	_new_run.text = "НОВЫЙ ЗАБЕГ"
	_new_run.add_theme_font_override("font", UI.CARD_SKIN.heading_font())
	_new_run.add_theme_font_size_override("font_size", 27)
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color", "font_disabled_color"]:
		_new_run.add_theme_color_override(state, BONE)
	for state in ["hover", "focus", "pressed", "hover_pressed"]:
		var style := StyleBoxTexture.new()
		style.texture = PRESSED if state in ["pressed", "hover_pressed"] else HOVER
		_new_run.add_theme_stylebox_override(state, style)
	_new_run.pressed.connect(_on_new_run_pressed)


func _scroll_copy(parent: Control, node_name: String, bounds: Array, copy: String, font_size: int, color: Color) -> void:
	var scroll := ScrollContainer.new()
	scroll.name = node_name
	scroll.clip_contents = true
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	UI.put(parent, scroll, UI.rect(bounds).grow_individual(-8, -3, -8, -3))
	var label := _caption(scroll, [0, 0, 0, 0], copy, font_size, color)
	label.name = "Summary" if node_name == "SummaryScroll" else "Copy"
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.custom_minimum_size.y = scroll.size.y
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if node_name == "SummaryScroll":
		# The narrow summary band above Last Deal must show a whole first line,
		# not the top edge of a second one. Overflow remains scrollable.
		label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		scroll.size.y = minf(scroll.size.y, label.get_line_height())
		label.custom_minimum_size.y = scroll.size.y
	scroll.tooltip_text = copy


func _caption(parent: Control, bounds: Array, copy: String, font_size: int, color: Color) -> Label:
	return UI.caption(parent, UI.rect(bounds), copy, font_size, color)


func _signed_bonus(value: float) -> String:
	return ("+" if value >= 0.0 else "") + String.num(value, 2)


func _layer(node_name: String) -> Control:
	var layer := Control.new()
	layer.name = node_name
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(layer)
	return layer


func _fade(node: Control, delay: float, duration: float) -> Tween:
	node.modulate.a = 0.0
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "modulate:a", 1.0, duration).set_delay(delay)
	return tween


func _enable_new_run() -> void:
	_new_run.disabled = false
	_new_run.grab_focus()


func _on_new_run_pressed() -> void:
	_new_run.disabled = true
	RunState.reset_run()
	SCENE_ROUTER.change_to(self, "res://scenes/class_select/class_select.tscn")
