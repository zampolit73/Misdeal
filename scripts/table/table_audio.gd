extends Node

const SAMPLE_RATE := 22050
const VOICE_COUNT := 4
const OAK_DEAL_PATH := "res://assets/audio/pilot/d367_deal_b_oak.wav"
const OAK_RATE := 24000
const OAK_CUE_DURATION := {"select": 0.14, "discard": 0.23, "meddle": 0.34, "milestone": 0.50}
const EVENT_COOLDOWN_MS := {"deal": 80, "select": 65, "discard": 90, "meddle": 160, "milestone": 260}

@export var output_volume_db: float = -12.0

var _streams: Dictionary = {}
var _voices: Array[AudioStreamPlayer] = []
var _voice_index := 0
var _last_played_ms: Dictionary = {}
var _fallback_streams: Dictionary = {}

func _ready() -> void:
	_build_streams()
	for _index in range(VOICE_COUNT):
		var voice := AudioStreamPlayer.new()
		voice.volume_db = output_volume_db
		voice.bus = "UI"
		add_child(voice)
		_voices.append(voice)

func play_event(event_name: String) -> void:
	var stream := _streams.get(event_name) as AudioStream
	if stream == null or _voices.is_empty():
		return
	var now := Time.get_ticks_msec()
	var cooldown := int(EVENT_COOLDOWN_MS.get(event_name, 0))
	if now - int(_last_played_ms.get(event_name, -100000)) < cooldown:
		return
	_last_played_ms[event_name] = now

	var voice := _voices[_voice_index]
	_voice_index = (_voice_index + 1) % _voices.size()
	voice.stop()
	voice.stream = stream
	voice.volume_db = output_volume_db
	match event_name:
		"select":
			voice.pitch_scale = 0.99
		"discard":
			voice.pitch_scale = 0.95
		"meddle":
			voice.pitch_scale = 0.88
		"milestone":
			voice.pitch_scale = 0.92
		_:
			voice.pitch_scale = 1.0
	voice.play()


func _build_streams() -> void:
	# D367B: preserve all original cues as a fallback if an approved sample
	# is missing or fails to import. Battle audio is deliberately untouched.
	_fallback_streams = {
		"deal": _make_stream("deal", 0.11),
		"select": _make_stream("select", 0.16),
		"discard": _make_stream("discard", 0.18),
		"meddle": _make_stream("meddle", 0.24),
		"milestone": _make_stream("milestone", 0.52),
	}
	_streams = _fallback_streams.duplicate()
	var approved_deal := load(OAK_DEAL_PATH) as AudioStreamWAV
	if approved_deal == null:
		push_warning("TableAudio: D367B oak sample unavailable, using procedural deal")
		return
	_streams["deal"] = approved_deal
	# Four restrained variations share the oak/dry-paper palette. No hover,
	# music, ambience or persistent noise is introduced by this bank.
	for kind in OAK_CUE_DURATION.keys():
		_streams[kind] = _make_oak_stream(kind)


func _make_oak_stream(kind: String) -> AudioStreamWAV:
	# Tactile one-shots: transient wood resonances + low-passed paper friction.
	# Deliberately short, deterministic and free of melodic synth UI chimes.
	var duration := float(OAK_CUE_DURATION.get(kind, 0.2))
	var sample_count := maxi(1, int(round(float(OAK_RATE) * duration)))
	var bytes := PackedByteArray()
	bytes.resize(sample_count * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = _seed_for_kind(kind) + 3670
	var tap_times: Array[float] = [0.0]
	var wood_gain := 0.40
	var paper_gain := 0.24
	match kind:
		"select":
			wood_gain = 0.38
			paper_gain = 0.17
		"discard":
			tap_times = [0.0, 0.095]
			wood_gain = 0.22
			paper_gain = 0.32
		"meddle":
			tap_times = [0.0, 0.13, 0.21]
			wood_gain = 0.33
			paper_gain = 0.22
		"milestone":
			tap_times = [0.0, 0.22]
			wood_gain = 0.46
			paper_gain = 0.12
	var filtered_noise := 0.0
	for index in range(sample_count):
		var t := float(index) / float(OAK_RATE)
		var progress := float(index) / float(maxi(1, sample_count - 1))
		var noise := rng.randf_range(-1.0, 1.0)
		filtered_noise = filtered_noise * 0.76 + noise * 0.24
		var knock := 0.0
		for onset in tap_times:
			var dt := t - onset
			if dt < 0.0:
				continue
			var decay := exp(-42.0 * dt)
			knock += (
				sin(TAU * 104.0 * dt) * 0.55
				+ sin(TAU * 208.0 * dt) * 0.21
				+ noise * 0.31 * exp(-53.0 * dt)
			) * decay
		var paper := filtered_noise * pow(maxf(0.0, 1.0 - progress), 1.6)
		if kind == "discard":
			paper *= 1.35
		var tail_fade := minf(1.0, (1.0 - progress) * 35.0)
		var onset_fade := minf(1.0, t * 800.0)
		var value := (knock * wood_gain + paper * paper_gain) * tail_fade * onset_fade
		var sample := int(round(clampf(value, -1.0, 1.0) * 32767.0))
		if sample < 0:
			sample += 65536
		bytes[index * 2] = sample & 0xFF
		bytes[index * 2 + 1] = (sample >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = OAK_RATE
	stream.stereo = false
	stream.data = bytes
	return stream


func _make_stream(kind: String, duration: float) -> AudioStreamWAV:
	var sample_count := maxi(1, int(round(float(SAMPLE_RATE) * duration)))
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	var noise_rng := RandomNumberGenerator.new()
	noise_rng.seed = _seed_for_kind(kind)

	for index in range(sample_count):
		var t := float(index) / float(SAMPLE_RATE)
		var progress := float(index) / float(maxi(1, sample_count - 1))
		var fade := pow(maxf(0.0, 1.0 - progress), 2.2)
		var noise := noise_rng.randf_range(-1.0, 1.0)
		var value := 0.0

		match kind:
			"deal":
				value = (noise * 0.48 + sin(TAU * 108.0 * t) * 0.26) * fade
			"select":
				value = (noise * 0.28 + sin(TAU * 310.0 * t) * 0.24 + sin(TAU * 465.0 * t) * 0.12) * fade
			"discard":
				var sweep := sin(TAU * (240.0 - 120.0 * progress) * t) * 0.18
				value = (noise * 0.42 + sweep) * fade
			"meddle":
				var tone := 150.0 - 55.0 * progress
				value = (sin(TAU * tone * t) * 0.34 + noise * 0.20) * fade
			"milestone":
				var low := 82.0 + 20.0 * sin(progress * PI)
				var bell := sin(TAU * 246.0 * t) * 0.18 + sin(TAU * 369.0 * t) * 0.10
				value = (sin(TAU * low * t) * 0.30 + bell + noise * 0.08) * fade

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
		"deal":
			return 202
		"select":
			return 307
		"discard":
			return 409
		"meddle":
			return 503
		"milestone":
			return 607
		_:
			return 1
