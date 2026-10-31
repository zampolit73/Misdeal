extends GutTest

# D377: distinguish stale F5 builds, location ambience and actual UI/Combat audio.
const AUDIT := preload("res://scripts/audio/live_audio_audit.gd")
const DIRECTOR := preload("res://scripts/audio/sound_director.gd")


func test_audit_has_explicit_live_build_id_and_only_opt_in_hotkey() -> void:
	assert_eq(AUDIT.BUILD_MARKER, "D377 / LIVE AUDIO A-B")
	var source := FileAccess.get_file_as_string("res://scripts/audio/sound_director.gd")
	assert_true(source.contains("KEY_F10"))
	assert_true(source.contains("key.ctrl_pressed"))
	assert_true(source.contains("key.shift_pressed"))
	assert_true(source.contains("OS.is_debug_build()"))
	assert_true(source.contains("LIVE_AUDIT_SCRIPT.new()"))
	assert_true(source.contains("get_tree().root.add_child(_live_audio_audit)"))


func test_live_mixer_ab_can_mute_then_restore_all_audio_buses() -> void:
	var original := {}
	for bus_name in ["Master", "UI", "Combat", "Ambience"]:
		var idx := AudioServer.get_bus_index(bus_name)
		assert_true(idx >= 0)
		if idx >= 0:
			original[bus_name] = AudioServer.is_bus_mute(idx)
	var panel := AUDIT.new() as CanvasLayer
	add_child_autofree(panel)
	assert_eq(panel.get_mode(), "normal")
	panel.set_mode("silence")
	assert_true(AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")))
	panel.set_mode("ui_only")
	assert_eq(AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")), original["Master"])
	assert_eq(AudioServer.is_bus_mute(AudioServer.get_bus_index("UI")), original["UI"])
	assert_true(AudioServer.is_bus_mute(AudioServer.get_bus_index("Combat")))
	assert_true(AudioServer.is_bus_mute(AudioServer.get_bus_index("Ambience")))
	panel.set_mode("combat_only")
	assert_true(AudioServer.is_bus_mute(AudioServer.get_bus_index("UI")))
	assert_eq(AudioServer.is_bus_mute(AudioServer.get_bus_index("Combat")), original["Combat"])
	assert_true(AudioServer.is_bus_mute(AudioServer.get_bus_index("Ambience")))
	panel.set_mode("normal")
	for bus_name in original:
		assert_eq(AudioServer.is_bus_mute(AudioServer.get_bus_index(bus_name)), original[bus_name], bus_name)


func test_live_audit_is_read_only_until_mode_button_and_never_starts_old_loops() -> void:
	var director := DIRECTOR.new() as Node
	add_child_autofree(director)
	assert_false(bool(director.call("is_location_ambience_enabled")))
	var panel := AUDIT.new() as CanvasLayer
	add_child_autofree(panel)
	assert_not_null(panel.get_node_or_null("AudioAuditPanel"))
	assert_false(bool(director.call("is_location_ambience_enabled")))
	for mode in AUDIT.VALID_MODES:
		panel.set_mode(mode)
		assert_false(bool(director.call("is_location_ambience_enabled")))
	panel.set_mode("normal")
	var table_code := FileAccess.get_file_as_string("res://scripts/table/table_audio.gd")
	var combat_code := FileAccess.get_file_as_string("res://scripts/battle/combat_audio.gd")
	assert_true(table_code.contains('voice.bus = "UI"'))
	assert_true(combat_code.contains('voice.bus = "Combat"'))
	assert_true(table_code.contains("OAK_DEAL_PATH"))


func test_audit_script_is_neither_in_main_tscn_nor_visible_by_default() -> void:
	var files := [
		"res://scenes/main/main.tscn",
		"res://scenes/table/table.tscn",
		"res://scenes/battle/battle.tscn",
	]
	for path in files:
		var text := FileAccess.get_file_as_string(path)
		assert_false(text.contains("live_audio_audit.gd"), path)
	var director_src := FileAccess.get_file_as_string("res://scripts/audio/sound_director.gd")
	assert_false(director_src.contains("add_child(LIVE_AUDIT_SCRIPT.new())"))
