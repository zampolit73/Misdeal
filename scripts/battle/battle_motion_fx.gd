extends Control

const ORDER_ASSAULT := "assault"
const ORDER_HUNT := "hunt"
const ORDER_FORMATION := "formation"
const ORDER_SACRIFICE := "sacrifice"
const ORDER_DEFIANCE := "defiance"

@onready var units_layer: Node2D = get_parent().get_node("UnitsLayer")
@onready var assault_button: Button = get_parent().get_node("AssaultOrderButton")
@onready var hunt_button: Button = get_parent().get_node("HuntOrderButton")
@onready var formation_button: Button = get_parent().get_node("FormationOrderButton")
@onready var sacrifice_button: Button = get_parent().get_node("SacrificeOrderButton")
@onready var defiance_button: Button = get_parent().get_node("DefianceOrderButton")
@onready var fight_button: Button = get_parent().get_node("FightButton")

var selected_order := ORDER_ASSAULT
var order_pulse := 0.0:
	set(value):
		order_pulse = value
		queue_redraw()

var combat_committed := false
var death_wager_mode := false
var ambient_time := 0.0
var redraw_accum := 0.0
var order_tween: Tween


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	assault_button.pressed.connect(_on_order_pressed.bind(ORDER_ASSAULT))
	hunt_button.pressed.connect(_on_order_pressed.bind(ORDER_HUNT))
	formation_button.pressed.connect(_on_order_pressed.bind(ORDER_FORMATION))
	sacrifice_button.pressed.connect(_on_order_pressed.bind(ORDER_SACRIFICE))
	defiance_button.pressed.connect(_on_order_pressed.bind(ORDER_DEFIANCE))
	fight_button.pressed.connect(_on_fight_pressed)
	call_deferred("_sync_initial_state")


func _process(delta: float) -> void:
	ambient_time += delta
	redraw_accum += delta
	if redraw_accum >= 0.05:
		redraw_accum = 0.0
		if order_pulse > 0.001 or death_wager_mode or (
			combat_committed and selected_order in [ORDER_SACRIFICE, ORDER_DEFIANCE]
		):
			queue_redraw()


func _sync_initial_state() -> void:
	if assault_button.button_pressed:
		selected_order = ORDER_ASSAULT
	elif hunt_button.button_pressed:
		selected_order = ORDER_HUNT
	elif formation_button.button_pressed:
		selected_order = ORDER_FORMATION
	elif sacrifice_button.button_pressed:
		selected_order = ORDER_SACRIFICE
	elif defiance_button.button_pressed:
		selected_order = ORDER_DEFIANCE

	var encounter = get_parent().get("encounter")
	if encounter != null:
		death_wager_mode = String(encounter.get("encounter_id")) == "death_wager"
	queue_redraw()


func _on_order_pressed(order_id: String) -> void:
	selected_order = order_id
	combat_committed = false
	_play_order_pulse()


func _on_fight_pressed() -> void:
	combat_committed = true
	_play_order_pulse(1.0)


func _play_order_pulse(strength: float = 1.0) -> void:
	if order_tween != null and order_tween.is_valid():
		order_tween.kill()
	order_pulse = strength
	order_tween = create_tween()
	order_tween.tween_property(self, "order_pulse", 0.0, 0.38).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _draw() -> void:
	if death_wager_mode:
		_draw_death_wager_frame()

	var persistent_special := combat_committed and selected_order in [ORDER_SACRIFICE, ORDER_DEFIANCE]
	if order_pulse <= 0.001 and not persistent_special:
		return

	var base_alpha := 0.10 if persistent_special else 0.0
	var pulse_alpha := order_pulse * 0.82
	var alpha := clampf(base_alpha + pulse_alpha, 0.0, 0.92)
	var breathe := 0.5 + 0.5 * sin(ambient_time * 3.0)

	for node in get_tree().get_nodes_in_group("combat_units"):
		if not node is BattleUnit:
			continue
		var unit := node as BattleUnit
		if not unit.alive or unit.team != 0:
			continue

		var unit_pos := units_layer.position + unit.position
		_draw_order_marker(unit_pos + Vector2(0.0, -78.0), selected_order, alpha)

		if selected_order == ORDER_SACRIFICE:
			var aura_alpha := (0.035 + breathe * 0.018) if persistent_special else order_pulse * 0.10
			draw_circle(unit_pos + Vector2(0.0, 20.0), 34.0 + order_pulse * 4.0, Color(0.92, 0.12, 0.06, aura_alpha), false, 2.0, true)
		elif selected_order == ORDER_DEFIANCE:
			var aura_alpha := (0.035 + breathe * 0.015) if persistent_special else order_pulse * 0.09
			draw_circle(unit_pos + Vector2(0.0, 20.0), 34.0 + order_pulse * 4.0, Color(0.28, 0.66, 1.0, aura_alpha), false, 2.0, true)


func _draw_order_marker(pos: Vector2, order_id: String, alpha: float) -> void:
	match order_id:
		ORDER_HUNT:
			var color := Color(0.90, 0.70, 0.34, alpha)
			draw_circle(pos, 8.0, color, false, 1.6, true)
			draw_line(pos + Vector2(-12.0, 0.0), pos + Vector2(12.0, 0.0), color, 1.4, true)
			draw_line(pos + Vector2(0.0, -12.0), pos + Vector2(0.0, 12.0), color, 1.4, true)
		ORDER_FORMATION:
			var color := Color(0.54, 0.78, 1.0, alpha)
			var shield := PackedVector2Array([
				pos + Vector2(0.0, -11.0),
				pos + Vector2(10.0, -6.0),
				pos + Vector2(8.0, 7.0),
				pos + Vector2(0.0, 13.0),
				pos + Vector2(-8.0, 7.0),
				pos + Vector2(-10.0, -6.0),
				pos + Vector2(0.0, -11.0),
			])
			draw_polyline(shield, color, 1.8, true)
		ORDER_SACRIFICE:
			var color := Color(1.0, 0.28, 0.14, alpha)
			var diamond := PackedVector2Array([
				pos + Vector2(0.0, -12.0),
				pos + Vector2(9.0, 0.0),
				pos + Vector2(0.0, 12.0),
				pos + Vector2(-9.0, 0.0),
				pos + Vector2(0.0, -12.0),
			])
			draw_polyline(diamond, color, 2.0, true)
			draw_line(pos + Vector2(0.0, -7.0), pos + Vector2(0.0, 7.0), color, 1.6, true)
		ORDER_DEFIANCE:
			var color := Color(0.42, 0.80, 1.0, alpha)
			draw_arc(pos, 10.0, PI * 0.10, PI * 0.90, 18, color, 2.0, true)
			draw_line(pos + Vector2(-9.0, 3.0), pos + Vector2(0.0, 12.0), color, 2.0, true)
			draw_line(pos + Vector2(0.0, 12.0), pos + Vector2(9.0, 3.0), color, 2.0, true)
		_:
			var color := Color(1.0, 0.56, 0.26, alpha)
			draw_line(pos + Vector2(-10.0, 7.0), pos + Vector2(8.0, -8.0), color, 2.0, true)
			draw_line(pos + Vector2(2.0, -8.0), pos + Vector2(8.0, -8.0), color, 2.0, true)
			draw_line(pos + Vector2(8.0, -8.0), pos + Vector2(8.0, -2.0), color, 2.0, true)


func _draw_death_wager_frame() -> void:
	var breathe := 0.5 + 0.5 * sin(ambient_time * 2.1)
	var alpha := 0.035 + breathe * 0.018
	var color := Color(0.92, 0.08, 0.05, alpha)

	draw_line(Vector2(22.0, 112.0), Vector2(160.0, 112.0), color, 2.0, true)
	draw_line(Vector2(22.0, 112.0), Vector2(22.0, 210.0), color, 2.0, true)
	draw_line(Vector2(size.x - 22.0, 112.0), Vector2(size.x - 160.0, 112.0), color, 2.0, true)
	draw_line(Vector2(size.x - 22.0, 112.0), Vector2(size.x - 22.0, 210.0), color, 2.0, true)
