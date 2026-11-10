extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")
const MISDEAL_UI_KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")

@onready var approved_splash: TextureRect = $ApprovedSplash
@onready var status_label: Label = $Status
@onready var start_button: Button = $StartButton

func _ready() -> void:
	# Keep the approved transparent splash hotspot and art intact.
	_setup_save_menu()
	start_button.pressed.connect(_on_start_button_pressed)
	start_button.grab_focus()
	call_deferred("_animate_main_in")


func _animate_main_in() -> void:
	approved_splash.modulate.a = 0.84
	start_button.pivot_offset = start_button.size * 0.5
	start_button.scale = Vector2(0.97, 0.97)
	start_button.modulate.a = 0.0

	var backdrop_tween := approved_splash.create_tween()
	backdrop_tween.tween_property(approved_splash, "modulate:a", 1.0, 0.32)

	var button_tween := start_button.create_tween()
	button_tween.set_parallel(true)
	button_tween.tween_property(start_button, "modulate:a", 1.0, 0.16).set_delay(0.14)
	button_tween.tween_property(start_button, "scale", Vector2.ONE, 0.20).set_delay(0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_start_button_pressed() -> void:
	var service := preload("res://scripts/core/run_save_service.gd").instance()
	if not service.path.is_empty() and FileAccess.file_exists(service.path):
		var dialog := ConfirmationDialog.new()
		dialog.dialog_text = "Начать новую игру? Текущее прохождение будет заменено. Витраж Памяти сохранится."
		add_child(dialog)
		dialog.confirmed.connect(_begin_new_run)
		dialog.popup_centered()
	else:
		_begin_new_run()

func _begin_new_run() -> void:
	var service := preload("res://scripts/core/run_save_service.gd").instance()
	if not service.path.is_empty() and FileAccess.file_exists(service.path):
		if DirAccess.copy_absolute(service.path,service.path+".previous") != OK or DirAccess.remove_absolute(service.path) != OK:
			status_label.text="Не удалось сохранить прежний файл. Новая игра не начата."
			return
	RunState.reset_run()
	SCENE_ROUTER.change_to(self,"res://scenes/intro/intro.tscn")

func _setup_save_menu() -> void:
	start_button.text="НОВАЯ ИГРА"
	start_button.position=Vector2(460,500)
	start_button.size=Vector2(360,48)
	MISDEAL_UI_KIT.apply_action_button(start_button,MISDEAL_UI_KIT.BRONZE,true)
	var service := preload("res://scripts/core/run_save_service.gd").instance()
	var data: Dictionary=service.read_slot(RunState)
	var resume:=Button.new()
	resume.name="ContinueButton"
	resume.text="ПРОДОЛЖИТЬ"
	resume.position=Vector2(460,554)
	resume.size=Vector2(360,48)
	resume.disabled=data.is_empty() or data.get("finished",true)
	add_child(resume)
	MISDEAL_UI_KIT.apply_action_button(resume,MISDEAL_UI_KIT.BRONZE,false)
	resume.pressed.connect(func():
		var current: Dictionary=service.read_slot(RunState)
		if service.apply_slot(RunState,current): SCENE_ROUTER.change_to(self,current.scene)
		else: status_label.text=service.error_message)
	var exit_button:=Button.new()
	exit_button.text="ВЫХОД"
	exit_button.position=Vector2(460,608)
	exit_button.size=Vector2(360,48)
	add_child(exit_button)
	MISDEAL_UI_KIT.apply_action_button(exit_button,MISDEAL_UI_KIT.BRONZE,false)
	exit_button.pressed.connect(func():get_tree().quit())
	status_label.visible=true
	status_label.position=Vector2(300,663)
	status_label.size=Vector2(680,48)
	status_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	status_label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	status_label.text=service.error_message
	if not data.is_empty() and not data.finished:
		status_label.text="%s · Пройдено %d/12 · %s" % [{"knight":"Рыцарь","ranger":"Следопыт","mage":"Маг"}[data.state.protagonist_role],data.state.cards_resolved,data.saved_at.replace("T"," ")]


func _animate_start_commit() -> void:
	start_button.pivot_offset = start_button.size * 0.5
	var tween := start_button.create_tween()
	tween.tween_property(start_button, "scale", Vector2(0.96, 0.94), 0.055).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(start_button, "scale", Vector2(1.04, 1.04), 0.075).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(start_button, "scale", Vector2.ONE, 0.055)
	await tween.finished
