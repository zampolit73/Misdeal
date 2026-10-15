class_name ThreadTetherController
extends Node2D

# D153 encounter-only mechanic. No edits to global BattleUnit damage handling.
# A live skeletal puppeteer protects nearby bone marionettes with visible threads.
const LINK_RADIUS := 285.0
const LINK_DAMAGE_MULTIPLIER := 0.68

var puppeteer: BattleUnit
var marionettes: Array[BattleUnit] = []
var base_multiplier_by_id: Dictionary = {}
var linked_by_id: Dictionary = {}
var running := false
var connections_made := 0
var connections_broken := 0
var master_death_breaks := 0


func _ready() -> void:
	set_process(false)
	z_index = 1250


func configure(master_unit: BattleUnit, puppet_units: Array[BattleUnit]) -> void:
	stop_threads()
	puppeteer = master_unit
	marionettes = puppet_units.duplicate()
	base_multiplier_by_id.clear()
	linked_by_id.clear()
	for puppet in marionettes:
		if not is_instance_valid(puppet):
			continue
		var key: int = puppet.get_instance_id()
		base_multiplier_by_id[key] = puppet.damage_taken_multiplier
		linked_by_id[key] = false
	if is_instance_valid(puppeteer) and not puppeteer.died.is_connected(_on_master_died):
		puppeteer.died.connect(_on_master_died)


func start_threads() -> void:
	if not is_instance_valid(puppeteer) or not puppeteer.alive:
		return
	running = true
	refresh_links()
	set_process(true)


func stop_threads() -> void:
	running = false
	for puppet in marionettes:
		if is_instance_valid(puppet):
			var key: int = puppet.get_instance_id()
			if bool(linked_by_id.get(key, false)):
				puppet.damage_taken_multiplier = float(base_multiplier_by_id.get(key, 1.0))
				linked_by_id[key] = false
	set_process(false)
	queue_redraw()


func _process(_delta: float) -> void:
	refresh_links()


func refresh_links() -> void:
	if not running:
		return
	var master_active: bool = is_instance_valid(puppeteer) and puppeteer.alive
	for puppet in marionettes:
		if not is_instance_valid(puppet):
			continue
		var key: int = puppet.get_instance_id()
		var close_enough: bool = master_active and puppet.alive and puppet.global_position.distance_squared_to(puppeteer.global_position) <= LINK_RADIUS * LINK_RADIUS
		var was_linked: bool = bool(linked_by_id.get(key, false))
		if close_enough == was_linked:
			continue
		if close_enough:
			puppet.damage_taken_multiplier = float(base_multiplier_by_id.get(key, 1.0)) * LINK_DAMAGE_MULTIPLIER
			linked_by_id[key] = true
			connections_made += 1
		else:
			puppet.damage_taken_multiplier = float(base_multiplier_by_id.get(key, 1.0))
			linked_by_id[key] = false
			connections_broken += 1
	queue_redraw()


func _on_master_died(dead: BattleUnit) -> void:
	if dead != puppeteer or not running:
		return
	master_death_breaks += 1
	# Restores all linked minions immediately, not after their next frame.
	stop_threads()


func is_linked(puppet: BattleUnit) -> bool:
	if not is_instance_valid(puppet):
		return false
	return bool(linked_by_id.get(puppet.get_instance_id(), false))


func _draw() -> void:
	if not running or not is_instance_valid(puppeteer) or not puppeteer.alive:
		return
	var origin: Vector2 = to_local(puppeteer.global_position + Vector2(0.0, -56.0))
	for puppet in marionettes:
		if not is_linked(puppet) or not puppet.alive:
			continue
		var destination: Vector2 = to_local(puppet.global_position + Vector2(0.0, -47.0))
		draw_line(origin, destination, Color(0.14, 0.08, 0.05, 0.91), 4.0, false)
		draw_line(origin, destination, Color(0.78, 0.76, 0.53, 0.93), 1.6, false)
		draw_circle(destination, 3.0, Color(0.90, 0.76, 0.49, 0.94))
