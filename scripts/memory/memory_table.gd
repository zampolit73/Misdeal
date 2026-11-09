extends Control
const PROFILE := preload("res://scripts/memory/memory_profile.gd")
const VIEWER := preload("res://scripts/memory/memory_viewer.gd")
const KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")
var viewer: Control
var button: Button

func _ready() -> void:
	name = "MemoryTable"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	button = Button.new()
	button.position = Vector2(1100,80)
	button.size = Vector2(160,32)
	button.text = "ПАМЯТЬ [M] %d/24" % PROFILE.instance().unlocked.size()
	button.pressed.connect(open_viewer)
	add_child(button)
	KIT.apply_action_button(button,KIT.BRONZE,false)
	# Narrow architectural glints, confined to background beside the hood.
	for x in [310,950]:
		var aperture := Control.new()
		aperture.position = Vector2(x,140)
		aperture.size = Vector2(14,105)
		aperture.clip_contents = true
		aperture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(aperture)
		var strip := TextureRect.new()
		strip.position = Vector2(0 if x == 310 else -236,-50)
		strip.size = Vector2(250,312.4)
		strip.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		strip.texture = load("res://assets/story/a1v2/approved_vitrazh_memory.png") as Texture2D
		var strength: float = 0.08 + 0.22*PROFILE.instance().unlocked.size()/24.0
		strip.modulate = Color(0.3,0.3,0.3,strength)
		strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		aperture.add_child(strip)
	if PROFILE.instance().pending > 0:
		button.text = "НОВАЯ ПАМЯТЬ [M]"
		PROFILE.instance().pending = 0

func open_viewer() -> void:
	var table := get_parent()
	if is_instance_valid(viewer) or table.get("selection_locked") or table.get("deal_in_progress"):
		return
	if is_instance_valid(table.get("fate_spread_overlay")) or is_instance_valid(table.get("squad_status")) or is_instance_valid(table.get("card_lore_inspect")) or table.get_node("WagerOverlay/Root").visible:
		return
	viewer = VIEWER.new()
	table.add_child(viewer)
	table.set_process_input(false)
	viewer.tree_exited.connect(func():
		if is_instance_valid(table):
			table.set_process_input(true)
			button.grab_focus())

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_M:
		open_viewer()
		get_viewport().set_input_as_handled()
