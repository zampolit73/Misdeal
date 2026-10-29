extends Node

# Audio 1: quiet independent UI/Combat/Ambience buses.
# D369: subtle environment roomtones, never background music.
# D374: user rejected all location ambience in real gameplay.
# Default to silent-first runtime. The former loops remain for explicit F6 audition.
# Preserve approved tabletop Oak and existing combat cues.
const BUS_UI := "UI"
const BUS_COMBAT := "Combat"
const BUS_AMBIENCE := "Ambience"
const SILENCE_DB := -60.0
const AMBIENCE_VOICE_DB := -2.0
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
var _location_ambience_enabled := false


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


func is_location_ambience_enabled() -> bool:
	return _location_ambience_enabled


func set_location_ambience_enabled(enabled: bool) -> void:
	# An explicit opt-in is reserved for isolated QA audition scenes, not F5.
	# Disabling cuts both crossfade voices and prevents a cached location
	# from restarting when Table/Battle/SceneTransition request it again.
	if _location_ambience_enabled == enabled:
		return
	_location_ambience_enabled = enabled
	if not enabled:
		_current_location = "silence"
		transition_ambience(null, 0.12)


static func location_for_arena(arena_id: String) -> String:
	if arena_id in OUTDOOR_ARENAS:
		return "courtyard"
	if arena_id in OSSUARY_ARENAS:
		return "ossuary"
	return "castle"


func get_current_location() -> String:
	return _current_location


func set_location(location_id: String, fade_seconds: float = 1.6) -> void:
	if not _location_ambience_enabled and location_id != "silence":
		return # D374: never play ambient loops automatically during the game.
	# Reopen a location if the old source was stopped by a prior preview.
	if location_id == _current_location:
		if location_id == "silence":
			return
		if _ambience_players.size() == 2 and _ambience_players[_ambience_slot].playing:
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


func get_ambience_debug_info() -> Dictionary:
	# Dev-only diagnostic readout; never changes the mix or gameplay.
	var idx := AudioServer.get_bus_index(BUS_AMBIENCE)
	var players: Array[Dictionary] = []
	var loaded := false
	for player in _ambience_players:
		var has_stream := player.stream != null
		loaded = loaded or has_stream
		players.append({
			"playing": player.playing,
			"gain_db": player.volume_db,
			"position_s": player.get_playback_position() if player.playing else 0.0,
			"stream_loaded": has_stream,
			"bus": String(player.bus),
		})
	return {
		"location": _current_location,
		"enabled": _location_ambience_enabled,
		"bus_exists": idx >= 0,
		"bus_db": AudioServer.get_bus_volume_db(idx) if idx >= 0 else -80.0,
		"bus_muted": AudioServer.is_bus_mute(idx) if idx >= 0 else true,
		"stream_loaded": loaded,
		"players": players,
	}


func _get_ambience_stream(location_id: String) -> AudioStreamWAV:
	if _ambience_streams.has(location_id):
		return _ambience_streams[location_id] as AudioStreamWAV
	var path: String = LOCATION_PATHS.get(location_id, "")
	# The authored WAV is exactly eight seconds; use Godot's imported stream.
	# Its source RIFF length is verified by GUT before shipping.
	var stream := load(path) as AudioStreamWAV
	if stream == null:
		return null
	stream.loop_begin = 0
	stream.loop_end = maxi(1, int(round(stream.get_length() * float(stream.mix_rate))))
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
