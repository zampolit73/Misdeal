class_name LaboratoryHazardController
extends Node2D

# D152-only staged controller. Never registered for other encounters.
const WAITING := 0
const WARNING := 1
const ACTIVE := 2
const RADIUS := 66.0
const WARNING_SECONDS := 1.2
const ACTIVE_SECONDS := 2.2
const COOLDOWN_SECONDS := 5.0
const PULSE_SECONDS := 0.65
const PULSE_DAMAGE := 5.0

var alchemist: BattleUnit
var homunculi: Array[BattleUnit] = []
var combat_units: Array[BattleUnit] = []
var zones: Array[Dictionary] = []
var phase := WAITING
var remaining := COOLDOWN_SECONDS
var warnings := 0
var pulses := 0
var spills := 0
var running := false
var _elapsed_pulse := 0.0
var _marked_position := Vector2.ZERO


func _ready() -> void:
	set_process(false)
	z_index = 100


func configure(leader: BattleUnit, minions: Array[BattleUnit], participants: Array[BattleUnit]) -> void:
	stop_hazards()
	alchemist = leader
	homunculi = minions.duplicate()
	combat_units = participants.duplicate()
	for minion in homunculi:
		if is_instance_valid(minion) and not minion.died.is_connected(_on_minion_died):
			minion.died.connect(_on_minion_died)


func start_hazards() -> void:
	if not is_instance_valid(alchemist) or not alchemist.alive:
		return
	running = true
	phase = WAITING
	remaining = COOLDOWN_SECONDS
	set_process(true)


func stop_hazards() -> void:
	running = false
	zones.clear()
	set_process(false)
	queue_redraw()


func _process(delta: float) -> void:
	advance_battle(delta)


func advance_battle(delta: float) -> void:
	if not running:
		return
	var dt := maxf(delta, 0.0)
	for index in range(zones.size() - 1, -1, -1):
		zones[index]["remaining"] = float(zones[index]["remaining"]) - dt
		if float(zones[index]["remaining"]) <= 0.0:
			zones.remove_at(index)
	_elapsed_pulse += dt
	while _elapsed_pulse >= PULSE_SECONDS:
		_elapsed_pulse -= PULSE_SECONDS
		_damage_in_zones()
	if not is_instance_valid(alchemist) or not alchemist.alive:
		phase = WAITING
		queue_redraw()
		return
	remaining -= dt
	if remaining <= 0.0:
		if phase == WAITING:
			_marked_position = _choose_target_position()
			phase = WARNING
			remaining = WARNING_SECONDS
			warnings += 1
		else:
			zones.append({"position": _marked_position, "remaining": ACTIVE_SECONDS})
			phase = WAITING
			remaining = COOLDOWN_SECONDS
	queue_redraw()


func _choose_target_position() -> Vector2:
	for unit in combat_units:
		if is_instance_valid(unit) and unit.alive and unit.team == 0:
			return unit.position
	return alchemist.position


func _on_minion_died(unit: BattleUnit) -> void:
	if not running or not is_instance_valid(unit):
		return
	zones.append({"position": unit.position, "remaining": ACTIVE_SECONDS})
	spills += 1
	queue_redraw()


func _damage_in_zones() -> void:
	for unit in combat_units:
		if not is_instance_valid(unit) or not unit.alive or unit.team != 0:
			continue
		for zone in zones:
			if unit.position.distance_to(zone["position"]) <= RADIUS:
				unit.take_damage(PULSE_DAMAGE, "plague_alchemist", zone["position"])
				pulses += 1
				break


func _draw() -> void:
	for zone in zones:
		draw_circle(zone["position"], RADIUS, Color(0.32, 0.64, 0.17, 0.16))
		draw_arc(zone["position"], RADIUS, 0.0, TAU, 36, Color(0.54, 0.86, 0.21, 0.82), 2.0)
	if running and phase == WARNING and is_instance_valid(alchemist) and alchemist.alive:
		draw_arc(_marked_position, RADIUS, 0.0, TAU, 36, Color(0.94, 0.53, 0.15, 0.95), 3.0)
