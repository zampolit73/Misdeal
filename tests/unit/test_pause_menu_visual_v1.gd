extends GutTest

const SAVE := preload("res://scripts/core/run_save_service.gd")
const MEMORY := preload("res://scripts/memory/memory_profile.gd")
const TABLE := preload("res://scenes/table/table.tscn")
const BATTLE := preload("res://scenes/battle/battle.tscn")
const BUTTONS := ["ResumeButton", "SaveButton", "LoadButton", "SaveExitButton", "MainMenuButton"]

var original_scene: Node
var old_save: RefCounted
var old_memory: RefCounted
var service: RefCounted
var run_menu: CanvasLayer

func before_each() -> void:
	original_scene = get_tree().current_scene
	old_save = SAVE.shared
	old_memory = MEMORY.shared
	service = SAVE.new()
	service.path = "user://pause_visual_test_%d.json" % Time.get_ticks_usec()
	SAVE.shared = service
	MEMORY.shared = MEMORY.new()
	MEMORY.shared.path = service.path + ".memory"
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	run_menu = get_tree().root.get_node("RunMenu")

func after_each() -> void:
	if is_instance_valid(run_menu.menu):
		run_menu.close_menu()
	get_tree().paused = false
	var scene := get_tree().current_scene
	get_tree().current_scene = original_scene
	if is_instance_valid(scene) and scene != original_scene:
		scene.free()
	for suffix in ["", ".bak", ".tmp", ".memory", ".memory.bak", ".memory.tmp"]:
		if FileAccess.file_exists(service.path + suffix):
			DirAccess.remove_absolute(service.path + suffix)
	RunState.reset_run()
	SAVE.shared = old_save
	MEMORY.shared = old_memory

func test_live_table_pause_save_resume_and_load() -> void:
	var table := TABLE.instantiate()
	get_tree().root.add_child(table)
	get_tree().current_scene = table
	await get_tree().create_timer(1.5).timeout
	assert_eq(run_menu.safe_scene(), SAVE.TABLE)
	RunState.gold = 37
	var ids := RunState.current_offer_ids.duplicate()
	var focus: Control = table.squad_button
	focus.grab_focus()
	_press_escape()
	assert_true(get_tree().paused)
	var panel: Control = run_menu.menu.get_node("PausePanel")
	assert_eq(panel.size, Vector2(370, 568))
	assert_true(panel.get_node("PausePlate") is TextureRect)
	assert_not_null(panel.get_node("PausePlate").texture)
	assert_eq(panel.get_node("PausePlate").texture.get_size(), Vector2(740, 1136))
	assert_eq(panel.get_node("Title").text, "ПАУЗА")
	assert_eq(get_viewport().gui_get_focus_owner(), panel.get_node("ResumeButton"))
	for name in BUTTONS:
		var button: Button = panel.get_node(name)
		assert_false(button.disabled, name)
		assert_true(panel.get_global_rect().encloses(button.get_global_rect()), name)
		var text_width := button.get_theme_font("font").get_string_size(button.text, HORIZONTAL_ALIGNMENT_LEFT, -1, button.get_theme_font_size("font_size")).x
		assert_lte(text_width, button.size.x, name)
	var save: Button = panel.get_node("SaveButton")
	save.pressed.emit()
	assert_eq(run_menu.status.text, "Сохранено.")
	assert_eq(service.read_slot(RunState).state.gold, 37)
	assert_eq(RunState.current_offer_ids, ids)
	# Existing main-menu confirmation retains cancellation.
	panel.get_node("MainMenuButton").grab_focus()
	panel.get_node("MainMenuButton").pressed.emit()
	var dialog: Control = run_menu.menu.get_node("SystemDialog")
	assert_not_null(dialog)
	assert_eq(get_viewport().gui_get_focus_owner(), dialog.get_node("Panel/CancelButton"))
	assert_true(get_tree().paused)
	_press_escape()
	assert_true(get_tree().paused, "Escape cancels confirmation, not pause")
	assert_false(dialog.visible)
	assert_eq(get_viewport().gui_get_focus_owner(), panel.get_node("MainMenuButton"))
	_press_escape()
	await get_tree().process_frame
	assert_false(get_tree().paused)
	assert_eq(get_viewport().gui_get_focus_owner(), focus)
	RunState.gold = 99
	_press_escape()
	panel = run_menu.menu.get_node("PausePanel")
	panel.get_node("LoadButton").pressed.emit()
	# Headless rendering never emits frame_post_draw. Drive only that
	# presentation signal, as the existing native route observers do.
	var transition := get_tree().root.get_node("SceneTransition")
	var deadline := Time.get_ticks_msec() + 4000
	while transition.get("_busy") and Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
		if DisplayServer.get_name() == "headless":
			RenderingServer.frame_post_draw.emit()
	await get_tree().process_frame
	assert_false(transition.get("_busy"))
	assert_ne(get_tree().current_scene, table)
	assert_false(get_tree().paused)
	assert_eq(get_tree().current_scene.scene_file_path, SAVE.TABLE)
	assert_eq(RunState.gold, 37)
	assert_eq(RunState.current_offer_ids, ids)

func test_live_battle_pause_blocks_unsafe_saves_and_freezes_combat() -> void:
	RunState.active_card_id = "bone_patrol"
	RunState.select_encounter("res://resources/encounters/bone_patrol.tres")
	var battle := BATTLE.instantiate()
	get_tree().root.add_child(battle)
	get_tree().current_scene = battle
	await get_tree().process_frame
	battle._on_fight_pressed()
	assert_true(battle.combat_started)
	var deadline := Time.get_ticks_msec() + 3000
	while not battle.combat_live and Time.get_ticks_msec() < deadline:
		await get_tree().process_frame
	assert_true(battle.combat_live)
	_press_escape()
	assert_true(get_tree().paused)
	var panel: Control = run_menu.menu.get_node("PausePanel")
	assert_true(panel.get_node("SaveButton").disabled)
	assert_true(panel.get_node("SaveExitButton").disabled)
	assert_false(panel.get_node("LoadButton").disabled)
	assert_true(run_menu.status.text.contains("Сохранение недоступно"))
	var resume: Button = panel.get_node("ResumeButton")
	assert_eq(resume.get_node(resume.focus_neighbor_bottom), panel.get_node("LoadButton"))
	assert_eq(panel.get_node("LoadButton").get_node(panel.get_node("LoadButton").focus_neighbor_bottom), panel.get_node("MainMenuButton"))
	var elapsed: float = battle.combat_elapsed
	await get_tree().create_timer(0.25).timeout
	assert_eq(battle.combat_elapsed, elapsed)
	resume.pressed.emit()
	await get_tree().process_frame
	assert_false(get_tree().paused)
	assert_false(is_instance_valid(run_menu.menu))

func _press_escape() -> void:
	var event := InputEventKey.new()
	event.keycode = KEY_ESCAPE
	event.pressed = true
	run_menu._unhandled_key_input(event)
