extends Node

const VOICE_COUNT := 6
const PALETTE := "res://assets/audio/combat/v2/"
const STEP := preload("res://assets/audio/act1/bones.ogg")
const RANGED_ROLES := ["ranger", "bone_archer", "lantern_archer"]
const MAGIC_ROLES := ["mage", "grave_bellkeeper", "funeral_priest", "plague_alchemist",
	"ash_scrivener", "threadbare_puppeteer", "mute_magistrate"]

# Filename, minimum interval in ms, priority, gain relative to the scene mix.
const CUES := {
	"attack_melee": ["blade", 105, 2, -7.0],
	"attack_ranged": ["bow-a", 155, 2, -8.0],
	"attack_magic": ["spell", 145, 2, -8.0],
	"strong_magic": ["spell-heavy", 250, 4, -5.0],
	"enemy_attack": ["skeleton-swing", 155, 2, -12.0],
	"creature_attack": ["spell-hit", 195, 2, -11.0],
	"enemy_step": ["", 740, 1, -21.0],
	"enemy_hit": ["bone-hit", 175, 3, -9.0],
	"hit": ["body-hit", 175, 3, -10.0],
	"hit_armor": ["armor-hit", 175, 3, -8.0],
	"hit_cloth": ["body-hit", 175, 3, -10.0],
	"hit_arrow": ["arrow-hit", 175, 3, -9.0],
	"hit_magic": ["spell-hit", 160, 3, -8.0],
	"enemy_death": ["bone-break", 245, 4, -6.0],
	"death": ["body-fall", 245, 4, -6.0],
	"death_armor": ["armor-fall", 245, 4, -6.0],
	"death_cloth": ["body-fall", 245, 4, -6.0],
	"heal": ["rite", 420, 5, -9.0],
	"last_rite": ["rite", 650, 5, -5.0],
	"whistle": ["whistle", 950, 5, -8.0],
	"boss_entrance": ["warden-entry", 850, 6, -4.0],
	"boss_attack": ["warden-strike", 235, 4, -5.0],
	"boss": ["warden-phase", 750, 6, -4.0],
	"boss_death": ["warden-fall", 850, 6, -4.0],
	"order": ["command", 105, 1, -12.0],
	"start": ["engage", 850, 4, -9.0],
	"victory": ["victory", 850, 5, -8.0],
	"defeat": ["defeat", 850, 5, -8.0],
}

@export var output_volume_db: float = -10.0

var _streams: Dictionary = {}
var _voices: Array[AudioStreamPlayer] = []
var _voice_priorities: Array[int] = []
var _voice_started_ms: Array[int] = []
var _voice_index := 0
var _ranged_accepted := 0
var _last_played_ms: Dictionary = {}
var _pitch_rng := RandomNumberGenerator.new()


func _ready() -> void:
	add_to_group("combat_audio")
	_pitch_rng.seed = 0x5A17C0DE
	for family: String in CUES:
		if family != "enemy_step":
			_streams[family] = load(PALETTE + String(CUES[family][0]) + ".wav") as AudioStream
	_streams["enemy_step"] = STEP
	_streams["bow_b"] = load(PALETTE + "bow-b.wav") as AudioStream
	for index in range(VOICE_COUNT):
		var voice := AudioStreamPlayer.new()
		voice.bus = "Combat"
		add_child(voice)
		_voices.append(voice)
		_voice_priorities.append(0)
		_voice_started_ms.append(0)


func play_event(event_name: String, role: String = "") -> void:
	var family := _get_attack_stream_key(role) if event_name == "attack" else event_name
	if not CUES.has(family):
		return
	var settings: Array = CUES[family]
	var now := Time.get_ticks_msec()
	if now - int(_last_played_ms.get(family, -100000)) < int(settings[1]):
		return
	var key := "bow_b" if family == "attack_ranged" and _ranged_accepted % 2 == 1 else family
	var stream := _streams.get(key) as AudioStream
	if stream == null:
		return
	var priority := int(settings[2])
	var chosen := _choose_voice(priority)
	if chosen < 0:
		return
	var voice := _voices[chosen]
	voice.stop()
	voice.stream = stream
	voice.volume_db = output_volume_db + float(settings[3])
	voice.pitch_scale = _get_pitch_scale(family, role)
	voice.play()
	_voice_started_ms[chosen] = now
	_voice_priorities[chosen] = priority
	_voice_index = (chosen + 1) % _voices.size()
	_last_played_ms[family] = now
	if family == "attack_ranged":
		_ranged_accepted += 1


func _choose_voice(incoming_priority: int) -> int:
	for offset in range(_voices.size()):
		var index := (_voice_index + offset) % _voices.size()
		if not _voices[index].playing:
			return index
	var oldest := 9223372036854775807
	var candidate := -1
	for index in range(_voices.size()):
		if _voice_priorities[index] > incoming_priority:
			continue
		if _voice_started_ms[index] < oldest:
			oldest = _voice_started_ms[index]
			candidate = index
	return candidate


func _get_attack_stream_key(role: String) -> String:
	if role in RANGED_ROLES:
		return "attack_ranged"
	if role in MAGIC_ROLES:
		return "attack_magic"
	return "attack_melee"


func _get_pitch_scale(family: String, role: String) -> float:
	if family == "enemy_step":
		return _pitch_rng.randf_range(1.12, 1.24)
	if family in ["heal", "last_rite", "whistle", "boss_entrance", "boss", "boss_death"]:
		return 1.0
	var base := 1.0
	if family == "death_cloth" and role == "mage":
		base = 0.90
	elif family == "creature_attack":
		base = 0.86
	return base * _pitch_rng.randf_range(0.96, 1.04)
