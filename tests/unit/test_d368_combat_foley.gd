extends GutTest

# The V2 palette keeps the existing player pool and the approved step cue.
const COMBAT_SCRIPT := preload("res://scripts/battle/combat_audio.gd")


func _new_audio() -> Node:
	var audio: Node = COMBAT_SCRIPT.new() as Node
	add_child_autofree(audio)
	return audio


func test_v2_palette_has_real_recorded_cues_and_original_bone_steps() -> void:
	var audio := _new_audio()
	var bank: Dictionary = audio.get("_streams")
	for family: String in COMBAT_SCRIPT.CUES:
		var stream := bank.get(family) as AudioStream
		assert_not_null(stream, "Missing live cue: " + family)
		if stream != null:
			assert_gt(stream.get_length(), 0.0)
			if family != "enemy_step":
				assert_eq(stream.resource_path, COMBAT_SCRIPT.PALETTE + String(COMBAT_SCRIPT.CUES[family][0]) + ".wav")
	assert_same(bank.get("enemy_step"), load("res://assets/audio/act1/bones.ogg"))
	assert_eq(COMBAT_SCRIPT.CUES["enemy_step"].slice(1), [740, 1, -21.0])


func test_combat_pool_keeps_six_voices_on_the_existing_bus() -> void:
	var audio := _new_audio()
	assert_eq(audio.get_child_count(), 6)
	for index in range(audio.get_child_count()):
		var voice := audio.get_child(index) as AudioStreamPlayer
		assert_not_null(voice)
		if voice != null:
			assert_eq(voice.bus, "Combat")


func test_four_fast_archers_are_throttled_but_bow_uses_two_variants() -> void:
	var audio := _new_audio()
	audio.call("play_event", "attack", "bone_archer")
	var first_voice: AudioStreamPlayer = audio.get_child(0) as AudioStreamPlayer
	assert_same(first_voice.stream, load(COMBAT_SCRIPT.PALETTE + "bow-a.wav"))
	var next_index := int(audio.get("_voice_index"))
	for _shot in range(3):
		audio.call("play_event", "attack", "bone_archer")
	assert_eq(int(audio.get("_voice_index")), next_index)
	assert_eq(int(audio.get("_ranged_accepted")), 1)
	var last_played: Dictionary = audio.get("_last_played_ms")
	last_played["attack_ranged"] = -100000
	audio.call("play_event", "attack", "ranger")
	assert_eq(int(audio.get("_ranged_accepted")), 2)
	var second_voice: AudioStreamPlayer = audio.get_child(1) as AudioStreamPlayer
	assert_same(second_voice.stream, load(COMBAT_SCRIPT.PALETTE + "bow-b.wav"))


func test_healing_and_boss_have_higher_priority_than_attack_spam() -> void:
	var audio := _new_audio()
	var cues := COMBAT_SCRIPT.CUES
	assert_gt(int(cues["heal"][2]), int(cues["attack_ranged"][2]))
	assert_gt(int(cues["boss"][2]), int(cues["hit"][2]))
	assert_gte(int(cues["attack_ranged"][1]), 150)
	assert_gt(int(cues["heal"][1]), int(cues["hit"][1]))
	audio.call("play_event", "heal", "grave_bellkeeper")
	var voice: AudioStreamPlayer = audio.get_child(0) as AudioStreamPlayer
	assert_same(voice.stream, load(COMBAT_SCRIPT.PALETTE + "rite.wav"))
	assert_almost_eq(voice.pitch_scale, 1.0, 0.001)


func test_d368_audition_is_a_real_f6_scene() -> void:
	var packed := load("res://scenes/dev/d368_combat_audio_audition.tscn") as PackedScene
	assert_not_null(packed)
	if packed != null:
		var scene := packed.instantiate()
		add_child_autofree(scene)
		assert_true(scene.has_node("CombatAudio"))
		assert_true(scene.has_node("Background"))
