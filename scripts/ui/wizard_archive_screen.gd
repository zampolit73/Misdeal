extends Control

const VISUAL := preload("res://scripts/ui/wizard_archive_visual_v3.gd")
const ARCHIVE := preload("res://scripts/core/wizard_archive.gd")
const ROUTER := preload("res://scripts/core/scene_router.gd")
const RELIQUARY := preload("res://scripts/ui/wizard_reliquary.gd")
const BESTIARY := preload("res://scripts/ui/wizard_bestiary.gd")
const CHRONICLE := preload("res://scripts/ui/wizard_chronicle.gd")
const CHALLENGES := preload("res://scripts/ui/wizard_challenges.gd")

var opens_over_table := false
var _archive := ARCHIVE.instance()
var _tabs: Array[Button] = []
var _reliquary: Control
var _bestiary: Control
var _chronicle: Control
var _challenges: Control
var _plate: TextureRect
var _reliquary_plate: Texture2D
var _tab_captions: Array[Label] = []
var _active_tab := 0
var _title_caption: Label
var _back_caption: Label
var _back_button: Button


func _ready() -> void:
	var design: Dictionary = RELIQUARY.LAYOUT.data
	var canvas := Vector2(design.resolution[0], design.resolution[1])
	_reliquary_plate = RELIQUARY.asset(design.plate)
	_plate = RELIQUARY.picture(self, _reliquary_plate, Rect2(Vector2.ZERO, canvas))

	var title: Dictionary = design.title
	VISUAL.plaque(self, Rect2(326, 27, 511, 80), true).name = "ArchiveV3Title"
	_title_caption = RELIQUARY.caption(self, RELIQUARY.rect(title.rect), "АРХИВ ВОЛШЕБНИКА", int(title.font_size), RELIQUARY.GOLD)
	var back_area := RELIQUARY.rect(design.back.rect)
	var back_caption := "К столу [Esc]" if opens_over_table else "В меню [Esc]"
	var back := RELIQUARY.hotspot(self, back_area, back_caption)
	VISUAL.style_button(back, true)
	var back_text := RELIQUARY.caption(back, Rect2(Vector2.ZERO, back_area.size),
		back_caption, int(design.back.font_size), RELIQUARY.GOLD)
	back.focus_entered.connect(func() -> void: back_text.modulate = Color(1.2, 1.2, 1.2))
	back.focus_exited.connect(func() -> void: back_text.modulate = Color.WHITE)
	back.pressed.connect(close)
	_back_button = back
	_back_caption = back_text

	for tab: Dictionary in design.tabs:
		var index := int(tab.index)
		var area := RELIQUARY.rect(tab.rect)
		var button := RELIQUARY.hotspot(self, area, tab.label)
		var text_area := RELIQUARY.rect(tab.text_rect)
		text_area.position -= area.position
		var caption := RELIQUARY.caption(button, text_area, tab.label, 22, RELIQUARY.GOLD)
		_tabs.append(button)
		_tab_captions.append(caption)
		button.pressed.connect(_show_tab.bind(index))
		button.focus_entered.connect(_update_tab.bind(index))
		button.focus_exited.connect(_update_tab.bind(index))
		button.mouse_entered.connect(_update_tab.bind(index))
		button.mouse_exited.connect(_update_tab.bind(index))

	_reliquary = RELIQUARY.new()
	add_child(_reliquary)
	_reliquary.set_collection(_archive.relics, _archive.error_message)
	_tabs[0].focus_neighbor_bottom = _tabs[0].get_path_to(_reliquary.first_niche())
	_show_tab(0)


func _update_tab(index: int) -> void:
	var button := _tabs[index]
	var active := index == _active_tab
	VISUAL.style_button(button, active)
	_tab_captions[index].modulate = Color(1.18, 1.18, 1.18) if button.has_focus() else Color.WHITE



func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		if _active_tab == 3 and _challenges != null and _challenges.is_collection_open():
			_challenges.close_collection()
		else:
			close()


func close() -> void:
	if opens_over_table:
		queue_free()
	else:
		ROUTER.change_to(self, "res://scenes/main/main.tscn")


func _show_tab(index: int) -> void:
	if _challenges != null and _challenges.is_collection_open():
		_challenges.close_collection(false)
	_active_tab = index
	for slot in _tabs.size():
		_update_tab(slot)
	_tabs[index].grab_focus()
	var is_reliquary := index == 0
	var is_bestiary := index == 1
	var is_chronicle := index == 2
	var is_challenges := index == 3
	_reliquary.visible = is_reliquary
	match index:
		1: _plate.texture = BESTIARY.PLATE
		2: _plate.texture = CHRONICLE.PLATE
		3: _plate.texture = CHALLENGES.PLATE
		_: _plate.texture = _reliquary_plate
	VISUAL.present_page(_plate, index)
	if is_bestiary and _bestiary == null:
		_bestiary = BESTIARY.new()
		add_child(_bestiary)
		_bestiary.set_collection(_archive.enemies, _archive.error_message)
		_tabs[1].focus_neighbor_bottom = _tabs[1].get_path_to(_bestiary.first_niche())
	if _bestiary != null:
		_bestiary.visible = is_bestiary
	if is_chronicle and _chronicle == null:
		_chronicle = CHRONICLE.new()
		add_child(_chronicle)
		_chronicle.set_history(_archive.history, _archive.error_message)
		var row: Button = _chronicle.first_record()
		if row != null:
			_tabs[2].focus_neighbor_bottom = _tabs[2].get_path_to(row)
	if _chronicle != null:
		_chronicle.visible = is_chronicle
	if is_challenges and _challenges == null:
		_challenges = CHALLENGES.new()
		add_child(_challenges)
		_challenges.set_archive(_archive)
		_challenges.collection_mode_changed.connect(_on_collection_mode_changed)
		_tabs[3].focus_neighbor_bottom = _tabs[3].get_path_to(_challenges.first_seal())
	if _challenges != null:
		_challenges.visible = is_challenges

func _on_collection_mode_changed(active: bool) -> void:
	if _active_tab != 3:
		return
	# Keep Challenges selected; only the cabinet changes to the 12-niche layout.
	_plate.texture = CHALLENGES.COLLECTION_PLATE if active else CHALLENGES.PLATE
	VISUAL.present_page(_plate, 1 if active else 3)
	_title_caption.text = _challenges.collection_title() if active else "АРХИВ ВОЛШЕБНИКА"
	var destination := "К столу" if opens_over_table else "В меню"
	# Escape is local to the collection; the global button still exits Archive.
	_back_caption.text = destination if active else destination + " [Esc]"
	_back_button.accessibility_name = _back_caption.text
	_tabs[3].focus_neighbor_bottom = _tabs[3].get_path_to(_challenges.first_seal())
