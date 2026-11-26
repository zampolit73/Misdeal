extends Panel
## Combat HUD Visual V1: only presentation. The planning view supplies current
## executor snapshots and transition text; this panel never advances a plan.

const SKIN := preload("res://scripts/battle/planning/battle_plan_skin.gd")
const FRAME_PATH := "res://assets/pixel/ui/combat_hud_v1/orders_frame.webp"
const WIDTH := 414.0
const ROW_TOP := 15.0
const ROW_HEIGHT := 24.0
const MAX_ROWS := 3
const BOTTOM := 9.0
const NOTICE_LINE := 18.0
const BONE := Color("ead1a5")
const TIMER := Color("e9b877")

var _role_font: Font
var _stage_font: Font
var _rows: Array[Control] = []
var _icons: Array[Control] = []
var _names: Array[Label] = []
var _stages: Array[Label] = []
var _tactics: Array[Label] = []
var _timers: Array[Label] = []
var _rules: Array[ColorRect] = []
var notice_panel: Panel
var notice_label: Label

func build() -> void:
	name = "ActiveOrdersHud"
	position = Vector2(838, 156)
	size = Vector2(WIDTH, ROW_TOP + ROW_HEIGHT * MAX_ROWS + BOTTOM)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_role_font = SKIN.serif()
	_stage_font = SKIN.serif(true)
	var frame_tex := load(FRAME_PATH) as Texture2D
	if frame_tex == null:
		# Cold editor imports must not break the live planner.
		frame_tex = SKIN.slice(SKIN.DOSSIER, Rect2(7, 8, 754, 497))
	add_theme_stylebox_override("panel", SKIN.textured(frame_tex, 17))

	var heading := Panel.new()
	heading.name = "HeadingPlate"
	heading.mouse_filter = Control.MOUSE_FILTER_IGNORE
	heading.add_theme_stylebox_override("panel",
		SKIN.textured(SKIN.slice(SKIN.BATTLE_RED, SKIN.RED_PLATE), 9, Color(0.70, 0.60, 0.53)))
	add_child(heading)
	_place(heading, Rect2(94, -10, 226, 25))
	var caption := _label(heading, "Heading", Rect2(5, 0, 216, 25), 16, BONE, _role_font)
	caption.text = "АКТИВНЫЕ ПРИКАЗЫ"
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	for i in MAX_ROWS:
		var row := Control.new()
		row.name = "OrderRow%d" % (i + 1)
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(row)
		_place(row, Rect2(15, ROW_TOP + i * ROW_HEIGHT, WIDTH - 30, ROW_HEIGHT))
		_rows.append(row)

		var icon := Control.new()
		icon.name = "RoleEmblem"
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.set_meta("role", "knight")
		row.add_child(icon)
		_place(icon, Rect2(0, 0, 30, 30))
		icon.scale = Vector2(0.77, 0.77)
		icon.draw.connect(_draw_emblem.bind(icon))
		_icons.append(icon)

		_names.append(_label(row, "Hero", Rect2(32, 0, 115, 24), 16, BONE, _role_font))
		var stage := _label(row, "Stage", Rect2(157, 0, 35, 24), 16, BONE, _stage_font)
		stage.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_stages.append(stage)
		_tactics.append(_label(row, "Tactic", Rect2(200, 0, 101, 24), 16, BONE, _role_font))
		var timer := _label(row, "Remaining", Rect2(302, 0, 79, 24), 16, TIMER, _role_font)
		timer.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		_timers.append(timer)
		_rule(row, "ColumnRule", Rect2(149, 5, 1, 14))
		_rules.append(_rule(row, "RowRule", Rect2(0, 23, WIDTH - 30, 1)))

	notice_panel = Panel.new()
	notice_panel.name = "TransitionPlate"
	notice_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# A quiet thin plate keeps the reason legible even with three simultaneous
	# transitions; the ornamental frame is reserved for the main readout.
	var notice_style := StyleBoxFlat.new()
	notice_style.bg_color = Color("140f0c")
	notice_style.border_color = Color("8a603b")
	notice_style.set_border_width_all(1)
	notice_style.set_corner_radius_all(2)
	notice_panel.add_theme_stylebox_override("panel", notice_style)
	add_child(notice_panel)
	notice_label = _label(notice_panel, "TransitionText", Rect2(8, 2, WIDTH - 28, 18), 14, TIMER, _role_font)
	notice_panel.hide()
	hide()


func present_rows(rows: Array[Dictionary]) -> void:
	var count := mini(rows.size(), MAX_ROWS)
	for i in MAX_ROWS:
		var visible_row := i < count
		_rows[i].visible = visible_row
		_rules[i].visible = visible_row and i < count - 1
		if not visible_row:
			continue
		var data := rows[i]
		var role: String = data.role
		if _icons[i].get_meta("role") != role:
			_icons[i].set_meta("role", role)
			_icons[i].queue_redraw()
		_names[i].text = data.hero
		_stages[i].text = data.stage
		_tactics[i].text = data.tactic
		_timers[i].text = data.remaining
	size.y = ROW_TOP + count * ROW_HEIGHT + BOTTOM
	notice_panel.position = Vector2(7, size.y + 4)
	if count == 0:
		hide()


func present_transition(value: String, active: bool) -> void:
	notice_panel.visible = active and not value.is_empty()
	if not notice_panel.visible:
		return
	if notice_label.text != value:
		notice_label.text = value
		var line_count := value.split("\n", false).size()
		# All authored transition reasons fit in the full-width notice.
		# Preserve simultaneous changes rather than clipping the last row.
		var point := 14
		var width := WIDTH - 28
		for line in value.split("\n", false):
			while point > 11 and _role_font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, point).x > width:
				point -= 1
		notice_label.add_theme_font_size_override("font_size", point)
		notice_label.size = Vector2(width, NOTICE_LINE * line_count)
		notice_panel.size = Vector2(WIDTH - 14, NOTICE_LINE * line_count + 4)


func _draw_emblem(icon: Control) -> void:
	SKIN.emblem(icon, icon.get_meta("role"))


func _place(item: Control, bounds: Rect2) -> void:
	item.position = bounds.position
	item.size = bounds.size


func _label(parent: Control, node_name: String, bounds: Rect2, point: int, color: Color, font: Font) -> Label:
	var item := Label.new()
	item.name = node_name
	item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	item.clip_text = true
	item.add_theme_font_override("font", font)
	item.add_theme_font_size_override("font_size", point)
	item.add_theme_color_override("font_color", color)
	parent.add_child(item)
	_place(item, bounds)
	return item


func _rule(parent: Control, node_name: String, bounds: Rect2) -> ColorRect:
	var line := ColorRect.new()
	line.name = node_name
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	line.color = Color(0.64, 0.43, 0.24, 0.65)
	parent.add_child(line)
	_place(line, bounds)
	return line
