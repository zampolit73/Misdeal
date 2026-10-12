extends Control

# Visual-only Gravedigger Shop study. No RunState, purchases or routing.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const ART := preload("res://scripts/ui/card_art_catalog.gd")
const WEBP := preload("res://scripts/ui/runtime_webp_texture.gd")

const ITEMS := [
	{"role": "knight", "art": "knight_executioner", "name": "МОГИЛЬНЫЙ УРОК", "hero": "РЫЦАРЬ", "detail": "Выбор усиления рыцаря."},
	{"role": "ranger", "art": "ranger_arrowstorm", "name": "ОХОТНИЧЬЯ СХЕМА", "hero": "СЛЕДОПЫТ", "detail": "Выбор усиления следопыта."},
	{"role": "mage", "art": "mage_glass_heart", "name": "ЗАПРЕТНАЯ ЗАПИСКА", "hero": "МАГ", "detail": "Выбор усиления мага."}
]
const PREVIEW_PRICE := 25 # Illustrative only; live shop uses RunState.get_gravedigger_shop_price().
var gold := 40
var available_roles := [true, true, true]
var selected := -1
var cards: Array[Button] = []
var card_prices: Array[Label] = []
var card_notes: Array[Label] = []
var pending_static_copy: Array[Dictionary] = []
var gold_label: Label
var status: Label

func _ready() -> void:
	_background()
	_header()
	_cards()
	_footer()
	_refresh()
	_apply_static_copy()

func _apply_static_copy() -> void:
	# Godot may not finalize the desired geometry for Labels populated before
	# they enter the live scene tree. Assign authored copy only after parenting
	# and fixed bounds, just like the live price/status labels.
	for entry in pending_static_copy:
		var label: Label = entry["label"] as Label
		label.text = String(entry["text"])

func _place(node: Control, pos: Vector2, dimensions: Vector2) -> void:
	node.position = pos
	node.size = dimensions

func _label(value: String, font_size: int, ink: Color, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER) -> Label:
	var label := Label.new()
	# Keep the initial Label blank until it has been added and positioned.
	# The changing demo copy is already refreshed after construction.
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", ink)
	if not value.is_empty():
		pending_static_copy.append({"label": label, "text": value})
	return label

func _background() -> void:
	var bg := WEBP.new() as TextureRect
	bg.set("webp_path", "res://assets/pixel/table/approved_variant_c/table_exact.webp")
	bg.set("expected_size", Vector2i(1280, 720))
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var shade := ColorRect.new()
	shade.color = Color(0.025, 0.012, 0.016, 0.59)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _header() -> void:
	var panel := Panel.new()
	add_child(panel)
	_place(panel, Vector2(176, 22), Vector2(928, 146))
	UI.apply_v2_material_plate(panel, true)
	var eyebrow := _label("MISDEAL  /  ТОРГОВЕЦ  /  ПРЕДПРОСМОТР DS2", 12, UI.AGED_BRONZE)
	panel.add_child(eyebrow)
	_place(eyebrow, Vector2(20, 8), Vector2(888, 23))
	var title := _label("МАГАЗИН МОГИЛЬЩИКА", 29, UI.PARCHMENT_WARM)
	panel.add_child(title)
	_place(title, Vector2(20, 33), Vector2(888, 43))
	var line := _label("«В земле всё равно ничего не пригодится. А тебе — ещё может.»", 15, UI.TEXT)
	panel.add_child(line)
	_place(line, Vector2(22, 79), Vector2(884, 24))
	gold_label = _label("", 15, UI.PARCHMENT_WARM)
	panel.add_child(gold_label)
	_place(gold_label, Vector2(22, 110), Vector2(884, 24))

func _cards() -> void:
	for i in range(ITEMS.size()):
		var item: Dictionary = ITEMS[i]
		var card := Button.new()
		card.text = ""
		card.focus_mode = Control.FOCUS_ALL
		add_child(card)
		_place(card, Vector2(176 + i * 318, 179), Vector2(292, 410))
		card.pressed.connect(_select.bind(i))
		cards.append(card)
		UI.apply_v2_reward_card(card)
		var brow := _label("%s  /  %s" % [str(i + 1), item["hero"]], 13, UI.PARCHMENT_WARM)
		card.add_child(brow)
		_place(brow, Vector2(12, 10), Vector2(268, 24))
		var frame := Panel.new()
		frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(frame)
		_place(frame, Vector2(14, 41), Vector2(264, 181))
		UI.apply_v2_material_plate(frame)
		var picture := TextureRect.new()
		picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		picture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		picture.texture = ART.get_upgrade_texture(String(item["art"]))
		picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		frame.add_child(picture)
		_place(picture, Vector2(5, 5), Vector2(254, 171))
		var parchment := Panel.new()
		parchment.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(parchment)
		_place(parchment, Vector2(14, 233), Vector2(264, 163))
		UI.apply_v2_parchment_plate(parchment)
		var heading := _label(String(item["name"]), 16, Color(0.19, 0.09, 0.07))
		parchment.add_child(heading)
		_place(heading, Vector2(9, 7), Vector2(246, 38))
		var rule := ColorRect.new()
		rule.color = Color(0.42, 0.24, 0.14, 0.75)
		rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parchment.add_child(rule)
		_place(rule, Vector2(23, 50), Vector2(218, 1))
		var price := _label("", 17, Color(0.46, 0.19, 0.10))
		parchment.add_child(price)
		_place(price, Vector2(9, 55), Vector2(246, 30))
		card_prices.append(price)
		var detail := _label(String(item["detail"]), 13, Color(0.22, 0.15, 0.12))
		parchment.add_child(detail)
		_place(detail, Vector2(13, 88), Vector2(238, 30))
		var note := _label("", 12, Color(0.57, 0.16, 0.11))
		parchment.add_child(note)
		_place(note, Vector2(10, 123), Vector2(244, 30))
		card_notes.append(note)

func _footer() -> void:
	var plate := Panel.new()
	add_child(plate)
	_place(plate, Vector2(176, 602), Vector2(928, 100))
	UI.apply_v2_material_plate(plate)
	status = _label("", 13, UI.PARCHMENT_WARM, HORIZONTAL_ALIGNMENT_LEFT)
	plate.add_child(status)
	_place(status, Vector2(16, 8), Vector2(615, 25))
	var hint := _label("F6-МАКЕТ  •  ПОКУПКИ НЕ СОВЕРШАЮТСЯ", 11, UI.TEXT_SECONDARY, HORIZONTAL_ALIGNMENT_LEFT)
	plate.add_child(hint)
	_place(hint, Vector2(16, 33), Vector2(615, 19))
	var gold_button := Button.new()
	gold_button.text = "ЗОЛОТО: 40 / 10"
	plate.add_child(gold_button)
	_place(gold_button, Vector2(16, 62), Vector2(165, 29))
	UI.apply_action_button(gold_button, UI.AGED_BRONZE)
	gold_button.pressed.connect(func() -> void:
		gold = 10 if gold >= PREVIEW_PRICE else 40
		_refresh()
	)
	var party_button := Button.new()
	party_button.text = "МАГ: В ОТРЯДЕ / НЕТ"
	plate.add_child(party_button)
	_place(party_button, Vector2(191, 62), Vector2(244, 29))
	UI.apply_action_button(party_button, UI.AGED_BRONZE)
	party_button.pressed.connect(func() -> void:
		available_roles[2] = not available_roles[2]
		_refresh()
	)
	var leave := Button.new()
	leave.text = "НИЧЕГО НЕ ПОКУПАТЬ"
	plate.add_child(leave)
	_place(leave, Vector2(650, 24), Vector2(257, 49))
	UI.apply_action_button(leave, UI.AGED_BRONZE, true)
	leave.pressed.connect(func() -> void:
		selected = -1
		status.text = "Выход выбран. Это макет: перехода нет."
		_refresh_cards()
	)

func _select(index: int) -> void:
	if gold < PREVIEW_PRICE or not available_roles[index]:
		return
	selected = index
	status.text = "Выбрано: %s. Золото не списано." % ITEMS[index]["name"]
	_refresh_cards()

func _refresh() -> void:
	gold_label.text = "ЗОЛОТО: %d     •     ЦЕНА В МАКЕТЕ: %d     •     В ИГРЕ ЦЕНА МЕНЯЕТСЯ" % [gold, PREVIEW_PRICE]
	if selected >= 0 and (gold < PREVIEW_PRICE or not available_roles[selected]):
		selected = -1
	status.text = "Выберите товар; переключатели проверяют доступность."
	_refresh_cards()

func _refresh_cards() -> void:
	for i in range(cards.size()):
		var affordable: bool = gold >= PREVIEW_PRICE
		var enabled: bool = affordable and available_roles[i]
		cards[i].disabled = not enabled
		cards[i].modulate = Color.WHITE if enabled else Color(0.78, 0.77, 0.75, 1.0)
		card_prices[i].text = "ЦЕНА: %d ЗОЛОТА" % PREVIEW_PRICE
		card_notes[i].text = ("НЕТ ГЕРОЯ В ОТРЯДЕ" if not available_roles[i] else ("НЕ ХВАТАЕТ ЗОЛОТА" if not affordable else "ДОСТУПНО К ПОКУПКЕ"))
		card_notes[i].add_theme_color_override("font_color", Color(0.38, 0.28, 0.15) if enabled else Color(0.57, 0.16, 0.11))
		UI.apply_v2_reward_card(cards[i], selected == i)
