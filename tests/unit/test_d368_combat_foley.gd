extends GutTest

# D368: authored imports, graceful fallback, restrained polyphony, no gameplay hooks.
const COMBAT_SCRIPT := preload("res://scripts/battle/combat_audio.gd")
const FILES := {
	"attack_melee": "res://assets/audio/combat/d368_attack_melee.wav",
	"attack_ranged_a": "res://assets/audio/combat/d368_attack_ranged_a.wav",
	"attack_ranged_b": "res://assets/audio/combat/d368_attack_ranged_b.wav",
	"attack_magic": "res://assets/audio/combat/d368_attack_magic.wav",
	"hit": "res://assets/audio/combat/d368_hit.wav",
	"death": "res://assets/audio/combat/d368_death.wav",
	"heal": "res://assets/audio/combat/d368_heal.wav",
	"boss": "res://assets/audio/combat/d368_boss.wav",
}


func _new_audio() -> Node:
	var audio: Node = COMBAT_SCRIPT.new() as Node
	add_child_autofree(audio)
	return audio


func test_eight_authored_combat_wavs_are_live_and_short() -> void:
	var audio := _new_audio()
	var bank: Dictionary = audio.get("_streams")
	for key in FILES:
		var sample := load(FILES[key]) as AudioStreamWAV
		assert_not_null(sample, "Missing WAV: " + key)
		if sample == null:
			continue
		assert_eq(sample.mix_rate, 24000)
		assert_eq(sample.format, AudioStreamWAV.FORMAT_16_BITS)
		assert_true(sample.get_length() >= 0.12 and sample.get_length() <= 0.65)
		assert_same(bank.get(key), sample, "Not connected to live combat: " + key)
	assert_false(bank.has("hover"))


func test_all_events_keep_procedural_fallback_and_combat_bus() -> void:
	var audio := _new_audio()
	var fallback: Dictionary = audio.get("_fallback_streams")
	for key in FILES:
		assert_not_null(fallback.get(key), "Missing procedural fallback: " + key)
	for key in ["start", "order", "victory", "defeat"]:
		assert_not_null(fallback.get(key))
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
	assert_same(first_voice.stream, load(FILES["attack_ranged_a"]))
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
	assert_same(second_voice.stream, load(FILES["attack_ranged_b"]))


func test_healing_and_boss_have_higher_priority_than_attack_spam() -> void:
	var audio := _new_audio()
	assert_true(int(audio.call("_get_priority", "heal", "")) > int(audio.call("_get_priority", "attack", "bone_archer")))
	assert_true(int(audio.call("_get_priority", "boss", "bone_warden")) > int(audio.call("_get_priority", "hit", "")))
	assert_true(int(audio.call("_get_cooldown_ms", "attack_ranged")) >= 150)
	assert_true(int(audio.call("_get_cooldown_ms", "heal")) > int(audio.call("_get_cooldown_ms", "hit")))
	audio.call("play_event", "heal", "grave_bellkeeper")
	var voice: AudioStreamPlayer = audio.get_child(0) as AudioStreamPlayer
	assert_same(voice.stream, load(FILES["heal"]))
	assert_almost_eq(voice.pitch_scale, 1.0, 0.001)


func test_d368_audition_is_a_real_f6_scene() -> void:
	var packed := load("res://scenes/dev/d368_combat_audio_audition.tscn") as PackedScene
	assert_not_null(packed)
	if packed != null:
		var scene := packed.instantiate()
		add_child_autofree(scene)
		assert_true(scene.has_node("CombatAudio"))
		assert_true(scene.has_node("Background"))
