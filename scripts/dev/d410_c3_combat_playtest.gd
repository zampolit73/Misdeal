extends Control

# F6-only launcher. Uses the real Battle, RunState scaling, units and reward
# route; the optional left flank only mirrors this fixture's starting positions.
var party: OptionButton
var flank: CheckBox

func _ready() -> void:
	var panel := PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-320, -240)
	panel.size = Vector2(640, 480)
	add_child(panel)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 18)
	panel.add_child(stack)
	var title := Label.new()
	title.text = "D410 — C3 В НАСТОЯЩЕМ БОЮ"
	title.add_theme_font_size_override("font_size", 25)
	stack.add_child(title)
	var instructions := Label.new()
	instructions.text = "Проверьте осанку и опору при ходьбе, разворот к врагу, оружие при атаке и получении урона. F6 заново — другой герой или направление."
	instructions.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stack.add_child(instructions)
	party = OptionButton.new()
	for label in ["Рыцарь", "Следопыт", "Маг", "Все трое"]:
		party.add_item(label)
	party.select(3)
	stack.add_child(party)
	flank = CheckBox.new()
	flank.text = "Враги слева — проверка первого разворота"
	stack.add_child(flank)
	var launch := Button.new()
	launch.text = "ОТКРЫТЬ БОЙ"
	launch.custom_minimum_size.y = 50
	launch.pressed.connect(_launch)
	stack.add_child(launch)
	var note := Label.new()
	note.text = "Костяной дозор · исходные характеристики и тайминги.\nНажмите «В БОЙ» на настоящем экране подготовки."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stack.add_child(note)

func _launch() -> void:
	var roles := ["knight", "ranger", "mage"]
	var selected := party.selected
	RunState.reset_run()
	RunState.choose_protagonist(roles[selected] if selected < 3 else "knight")
	if selected == 3:
		RunState.recruit_companion("ranger", "D410 F6")
		RunState.recruit_companion("mage", "D410 F6")
	RunState.active_card_id = "bone_patrol"
	RunState.select_encounter("res://resources/encounters/bone_patrol.tres")
	var tree := get_tree()
	# Bind the optional fixture to scene_changed before this launcher is freed.
	if flank.button_pressed:
		tree.scene_changed.connect(_mirror_battle.bind(tree), CONNECT_ONE_SHOT)
	tree.change_scene_to_file("res://scenes/battle/battle.tscn")

static func _mirror_battle(tree: SceneTree) -> void:
	var battle := tree.current_scene
	for actor: BattleUnit in battle.get("units"):
		actor.position.x = 1280.0 - actor.position.x
		# Deployment drag is disabled only in this deliberately reversed fixture;
		# original left-side placement regions must not snap it back across arena.
		actor.disable_placement()
