extends GutTest

# D367B: user-approved oak prototype now drives the live table's deal cue.
# Other four authored, short oak/paper one-shots keep a procedural fallback.
const TABLE_SCRIPT := preload("res://scripts/table/table_audio.gd")
const OAK_DEAL_PATH := "res://assets/audio/pilot/d367_deal_b_oak.wav"
const CUES := ["deal", "select", "discard", "meddle", "milestone"]


func _new_table_audio() -> Node:
	var node: Node = TABLE_SCRIPT.new() as Node
	add_child_autofree(node)
	return node


func test_oak_deal_is_live_sample_and_all_five_cues_exist() -> void:
	var node := _new_table_audio()
	var bank: Dictionary = node.get("_streams")
	var approved := load(OAK_DEAL_PATH) as AudioStreamWAV
	assert_not_null(approved)
	assert_eq(bank.size(), 5)
	assert_same(bank.get("deal"), approved)
	for kind in CUES:
		assert_not_null(bank.get(kind), "Missing live cue: " + kind)
	assert_false(bank.has("hover"), "Hover should stay silent")


func test_non_deal_oak_cues_are_distinct_short_pcm_streams() -> void:
	var node := _new_table_audio()
	var bank: Dictionary = node.get("_streams")
	var lengths: Array[int] = []
	for kind in ["select", "discard", "meddle", "milestone"]:
		var stream := bank.get(kind) as AudioStreamWAV
		assert_not_null(stream, "No PCM cue: " + kind)
		if stream == null:
			continue
		assert_true(stream.mix_rate == 24000, "Wrong sample rate: " + kind)
		assert_true(stream.format == AudioStreamWAV.FORMAT_16_BITS)
		assert_true(stream.data.size() > 2000)
		assert_true(stream.get_length() < 0.65)
		lengths.append(stream.data.size())
	assert_eq(lengths.size(), 4)
	if lengths.size() == 4:
		assert_true(lengths[0] != lengths[1] and lengths[1] != lengths[2] and lengths[2] != lengths[3])


func test_procedural_fallback_bank_preserved_for_every_event() -> void:
	var node := _new_table_audio()
	var fallback: Dictionary = node.get("_fallback_streams")
	for kind in CUES:
		assert_not_null(fallback.get(kind), "Lost fallback: " + kind)


func test_live_table_cues_play_on_ui_bus_and_repeat_cooldown_is_scoped() -> void:
	var node := _new_table_audio()
	node.play_event("deal")
	var voice := node.get_child(0) as AudioStreamPlayer
	assert_not_null(voice)
	if voice != null:
		assert_eq(voice.bus, "UI")
		assert_same(voice.stream, load(OAK_DEAL_PATH))
		assert_almost_eq(voice.pitch_scale, 1.0, 0.001)
	node.play_event("select")
	var before := int(node.get("_voice_index"))
	node.play_event("select")
	assert_eq(int(node.get("_voice_index")), before, "Repeated select should be throttled")
	node.play_event("discard")
	assert_eq(int(node.get("_voice_index")), (before + 1) % 4, "Different cue must still play")
