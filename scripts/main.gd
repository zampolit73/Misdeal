extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")
const SYSTEM_DIALOG := preload("res://scripts/ui/system_dialog.gd")
const ARCHIVE := preload("res://scripts/core/wizard_archive.gd")
const MENU_TYPE := preload("res://scripts/class_select/class_select_card_skin.gd")
const PRIMARY := preload("res://assets/pixel/main/menu_v2/primary.webp")
const SECONDARY := preload("res://assets/pixel/main/menu_v2/secondary.webp")
const INACTIVE := preload("res://assets/pixel/main/menu_v2/disabled.webp")
const BONE := Color("ddc1a5")

@onready var approved_splash: TextureRect = $ApprovedSplash
@onready var status_label: Label = $Status
@onready var start_button: Button = $StartButton
var _menu_buttons: Array[Button] = []

func _ready() -> void:
	_setup_save_menu()
	$Tagline.add_theme_font_override("font", MENU_TYPE.heading_font())
	$Tagline.add_theme_font_size_override("font_size", 19)
	$Tagline.add_theme_color_override("font_color", BONE)
	start_button.pressed.connect(_on_start_button_pressed)
	start_button.grab_focus()
	call_deferred("_animate_main_in")


func _animate_main_in() -> void:
	var tween := create_tween().set_parallel()
	for item in [approved_splash, $Logo, $Tagline, status_label]:
		item.modulate.a = 0.0
		tween.tween_property(item, "modulate:a", 1.0, 0.30)
	for index in _menu_buttons.size():
		var button := _menu_buttons[index]
		button.modulate.a = 0.0
		tween.tween_property(button, "modulate:a", 1.0, 0.20).set_delay(0.08 + 0.035 * index)


func _on_start_button_pressed() -> void:
	var service := preload("res://scripts/core/run_save_service.gd").instance()
	if (not service.path.is_empty() and FileAccess.file_exists(service.path)) or not preload("res://scripts/memory/memory_profile.gd").instance().unlocked.is_empty():
		if get_node_or_null("SystemDialog") != null:
			return
		var dialog := SYSTEM_DIALOG.new()
		dialog.name = "SystemDialog"
		add_child(dialog)
		dialog.present_new_game(_begin_new_run)
	else:
		_begin_new_run()

func _begin_new_run(reset_memory: bool = true) -> void:
	var service := preload("res://scripts/core/run_save_service.gd").instance()
	if not service.prepare_new_game(reset_memory):
		status_label.text=service.error_message
		return
	RunState.reset_run()
	SCENE_ROUTER.change_to(self,"res://scenes/intro/intro.tscn")

func _setup_save_menu() -> void:
	start_button.text="НОВАЯ ИГРА"
	_style_menu_button(start_button, 280, PRIMARY)
	var archive := Button.new()
	archive.name = "WizardArchiveButton"
	archive.text = "АРХИВ ВОЛШЕБНИКА"
	add_child(archive)
	archive.pressed.connect(func() -> void:
		SCENE_ROUTER.change_to(self, "res://scenes/archive/wizard_archive.tscn"))
	var service := preload("res://scripts/core/run_save_service.gd").instance()
	var data: Dictionary=service.read_slot(RunState)
	if not data.is_empty() and data.finished:
		ARCHIVE.instance().observe_checkpoint(data.state, data.memory_run, data.saved_at)
	var resume:=Button.new()
	resume.name="ContinueButton"
	resume.text="ПРОДОЛЖИТЬ"
	resume.disabled=data.is_empty() or data.get("finished",true)
	add_child(resume)
	_style_menu_button(resume, 363, SECONDARY)
	move_child(resume, archive.get_index())
	_style_menu_button(archive, 440, SECONDARY)
	resume.pressed.connect(func():
		var current: Dictionary=service.read_slot(RunState)
		if service.apply_slot(RunState,current): SCENE_ROUTER.change_to(self,current.scene)
		else: status_label.text=service.error_message)
	var exit_button:=Button.new()
	exit_button.name = "ExitButton"
	exit_button.text="ВЫХОД"
	add_child(exit_button)
	_style_menu_button(exit_button, 520, SECONDARY)
	exit_button.pressed.connect(func():get_tree().quit())
	var enabled := _menu_buttons.filter(func(button: Button) -> bool: return not button.disabled)
	for index in enabled.size():
		var button: Button = enabled[index]
		var previous := button.get_path_to(enabled[posmod(index - 1, enabled.size())])
		var next := button.get_path_to(enabled[(index + 1) % enabled.size()])
		button.focus_neighbor_top = previous
		button.focus_neighbor_bottom = next
		button.focus_previous = previous
		button.focus_next = next
	status_label.visible=true
	status_label.position=Vector2(80,590)
	status_label.size=Vector2(327,55)
	status_label.add_theme_color_override("font_color", BONE)
	status_label.add_theme_font_size_override("font_size", 13)
	status_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	status_label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	status_label.text=service.error_message
	if not data.is_empty() and not data.finished:
		status_label.text="%s · Пройдено %d/12 · %s" % [{"knight":"Рыцарь","ranger":"Следопыт","mage":"Маг"}[data.state.protagonist_role],data.state.cards_resolved,data.saved_at.replace("T"," ")]


func _style_menu_button(button: Button, y: float, plate: Texture2D) -> void:
	button.position = Vector2(80, y)
	button.size = Vector2(327, 63)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.focus_mode = Control.FOCUS_NONE if button.disabled else Control.FOCUS_ALL
	button.add_theme_font_override("font", MENU_TYPE.heading_font())
	button.add_theme_font_size_override("font_size", 25)
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		button.add_theme_color_override(state, BONE)
	button.add_theme_color_override("font_disabled_color", Color("92857b"))
	for state in ["normal", "hover", "pressed", "hover_pressed", "disabled"]:
		var style := StyleBoxTexture.new()
		style.texture = INACTIVE if state == "disabled" else plate
		if state == "hover":
			style.modulate_color = Color(1.10, 1.07, 1.04)
		elif state in ["pressed", "hover_pressed"]:
			style.modulate_color = Color("d4bfb3")
		button.add_theme_stylebox_override(state, style)
	var focus := StyleBoxFlat.new()
	focus.draw_center = false
	focus.border_color = Color("a5856d90")
	focus.set_border_width_all(1)
	focus.set_corner_radius_all(5)
	focus.set_expand_margin_all(-10)
	button.add_theme_stylebox_override("focus", focus)
	_menu_buttons.append(button)
