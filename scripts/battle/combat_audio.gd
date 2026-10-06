extends Node

const SAMPLE_RATE := 22050
const VOICE_COUNT := 10

@export var output_volume_db: float = -10.0

var _streams: Dictionary = {}
var _voices: Array[AudioStreamPlayer] = []
var _voice_index := 0
var _last_played_ms: Dictionary = {}
var _pitch_rng := RandomNumberGenerator.new()

func _ready() -> void:
	add_to_group("combat_audio")
	_pitch_rng.seed = 0x5A17C0DE
	_build_streams()

	for _index in range(VOICE_COUNT):
		var voice := AudioStreamPlayer.new()
		voice.volume_db = output_volume_db
		add_child(voice)
		_voices.append(voice)

func play_event(event_name: String, role: String = "") -> void:
	var stream_key := event_name
	if event_name == "attack":
		stream_key = _get_attack_stream_key(role)

	var cooldown_key := event_name if event_name != "attack" else stream_key
	var now := Time.get_ticks_msec()
	var cooldown := _get_cooldown_ms(event_name)
	var last_played := int(_last_played_ms.get(cooldown_key, -100000))
	if cooldown > 0 and now - last_played < cooldown:
		return
	_last_played_ms[cooldown_key] = now

	var stream := _streams.get(stream_key) as AudioStreamWAV
	if stream == null or _voices.is_empty():
		return

	var voice := _voices[_voice_index]
	_voice_index = (_voice_index + 1) % _voices.size()
	voice.stop()
	voice.stream = stream
	voice.volume_db = output_volume_db + _get_volume_offset_db(event_name)
	voice.pitch_scale = _get_pitch_scale(event_name, role)
	voice.play()

func _get_attack_stream_key(role: String) -> String:
	match role:
		"ranger", "bone_archer":
			return "attack_ranged"
		"mage", "grave_bellkeeper":
			return "attack_magic"
		_:
			return "attack_melee"

func _get_cooldown_ms(event_name: String) -> int:
	match event_name:
		"attack":
			return 28
		"hit":
			return 42
		"order":
			return 85
		_:
			return 0

func _get_volume_offset_db(event_name: String) -> float:
	match event_name:
		"hit":
			return -2.0
		"order":
			return -3.0
		"heal":
			return -2.0
		"boss":
			return 2.0
		"victory", "defeat":
			return 1.0
		_:
			return 0.0

func _get_pitch_scale(event_name: String, role: String) -> float:
	if event_name == "death" and role == "bone_warden":
		return 0.72
	if event_name == "boss":
		return 0.78
	return _pitch_rng.randf_range(0.96, 1.04)

func _build_streams() -> void:
	_streams = {
		"attack_melee": _make_stream("attack_melee", 0.11),
		"attack_ranged": _make_stream("attack_ranged", 0.13),
		"attack_magic": _make_stream("attack_magic", 0.18),
		"hit": _make_stream("hit", 0.085),
		"death": _make_stream("death", 0.28),
		"heal": _make_stream("heal", 0.24),
		"boss": _make_stream("boss", 0.42),
		"order": _make_stream("order", 0.075),
		"start": _make_stream("start", 0.24),
		"victory": _make_stream("victory", 0.42),
		"defeat": _make_stream("defeat", 0.46),
	}

func _make_stream(kind: String, duration: float) -> AudioStreamWAV:
	var sample_count := maxi(1, int(round(float(SAMPLE_RATE) * duration)))
	var data := PackedByteArray()
	data.resize(sample_count * 2)

	var noise_rng := RandomNumberGenerator.new()
	noise_rng.seed = _seed_for_kind(kind)

	for index in range(sample_count):
		var t := float(index) / float(SAMPLE_RATE)
		var progress := float(index) / float(maxi(1, sample_count - 1))
		var fade := pow(maxf(0.0, 1.0 - progress), 2.0)
		var noise := noise_rng.randf_range(-1.0, 1.0)
		var value := 0.0

		match kind:
			"attack_melee":
				var punch := sin(TAU * 92.0 * t) * 0.48
				value = (punch + noise * 0.48) * fade
			"attack_ranged":
				var sweep_freq := 760.0 - 500.0 * progress
				var string_tone := sin(TAU * sweep_freq * t) * 0.52
				var click := noise * 0.34 * maxf(0.0, 1.0 - progress * 8.0)
				value = (string_tone + click) * fade
			"attack_magic":
				var magic_freq := 260.0 + 760.0 * progress
				value = (
					sin(TAU * magic_freq * t) * 0.42
					+ sin(TAU * magic_freq * 1.51 * t) * 0.20
				) * fade
			"hit":
				value = (
					sin(TAU * 118.0 * t) * 0.38
					+ noise * 0.58
				) * pow(maxf(0.0, 1.0 - progress), 2.6)
			"death":
				var death_freq := 155.0 - 92.0 * progress
				value = (
					sin(TAU * death_freq * t) * 0.47
					+ noise * 0.24
				) * fade
			"heal":
				value = (
					sin(TAU * 660.0 * t) * 0.34
					+ sin(TAU * 990.0 * t) * 0.22
				) * fade
			"boss":
				var rumble_freq := 72.0 - 22.0 * progress
				value = (
					sin(TAU * rumble_freq * t) * 0.52
					+ sin(TAU * 116.0 * t) * 0.19
					+ noise * 0.18
				) * fade
			"order":
				value = (
					sin(TAU * 520.0 * t) * 0.34
					+ sin(TAU * 780.0 * t) * 0.18
				) * fade
			"start":
				value = (
					sin(TAU * (105.0 + 90.0 * progress) * t) * 0.44
					+ noise * 0.18
				) * fade
			"victory":
				var victory_freq := 392.0
				if progress > 0.66:
					victory_freq = 659.0
				elif progress > 0.33:
					victory_freq = 523.0
				value = (
					sin(TAU * victory_freq * t) * 0.38
					+ sin(TAU * victory_freq * 2.0 * t) * 0.10
				) * fade
			"defeat":
				var defeat_freq := 190.0 - 105.0 * progress
				value = (
					sin(TAU * defeat_freq * t) * 0.42
					+ sin(TAU * defeat_freq * 0.5 * t) * 0.18
				) * fade

		var sample := int(round(clampf(value * 0.82, -1.0, 1.0) * 32767.0))
		if sample < 0:
			sample += 65536
		data[index * 2] = sample & 0xFF
		data[index * 2 + 1] = (sample >> 8) & 0xFF

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = data
	return stream

func _seed_for_kind(kind: String) -> int:
	match kind:
		"attack_melee":
			return 101
		"attack_ranged":
			return 211
		"attack_magic":
			return 307
		"hit":
			return 401
		"death":
			return 503
		"heal":
			return 601
		"boss":
			return 701
		"order":
			return 809
		"start":
			return 907
		"victory":
			return 1009
		"defeat":
			return 1103
		_:
			return 1
