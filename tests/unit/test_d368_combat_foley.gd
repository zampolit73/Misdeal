extends GutTest

# The combat palette keeps the existing player pool.
const COMBAT_SCRIPT := preload("res://scripts/battle/combat_audio.gd")


func _new_audio() -> Node:
	var audio: Node = COMBAT_SCRIPT.new() as Node
	add_child_autofree(audio)
	return audio


func test_combat_palette_has_recorded_cues_and_rotates_stone_steps_at_native_pitch() -> void:
	var audio := _new_audio()
	var bank: Dictionary = audio.get("_streams")
	for family: String in COMBAT_SCRIPT.CUES:
		if family == "enemy_step":
			continue
		var stream := bank.get(family) as AudioStream
		assert_not_null(stream, "Missing live cue: " + family)
		if stream != null:
			assert_gt(stream.get_length(), 0.0)
	var last_played: Dictionary = audio.get("_last_played_ms")
	for index in COMBAT_SCRIPT.STEP_VARIANTS.size() + 1:
		last_played["enemy_step"] = -100000
		audio.call("play_event", "enemy_step", "skeleton")
		var voice := audio.get_child(index) as AudioStreamPlayer
		var filename: String = COMBAT_SCRIPT.STEP_VARIANTS[index % COMBAT_SCRIPT.STEP_VARIANTS.size()]
		assert_eq(voice.stream.resource_path, COMBAT_SCRIPT.HOTFIX_PALETTE + filename)
		assert_eq(voice.pitch_scale, 1.0)


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
	assert_same(first_voice.stream, load(COMBAT_SCRIPT.HOTFIX_PALETTE + "bow-release-a.wav"))
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
	assert_same(second_voice.stream, load(COMBAT_SCRIPT.HOTFIX_PALETTE + "bow-release-b.wav"))
	audio.call("play_event", "hit_arrow", "skeleton")
	var impact := audio.get_child(2) as AudioStreamPlayer
	assert_same(impact.stream, load(COMBAT_SCRIPT.HOTFIX_PALETTE + "arrow-impact.wav"))


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
