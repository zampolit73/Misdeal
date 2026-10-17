extends Control

# D209: selected original forest art + actual lanternlight geometry.
# Strictly visual QA: no combat, stats, game route, or original sprite activation.
const LIGHT_SCRIPT := preload("res://scripts/battle/black_lantern_light.gd")
const ENCOUNTER: EncounterData = preload("res://resources/encounters/black_lantern_road.tres")
const EXPECTED_SIZE := Vector2i(1280, 720)
const UNIT_LAYER_OFFSET := Vector2(20.0, 96.0)
const FOOT_OFFSET := Vector2(0.0, 36.0)
const LOCAL_FLOOR := Rect2(Vector2(90.0, 284.0), Vector2(1080.0, 158.0))
const HERO_SOURCES: Array[Vector2] = [Vector2(185, 195), Vector2(335, 280), Vector2(490, 370)]

@onready var backdrop: TextureRect = $BattleBackdrop
@onready var proxy_markers: Node2D = $ProxyMarkers

var lamp_light: BlackLanternLightController
var elapsed: float = 0.0
var paused: bool = false
var phase_label: Label
var pause_button: Button
var floor_button: Button

func _ready() -> void:
	if not backdrop.has_method("set_arena_id"):
		_show_failure("Отсутствует загрузчик утверждённых арен.")
		return
	backdrop.call("set_arena_id", "black_lantern_road")
	var art: Texture2D = backdrop.texture
	if art == null or art.get_size() != Vector2(1280, 720):
		_show_failure("Утверждённый лесной фон не загрузился в разрешении 1280×720.")
		return
	if ENCOUNTER.enemy_unit_paths.size() != 5 or ENCOUNTER.get_formation_count() != 2:
		_show_failure("Ресурсы пяти скелетов / двух расстановок не найдены.")
		return
	if RunState.ACT1_CARD_IDS.has("black_lantern_road"):
		_show_failure("Карта №38 неожиданно оказалась в обычной колоде.")
		return

	var heroes: Array[Vector2] = []
	for source in HERO_SOURCES:
		heroes.append(_screen_foot(source))
	var enemies: Array[Vector2] = []
	var starts: PackedVector2Array = ENCOUNTER.get_enemy_positions_for_formation(0)
	for source in starts:
		enemies.append(_screen_foot(source))
	proxy_markers.call("configure", heroes, enemies)

	lamp_light = LIGHT_SCRIPT.new() as BlackLanternLightController
	lamp_light.position = UNIT_LAYER_OFFSET
	add_child(lamp_light)
	lamp_light.running = true # Deliberately render the scoped controller without units.
	lamp_light.elapsed = elapsed
	lamp_light.set_process(false)
	lamp_light.queue_redraw()

	var top := _label("D209 / ДОРОГА ЧЁРНЫХ ФОНАРЕЙ • АРЕНА", Vector2(85, 16), Vector2(1110, 42), 24)
	top.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	phase_label = _label("", Vector2(90, 69), Vector2(1100, 36), 19)
	phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var footer := _label(
		"QA-МАКЕТ: синие контуры — герои, бронзовые — пять НОВЫХ скелетов, большой — Проводник.\n"
		+ "Контуры НЕ являются одобренными спрайтами. Фон — именно выбранный третий лес. Боевой эффект НЕ включён.",
		Vector2(110, 599), Vector2(1060, 80), 15
	)
	footer.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_button = _button("ПАУЗА", Vector2(1110, 31), Vector2(135, 36))
	pause_button.pressed.connect(_toggle_pause)
	floor_button = _button("ПОКАЗАТЬ ПОЛ", Vector2(26, 31), Vector2(170, 36))
	floor_button.pressed.connect(_toggle_floor)
	_update_phase()
	set_process(true)
	print("D209 selected Black Lantern forest arena: verified 1280x720 source art; QA only.")

func _screen_foot(source: Vector2) -> Vector2:
	# Mirrors Battle._project_spawn_on_floor exactly: old authored Y -> walkable road.
	var depth: float = clampf((source.y - 130.0) / 275.0, 0.0, 1.0)
	var y: float = lerpf(LOCAL_FLOOR.position.y + 32.0, LOCAL_FLOOR.end.y - 32.0, depth)
	return Vector2(source.x, y) + UNIT_LAYER_OFFSET + FOOT_OFFSET

func _label(value: String, at: Vector2, dimensions: Vector2, font_size: int) -> Label:
	var element := Label.new()
	element.text = value
	element.position = at
	element.size = dimensions
	element.z_index = 200
	element.add_theme_font_size_override("font_size", font_size)
	element.add_theme_color_override("font_color", Color(0.96, 0.88, 0.76))
	element.add_theme_color_override("font_shadow_color", Color(0.02, 0.02, 0.03, 0.98))
	element.add_theme_constant_override("shadow_offset_x", 2)
	element.add_theme_constant_override("shadow_offset_y", 2)
	add_child(element)
	return element

func _button(caption: String, at: Vector2, dimensions: Vector2) -> Button:
	var element := Button.new()
	element.text = caption
	element.position = at
	element.size = dimensions
	element.z_index = 200
	add_child(element)
	return element

func _show_failure(message: String) -> void:
	_label("D209 / QA FAIL: " + message, Vector2(80, 300), Vector2(1120, 105), 23)
	push_error(message)

func _toggle_pause() -> void:
	paused = not paused
	pause_button.text = "ПРОДОЛЖИТЬ" if paused else "ПАУЗА"

func _toggle_floor() -> void:
	var now_visible: bool = bool(proxy_markers.get("show_floor_guide"))
	proxy_markers.set("show_floor_guide", not now_visible)
	proxy_markers.queue_redraw()
	floor_button.text = "СКРЫТЬ ПОЛ" if not now_visible else "ПОКАЗАТЬ ПОЛ"

func _process(delta: float) -> void:
	if paused or lamp_light == null:
		return
	elapsed += delta
	lamp_light.elapsed = elapsed
	lamp_light.queue_redraw()
	_update_phase()

func _update_phase() -> void:
	var phase: String = lamp_light.get_phase()
	var elapsed_in_cycle: float = fposmod(elapsed, BlackLanternLightController.CYCLE_SECONDS)
	match phase:
		"warning":
			phase_label.text = "ПРЕДУПРЕЖДЕНИЕ • %.1f с до света" % (BlackLanternLightController.WARNING_SECONDS - elapsed_in_cycle)
		"active":
			phase_label.text = "СВЕТ ДВИЖЕТСЯ • %.1f с" % (BlackLanternLightController.WARNING_SECONDS + BlackLanternLightController.ACTIVE_SECONDS - elapsed_in_cycle)
		_:
			phase_label.text = "ТЬМА • %.1f с до нового предупреждения" % (BlackLanternLightController.CYCLE_SECONDS - elapsed_in_cycle)
