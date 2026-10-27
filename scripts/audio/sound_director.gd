extends Node

# D366: three independent native buses. Existing procedural one-shots keep
# working while the D367 audition bank is awaiting a sound-style approval.
const BUS_UI := "UI"
const BUS_COMBAT := "Combat"
const BUS_AMBIENCE := "Ambience"
const SILENCE_DB := -60.0

var _ambience_players: Array[AudioStreamPlayer] = []
var _ambience_slot := 0
var _transition: Tween


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


func transition_ambience(stream: AudioStream, fade_seconds: float = 0.8) -> void:
	# Prepared for D369. Silent until a real approved ambient recording is supplied.
	# Keeping these voices under a persistent autoload avoids cuts during scene swap.
	if _ambience_players.size() != 2:
		return
	if _transition != null and _transition.is_valid():
		_transition.kill()
	var current := _ambience_players[_ambience_slot]
	var next_slot := 1 - _ambience_slot
	var incoming := _ambience_players[next_slot]
	incoming.stop()
	if stream != null:
		incoming.stream = stream
		incoming.volume_db = SILENCE_DB
		incoming.play()
	_transition = create_tween()
	_transition.set_parallel(true)
	_transition.tween_property(current, "volume_db", SILENCE_DB, maxf(0.05, fade_seconds))
	if stream != null:
		_transition.tween_property(incoming, "volume_db", 0.0, maxf(0.05, fade_seconds))
	_transition.chain().tween_callback(current.stop)
	_ambience_slot = next_slot
