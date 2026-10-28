extends Node

# Audio 1: quiet independent UI/Combat/Ambience buses.
# D369: optional low-level environment roomtones, never background music.
const BUS_UI := "UI"
const BUS_COMBAT := "Combat"
const BUS_AMBIENCE := "Ambience"
const SILENCE_DB := -60.0
const AMBIENCE_VOICE_DB := -16.0
const LOCATION_PATHS := {
	"castle": "res://assets/audio/ambience/d369_castle_roomtone.wav",
	"courtyard": "res://assets/audio/ambience/d369_courtyard_roomtone.wav",
	"ossuary": "res://assets/audio/ambience/d369_ossuary_roomtone.wav",
}
const OUTDOOR_ARENAS := [
	"graveyard", "gallows", "grave_crossfire", "firing_square",
	"black_lantern_road", "black_crossing",
]
const OSSUARY_ARENAS := [
	"crypt", "ossuary", "warden", "bone_crush", "bone_swarm",
	"bone_ritual", "defiled_laboratory",
]

var _ambience_players: Array[AudioStreamPlayer] = []
var _ambience_slot := 0
var _transition: Tween
var _ambience_streams: Dictionary = {}
var _current_location := "silence"


func _ready() -> void:
	for slot in range(2):
		var player := AudioStreamPlayer.new()
		player.name = "Ambience%d" % slot
		player.bus = BUS_AMBIENCE
		player.volume_db = SILENCE_DB
		add_child(player)
		_ambience_players.append(player)


func set_channel_volume(bus_name: String, linear: float) -> void:
	if bus_name not in [BUS_UI, BUS_COMBAT, BUS_AMBIENCE]:
		push_warning("SoundDirector: unknown audio bus " + bus_name)
		return
	var idx := AudioServer.get_bus_index(bus_name)
	if idx < 0:
		push_warning("SoundDirector: missing audio bus " + bus_name)
		return
	var amount := clampf(linear, 0.0, 1.0)
	AudioServer.set_bus_mute(idx, amount <= 0.001)
	AudioServer.set_bus_volume_db(idx, linear_to_db(maxf(amount, 0.001)))


func get_channel_volume(bus_name: String) -> float:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx < 0 or AudioServer.is_bus_mute(idx):
		return 0.0
	return clampf(db_to_linear(AudioServer.get_bus_volume_db(idx)), 0.0, 1.0)


static func location_for_arena(arena_id: String) -> String:
	if arena_id in OUTDOOR_ARENAS:
		return "courtyard"
	if arena_id in OSSUARY_ARENAS:
		return "ossuary"
	return "castle"


func get_current_location() -> String:
	return _current_location


func set_location(location_id: String, fade_seconds: float = 1.6) -> void:
	if location_id == _current_location:
		return
	if location_id == "silence":
		_current_location = "silence"
		transition_ambience(null, fade_seconds)
		return
	if not LOCATION_PATHS.has(location_id):
		push_warning("SoundDirector: unknown ambience " + location_id)
		return

	var stream := _get_ambience_stream(location_id)
	if stream == null:
		# Failed asset imports should not silence the entire audio bus.
		push_warning("SoundDirector: missing ambience for " + location_id)
		return
	_current_location = location_id
	transition_ambience(stream, fade_seconds)


func _get_ambience_stream(location_id: String) -> AudioStreamWAV:
	if _ambience_streams.has(location_id):
		return _ambience_streams[location_id] as AudioStreamWAV
	var path: String = LOCATION_PATHS.get(location_id, "")
	# Godot's default WAV importer trims low-amplitude tails. That is fine for
	# one-shots, but creates audible joins in intentionally quiet ambient loops.
	# Our authored WAVs have a fixed 44-byte RIFF/PCM header; load their exact
	# source frames when available, with the imported resource as export fallback.
	var stream: AudioStreamWAV = null
	var source := FileAccess.get_file_as_bytes(path)
	if source.size() == 256044 and source.slice(0, 4).get_string_from_ascii() == "RIFF" and source.slice(8, 12).get_string_from_ascii() == "WAVE" and source.slice(36, 40).get_string_from_ascii() == "data":
		stream = AudioStreamWAV.new()
		stream.format = AudioStreamWAV.FORMAT_16_BITS
		stream.mix_rate = 16000
		stream.stereo = false
		stream.data = source.slice(44)
	else:
		stream = load(path) as AudioStreamWAV
	if stream == null:
		return null
	stream.loop_begin = 0
	stream.loop_end = maxi(1, int(stream.data.size() / 2)) if stream.format == AudioStreamWAV.FORMAT_16_BITS else maxi(1, int(round(stream.get_length() * float(stream.mix_rate))))
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	_ambience_streams[location_id] = stream
	return stream


func transition_ambience(stream: AudioStream, fade_seconds: float = 1.6) -> void:
	if _ambience_players.size() != 2:
		return
	if _transition != null and _transition.is_valid():
		_transition.kill()

	var duration := maxf(0.05, fade_seconds)
	_transition = create_tween()
	_transition.set_parallel(true)
	if stream == null:
		# Fade any partially crossfaded voices too, not just the current slot.
		for player in _ambience_players:
			_transition.tween_property(player, "volume_db", SILENCE_DB, duration)
		_transition.chain().tween_callback(_stop_ambience_voices)
		return

	var outgoing := _ambience_players[_ambience_slot]
	var incoming_slot := 1 - _ambience_slot
	var incoming := _ambience_players[incoming_slot]
	incoming.stop()
	incoming.stream = stream
	incoming.volume_db = SILENCE_DB
	incoming.play()
	_transition.tween_property(outgoing, "volume_db", SILENCE_DB, duration)
	_transition.tween_property(incoming, "volume_db", AMBIENCE_VOICE_DB, duration)
	_transition.chain().tween_callback(outgoing.stop)
	_ambience_slot = incoming_slot


func _stop_ambience_voices() -> void:
	for player in _ambience_players:
		player.stop()
