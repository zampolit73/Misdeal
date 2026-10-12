extends Control

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")

const APPROVED_CHOICE_ART := preload("res://scripts/ui/approved_choice_art.gd")
const CARD_ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const ARTIFACT_ART_CATALOG := preload("res://scripts/ui/artifact_art_catalog.gd")
const MISDEAL_UI_KIT := preload("res://scripts/ui/misdeal_ui_kit.gd")
const ROLE_FALLBACK_ART := {
	"knight": preload("res://assets/art/units/knight.webp"),
	"ranger": preload("res://assets/art/units/ranger.webp"),
	"mage": preload("res://assets/art/units/mage.webp"),
}

@onready var title_label: Label = $Title
@onready var summary_label: Label = $Summary
@onready var hint_label: Label = $Hint
@onready var run_stats_label: Label = $RunStats
@onready var progress_marks_label: Label = $ProgressMarks
@onready var hover_summary_label: Label = $HoverSummary
@onready var header_panel: Panel = $HeaderPanel
@onready var rewards_root: HBoxContainer = $Rewards
@onready var blood_coin_button: Button = $Rewards/BloodCoin
@onready var iron_ward_button: Button = $Rewards/IronWard
@onready var tempered_steel_button: Button = $Rewards/TemperedSteel

var reward_buttons: Array[Button] = []
var option_ids: Array[String] = ["", "", ""]
var reward_mode := ""
var upgrade_portraits: Array[TextureRect] = []
var upgrade_role_labels: Array[Label] = []
var upgrade_title_labels: Array[Label] = []
var upgrade_description_labels: Array[Label] = []
var upgrade_quick_labels: Array[Label] = []
var upgrade_choose_bars: Array[Panel] = []

func _ready() -> void:
	reward_buttons = [blood_coin_button, iron_ward_button, tempered_steel_button]
	upgrade_portraits = [$Rewards/BloodCoin/Portrait, $Rewards/IronWard/Portrait, $Rewards/TemperedSteel/Portrait]
	upgrade_role_labels = [$Rewards/BloodCoin/Role, $Rewards/IronWard/Role, $Rewards/TemperedSteel/Role]
	upgrade_title_labels = [$Rewards/BloodCoin/UpgradeTitle, $Rewards/IronWard/UpgradeTitle, $Rewards/TemperedSteel/UpgradeTitle]
	upgrade_description_labels = [$Rewards/BloodCoin/UpgradeDescription, $Rewards/IronWard/UpgradeDescription, $Rewards/TemperedSteel/UpgradeDescription]
	upgrade_quick_labels = [$Rewards/BloodCoin/QuickEffect, $Rewards/IronWard/QuickEffect, $Rewards/TemperedSteel/QuickEffect]
	upgrade_choose_bars = [$Rewards/BloodCoin/ChooseBar, $Rewards/IronWard/ChooseBar, $Rewards/TemperedSteel/ChooseBar]
	_apply_ui_kit()
	for index in range(reward_buttons.size()):
		reward_buttons[index].pressed.connect(_on_reward_button_pressed.bind(index))
		reward_buttons[index].mouse_entered.connect(_on_reward_hover.bind(reward_buttons[index], true))
		reward_buttons[index].mouse_exited.connect(_on_reward_hover.bind(reward_buttons[index], false))

	_refresh_run_stats()
	_setup_initial_reward()
	call_deferred("_animate_reward_screen_in")

func _apply_ui_kit() -> void:
	# The F6-approved Fate Spread material layout is now used by Reward.
	# Keep the scene's existing Buttons, child data labels and click signals:
	# only their presentation changes; reward handlers remain untouched.
	$Logo.visible = false
	$Visual.visible = false
	$HudPanel.visible = false
	$WizardBackdrop.modulate = Color.WHITE
	$BackdropShade.color = Color(0.030, 0.013, 0.014, 0.53)
	MISDEAL_UI_KIT.apply_v2_material_plate(header_panel, true)
	header_panel.position = Vector2(167.0, 20.0)
	header_panel.size = Vector2(946.0, 151.0)

	title_label.position = Vector2(211.0, 61.0)
	title_label.size = Vector2(858.0, 43.0)
	title_label.add_theme_font_size_override("font_size", 30)
	MISDEAL_UI_KIT.apply_screen_copy(title_label, MISDEAL_UI_KIT.PARCHMENT_WARM, true)

	summary_label.position = Vector2(211.0, 105.0)
	summary_label.size = Vector2(858.0, 37.0)
	summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	summary_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	summary_label.add_theme_font_size_override("font_size", 15)
	MISDEAL_UI_KIT.apply_screen_copy(summary_label, MISDEAL_UI_KIT.TEXT, false)

	run_stats_label.position = Vector2(211.0, 146.0)
	run_stats_label.size = Vector2(858.0, 22.0)
	run_stats_label.add_theme_font_size_override("font_size", 12)
	MISDEAL_UI_KIT.apply_screen_copy(run_stats_label, MISDEAL_UI_KIT.AGED_BRONZE)

	rewards_root.position = Vector2(174.0, 184.0)
	rewards_root.size = Vector2(932.0, 412.0)
	rewards_root.add_theme_constant_override("separation", 26)

	# This plate uses the unchanged Hint label; dynamic reward-mode advice
	# remains available at the bottom, independent of the cards.
	var footer := Panel.new()
	footer.name = "DS2RewardFooter"
	footer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	footer.position = Vector2(174.0, 608.0)
	footer.size = Vector2(932.0, 87.0)
	add_child(footer)
	MISDEAL_UI_KIT.apply_v2_material_plate(footer, false)
	move_child(footer, hint_label.get_index())

	hint_label.position = Vector2(198.0, 627.0)
	hint_label.size = Vector2(882.0, 48.0)
	hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint_label.add_theme_font_size_override("font_size", 14)
	MISDEAL_UI_KIT.apply_screen_copy(hint_label, MISDEAL_UI_KIT.PARCHMENT_WARM)
	hover_summary_label.visible = false

	for index in range(reward_buttons.size()):
		_build_v2_card_chrome(index)


func _build_v2_card_chrome(index: int) -> void:
	var button := reward_buttons[index]
	button.custom_minimum_size = Vector2(292.0, 410.0)
	button.focus_mode = Control.FOCUS_ALL
	MISDEAL_UI_KIT.apply_v2_reward_card(button, false)
	# Parent Button remains the sole input target; sub-controls ignore mouse.
	var art_frame := Panel.new()
	art_frame.name = "DS2ArtFrame"
	art_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	art_frame.position = Vector2(14.0, 42.0)
	art_frame.size = Vector2(264.0, 183.0)
	button.add_child(art_frame)
	button.move_child(art_frame, 0)
	MISDEAL_UI_KIT.apply_v2_material_plate(art_frame, false)

	var parchment := Panel.new()
	parchment.name = "DS2Parchment"
	parchment.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parchment.clip_contents = true
	parchment.position = Vector2(14.0, 234.0)
	parchment.size = Vector2(264.0, 161.0)
	button.add_child(parchment)
	button.move_child(parchment, 1)
	MISDEAL_UI_KIT.apply_v2_parchment_plate(parchment)

	var rule := ColorRect.new()
	rule.name = "DS2Rule"
	rule.color = Color(0.40, 0.23, 0.13, 0.74)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rule.position = Vector2(38.0, 281.0)
	rule.size = Vector2(216.0, 1.0)
	button.add_child(rule)
	button.move_child(rule, 2)

	var portrait := upgrade_portraits[index]
	portrait.position = Vector2(20.0, 48.0)
	portrait.size = Vector2(252.0, 171.0)
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	var role := upgrade_role_labels[index]
	role.position = Vector2(20.0, 10.0)
	role.size = Vector2(252.0, 25.0)
	role.add_theme_font_size_override("font_size", 13)
	role.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	role.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	role.clip_text = true

	var heading := upgrade_title_labels[index]
	heading.position = Vector2(25.0, 243.0)
	heading.size = Vector2(242.0, 34.0)
	heading.add_theme_font_size_override("font_size", 16)
	heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	heading.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.clip_text = true

	var effect := upgrade_quick_labels[index]
	effect.position = Vector2(26.0, 287.0)
	effect.size = Vector2(240.0, 34.0)
	effect.add_theme_font_size_override("font_size", 12)
	effect.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effect.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	effect.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	effect.clip_text = true

	var description := upgrade_description_labels[index]
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.clip_text = true
	description.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description.add_theme_font_size_override("font_size", 13)
	description.position = Vector2(29.0, 323.0)
	description.size = Vector2(234.0, 63.0)

	# Selection is communicated by the entire antique card border.
	upgrade_choose_bars[index].visible = false


func _style_v2_reward_copy(index: int, effect_text: String = "") -> void:
	var role := upgrade_role_labels[index]
	var heading := upgrade_title_labels[index]
	var effect := upgrade_quick_labels[index]
	var description := upgrade_description_labels[index]

	role.add_theme_color_override("font_color", MISDEAL_UI_KIT.PARCHMENT_WARM)
	heading.add_theme_color_override("font_color", Color(0.18, 0.09, 0.07))
	var long_effect := effect_text.length() > 38
	effect.text = effect_text.replace("  •  ", "\n") if long_effect else effect_text
	effect.visible = not effect_text.is_empty()
	effect.position.y = 281.0 if long_effect else 287.0
	effect.size.y = 48.0 if long_effect else 34.0
	effect.add_theme_font_size_override("font_size", 11 if long_effect else 12)
	effect.add_theme_color_override("font_color", Color(0.43, 0.18, 0.10))
	description.add_theme_color_override("font_color", Color(0.22, 0.16, 0.13))

	# Long upgrades get a three-line effect area, short rewards a
	# larger descriptive area, and relics without an effect get most.
	var has_effect := effect.visible
	description.position.y = 337.0 if long_effect else (323.0 if has_effect else 290.0)
	description.size.y = 50.0 if long_effect else (63.0 if has_effect else 96.0)
	var length := description.text.length()
	var font_size := 13
	if length > 125:
		font_size = 11
	elif length > 90:
		font_size = 12
	description.add_theme_font_size_override("font_size", font_size)
	# Tooltip keeps every character accessible even if translation grows.
	reward_buttons[index].tooltip_text = "%s\n\n%s\n%s" % [
		heading.text, effect_text, description.text
	]
	call_deferred("_fit_v2_reward_copy", index)


func _fit_v2_reward_copy(index: int) -> void:
	if index < 0 or index >= reward_buttons.size():
		return
	var description := upgrade_description_labels[index]
	if not description.visible:
		return
	# Auto-fit after Control's final width has been established. This
	# prevents future longer role/artifact descriptions from clipping.
	for point_size in range(description.get_theme_font_size("font_size"), 9, -1):
		description.add_theme_font_size_override("font_size", point_size)
		if description.get_line_count() * (point_size + 3) <= description.size.y:
			break


func _setup_initial_reward() -> void:
	_refresh_run_stats()
	if RunState.is_major_upgrade_due_for_active_card():
		_setup_major_upgrade_reward()
	else:
		_setup_card_reward()

func _setup_major_upgrade_reward() -> void:
	reward_mode = "major_upgrade"
	_reset_buttons()

	var active_card := RunState.get_active_card()
	var tier_number := 1
	if active_card != null:
		tier_number = active_card.tier + 1

	title_label.text = "РАЗВИТИЕ ОТРЯДА"
	match RunState.get_party_size():
		1:
			summary_label.text = "Вы пока один. Выберите, какой версией себя станете дальше."
			hint_label.text = "Этап %d/3. Все доступные пути принадлежат вашему герою." % tier_number
		2:
			summary_label.text = "Двое пережили этот этап. Выберите, чью судьбу переписать сильнее."
			hint_label.text = "Этап %d/3. Награда предлагает только тех, кто уже в отряде." % tier_number
		_:
			summary_label.text = "Первая победа этого этапа меняет одного героя. Выберите направление билда."
			hint_label.text = "Этап %d/3. Можно снова усиливать того же героя и собирать специализацию." % tier_number

	progress_marks_label.visible = false
	var offers := RunState.get_major_upgrade_offer_ids()
	_setup_upgrade_buttons(offers)

func _setup_bonus_upgrade_reward() -> void:
	reward_mode = "bonus_upgrade"
	_reset_buttons()
	progress_marks_label.visible = false
	title_label.text = "ЕЩЁ ОДНА СТАВКА"
	summary_label.text = "Вместо золота вы выторговали ещё одно изменение отряда."
	hint_label.text = "Это дополнительное улучшение не заменяет развитие этапа."

	var offers := RunState.get_bonus_upgrade_offer_ids()
	if offers.is_empty():
		RunState.gold += 60
		await _finish_reward("Больше менять нечего. Волшебник бросает вам 60 золота.")
		return

	_setup_upgrade_buttons(offers)

func _setup_upgrade_buttons(offers: Array[String]) -> void:
	for index in range(reward_buttons.size()):
		var button := reward_buttons[index]
		if index >= offers.size():
			button.visible = false
			continue

		var upgrade_id := offers[index]
		var upgrade := RunState.get_hero_upgrade(upgrade_id)
		if upgrade == null:
			button.visible = false
			continue

		option_ids[index] = upgrade_id
		_set_upgrade_card(index, upgrade_id, upgrade)
		button.add_theme_color_override("font_color", _get_role_color(upgrade.target_role))
		button.add_theme_color_override("font_hover_color", _get_role_color(upgrade.target_role).lightened(0.16))

func _setup_card_reward() -> void:
	progress_marks_label.visible = false
	hover_summary_label.visible = false
	var active_card := RunState.get_active_card()
	if active_card != null and active_card.card_id == "death_wager":
		_setup_death_wager_reward()
	elif active_card != null and active_card.card_id == "crypt_guard":
		_setup_elite_reward()
	else:
		_setup_normal_loot()

func _setup_normal_loot() -> void:
	reward_mode = "normal_loot"
	_reset_buttons()

	var multiplier := RunState.get_reward_multiplier()
	var amount := 25 * multiplier

	title_label.text = "ДОБЫЧА"
	summary_label.text = "Развитие приходит редко. Золото — чаще."
	hint_label.text = "Золото тратится на событиях и в лавках."
	if multiplier > 1:
		title_label.text = "ДОЛГ ПОГАШЕН"
		summary_label.text = "Волшебник удваивает обычную добычу. На этот раз он держит слово."

	option_ids[0] = "blood_coin"
	var loot_art_key := "gold_windfall" if multiplier > 1 else "blood_coin"
	_set_reward_card(
		0,
		loot_art_key,
		"ДОБЫЧА",
		"ЗАБРАТЬ ТРОФЕИ",
		"+%d золота\nБез вечных +HP и +урона. Только ресурс для следующих решений." % amount
	)
	iron_ward_button.visible = false
	tempered_steel_button.visible = false

func _setup_death_wager_reward() -> void:
	reward_mode = "death_wager"
	_reset_buttons()

	title_label.text = "ВЫИГРЫШ СТАВКИ"
	summary_label.text = "Вы пережили ставку. Теперь выбирайте, чем именно она окупится."
	hint_label.text = "Специальная награда не погашает ДОЛГ ВОЛШЕБНИКУ."
	if RunState.wizard_debt_active:
		summary_label.text += " Долг остаётся до следующей обычной добычи."

	option_ids[0] = "gold"
	_set_reward_card(0, "gold_windfall", "ВЫИГРЫШ", "ЗОЛОТОЙ КУШ", "+60 золота\nСамый безопасный способ забрать выигрыш.")

	var artifacts := RunState.get_available_artifact_ids()
	artifacts.shuffle()
	if artifacts.is_empty():
		option_ids[1] = "fallback_gold"
		_set_reward_card(1, "empty_cache", "СТАВКА", "ПУСТОЙ ТАЙНИК", "+50 золота\nВсе известные реликвии уже у вас.")
	else:
		var artifact_id := artifacts[0]
		var artifact := RunState.get_artifact(artifact_id)
		option_ids[1] = "artifact:%s" % artifact_id
		_set_reward_card(1, artifact_id, "РЕЛИКВИЯ СТАВКИ", artifact.title, artifact.description)

	if RunState.can_claim_extra_hero_upgrade():
		option_ids[2] = "bonus_upgrade"
		_set_reward_card(
			2,
			"bonus_upgrade",
			"СТАВКА",
			"УДВОИТЬ СТАВКУ",
			"Получить ещё один выбор развития героя.\nДоп. развитие: %s" % RunState.get_extra_upgrade_progress_text()
		)
	else:
		option_ids[2] = "extra_cap_gold"
		_set_reward_card(
			2,
			"gold_windfall",
			"ПРЕДЕЛ ДОСТИГНУТ",
			"ЗАБРАТЬ ЗОЛОТО",
			"Доп. развитие %s\n+45 золота вместо усиления" % RunState.get_extra_upgrade_progress_text()
		)

func _setup_elite_reward() -> void:
	reward_mode = "elite_artifact"
	_reset_buttons()

	title_label.text = "ТРОФЕЙ СТРАЖА"
	summary_label.text = "Склеп открыт. Волшебник нехотя позволяет забрать одну реликвию."
	hint_label.text = "Реликвии дополняют билд героя, но не заменяют его развитие."
	if RunState.wizard_debt_active:
		summary_label.text += " Долг остаётся до следующей обычной добычи."

	var available := RunState.get_available_artifact_ids()
	if available.is_empty():
		option_ids[0] = "elite_gold"
		_set_reward_card(0, "empty_cache", "ТРОФЕЙ СТРАЖА", "ОПУСТЕВШИЙ ТАЙНИК", "+50 золота\nВсе известные артефакты уже у вас.")
		iron_ward_button.visible = false
		tempered_steel_button.visible = false
		return

	for index in range(reward_buttons.size()):
		var button := reward_buttons[index]
		if index >= available.size():
			button.visible = false
			continue

		var artifact_id: String = available[index]
		var artifact := RunState.get_artifact(artifact_id)
		if artifact == null:
			button.visible = false
			continue

		option_ids[index] = artifact_id
		_set_reward_card(index, artifact_id, "ЭЛИТНАЯ РЕЛИКВИЯ", artifact.title, artifact.description)

func _on_reward_button_pressed(index: int) -> void:
	if index < 0 or index >= reward_buttons.size():
		return
	if not reward_buttons[index].visible or option_ids[index].is_empty():
		return

	_disable_reward_buttons()
	await _animate_reward_commit(index)
	var option_id := option_ids[index]

	match reward_mode:
		"major_upgrade":
			if not RunState.claim_major_upgrade(option_id):
				_enable_reward_buttons()
				return

			var upgrade := RunState.get_hero_upgrade(option_id)
			summary_label.text = "Выбрано: %s." % upgrade.title
			_refresh_run_stats()
			await get_tree().create_timer(0.22).timeout
			_setup_card_reward()

		"bonus_upgrade":
			if not RunState.claim_bonus_upgrade(option_id):
				_enable_reward_buttons()
				return

			var upgrade := RunState.get_hero_upgrade(option_id)
			await _finish_reward("Ставка изменила героя: %s." % upgrade.title)

		"normal_loot":
			RunState.apply_reward("blood_coin")
			await _finish_reward("Трофеи забраны. Остальное придётся выторговать у стола.")

		"death_wager":
			await _resolve_death_wager_option(option_id)

		"elite_artifact":
			await _resolve_elite_option(option_id)

func _resolve_death_wager_option(option_id: String) -> void:
	match option_id:
		"gold":
			RunState.gold += 60
			RunState.record_wizard_memory("greed", "death_wager")
			await _finish_reward("Ставка оплачена золотом. Волшебник явно жалеет, что предложил её.")
		"fallback_gold":
			RunState.gold += 50
			await _finish_reward("Реликвий не осталось. Вы забираете ещё 50 золота.")
		"bonus_upgrade":
			await get_tree().create_timer(0.18).timeout
			_setup_bonus_upgrade_reward()
		"extra_cap_gold":
			RunState.gold += 45
			await _finish_reward("Новых поблажек не будет. Волшебник бросает 45 золота вместо ещё одного изменения.")
		_:
			if not option_id.begins_with("artifact:"):
				_enable_reward_buttons()
				return

			var artifact_id := option_id.substr("artifact:".length())
			if not RunState.add_artifact(artifact_id):
				_enable_reward_buttons()
				return

			var artifact := RunState.get_artifact(artifact_id)
			await _finish_reward("Ставка оплачена реликвией: %s." % artifact.title)

func _resolve_elite_option(option_id: String) -> void:
	if option_id == "elite_gold":
		RunState.gold += 50
		await _finish_reward("Реликвий больше нет. Зато в тайнике нашлось 50 золота.")
		return

	if not RunState.add_artifact(option_id):
		_enable_reward_buttons()
		return

	var artifact := RunState.get_artifact(option_id)
	await _finish_reward("Трофей ваш: %s." % artifact.title)

func _set_progress_marks(tier_number: int) -> void:
	var marks: Array[String] = []
	for index in range(3):
		marks.append("◆" if index < tier_number else "◇")
	progress_marks_label.text = "   ".join(marks)
	progress_marks_label.visible = true

func _set_upgrade_card(index: int, upgrade_id: String, upgrade: HeroUpgradeData) -> void:
	var button := reward_buttons[index]
	button.text = ""
	_set_upgrade_nodes_visible(index, true)
	var approved_art: Texture2D = CARD_ART_CATALOG.get_upgrade_texture(upgrade_id)
	if approved_art == null:
		approved_art = APPROVED_CHOICE_ART.get_upgrade_texture(upgrade_id)
	if approved_art == null:
		approved_art = ROLE_FALLBACK_ART.get(upgrade.target_role) as Texture2D
	upgrade_portraits[index].texture = approved_art
	upgrade_portraits[index].texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	upgrade_portraits[index].stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	upgrade_portraits[index].visible = approved_art != null
	upgrade_choose_bars[index].visible = false
	_apply_upgrade_text_layout(index, approved_art != null)
	upgrade_role_labels[index].text = _get_role_label(upgrade.target_role)
	upgrade_role_labels[index].add_theme_color_override("font_color", _get_role_color(upgrade.target_role))
	upgrade_title_labels[index].text = upgrade.title
	upgrade_title_labels[index].add_theme_color_override("font_color", _get_role_color(upgrade.target_role).lightened(0.12))
	upgrade_description_labels[index].text = upgrade.description
	_style_v2_reward_copy(index, _get_upgrade_quick_effect(upgrade_id))

func _set_reward_card(index: int, art_key: String, kicker: String, title: String, description: String) -> void:
	var button := reward_buttons[index]
	button.text = ""
	_set_upgrade_nodes_visible(index, true)

	var texture := ARTIFACT_ART_CATALOG.get_texture(art_key)
	if texture == null:
		texture = CARD_ART_CATALOG.get_reward_texture(art_key)
	upgrade_portraits[index].texture = texture
	upgrade_portraits[index].texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	upgrade_portraits[index].stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	upgrade_portraits[index].visible = texture != null

	var accent := Color(0.96, 0.72, 0.42, 1.0)
	upgrade_role_labels[index].text = kicker
	upgrade_role_labels[index].add_theme_color_override("font_color", accent.darkened(0.08))
	upgrade_title_labels[index].text = title
	upgrade_title_labels[index].add_theme_color_override("font_color", accent)
	var detail := description
	var effect := ""
	var separator := description.find("\n")
	if separator >= 0:
		effect = description.substr(0, separator).strip_edges()
		detail = description.substr(separator + 1).strip_edges()
	upgrade_description_labels[index].text = detail
	_style_v2_reward_copy(index, effect)
	upgrade_choose_bars[index].visible = false

func _set_upgrade_nodes_visible(index: int, visible: bool) -> void:
	upgrade_portraits[index].visible = visible
	upgrade_role_labels[index].visible = visible
	upgrade_title_labels[index].visible = visible
	upgrade_description_labels[index].visible = visible
	upgrade_quick_labels[index].visible = false
	upgrade_choose_bars[index].visible = visible

func _get_upgrade_quick_effect(upgrade_id: String) -> String:
	match upgrade_id:
		"knight_iron_oath":
			return "+65 HP  •  −15% СКОРОСТЬ АТАКИ"
		"knight_executioner":
			return "+45% УРОН  •  −30 HP"
		"knight_cleaver":
			return "45% СПЛЭШ  •  −12% СКОРОСТЬ АТАКИ"
		"ranger_longshot":
			return "+30% УРОН  •  +ДАЛЬНОСТЬ  •  −18% ТЕМП"
		"ranger_arrowstorm":
			return "+38% ТЕМП  •  −22% УРОН СТРЕЛЫ"
		"ranger_beast_trail":
			return "+35% ДВИЖЕНИЕ  •  +10% ТЕМП  •  −15 HP"
		"mage_glass_heart":
			return "+65% УРОН  •  −35 HP"
		"mage_overload":
			return "+35% ТЕМП  •  −12% УРОН  •  −15% ДВИЖЕНИЕ"
		"mage_wildfire":
			return "+ШИРОКИЙ ВЗРЫВ  •  +ПОБОЧНЫЙ УРОН  •  −18% ОСНОВНОЙ"
		_:
			return "ПЕРЕПИСЫВАЕТ БИЛД ГЕРОЯ"

func _apply_upgrade_text_layout(index: int, has_approved_art: bool) -> void:
	# Keep identical card geometry for normal loot, upgrades and wagers.
	upgrade_role_labels[index].position.y = 10.0
	upgrade_title_labels[index].position.y = 243.0
	upgrade_description_labels[index].position.y = 323.0

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

func _get_role_color(role: String) -> Color:
	match role:
		"knight":
			return Color(0.72, 0.84, 0.98, 1.0)
		"ranger":
			return Color(0.66, 0.90, 0.58, 1.0)
		"mage":
			return Color(0.86, 0.66, 1.0, 1.0)
		_:
			return Color(0.94, 0.82, 0.62, 1.0)

func _refresh_run_stats() -> void:
	run_stats_label.text = "%s   |   ЗОЛОТО %d   |   ОТРЯД %d/3   |   РАЗВИТИЕ %d   |   РЕЛИКВИИ %d" % [
		RunState.get_progress_text(),
		RunState.gold,
		RunState.get_party_size(),
		RunState.hero_upgrade_ids.size(),
		RunState.artifact_ids.size()
	]

func _animate_reward_screen_in() -> void:
	header_panel.pivot_offset = header_panel.size * 0.5
	header_panel.scale = Vector2(0.985, 0.985)
	header_panel.modulate.a = 0.0

	var header_tween := header_panel.create_tween()
	header_tween.set_parallel(true)
	header_tween.tween_property(header_panel, "scale", Vector2.ONE, 0.20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	header_tween.tween_property(header_panel, "modulate:a", 1.0, 0.16)

	var visible_index := 0
	for button in reward_buttons:
		if not button.visible:
			continue
		button.pivot_offset = button.size * 0.5
		button.scale = Vector2(0.975, 0.975)
		button.modulate.a = 0.0

		var card_tween := button.create_tween()
		card_tween.set_parallel(true)
		var delay := 0.06 + float(visible_index) * 0.06
		card_tween.tween_property(button, "scale", Vector2.ONE, 0.20).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		card_tween.tween_property(button, "modulate:a", 1.0, 0.16).set_delay(delay)
		visible_index += 1


func _animate_reward_commit(selected_index: int) -> void:
	if selected_index < 0 or selected_index >= reward_buttons.size():
		return

	var selected := reward_buttons[selected_index]
	if not selected.visible:
		return

	for index in range(reward_buttons.size()):
		var button := reward_buttons[index]
		if not button.visible:
			continue
		button.pivot_offset = button.size * 0.5
		var tween := button.create_tween()
		tween.set_parallel(true)
		if index == selected_index:
			button.z_index = 20
			tween.tween_property(button, "scale", Vector2(1.045, 1.045), 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_property(button, "modulate", Color(1.10, 1.00, 0.88, 1.0), 0.13)
			var portrait := upgrade_portraits[index]
			if portrait != null and portrait.visible:
				var portrait_tween := portrait.create_tween()
				portrait_tween.tween_property(portrait, "modulate", Color(1.16, 1.06, 0.90, 1.0), 0.08)
				portrait_tween.tween_property(portrait, "modulate", Color.WHITE, 0.16)
		else:
			button.z_index = 0
			tween.tween_property(button, "scale", Vector2(0.985, 0.985), 0.14)
			tween.tween_property(button, "modulate", Color(0.42, 0.40, 0.44, 0.58), 0.14)

	var choose_bar := upgrade_choose_bars[selected_index]
	if choose_bar != null and choose_bar.visible:
		choose_bar.pivot_offset = choose_bar.size * 0.5
		var bar_tween := choose_bar.create_tween()
		bar_tween.tween_property(choose_bar, "scale", Vector2(1.04, 0.94), 0.07).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		bar_tween.tween_property(choose_bar, "scale", Vector2.ONE, 0.10).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	await get_tree().create_timer(0.18).timeout


func _on_reward_hover(button: Button, hovered: bool) -> void:
	if button.disabled or not button.visible:
		return

	button.pivot_offset = button.size * 0.5
	var tween := button.create_tween()
	tween.tween_property(button, "scale", Vector2(1.025, 1.025) if hovered else Vector2.ONE, 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	hover_summary_label.visible = false

func _reset_buttons() -> void:
	option_ids = ["", "", ""]
	hover_summary_label.visible = false
	for index in range(reward_buttons.size()):
		var button := reward_buttons[index]
		button.visible = true
		button.disabled = false
		button.scale = Vector2.ONE
		button.modulate = Color.WHITE
		button.z_index = 0
		button.remove_meta("quick_effect")
		button.remove_theme_color_override("font_color")
		button.remove_theme_color_override("font_hover_color")
		button.tooltip_text = ""
		MISDEAL_UI_KIT.apply_v2_reward_card(button, false)
		_set_upgrade_nodes_visible(index, false)

func _enable_reward_buttons() -> void:
	for button in reward_buttons:
		if button.visible:
			button.disabled = false

func _disable_reward_buttons() -> void:
	for button in reward_buttons:
		button.disabled = true

func _finish_reward(message: String) -> void:
	_refresh_run_stats()
	RunState.complete_active_card()
	summary_label.text = message
	await get_tree().create_timer(0.22).timeout

	if RunState.is_run_complete():
		SCENE_ROUTER.change_to(self, "res://scenes/run_end/run_end.tscn")
	else:
		SCENE_ROUTER.change_to(self, "res://scenes/table/table.tscn")
