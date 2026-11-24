extends Control

const UI := preload("res://scripts/ui/wizard_reliquary.gd")
const CARD_SKIN := preload("res://scripts/class_select/class_select_card_skin.gd")
const CHARTER := preload("res://scripts/core/run_charter.gd")
const LAYOUT := preload("res://assets/pixel/ui/wizard_challenges_v2/layout_1280x720.json")
const PLATE := preload("res://assets/pixel/ui/wizard_challenges_v2/challenges_plate.webp")
const ASSETS := "res://assets/pixel/ui/wizard_challenges_v2/"
const ACHIEVEMENTS := {
	"solo_xiii": ["Один против XIII", "Победить с одним героем в отряде."],
	"trio_xiii": ["Три судьбы", "Победить полным отрядом."],
	"no_last_deal": ["Без второй попытки", "Победить без Последней сделки."],
	"oath_v_victory": ["Вопреки последней ставке", "Победить с пятой клятвой."],
}

var _buttons: Array[Button] = []
var _entries: Array[Dictionary] = []
var _seal: TextureRect
var _title: Label
var _status: Label
var _condition: RichTextLabel
var _effect_heading: Label
var _effect: RichTextLabel
var _count: Label
var _selected := 0


func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	var design: Dictionary = LAYOUT.data
	for group: Dictionary in design.groups:
		UI.caption(self, UI.rect(group.rect), group.label, int(group.font_size), UI.GOLD)

	var detail: Dictionary = design.detail
	_seal = UI.picture(self, null, UI.rect(detail.art_rect))
	_seal.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_title = UI.caption(self, UI.rect(detail.title_rect), "", 26, UI.INK)
	_status = UI.caption(self, UI.rect(detail.status_rect), "", 16, UI.GOLD)
	UI.caption(self, UI.rect(detail.condition_heading_rect), "Условие", 19, UI.INK)
	_condition = _body(UI.rect(detail.condition_rect))
	_effect_heading = UI.caption(self, UI.rect(detail.effect_heading_rect), "Эффект", 19, UI.INK)
	_effect = _body(UI.rect(detail.effect_rect))
	_count = UI.caption(self, UI.rect(detail.count_rect), "", 21, UI.GOLD)


func set_archive(archive: RefCounted) -> void:
	var wins_by_oath := {}
	var earned := {"solo_xiii": false, "trio_xiii": false, "no_last_deal": false}
	for entry: Dictionary in archive.history.values():
		if not entry.won:
			continue
		wins_by_oath[int(entry.oath)] = true
		earned.solo_xiii = earned.solo_xiii or entry.party.size() == 1
		earned.trio_xiii = earned.trio_xiii or entry.party.size() == 3
		earned.no_last_deal = earned.no_last_deal or not entry.last_deal
	earned["oath_v_victory"] = wins_by_oath.has(CHARTER.OATHS.size() - 1)

	var group := ButtonGroup.new()
	var open_count := 0
	var highest_oath: int = archive.highest_oath()
	for layout: Dictionary in LAYOUT.data.entries:
		var entry := _describe(layout, archive, earned, highest_oath, wins_by_oath)
		_entries.append(entry)
		if entry.unlocked:
			open_count += 1
		_add_seal_button(layout, entry, group)
	_count.text = "Открыто %d / %d" % [open_count, _entries.size()]
	if not archive.error_message.is_empty():
		UI.caption(self, Rect2(350, 685, 580, 28), archive.error_message, 16, UI.GOLD)
	_select(0)


func first_seal() -> Button:
	return _buttons[0]


func _describe(layout: Dictionary, archive: RefCounted, earned: Dictionary, highest_oath: int, wins_by_oath: Dictionary) -> Dictionary:
	var result := {"title": "", "condition": "", "effect": "", "unlocked": false, "status": "ЗАКРЫТО"}
	match String(layout.kind):
		"style":
			var role: String = layout.role
			var style: Array = CHARTER.STYLES[role]
			result.title = style[1]
			result.condition = "%s должен победить XIII." % RunState.get_hero_unit_data(role).unit_name
			result.effect = style[2]
			result.unlocked = archive.style_unlocked(role)
			if result.unlocked:
				result.status = "ОТКРЫТО"
		"achievement":
			var achievement: Array = ACHIEVEMENTS[layout.id]
			result.title = achievement[0]
			result.condition = achievement[1]
			result.unlocked = earned[layout.id]
			if result.unlocked:
				result.status = "ВЫПОЛНЕНО"
		"oath":
			var rank := int(layout.rank)
			result.title = CHARTER.OATHS[rank][0]
			result.effect = CHARTER.OATHS[rank][1]
			result.condition = "Одержать первую победу над XIII." if rank == 1 else (
				"Победить с клятвой «%s»." % CHARTER.OATHS[rank - 1][0])
			result.unlocked = rank <= highest_oath
			if result.unlocked:
				result.status = "ПРОЙДЕНО" if wins_by_oath.has(rank) else "ДОСТУПНО"
	result["detail_texture"] = layout.open_detail_texture if result.unlocked else layout.locked_detail_texture
	return result


func _add_seal_button(layout: Dictionary, entry: Dictionary, group: ButtonGroup) -> void:
	var area := UI.rect(layout.rect)
	var button := UI.hotspot(self, area, "%s · %s" % [entry.title, entry.status.to_lower()])
	button.toggle_mode = true
	button.button_group = group
	button.tooltip_text = button.accessibility_name
	var art_area := UI.rect(layout.art_rect)
	art_area.position -= area.position
	var path: String = layout.open_texture if entry.unlocked else layout.locked_texture
	UI.picture(button, load(ASSETS + path) as Texture2D, art_area).name = "Seal"
	var glow := UI.picture(button, load(ASSETS + String(layout.selected_texture)) as Texture2D,
		Rect2(Vector2.ZERO, area.size))
	glow.name = "Highlight"
	glow.hide()
	button.pressed.connect(_select.bind(int(layout.index)))
	button.focus_entered.connect(_update_highlight.bind(button))
	button.focus_exited.connect(_update_highlight.bind(button))
	button.mouse_entered.connect(_update_highlight.bind(button))
	button.mouse_exited.connect(_update_highlight.bind(button))
	_buttons.append(button)


func _select(index: int) -> void:
	_selected = index
	_buttons[index].set_pressed_no_signal(true)
	for button in _buttons:
		_update_highlight(button)
	var entry := _entries[index]
	_seal.texture = load(ASSETS + String(entry.detail_texture)) as Texture2D
	_title.text = entry.title.to_upper()
	_status.text = entry.status
	_condition.text = entry.condition
	_condition.scroll_to_line(0)
	_effect.text = entry.effect
	_effect.scroll_to_line(0)
	_effect_heading.visible = not _effect.text.is_empty()
	_effect.visible = _effect_heading.visible


func _update_highlight(button: Button) -> void:
	var glow := button.get_node("Highlight") as TextureRect
	glow.visible = button.button_pressed or button.has_focus() or button.is_hovered()
	glow.modulate.a = 1.0 if button.button_pressed else 0.45


func _body(area: Rect2) -> RichTextLabel:
	var label := RichTextLabel.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("normal_font", CARD_SKIN.heading_font())
	label.add_theme_font_size_override("normal_font_size", 18)
	label.add_theme_color_override("default_color", UI.INK)
	UI.put(self, label, area)
	return label
