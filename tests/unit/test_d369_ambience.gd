extends GutTest

# D369: low, looped environmental sound is separate from Oak/UI and combat.
const DIRECTOR_SCRIPT := preload("res://scripts/audio/sound_director.gd")
const SAMPLES := {
	"castle": "res://assets/audio/ambience/d369_castle_roomtone.wav",
	"courtyard": "res://assets/audio/ambience/d369_courtyard_roomtone.wav",
	"ossuary": "res://assets/audio/ambience/d369_ossuary_roomtone.wav",
}


func _new_director() -> Node:
	var director := DIRECTOR_SCRIPT.new() as Node
	add_child_autofree(director)
	return director


func test_three_short_authored_ambient_samples_are_importable() -> void:
	for location in SAMPLES:
		var stream := load(SAMPLES[location]) as AudioStreamWAV
		assert_not_null(stream, "D369 WAV not importable: " + location)
		if stream != null:
			assert_eq(stream.mix_rate, 16000)
			# Importer's silence trim is expected for these soft WAV resources.
			assert_true(stream.get_length() >= 7.0 and stream.get_length() <= 8.2)
			var source := FileAccess.get_file_as_bytes(SAMPLES[location])
			assert_eq(source.size(), 256044, "The original 8-second PCM source must be complete")


func test_ambience_is_silent_until_location_and_players_use_own_bus() -> void:
	var director := _new_director()
	assert_eq(director.call("get_current_location"), "silence")
	assert_eq(director.get_child_count(), 2)
	for i in range(2):
		var voice := director.get_child(i) as AudioStreamPlayer
		assert_not_null(voice)
		if voice != null:
			assert_eq(voice.bus, "Ambience")
			assert_null(voice.stream)


func test_context_mapping_follows_existing_arena_ids() -> void:
	assert_eq(DIRECTOR_SCRIPT.location_for_arena("iron_wall"), "castle")
	assert_eq(DIRECTOR_SCRIPT.location_for_arena("last_bell"), "castle")
	assert_eq(DIRECTOR_SCRIPT.location_for_arena("firing_square"), "courtyard")
	assert_eq(DIRECTOR_SCRIPT.location_for_arena("graveyard"), "courtyard")
	assert_eq(DIRECTOR_SCRIPT.location_for_arena("ossuary"), "ossuary")
	assert_eq(DIRECTOR_SCRIPT.location_for_arena("warden"), "ossuary")


func test_location_streams_loop_and_same_location_does_not_restart() -> void:
	var director := _new_director()
	director.call("set_location", "castle")
	assert_eq(director.call("get_current_location"), "castle")
	var slot := int(director.get("_ambience_slot"))
	var voice: AudioStreamPlayer = director.get_child(slot) as AudioStreamPlayer
	var stream := voice.stream as AudioStreamWAV
	assert_not_null(stream)
	if stream != null:
		assert_eq(stream.loop_mode, AudioStreamWAV.LOOP_FORWARD)
		assert_eq(stream.loop_end, 128000)
		assert_true(stream.get_length() >= 7.99 and stream.get_length() <= 8.01)
	director.call("set_location", "castle")
	assert_eq(int(director.get("_ambience_slot")), slot)
	assert_same(voice.stream, stream)


func test_crossfade_and_silence_preserve_location_state() -> void:
	var director := _new_director()
	director.call("set_location", "castle", 0.10)
	director.call("set_location", "ossuary", 0.10)
	assert_eq(director.call("get_current_location"), "ossuary")
	var slot := int(director.get("_ambience_slot"))
	var voice: AudioStreamPlayer = director.get_child(slot) as AudioStreamPlayer
	assert_not_null(voice.stream)
	assert_eq((voice.stream as AudioStreamWAV).data.size(), 256000)
	assert_eq((voice.stream as AudioStreamWAV).loop_end, 128000)
	director.call("set_location", "silence", 0.10)
	assert_eq(director.call("get_current_location"), "silence")


func test_table_battle_and_scene_exit_have_scoped_location_hooks() -> void:
	var table_code := FileAccess.get_file_as_string("res://scripts/table/table.gd")
	var battle_code := FileAccess.get_file_as_string("res://scripts/battle/battle.gd")
	var scene_code := FileAccess.get_file_as_string("res://scripts/core/scene_transition.gd")
	assert_true(table_code.contains("SoundDirector.set_location(\"castle\")"))
	assert_true(battle_code.contains("SoundDirector.location_for_arena(encounter.arena_id)"))
	assert_true(scene_code.contains("SoundDirector.set_location(\"silence\")"))


func test_audio_audition_is_real_f6_scene() -> void:
	var scene := load("res://scenes/dev/d369_ambience_audition.tscn") as PackedScene
	assert_not_null(scene)
	if scene != null:
		var preview := scene.instantiate()
		add_child_autofree(preview)
		for name in ["SelectCastle", "SelectCourtyard", "SelectOssuary", "SelectSilence", "AmbienceVolume"]:
			assert_true(preview.has_node("Background") if name == "Background" else _has_node_recursive(preview, name), "No audition UI: " + name)


func _has_node_recursive(root: Node, target_name: String) -> bool:
	if root.name == target_name:
		return true
	for child in root.get_children():
		if _has_node_recursive(child, target_name):
			return true
	return false
