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

	_refresh_choice_text()

func _refresh_choice_text() -> void:
	gold_label.text = "Золото: %d   |   Развитие: %d   |   Реликвии: %d" % [
		RunState.gold,
		RunState.hero_upgrade_ids.size(),
		RunState.artifact_ids.size()
	]

	var gift_role := "mage"
	if RunState.get_next_available_hero_upgrade_id(gift_role).is_empty():
		gift_role = RunState.get_least_developed_available_role()

	if gift_role.is_empty():
		accept_button.text = "ПРИНЯТЬ ДАР\n\nКолодцу больше нечего изменить"
		accept_button.disabled = true
	else:
		var upgrade_id := RunState.get_next_available_hero_upgrade_id(gift_role)
		var upgrade := RunState.get_hero_upgrade(upgrade_id)
		accept_button.text = "ПРИНЯТЬ ДАР\n\n-15 здоровья отряду\n%s: %s" % [
			_get_role_label(gift_role),
			upgrade.title
		]

	var has_artifact := not RunState.get_available_artifact_ids().is_empty()
	var fallback_role := RunState.get_least_developed_available_role()
	pay_button.disabled = RunState.gold < 25 or (not has_artifact and fallback_role.is_empty())

	if has_artifact:
		pay_button.text = "БРОСИТЬ 25 ЗОЛОТА\n\nКолодец отдаст случайную реликвию"
	elif not fallback_role.is_empty():
		var fallback_id := RunState.get_next_available_hero_upgrade_id(fallback_role)
		var fallback_upgrade := RunState.get_hero_upgrade(fallback_id)
		pay_button.text = "БРОСИТЬ 25 ЗОЛОТА\n\nРеликвий не осталось\n%s: %s" % [
			_get_role_label(fallback_role),
			fallback_upgrade.title
		]
	else:
		pay_button.text = "БРОСИТЬ 25 ЗОЛОТА\n\nКолодец молчит"

func _on_accept_gift() -> void:
	if accept_button.disabled:
		return

	var role := "mage"
	if RunState.get_next_available_hero_upgrade_id(role).is_empty():
		role = RunState.get_least_developed_available_role()
	if role.is_empty():
		return

	var upgrade_id := RunState.add_next_available_hero_upgrade(role)
	if upgrade_id.is_empty():
		return

	_disable_choices()
	RunState.party_hp_bonus -= 15.0
	RunState.resolve_whispering_well()

	var upgrade := RunState.get_hero_upgrade(upgrade_id)
	result_label.text = "Вода обжигает горло. Здоровье отряда -15.\n%s получает развитие: %s." % [
		_get_role_label(role),
		upgrade.title
	]
	await get_tree().create_timer(0.8).timeout
	_return_to_table()

func _on_pay_coin() -> void:
	if pay_button.disabled or RunState.gold < 25:
		return

	_disable_choices()
	RunState.gold -= 25

	var artifact_id := RunState.add_random_available_artifact()
	if artifact_id.is_empty():
		var upgrade_id := RunState.add_upgrade_to_least_developed_role()
		if upgrade_id.is_empty():
			RunState.gold += 25
			result_label.text = "Монета возвращается на край колодца. Ему больше нечего предложить."
		else:
			var upgrade := RunState.get_hero_upgrade(upgrade_id)
			result_label.text = "Монета исчезает. Вместо реликвии вода переписывает героя.\n%s получает развитие: %s." % [
				_get_role_label(upgrade.target_role),
				upgrade.title
			]
	else:
		var artifact := RunState.get_artifact(artifact_id)
		result_label.text = "Монета исчезает без всплеска. Со дна всплывает реликвия: %s." % artifact.title

	RunState.resolve_whispering_well()
	await get_tree().create_timer(0.8).timeout
	_return_to_table()

func _on_leave() -> void:
	_disable_choices()
	RunState.resolve_whispering_well()
	result_label.text = "Ты отходишь от края. Волшебник тихо смеётся."
	await get_tree().create_timer(0.65).timeout
	_return_to_table()

func _get_role_label(role: String) -> String:
	match role:
		"knight":
			return "РЫЦАРЬ"
		"ranger":
			return "СЛЕДОПЫТ"
		"mage":
			return "МАГ"
		_:
			return "ГЕРОЙ"

func _disable_choices() -> void:
	accept_button.disabled = true
	pay_button.disabled = true
	leave_button.disabled = true

func _return_to_table() -> void:
	RunState.complete_active_card()
	get_tree().change_scene_to_file("res://scenes/table/table.tscn")
