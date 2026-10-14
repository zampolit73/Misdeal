extends Control

# Isolated F6 entry for the two new non-combat cards. It uses the real
# ActChoice scene, buttons, RunState mutations, DS2 surfaces and table return.
const EVENT_SCENE := "res://scenes/event/act_choice.tscn"

func _ready() -> void:
	var background := ColorRect.new()
	background.color = Color("#100c0d")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var title := Label.new()
	title.text = "MISDEAL — DECK EXPANSION 02 / ПАРА СОБЫТИЙ"
	title.position = Vector2(110, 96)
	title.size = Vector2(1080, 46)
	title.add_theme_color_override("font_color", Color("#dfb77e"))
	title.add_theme_font_size_override("font_size", 26)
	add_child(title)

	var note := Label.new()
	note.text = "Выберите вариант: откроется настоящая сцена события. Возврат идёт на обычный игровой стол."
	note.position = Vector2(114, 169)
	note.size = Vector2(1060, 60)
	note.add_theme_font_size_override("font_size", 16)
	add_child(note)

	_add_button("1 / ЛУННАЯ ПЕЧАТЬ — начало акта", 266, "moon_seal", false)
	_add_button("2 / СКЛЕП ОТЗВУКОВ — с сохранённой печатью", 352, "echo_crypt", true)
	_add_button("3 / СКЛЕП ОТЗВУКОВ — без печати", 438, "echo_crypt", false)

	var art_notice := Label.new()
	art_notice.text = "Геймплейный предпросмотр. Арты новых карт пока используют тематические DS2-заглушки."
	art_notice.position = Vector2(114, 555)
	art_notice.size = Vector2(1050, 78)
	art_notice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	art_notice.add_theme_color_override("font_color", Color("#a68c78"))
	add_child(art_notice)


func _add_button(caption: String, y: float, card_id: String, with_seal: bool) -> void:
	var button := Button.new()
	button.text = caption
	button.position = Vector2(230, y)
	button.size = Vector2(820, 62)
	button.pressed.connect(_open_card.bind(card_id, with_seal))
	add_child(button)


func _open_card(card_id: String, with_seal: bool) -> void:
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	RunState.gold = 35
	if with_seal:
		RunState.set_event_outcome("moon_seal", "kept")
	RunState.current_offer_ids.clear()
	RunState.current_offer_ids.append(card_id)
	RunState.current_offer_ids.append("bone_patrol")
	if not RunState.choose_card(card_id):
		push_error("D149 dev preview failed to choose %s" % card_id)
		return
	get_tree().change_scene_to_file(EVENT_SCENE)
