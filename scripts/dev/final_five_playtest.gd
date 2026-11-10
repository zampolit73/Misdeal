extends Control
const EVENTS := preload("res://scripts/event/final_five_events.gd")
var party: OptionButton
var wallet: SpinBox
var debt: CheckBox
func _ready() -> void:
	var layout := VBoxContainer.new()
	layout.position=Vector2(220,70)
	layout.size=Vector2(840,580)
	layout.add_theme_constant_override("separation",16)
	add_child(layout)
	var title := Label.new()
	title.text="ПЯТЬ ИСТОРИЙ ОСАДЫ — F6 / QA"
	title.add_theme_font_size_override("font_size",28)
	layout.add_child(title)
	party=OptionButton.new()
	for label in ["Рыцарь — solo","Рыцарь + Следопыт — duo","Все герои — trio"]: party.add_item(label)
	layout.add_child(party)
	wallet=SpinBox.new()
	wallet.prefix="Золото: "
	wallet.max_value=200
	wallet.value=50
	layout.add_child(wallet)
	debt=CheckBox.new()
	debt.text="Долг Волшебника активен"
	layout.add_child(debt)
	for id in EVENTS.IDS:
		var button := Button.new()
		button.text=RunState.get_card(id).title
		button.custom_minimum_size.y=50
		button.pressed.connect(_open.bind(id))
		layout.add_child(button)

func _open(id: String) -> void:
	var count := party.selected+1
	RunState.reset_run()
	RunState.choose_protagonist("knight")
	if count>=2: RunState.recruit_companion("ranger","QA")
	if count>=3: RunState.recruit_companion("mage","QA")
	RunState.gold=int(wallet.value)
	RunState.wizard_debt_active=debt.button_pressed
	RunState.cards_resolved=RunState.get_card(id).tier*4
	RunState.fate_spread_last_milestone_shown=12
	RunState.wizard_wager_slots.clear()
	RunState.wizard_mark_slots.clear()
	RunState.wizard_meddling_slots.clear()
	RunState.current_offer_ids.assign([id,"bone_patrol"])
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")
