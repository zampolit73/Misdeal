extends Control

@onready var gold_label: Label = $GoldLabel
@onready var result_label: Label = $Result
@onready var accept_button: Button = $Choices/AcceptGift
@onready var pay_button: Button = $Choices/PayCoin
@onready var leave_button: Button = $Choices/Leave

func _ready() -> void:
	accept_button.pressed.connect(_on_accept_gift)
	pay_button.pressed.connect(_on_pay_coin)
	leave_button.pressed.connect(_on_leave)

	gold_label.text = "Золото: %d" % RunState.gold
	pay_button.disabled = RunState.gold < 25

	if pay_button.disabled:
		pay_button.text = "БРОСИТЬ 25 ЗОЛОТА\n\nНедостаточно золота"

func _on_accept_gift() -> void:
	_disable_choices()
	RunState.party_damage_bonus += 4.0
	RunState.party_hp_bonus -= 15.0
	RunState.resolve_whispering_well()
	result_label.text = "Вода обжигает горло. Сила приходит вместе с холодом.\nУрон отряда +4. Здоровье отряда -15."
	await get_tree().create_timer(0.8).timeout
	_return_to_table()

func _on_pay_coin() -> void:
	if RunState.gold < 25:
		return

	_disable_choices()
	RunState.gold -= 25
	RunState.party_hp_bonus += 25.0
	RunState.resolve_whispering_well()
	result_label.text = "Монета исчезает без всплеска. Колодец отвечает.\nЗдоровье отряда +25."
	await get_tree().create_timer(0.8).timeout
	_return_to_table()

func _on_leave() -> void:
	_disable_choices()
	RunState.resolve_whispering_well()
	result_label.text = "Ты отходишь от края. Волшебник тихо смеётся."
	await get_tree().create_timer(0.65).timeout
	_return_to_table()

func _disable_choices() -> void:
	accept_button.disabled = true
	pay_button.disabled = true
	leave_button.disabled = true

func _return_to_table() -> void:
	RunState.complete_active_card()
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")
