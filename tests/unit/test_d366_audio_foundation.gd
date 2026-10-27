extends GutTest

# D366–D367: the final audio bus layout and wav prototypes must be importable.
const SAMPLES := [
	"res://assets/audio/pilot/d367_deal_a_parchment.wav",
	"res://assets/audio/pilot/d367_deal_b_oak.wav",
	"res://assets/audio/pilot/d367_deal_c_cursed.wav",
]


func test_separate_audio_bus_layout_loaded() -> void:
	for bus_name in ["Master", "UI", "Combat", "Ambience"]:
		assert_true(AudioServer.get_bus_index(bus_name) >= 0, "Missing bus: " + bus_name)


func test_three_audio_pilot_samples_are_real_imported_streams() -> void:
	for path in SAMPLES:
		var stream := load(path) as AudioStream
		assert_not_null(stream, "Unimportable WAV: " + path)
		if stream != null:
			assert_true(stream.get_length() >= 0.40, "Unexpectedly short WAV: " + path)


func test_sound_director_handles_mute_and_restore_per_bus() -> void:
	var before := SoundDirector.get_channel_volume("UI")
	SoundDirector.set_channel_volume("UI", 0.0)
	assert_eq(SoundDirector.get_channel_volume("UI"), 0.0)
	SoundDirector.set_channel_volume("UI", 0.5)
	assert_almost_eq(SoundDirector.get_channel_volume("UI"), 0.5, 0.03)
	SoundDirector.set_channel_volume("UI", before)


func test_real_existing_scene_voices_use_independent_buses() -> void:
	var table := load("res://scenes/table/table.tscn") as PackedScene
	var battle := load("res://scenes/battle/battle.tscn") as PackedScene
	assert_not_null(table)
	assert_not_null(battle)
	# Test the authored scripts' configuration without loading complete run scenes.
	var table_script: GDScript = load("res://scripts/table/table_audio.gd") as GDScript
	var battle_script: GDScript = load("res://scripts/battle/combat_audio.gd") as GDScript
	assert_not_null(table_script)
	assert_not_null(battle_script)
	if table_script == null or battle_script == null:
		return
	var table_audio: Node = table_script.new() as Node
	var battle_audio: Node = battle_script.new() as Node
	add_child_autofree(table_audio)
	add_child_autofree(battle_audio)
	var table_voice: AudioStreamPlayer = table_audio.get_child(0) as AudioStreamPlayer
	var battle_voice: AudioStreamPlayer = battle_audio.get_child(0) as AudioStreamPlayer
	assert_not_null(table_voice)
	assert_not_null(battle_voice)
	if table_voice != null and battle_voice != null:
		assert_eq(table_voice.bus, "UI")
		assert_eq(battle_voice.bus, "Combat")


func test_audition_scene_has_three_real_audio_buttons() -> void:
	var scene := load("res://scenes/dev/d367_audio_audition.tscn") as PackedScene
	assert_not_null(scene)
	if scene != null:
		var root := scene.instantiate()
		add_child_autofree(root)
		for index in range(3):
			assert_true(root.has_node("Preview%d" % index))
		assert_true(root.has_node("PreviewPlayer"))
