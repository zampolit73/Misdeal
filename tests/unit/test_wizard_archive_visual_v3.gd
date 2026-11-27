extends GutTest

const SCENE := preload("res://scenes/archive/wizard_archive.tscn")
const ARCHIVE := preload("res://scripts/core/wizard_archive.gd")
const VISUAL := preload("res://scripts/ui/wizard_archive_visual_v3.gd")

var profile: RefCounted
var _previous: RefCounted


func before_each() -> void:
	_previous = ARCHIVE.shared
	profile = ARCHIVE.new()
	ARCHIVE.shared = profile


func after_each() -> void:
	ARCHIVE.shared = _previous


func _open() -> Control:
	var screen := SCENE.instantiate() as Control
	screen.opens_over_table = true
	add_child_autofree(screen)
	return screen


func _assert_page(screen: Control, index: int) -> void:
	var plate: TextureRect = screen._plate
	var panel := plate.get_node("ArchiveV3Details") as Panel
	assert_eq(panel.get_rect(), VISUAL.DETAIL_RECTS[index])
	assert_eq(panel.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	assert_eq(panel.get_theme_stylebox("panel").texture, VISUAL.MENU.plate_style(VISUAL.MENU.SECONDARY).texture)
	assert_eq(plate.material.shader, VISUAL.GRADE)
	assert_true(plate.material.get_shader_parameter("full_plate"))
	for i in range(4):
		var button: Button = screen._tabs[i]
		var style := button.get_theme_stylebox("normal") as StyleBoxTexture
		var expected := VISUAL.MENU.PRIMARY if i == index else VISUAL.MENU.SECONDARY
		assert_eq(style.texture, VISUAL.MENU.plate_style(expected).texture)
		assert_false(button.get_theme_stylebox("focus").draw_center)
	assert_eq(screen._active_tab, index)


func test_partial_profile_real_artwork_and_four_native_pages() -> void:
	profile.relics = {"dead_mans_shield": true, "harvest_ring": true}
	profile.enemies = {"bone_warden": true, "skeleton": true}
	profile.history = {
		"win": {"role": "knight", "party": ["knight"], "relics": ["dead_mans_shield"], "won": true,
			"date": "2026-11-26T20:25:00", "card": 13, "style": "", "oath": 0, "last_deal": false},
		"loss": {"role": "ranger", "party": ["ranger"], "relics": [], "won": false,
			"date": "2026-11-25T20:25:00", "card": 7, "style": "", "oath": 0, "last_deal": true},
	}
	var before := [profile.relics.duplicate(true), profile.enemies.duplicate(true), profile.history.duplicate(true)]
	var screen := _open()
	await get_tree().process_frame
	_assert_page(screen, 0)
	var relic: Control = screen._reliquary
	assert_eq(relic._buttons.size(), RunState.ARTIFACT_PATHS.size())
	assert_eq(relic._count.text, "Найдено 2 / 13")
	var shield_index: int = relic._ids.find("dead_mans_shield")
	relic._buttons[shield_index].pressed.emit()
	assert_eq(relic._title.text, RunState.get_artifact("dead_mans_shield").title)
	assert_eq(relic._description.text, RunState.get_artifact("dead_mans_shield").description)
	assert_null(relic._portrait.material, "Do not regrade actual relic art")
	assert_eq(relic._description.get_theme_color("default_color"), VISUAL.COPY)
	var unknown: int = relic._ids.size() - 1
	relic._buttons[unknown].pressed.emit()
	assert_eq(relic._status.text, "НИША ЗАКРЫТА")
	screen._tabs[1].pressed.emit()
	_assert_page(screen, 1)
	var bestiary: Control = screen._bestiary
	assert_eq(bestiary._count.text, "Встречено 2 / 26")
	bestiary._slots[ARCHIVE.ENEMY_IDS.find("bone_warden")].pressed.emit()
	assert_eq(bestiary._title.text, "Костяной надзиратель")
	assert_null(bestiary._portrait.material)
	bestiary._next.pressed.emit()
	assert_eq(bestiary._page_label.text, "2 / 3")
	screen._tabs[2].pressed.emit()
	_assert_page(screen, 2)
	var chronicle: Control = screen._chronicle
	assert_eq(chronicle._outcome.text, "ПОБЕДА")
	assert_eq(chronicle._outcome.get_theme_color("font_color"), VISUAL.GOLD)
	chronicle._rows[1].pressed.emit()
	assert_eq(chronicle._outcome.text, "ПОРАЖЕНИЕ")
	assert_eq(chronicle._outcome.get_theme_color("font_color"), VISUAL.DEFEAT)
	assert_true(chronicle._last_deal.text.ends_with("использована"))
	screen._tabs[3].pressed.emit()
	_assert_page(screen, 3)
	var challenges: Control = screen._challenges
	assert_eq(challenges._buttons.size(), 12)
	assert_eq(challenges._status.text, "ОТКРЫТО")
	assert_eq(challenges._condition.get_theme_color("default_color"), VISUAL.COPY)
	assert_null(challenges._seal.material)
	challenges._buttons.back().pressed.emit()
	assert_eq(challenges._status.text, "ЗАКРЫТО")
	screen._tabs[0].pressed.emit()
	_assert_page(screen, 0)
	assert_eq(screen._reliquary._selected, unknown)
	assert_eq([profile.relics, profile.enemies, profile.history], before, "Browsing must be read-only")


func test_empty_profile_and_return_to_table() -> void:
	var screen := _open()
	assert_eq(screen._reliquary._count.text, "Найдено 0 / 13")
	screen._tabs[2].pressed.emit()
	assert_true(screen._chronicle._empty.visible)
	assert_false(screen._chronicle._details.visible)
	screen._tabs[3].pressed.emit()
	assert_eq(screen._challenges._count.text, "Открыто 0 / 12")
	assert_eq(screen._challenges._status.text, "ЗАКРЫТО")
	var event := InputEventKey.new()
	event.keycode = KEY_ESCAPE
	event.pressed = true
	screen._unhandled_key_input(event)
	assert_true(screen.is_queued_for_deletion())
