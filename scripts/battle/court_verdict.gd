class_name CourtVerdictController
extends Node2D

# D262 isolated Court of the Mute mechanic: no changes to shared enemy AI.
# Bailiffs receive a temporary target preference ONLY after a clear warning.
# When the scribe dies or the phase ends, normal target selection is restored.
const WARNING_SECONDS := 1.4
const ACTIVE_SECONDS := 2.5
const REST_SECONDS := 3.6
const INITIAL_DELAY := 1.0
const SEAL_HEIGHT := Vector2(0.0, -102.0)
const SCRIBE_QUILL_HEIGHT := Vector2(0.0, -58.0)

var scrivener: BattleUnit
var bailiffs: Array[BattleUnit] = []
var heroes: Array[BattleUnit] = []
var marked_hero: BattleUnit
var affected_bailiffs: Array[BattleUnit] = []
var running := false
var phase := "idle"
var remaining := INITIAL_DELAY
var elapsed_in_phase := 0.0
var warnings := 0
var verdicts := 0
var interrupted := 0
var bailiff_redirects := 0


func _ready() -> void:
	z_index = 1550
	set_process(false)


func configure(scribe: BattleUnit, guard_units: Array[BattleUnit], hero_units: Array[BattleUnit]) -> void:
	stop_verdict()
	scrivener = scribe
	bailiffs = guard_units.duplicate()
	heroes = hero_units.duplicate()
	warnings = 0
	verdicts = 0
	interrupted = 0
	bailiff_redirects = 0
	remaining = INITIAL_DELAY
	if is_instance_valid(scrivener) and not scrivener.died.is_connected(_on_scrivener_died):
		scrivener.died.connect(_on_scrivener_died)


func start_verdict() -> void:
	if not is_instance_valid(scrivener) or not scrivener.alive or bailiffs.is_empty():
		return
	_clear_focus()
	running = true
	phase = "rest"
	remaining = INITIAL_DELAY
	elapsed_in_phase = 0.0
	set_process(true)


func stop_verdict() -> void:
	_clear_focus()
	running = false
	phase = "idle"
	remaining = INITIAL_DELAY
	elapsed_in_phase = 0.0
	set_process(false)
	queue_redraw()


func _exit_tree() -> void:
	stop_verdict()


func _process(delta: float) -> void:
	advance_battle(delta)


# Can be stepped deterministically in a headless 54-case balance matrix.
func advance_battle(delta: float) -> void:
	if not running:
		return
	if not is_instance_valid(scrivener) or not scrivener.alive:
		_on_scrivener_died(scrivener)
		return
	var dt: float = maxf(0.0, delta)
	remaining -= dt
	elapsed_in_phase += dt
	if remaining > 0.0:
		if phase == "active":
			_apply_focus()
		queue_redraw()
		return
	match phase:
		"rest":
			marked_hero = _choose_target()
			if not is_instance_valid(marked_hero):
				stop_verdict()
				return
			phase = "warning"
			remaining = WARNING_SECONDS
			warnings += 1
		"warning":
			if not is_instance_valid(marked_hero) or not marked_hero.alive:
				marked_hero = _choose_target()
			if not is_instance_valid(marked_hero):
				stop_verdict()
				return
			phase = "active"
			remaining = ACTIVE_SECONDS
			verdicts += 1
			_apply_focus()
		"active":
			_clear_focus()
			phase = "rest"
			remaining = REST_SECONDS
	elapsed_in_phase = 0.0
	queue_redraw()


func _choose_target() -> BattleUnit:
	if not is_instance_valid(scrivener):
		return null
	var best: BattleUnit = null
	var shortest := INF
	for hero in heroes:
		if not is_instance_valid(hero) or not hero.alive or hero.team != 0:
			continue
		var distance := scrivener.global_position.distance_squared_to(hero.global_position)
		if distance < shortest:
			shortest = distance
			best = hero
	return best


func _apply_focus() -> void:
	if phase != "active":
		return
	if not is_instance_valid(marked_hero) or not marked_hero.alive:
		_clear_focus()
		return
	for guard in bailiffs:
		if not is_instance_valid(guard) or not guard.alive or guard.team != 1 or guard.visual_role != "bone_bailiff":
			continue
		if guard.target != marked_hero:
			guard.target = marked_hero
			bailiff_redirects += 1
		guard.target_refresh_cooldown = 0.35
		if not affected_bailiffs.has(guard):
			affected_bailiffs.append(guard)


func _clear_focus() -> void:
	for guard in affected_bailiffs:
		if is_instance_valid(guard):
			if guard.target == marked_hero:
				guard.target = null
			guard.target_refresh_cooldown = 0.0
	affected_bailiffs.clear()
	marked_hero = null


func _on_scrivener_died(_dead: BattleUnit) -> void:
	if running:
		interrupted += 1
	stop_verdict()


func _draw() -> void:
	if not running or phase == "rest" or not is_instance_valid(marked_hero):
		return
	if not marked_hero.alive:
		return
	var center := to_local(marked_hero.global_position + SEAL_HEIGHT)
	var pulse := 0.5 + 0.5 * sin(elapsed_in_phase * 8.0)
	var is_active := phase == "active"
	var border := Color(0.98, 0.22, 0.17, 0.91) if is_active else Color(0.95, 0.56, 0.38, 0.63 + pulse * 0.30)
	draw_arc(center, 19.0, 0.0, TAU, 36, border, 2.3, true)
	draw_line(center + Vector2(-12, -12), center + Vector2(12, 12), border, 2.0, true)
	draw_line(center + Vector2(-12, 12), center + Vector2(12, -12), border, 2.0, true)
	draw_circle(center, 3.0, border)
	if phase == "warning" and is_instance_valid(scrivener):
		var quill := to_local(scrivener.global_position + SCRIBE_QUILL_HEIGHT)
		draw_line(quill, center, Color(0.86, 0.21, 0.17, 0.25 + 0.22 * pulse), 1.5, true)
