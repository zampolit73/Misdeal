extends Node

const SAMPLE_RATE := 22050
const VOICE_COUNT := 4

@export var output_volume_db: float = -12.0

var _streams: Dictionary = {}
var _voices: Array[AudioStreamPlayer] = []
var _voice_index := 0

func _ready() -> void:
	_build_streams()
	for _index in range(VOICE_COUNT):
		var voice := AudioStreamPlayer.new()
		voice.volume_db = output_volume_db
		add_child(voice)
		_voices.append(voice)

func play_event(event_name: String) -> void:
	var stream := _streams.get(event_name) as AudioStreamWAV
	if stream == null or _voices.is_empty():
		return

	var voice := _voices[_voice_index]
	_voice_index = (_voice_index + 1) % _voices.size()
	voice.stop()
	voice.stream = stream
	voice.volume_db = output_volume_db
	match event_name:
		"select":
			voice.pitch_scale = 0.96
		"discard":
			voice.pitch_scale = 0.90
		"meddle":
			voice.pitch_scale = 0.78
		"milestone":
			voice.pitch_scale = 0.92
		_:
			voice.pitch_scale = 1.0
	voice.play()

func _build_streams() -> void:
	_streams = {
		"deal": _make_stream("deal", 0.11),
		"select": _make_stream("select", 0.16),
		"discard": _make_stream("discard", 0.18),
		"meddle": _make_stream("meddle", 0.24),
		"milestone": _make_stream("milestone", 0.52),
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
