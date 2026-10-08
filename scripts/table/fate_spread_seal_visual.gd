extends Control

# Decorative/live occult spread under the historical cards. Geometry mirrors
# the FateSpreadOverlay slot layout so the path reads like a physical ritual
# laid onto the Wizard's table rather than a generic progress bar.

const CENTER := Vector2(390.0, 270.0)
const RADIUS := Vector2(286.0, 176.0)
const SLOT_COUNT := 12

const DIM_LINE := Color(0.30, 0.11, 0.10, 0.24)
const DIM_NODE := Color(0.34, 0.18, 0.16, 0.34)
const GOLD := Color(0.84, 0.46, 0.18, 0.78)
const EMBER := Color(0.95, 0.20, 0.08, 0.92)
const BLOOD := Color(0.55, 0.035, 0.025, 0.30)


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()


func refresh() -> void:
	queue_redraw()


func _draw() -> void:
	var resolved: int = clampi(RunState.cards_resolved, 0, SLOT_COUNT)
	var chapter: int = mini(3, int(resolved / 4))

	_draw_outer_thread(resolved)
	_draw_chapter_marks()
	_draw_center_sigil(resolved, chapter)
	_draw_inward_threads(resolved)


func _draw_outer_thread(resolved: int) -> void:
	var points := PackedVector2Array()
	for index in range(SLOT_COUNT):
		points.append(_slot_center(index))
	points.append(points[0])

	# Entire fate-thread exists from the start, but stays almost buried in the
	# table until the run actually writes history onto it.
	draw_polyline(points, DIM_LINE, 1.4, true)

	if resolved <= 0:
		return

	var completed := PackedVector2Array()
	for index in range(mini(resolved, SLOT_COUNT)):
		completed.append(_slot_center(index))
	if resolved < SLOT_COUNT:
		completed.append(_slot_center(resolved))
	elif completed.size() > 0:
		completed.append(_slot_center(0))

	if completed.size() >= 2:
		draw_polyline(completed, GOLD, 2.2, true)
		draw_polyline(completed, Color(0.96, 0.20, 0.07, 0.24), 5.0, true)


func _draw_chapter_marks() -> void:
	for index in range(SLOT_COUNT):
		var p := _slot_center(index)
		var is_gate: bool = index == 3 or index == 7 or index == 11
		var radius: float = 5.0 if is_gate else 2.6
		var color := Color(0.52, 0.27, 0.17, 0.52) if is_gate else DIM_NODE
		draw_circle(p, radius, color, false, 1.2)
		if is_gate:
			draw_circle(p, radius + 5.0, Color(color.r, color.g, color.b, 0.17), false, 1.0)
			var tangent := Vector2(-(p - CENTER).y, (p - CENTER).x).normalized()
			draw_line(p - tangent * 9.0, p + tangent * 9.0, Color(0.72, 0.34, 0.18, 0.36), 1.0, true)


func _draw_center_sigil(resolved: int, chapter: int) -> void:
	var progress: float = float(resolved) / float(SLOT_COUNT)
	var ember_alpha: float = 0.20 + progress * 0.48
	var core := Color(EMBER.r, EMBER.g, EMBER.b, ember_alpha)

	# Soft blood stain / ritual heat behind XIII.
	draw_circle(CENTER, 122.0, Color(BLOOD.r, BLOOD.g, BLOOD.b, 0.08 + progress * 0.10))
	draw_circle(CENTER, 108.0, Color(0.26, 0.035, 0.028, 0.08 + progress * 0.08), false, 2.0)
	draw_circle(CENTER, 88.0, Color(core.r, core.g, core.b, 0.16), false, 1.6)
	draw_circle(CENTER, 60.0, Color(core.r, core.g, core.b, 0.22), false, 1.2)

	# Twelve restrained ritual rays. Completed quarters burn brighter.
	for index in range(SLOT_COUNT):
		var angle := deg_to_rad(-90.0 + float(index) * 30.0)
		var direction := Vector2(cos(angle), sin(angle))
		var inner := CENTER + direction * 58.0
		var outer := CENTER + direction * (102.0 if index % 3 == 0 else 91.0)
		var ray_color := Color(0.52, 0.12, 0.08, 0.18)
		if index < resolved:
			ray_color = Color(0.90, 0.30, 0.10, 0.30 + 0.05 * float(chapter))
		draw_line(inner, outer, ray_color, 1.0 if index % 3 != 0 else 1.6, true)

	# Central diamond/cross motif, close to the approved reference rather than
	# a generic magic circle.
	var diamond_radius: float = 36.0
	var diamond := PackedVector2Array([
		CENTER + Vector2(0.0, -diamond_radius),
		CENTER + Vector2(diamond_radius, 0.0),
		CENTER + Vector2(0.0, diamond_radius),
		CENTER + Vector2(-diamond_radius, 0.0),
		CENTER + Vector2(0.0, -diamond_radius),
	])
	draw_polyline(diamond, Color(core.r, core.g, core.b, 0.34), 1.3, true)
	draw_line(CENTER + Vector2(-49.0, 0.0), CENTER + Vector2(49.0, 0.0), Color(core.r, core.g, core.b, 0.22), 1.0, true)
	draw_line(CENTER + Vector2(0.0, -49.0), CENTER + Vector2(0.0, 49.0), Color(core.r, core.g, core.b, 0.22), 1.0, true)

	# Progress burns around the inner seal in three four-card chapters.
	for index in range(resolved):
		var start_angle := deg_to_rad(-90.0 + float(index) * 30.0 + 2.5)
		var end_angle := deg_to_rad(-90.0 + float(index + 1) * 30.0 - 2.5)
		var segment_color := GOLD if index < 4 else Color(0.90, 0.27, 0.10, 0.84)
		if index >= 8:
			segment_color = Color(1.0, 0.18, 0.07, 0.96)
		draw_arc(CENTER, 112.0, start_angle, end_angle, 10, segment_color, 2.5, true)


func _draw_inward_threads(resolved: int) -> void:
	# The current path slowly tightens toward XIII; future spokes remain almost
	# invisible, matching the reference's "fate converges on the center" read.
	for index in range(SLOT_COUNT):
		var p := _slot_center(index)
		var direction := (CENTER - p).normalized()
		var from_point := p + direction * 48.0
		var to_point := CENTER - direction * 126.0
		var color := Color(0.38, 0.10, 0.075, 0.08)
		if index < resolved:
			color = Color(0.78, 0.20, 0.08, 0.16)
		draw_line(from_point, to_point, color, 1.0, true)


func _slot_center(index: int) -> Vector2:
	var angle := deg_to_rad(-90.0 + float(index) * 30.0)
	return CENTER + Vector2(cos(angle) * RADIUS.x, sin(angle) * RADIUS.y)
