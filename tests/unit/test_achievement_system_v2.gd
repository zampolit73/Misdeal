extends GutTest

const ARCHIVE := preload("res://scripts/core/wizard_archive.gd")
const CATALOG := preload("res://scripts/core/achievement_catalog.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const MEMORY := preload("res://scripts/memory/memory_profile.gd")
const SCREEN := preload("res://scenes/archive/wizard_archive.tscn")
const END_SCREEN := preload("res://scenes/run_end/run_end.tscn")
const NOTICE := preload("res://scripts/ui/achievement_notice.gd")
const DATE := "2026-11-27T12:00:00"

var profile: RefCounted
var _previous: RefCounted
var _old_save_path: String
var _path: String
var _batches: Array


func before_each() -> void:
	_previous = ARCHIVE.shared
	_old_save_path = SAVE.instance().path
	profile = ARCHIVE.new()
	_path = "user://qa_achievement_" + Crypto.new().generate_random_bytes(7).hex_encode() + ".json"
	profile.open_profile(_path)
	ARCHIVE.shared = profile
	SAVE.instance().path = _path + ".run"
	_batches = []
	profile.achievements_unlocked.connect(func(ids: Array[String]) -> void: _batches.append(ids.duplicate()))
	RunState.reset_run()
	RunState.choose_protagonist("knight")


func after_each() -> void:
	ARCHIVE.shared = _previous
	SAVE.instance().path = _old_save_path
	RunState.reset_run()


func _snapshot() -> Dictionary:
	return SAVE.instance().snapshot(RunState).state


func test_checkpoint_unlocks_once_persists_and_reports_current_run() -> void:
	var uid: String = MEMORY.instance().run_uid
	RunState.cards_resolved = 1
	RunState.gold = 100
	RunState.add_artifact("dead_mans_shield")
	RunState.add_hero_upgrade("knight_iron_oath")
	var notice := NOTICE.new()
	add_child_autofree(notice)
	notice.bind_archive(profile)
	assert_true(SAVE.instance().write_slot(RunState))
	for id in ["first_step", "gold_100", "first_relic", "first_upgrade"]:
		assert_true(profile.has_achievement(id), id)
		assert_has(profile.achievements_for_run(uid), id)
	assert_eq(_batches.size(), 1)
	assert_true(notice._panel.visible)
	assert_eq(notice._panel.mouse_filter, Control.MOUSE_FILTER_IGNORE)
	assert_true(notice._heading.text.contains("ДОСТИЖЕНИ"))
	assert_true(SAVE.instance().write_slot(RunState))
	assert_eq(_batches.size(), 1, "No second award on checkpoint replay")
	var restored := ARCHIVE.new()
	restored.open_profile(_path)
	assert_eq(restored.achievements, profile.achievements)
	assert_eq(restored.achievements_for_run(uid), profile.achievements_for_run(uid))
	RunState.run_failed = true
	var result := END_SCREEN.instantiate() as Control
	add_child_autofree(result)
	assert_true(profile.has_achievement("first_defeat"))
	var summary := result.get_node("NewAchievements") as Panel
	assert_not_null(summary)
	assert_true(summary.get_node("AchievementList").tooltip_text.contains(CATALOG.title("first_defeat")))
	assert_true(summary.get_rect().end.x < 633.0, "Result details untouched")
	RunState.reset_run()
	assert_true(restored.achievements_for_run(MEMORY.instance().run_uid).is_empty())


func test_all_24_predicates_and_page_navigation() -> void:
	var state := _snapshot()
	state.cards_resolved = 12
	state.deals_survived = 1
	state.gold = 100
	state.hero_upgrade_ids = ["knight_iron_oath"]
	state.wizard_wagers_accepted = 1
	state.fate_hold_used = true
	state.artifact_ids = RunState.ARTIFACT_PATHS.keys()
	state.last_deal_used = true
	state.run_failed = true
	state.party_roles = ["knight"]
	profile.observe_checkpoint(state, "loss", DATE)
	assert_true(profile.has_achievement("last_deal_accepted"))
	assert_false(profile.has_achievement("solo_xiii"))
	assert_false(profile.has_achievement("no_last_deal"))
	profile.record_enemies(ARCHIVE.ENEMY_IDS, "loss")
	assert_has(profile.achievements_for_run("loss"), "all_enemies")
	state.run_failed = false
	state.boss_defeated = true
	state.last_battle_won = true
	state.last_deal_used = false
	profile.observe_checkpoint(state, "solo", DATE)
	assert_true(profile.has_achievement("solo_xiii"))
	assert_true(profile.has_achievement("no_last_deal"))
	assert_false(profile.has_achievement("oath_v_victory"))
	state.party_roles = ["knight", "ranger", "mage"]
	state.oath_rank = 5
	profile.observe_checkpoint(state, "trio", DATE)
	assert_eq(profile.achievements.size(), 24)
	for entry in CATALOG.ENTRIES:
		assert_true(profile.has_achievement(entry[0]), entry[0])
	var screen := SCREEN.instantiate() as Control
	screen.opens_over_table = true
	add_child_autofree(screen)
	screen._tabs[3].pressed.emit()
	var page: Control = screen._challenges
	assert_eq(page._achievement_page_count(), 6)
	assert_eq(page._achievement_heading.text, "Достижения 24/24")
	assert_eq(page._achievement_page_label.text, "1 / 6")
	assert_true(page._achievement_previous.disabled)
	var visible_ids: Array[String] = []
	for number in range(6):
		for slot in range(3, 7):
			visible_ids.append(page._entries[slot].id)
			page._buttons[slot].pressed.emit()
			assert_eq(page._status.text, "ВЫПОЛНЕНО")
			assert_eq(page._title.text, CATALOG.title(page._entries[slot].id).to_upper())
		if number < 5:
			page._achievement_next.pressed.emit()
	assert_eq(visible_ids.size(), 24)
	assert_eq(visible_ids, CATALOG.ENTRIES.map(func(entry: Array) -> String: return entry[0]))
	assert_true(page._achievement_next.disabled)
	assert_eq(page._achievement_page_label.text, "6 / 6")
	assert_eq(page._buttons.size(), 12)
	assert_eq(page._count.text, "Открыто 30 / 32")
	assert_eq(page._entries[11].status, "ПРОЙДЕНО")


func test_v1_migration_preserves_proven_history_without_toast() -> void:
	var file := FileAccess.open(_path, FileAccess.WRITE)
	file.store_string(JSON.stringify({"version": 1, "relics": {"dead_mans_shield": true}, "enemies": {},
		"history": {"old": {"won": true, "role": "knight", "party": ["knight"], "card": 13,
		"relics": ["dead_mans_shield"], "style": "", "oath": 0, "last_deal": false, "date": DATE}}}))
	file.close()
	profile.open_profile(_path)
	assert_true(profile.has_achievement("solo_xiii"))
	assert_true(profile.has_achievement("no_last_deal"))
	assert_true(profile.has_achievement("first_victory"))
	assert_true(profile.has_achievement("first_relic"))
	assert_false(profile.has_achievement("gold_100"))
	assert_false(profile.has_achievement("first_upgrade"))
	assert_true(profile.achievements_for_run("old").is_empty())
	assert_true(_batches.is_empty())
	assert_eq(int(JSON.parse_string(FileAccess.get_file_as_string(_path)).version), 1, "Browsing is read-only")
	profile.observe_checkpoint(_snapshot(), "new", DATE)
	assert_eq(int(JSON.parse_string(FileAccess.get_file_as_string(_path)).version), 2)
	assert_true(_batches.is_empty())
	assert_true(profile.style_unlocked("knight"))
	assert_eq(profile.highest_oath(), 1)


func test_failed_archive_write_never_announces_until_retry_succeeds() -> void:
	profile.path = _path + "/missing/archive.json"
	RunState.gold = 100
	profile.observe_checkpoint(_snapshot(), "retry", DATE)
	assert_false(profile.has_achievement("gold_100"))
	assert_true(_batches.is_empty())
	assert_false(profile.error_message.is_empty())
	profile.path = _path
	profile.observe_checkpoint(_snapshot(), "retry", DATE)
	assert_true(profile.has_achievement("gold_100"))
	assert_eq(_batches.size(), 1)
	assert_has(profile.achievements_for_run("retry"), "gold_100")
	profile.observe_checkpoint(_snapshot(), "retry", DATE)
	assert_eq(_batches.size(), 1)
