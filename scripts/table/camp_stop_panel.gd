extends Control

signal finished(message: String)

const STOPS := preload("res://scripts/core/run_camp_stops.gd")
const SAVE := preload("res://scripts/core/run_save_service.gd")
const BUILD := preload("res://scripts/ui/run_build_feedback.gd")

const REST_VIEW := preload("res://scripts/table/camp_rest_view.gd")
const MERCHANT_VIEW := preload("res://scripts/table/merchant_view.gd")

var _shop: bool
var _merchant: MERCHANT_VIEW
var _message: Label
var _action_buttons: Array[Button] = []


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	z_index = 100
	_shop = RunState.camp_stop.slot == STOPS.SHOP_SLOT
	if _shop:
		_merchant = MERCHANT_VIEW.new()
		add_child(_merchant)
		_merchant.action_requested.connect(_choose)
		_merchant.build(_title(), _intro())
		_message = _merchant.message
		_action_buttons = _merchant.refresh()
		return
	var rest := REST_VIEW.new()
	add_child(rest)
	rest.action_requested.connect(_choose)
	rest.build(_title(), _intro())
	_message = rest.message
	_action_buttons = rest.action_buttons


func _title() -> String:
	if _shop: return "ТОРГОВЕЦ У ВОРОТ"
	return "ПЕРВЫЙ ПРИВАЛ" if RunState.camp_stop.slot == 4 else "ПОСЛЕДНЯЯ ПОДГОТОВКА"


func _intro() -> String:
	if _shop: return "После VIII · Запасы торговца ограничены. Покупки можно пропустить."
	return "После %s · Одна возможность перед возвращением к столу." % ("IV" if RunState.camp_stop.slot == 4 else "XII")


func _choose(action: String) -> void:
	if RunState.camp_stop.is_empty():
		return
	var save := SAVE.instance()
	var previous: Dictionary = save.snapshot(RunState).state
	var before := BUILD.capture(RunState)
	var next_relic := ""
	if action.begins_with("relic/"):
		next_relic = action.get_slice("/", 1)
	elif action == "rite" and not RunState.camp_stop.stock.is_empty():
		next_relic = String(RunState.camp_stop.stock[0]).get_slice("/", 1)
	if not STOPS.apply(RunState, action):
		return
	if not save.write_slot(RunState):
		save.restore_values(RunState, previous)
		_message.text = save.error_message
		return
	var after := BUILD.capture(RunState)
	var delta := BUILD.changes(before, after, 1)
	if not next_relic.is_empty():
		var artifact := RunState.get_artifact(next_relic)
		if delta.is_empty(): delta = artifact.title + " · " + artifact.description
	if RunState.camp_stop.is_empty():
		var message := "Торговец закрыл свою лавку." if _shop else "Привал закончился. Волшебник раздаёт карты."
		finished.emit(delta if not delta.is_empty() else message)
		queue_free()
	else:
		_message.text = "Осталось %d золота." % RunState.gold
		if not delta.is_empty(): _message.text += " " + delta
		_message.tooltip_text = BUILD.changes(before, after)
		_action_buttons = _merchant.refresh()
