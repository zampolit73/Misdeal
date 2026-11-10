extends CanvasLayer
const SAVE := preload("res://scripts/core/run_save_service.gd")
const KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")
const ROUTER := preload("res://scripts/core/scene_router.gd")
var menu: Control
var timer := 0.0
var last_signature := ""
var status: Label

func _ready() -> void:
	layer=100
	process_mode=Node.PROCESS_MODE_ALWAYS

func safe_scene() -> String:
	var scene := get_tree().current_scene
	if scene == null: return ""
	var path := scene.scene_file_path
	if path==SAVE.TABLE:
		if scene.get("selection_locked") or scene.get("deal_in_progress"): return ""
		return path
	if path==SAVE.REWARD:
		for button in scene.get("reward_buttons"):
			if not button.disabled: return path
	if path=="res://scenes/event/act_choice.tscn" and scene.get("resolved"):
		return SAVE.TABLE
	if path=="res://scenes/run_end/run_end.tscn": return SAVE.TABLE
	return ""

func checkpoint() -> bool:
	var path := safe_scene()
	if path.is_empty(): return false
	var phase := ""
	if path==SAVE.REWARD: phase=str(get_tree().current_scene.get("reward_mode"))
	var ok: bool=SAVE.instance().write_slot(RunState,path,phase)
	if ok: last_signature = signature()
	return ok

func signature() -> String:
	return var_to_bytes(SAVE.instance().snapshot(RunState,safe_scene())).hex_encode()

func _process(delta: float) -> void:
	if get_tree().paused: return
	timer+=delta
	if timer<0.5: return
	timer=0
	if safe_scene().is_empty() or not RunState.has_chosen_protagonist(): return
	# Time is excluded from the change detector.
	var data: Dictionary=SAVE.instance().snapshot(RunState,safe_scene())
	data.erase("saved_at")
	var key:=var_to_bytes(data).hex_encode()
	if key!=last_signature and checkpoint(): last_signature=key

func _unhandled_key_input(event: InputEvent) -> void:
	if not(event is InputEventKey and event.pressed and not event.echo and event.keycode==KEY_ESCAPE): return
	var scene:=get_tree().current_scene
	if scene==null or scene.scene_file_path.contains("/main/") or scene.scene_file_path.contains("/intro/"): return
	if is_instance_valid(menu):
		close_menu()
	else:
		# Existing modal owners always close before the pause menu can open.
		for key in ["card_lore_inspect","fate_spread_overlay","squad_status","_details"]:
			var modal: Variant=scene.get(key)
			if is_instance_valid(modal):
				if modal.has_method("close"): modal.close()
				else: modal.queue_free()
				get_viewport().set_input_as_handled()
				return
		open_menu()
	get_viewport().set_input_as_handled()

func open_menu() -> void:
	menu=Control.new()
	menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(menu)
	var shade:=ColorRect.new()
	shade.color=Color(0,0,0,0.8)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu.add_child(shade)
	var panel:=Panel.new()
	panel.position=Vector2(390,140)
	panel.size=Vector2(500,440)
	menu.add_child(panel)
	KIT.apply_panel(panel,KIT.BRONZE,true)
	var column:=VBoxContainer.new()
	column.position=Vector2(420,165)
	column.size=Vector2(440,390)
	column.add_theme_constant_override("separation",12)
	menu.add_child(column)
	status=Label.new()
	status.text="ПАУЗА\nВ бою загрузка вернёт к контрольной точке."
	if not SAVE.instance().error_message.is_empty(): status.text=SAVE.instance().error_message
	status.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	column.add_child(status)
	for entry in [["Продолжить игру",close_menu],["Сохранить",save_now],["Загрузить игру",load_now],["Сохранить и выйти",save_exit],["В главное меню",main_menu]]:
		var button:=Button.new()
		button.text=entry[0]
		button.custom_minimum_size.y=42
		column.add_child(button)
		KIT.apply_action_button(button,KIT.BRONZE,false)
		button.pressed.connect(entry[1])
		if entry[0] in ["Сохранить","Сохранить и выйти"]: button.disabled=safe_scene().is_empty()
	get_tree().paused=true

func close_menu() -> void:
	get_tree().paused=false
	if is_instance_valid(menu): menu.queue_free()
	menu=null

func save_now() -> void:
	status.text="Сохранено." if checkpoint() else SAVE.instance().error_message

func save_exit() -> void:
	if checkpoint(): get_tree().quit()
	else: status.text=SAVE.instance().error_message

func load_now() -> void:
	var data: Dictionary=SAVE.instance().read_slot(RunState)
	if data.is_empty() or data.finished or not SAVE.instance().apply_slot(RunState,data):
		status.text=SAVE.instance().error_message if not SAVE.instance().error_message.is_empty() else "Нет незавершённого сохранения."
		return
	close_menu()
	ROUTER.change_to(self,data.scene)

func main_menu() -> void:
	var confirm:=ConfirmationDialog.new()
	confirm.dialog_text="Вернуться в меню? Изменения после последней контрольной точки будут потеряны."
	menu.add_child(confirm)
	confirm.confirmed.connect(func():
		close_menu()
		ROUTER.change_to(self,"res://scenes/main/main.tscn"))
	confirm.popup_centered()
