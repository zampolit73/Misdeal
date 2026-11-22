extends Control

const BUILD_FEEDBACK := preload("res://scripts/ui/run_build_feedback.gd")

const FINAL_FIVE := preload("res://scripts/event/final_five_events.gd")

const SCENE_ROUTER := preload("res://scripts/core/scene_router.gd")
const CASTLE_MEMORY_TEXT := preload("res://scripts/story/act1_castle_memory_text.gd")

const CARD_ART_CATALOG := preload("res://scripts/ui/card_art_catalog.gd")
const CARD_UNIFICATION_V1 := preload("res://scripts/ui/card_unification_v1.gd")
const ARTIFACT_ART_CATALOG := preload("res://scripts/ui/artifact_art_catalog.gd")
const APPROVED_EVENT_CHOICE_ART := preload("res://scripts/ui/approved_event_choice_art.gd")
const CHOICE_VIEW := preload("res://scripts/ui/event_choice_presentation.gd")
const CHOICE_COPY := preload("res://scripts/event/event_choice_copy.gd")
const EVENT_SCENE_ART_PATHS := {
	"curse_forge": "res://assets/pixel/event/v7/curse_forge.webp",
	"chained_prisoner": "res://assets/pixel/event/v7/chained_prisoner.webp",
	"black_altar": "res://assets/pixel/event/v7/black_altar.webp",
	"faceless_card": "res://assets/pixel/event/v8/faceless_card.webp",
	"blood_ledger": "res://assets/pixel/event/v8/blood_ledger.webp",
	"gravedigger_shop": "res://assets/pixel/event/v8/gravedigger_shop.webp",
	"candle_seller": "res://assets/pixel/event/v8/candle_seller.webp",
	"broken_crown": "res://assets/pixel/event/v9/broken_crown.webp",
	"last_camp": "res://assets/pixel/event/v9/last_camp.webp",
	"ash_rest": "res://assets/pixel/event/v9/ash_rest.webp",
	"wizard_tithe": "res://assets/pixel/event/v9/wizard_tithe.webp",
	"bone_tax": "res://assets/pixel/event/v9/bone_tax.webp",
	"debtor_bones": "res://assets/pixel/event/v9/debtor_bones.webp",
	"lost_purse": "res://assets/pixel/event/v9/lost_purse.webp",
	"rattling_bridge": "res://assets/pixel/event/v9/rattling_bridge.webp",
}

@onready var title_label: Label = $Panel/Title
@onready var description_label: Label = $Panel/Description
@onready var wizard_line: Label = $Panel/WizardLine
@onready var gold_label: Label = $Panel/Gold
@onready var artifacts_label: Label = $Panel/Artifacts
@onready var choice_a: Button = $Panel/Choices/ChoiceA
@onready var choice_b: Button = $Panel/Choices/ChoiceB
@onready var choice_c: Button = $Panel/Choices/ChoiceC
@onready var leave_button: Button = $Panel/LeaveButton
@onready var result_label: Label = $Panel/Result
@onready var continue_button: Button = $Panel/ContinueButton
@onready var panel: Panel = $Panel
@onready var screen_visual: Control = $Visual
@onready var backdrop: TextureRect = $WizardBackdrop
@onready var feature_scene_art: TextureRect = $FeatureSceneArt
@onready var choice_art_a: TextureRect = $Panel/Choices/ChoiceA/ChoiceArt
@onready var choice_art_b: TextureRect = $Panel/Choices/ChoiceB/ChoiceArt
@onready var choice_art_c: TextureRect = $Panel/Choices/ChoiceC/ChoiceArt

var active_card: RunCardData
var resolved := false
var travel_context: Dictionary = {}
var presentation_choice_role := ""
var presentation_action := ""
var presentation_roll_success: Variant = null
var presentation_recruitment := false
var resolving_leave := false
var returning := false
var _entry_gold := 0
var _entry_hp := 0.0
var _entry_relics := 0
var _entry_build: Dictionary
var choice_view: CHOICE_VIEW

func _ready() -> void:
	active_card = RunState.get_active_card()
	if active_card == null:
		push_warning("Act choice scene opened without an active run card.")
		SCENE_ROUTER.after_resolution(self, travel_context)
		return

	choice_view = CHOICE_VIEW.new()
	add_child(choice_view)
	choice_view.track([choice_a, choice_b, choice_c, leave_button])
	continue_button.pressed.connect(_return_to_table)
	leave_button.pressed.connect(_resolve_leave)

	title_label.text = active_card.title
	description_label.text = FINAL_FIVE.SCENES.get(active_card.card_id, active_card.card_text)
	wizard_line.text = active_card.wizard_line
	_entry_gold = RunState.gold
	_entry_hp = RunState.party_hp_bonus - RunState.get_total_rescue_scar_hp_penalty()
	_entry_relics = RunState.artifact_ids.size()
	_entry_build = BUILD_FEEDBACK.capture(RunState)
	_refresh_run_labels()
	_configure_card()
	_apply_castle_memory_hint()
	_apply_approved_choice_art()
	_apply_event_backdrop()
	_build_choice_view()


func _build_choice_view() -> void:
	panel.position = Vector2.ZERO
	panel.size = Vector2(1280, 720)
	panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	$Logo.hide()

	var row := $Panel/Choices as HBoxContainer
	var cards: Array[Button] = [choice_a, choice_b, choice_c]
	if leave_button.visible:
		leave_button.reparent(row, false)
		var art := TextureRect.new()
		art.name = "ChoiceArt"
		art.texture = CARD_ART_CATALOG.get_run_card_texture(active_card.card_id)
		leave_button.add_child(art)
		leave_button.set_meta("event_kind", "ОТКАЗ")
		var exit_detail := "Без изменений."
		if active_card.card_id == "lost_purse":
			exit_detail = "Кошелёк останется у мертвеца."
		elif active_card.card_id == "faceless_card":
			match RunState.get_act1_reckoning_profile():
				"witnessless":
					exit_detail = "+50 золота."
				"scarred":
					exit_detail = "+35 золота: свободных реликвий больше нет." if RunState.get_available_artifact_ids().is_empty() else "Случайная реликвия."
				"riskbound":
					exit_detail = "Развитие отстающему герою." if RunState.can_claim_extra_hero_upgrade() and not RunState.get_least_developed_extra_role().is_empty() else "+35 золота: развивать больше некого."
			if exit_detail != "Без изменений.":
				leave_button.set_meta("event_kind", "СУДЬБА")
		leave_button.set_meta("event_outcome", exit_detail)
		cards.append(leave_button)
	for button in cards:
		if button.visible:
			CHOICE_COPY.prepare(button)
	choice_view.build(panel, row, title_label, wizard_line, description_label, result_label,
		[gold_label, artifacts_label], cards)


func _apply_approved_choice_art() -> void:
	var buttons: Array[Button] = [choice_a, choice_b, choice_c]
	var arts: Array[TextureRect] = [choice_art_a, choice_art_b, choice_art_c]
	if FINAL_FIVE.IDS.has(active_card.card_id):
		var pictures: Array[Texture2D] = []
		for entry: Array in FINAL_FIVE.CHOICES[active_card.card_id]:
			var image := Image.new()
			var path := "res://assets/pixel/events/final_five/"+active_card.card_id+"/choices/"+str(entry[0])+".webp"
			var error := image.load_webp_from_buffer(FileAccess.get_file_as_bytes(path))
			assert(error == OK, "Missing final-five choice illustration: "+path)
			pictures.append(ImageTexture.create_from_image(image))
		_apply_choice_texture_set(buttons, arts, pictures)
		return
	if active_card.card_id == "jack":
		_apply_choice_texture_set(buttons, arts, [
			CARD_ART_CATALOG.get_run_card_texture("jack"),
			_jack_detail_texture("pass"),
			_jack_detail_texture("token")])
		return

	if active_card.card_id == "moon_seal":
		_apply_choice_texture_set(
			buttons, arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_action_texture("occult_card"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("coins"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("blood"),
			]
		)
		return

	if active_card.card_id == "echo_crypt":
		_apply_choice_texture_set(
			buttons, arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_action_texture("cursed_relic"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("coins"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("occult_card"),
			]
		)
		return

	if active_card.card_id == "curse_forge":
		var artifact_ids := ["dead_mans_shield", "blind_quiver", "cracked_focus"]
		var textures: Array = []
		for artifact_id in artifact_ids:
			textures.append(ARTIFACT_ART_CATALOG.get_texture(artifact_id))
		_apply_choice_texture_set(buttons, arts, textures, true)
		return

	if active_card.card_id == "broken_crown":
		var crown_upgrade_art := _get_upgrade_choice_art(choice_c)
		if crown_upgrade_art == null:
			crown_upgrade_art = APPROVED_EVENT_CHOICE_ART.get_action_texture("cursed_relic")
		_apply_choice_texture_set(
			buttons,
			arts,
			[
				ARTIFACT_ART_CATALOG.get_texture("broken_crown"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("coins"),
				crown_upgrade_art,
			]
		)
		return

	if active_card.card_id == "chained_prisoner":
		var recruitment_state := RunState.can_recruit_companion("knight")
		var textures: Array = []
		for index in range(buttons.size()):
			textures.append(
				APPROVED_EVENT_CHOICE_ART.get_chained_prisoner_recruitment_texture(index)
				if recruitment_state
				else APPROVED_EVENT_CHOICE_ART.get_chained_prisoner_texture(index)
			)
		_apply_choice_texture_set(buttons, arts, textures)
		return

	if active_card.card_id == "rattling_bridge":
		_apply_choice_texture_set(
			buttons,
			arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_rattling_bridge_texture(0),
				APPROVED_EVENT_CHOICE_ART.get_rattling_bridge_texture(1),
				APPROVED_EVENT_CHOICE_ART.get_rattling_bridge_texture(2),
			]
		)
		return

	if active_card.card_id == "black_altar" and RunState.can_recruit_companion("mage"):
		_apply_choice_texture_set(
			buttons,
			arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_black_altar_texture(0),
				APPROVED_EVENT_CHOICE_ART.get_black_altar_texture(1),
				APPROVED_EVENT_CHOICE_ART.get_black_altar_texture(2),
			]
		)
		return

	if active_card.card_id == "ash_rest" and RunState.can_recruit_companion("ranger"):
		_apply_choice_texture_set(
			buttons,
			arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_action_texture("rescue"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("bag"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("leave"),
			]
		)
		return

	if active_card.card_id == "last_camp" and RunState.can_recruit_companion("knight"):
		_apply_choice_texture_set(
			buttons,
			arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_action_texture("chains"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("coins"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("loot_body"),
			]
		)
		return

	if active_card.card_id == "lost_purse":
		_apply_choice_texture_set(
			buttons,
			arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_action_texture("coins"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("bag"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("loot_body"),
			]
		)
		return

	if active_card.card_id == "debtor_bones":
		_apply_choice_texture_set(
			buttons,
			arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_action_texture("occult_card"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("coins"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("blood"),
			]
		)
		return

	if active_card.card_id == "wizard_tithe":
		_apply_choice_texture_set(
			buttons,
			arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_action_texture("coins"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("blood"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("leave"),
			]
		)
		return

	if active_card.card_id == "blood_ledger":
		_apply_choice_texture_set(
			buttons,
			arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_action_texture("coins"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("blood"),
				APPROVED_EVENT_CHOICE_ART.get_action_texture("occult_card"),
			]
		)
		return

	if active_card.card_id == "faceless_card":
		var fate_art := _get_upgrade_choice_art(choice_b)
		if fate_art == null:
			fate_art = APPROVED_EVENT_CHOICE_ART.get_action_texture("coins")
		_apply_choice_texture_set(
			buttons,
			arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_action_texture("occult_card"),
				fate_art,
				CARD_ART_CATALOG.get_run_card_texture(active_card.card_id),
			]
		)
		return

	if active_card.card_id == "bone_tax":
		var force_art := _get_upgrade_choice_art(choice_c)
		if force_art == null:
			force_art = APPROVED_EVENT_CHOICE_ART.get_action_texture("chains")
		var payment_art := (
			APPROVED_EVENT_CHOICE_ART.get_action_texture("chains")
			if RunState.has_rescue_scar("knight")
			else APPROVED_EVENT_CHOICE_ART.get_action_texture("blood")
		)
		_apply_choice_texture_set(
			buttons,
			arts,
			[
				APPROVED_EVENT_CHOICE_ART.get_action_texture("coins"),
				payment_art,
				force_art,
			]
		)
		return

	# Role-development screens already have semantic upgrade thumbnails. Only
	# fall back to the event art when a choice has no authored semantic source.
	var event_art := CARD_ART_CATALOG.get_run_card_texture(active_card.card_id)
	var fallback_textures: Array = []
	for button in buttons:
		var choice_texture := _get_upgrade_choice_art(button)
		if choice_texture == null:
			choice_texture = event_art
		fallback_textures.append(choice_texture)
	_apply_choice_texture_set(buttons, arts, fallback_textures)


func _apply_choice_texture_set(
	buttons: Array[Button],
	arts: Array[TextureRect],
	textures: Array,
	nearest_filter: bool = false
) -> void:
	for index in range(buttons.size()):
		var art: TextureRect = arts[index]
		var button: Button = buttons[index]
		if not button.visible:
			art.visible = false
			continue

		var texture: Texture2D = null
		if index < textures.size():
			texture = textures[index] as Texture2D
		if texture == null:
			art.visible = false
			continue

		art.texture = texture
		art.texture_filter = (
			CanvasItem.TEXTURE_FILTER_NEAREST
			if nearest_filter
			else CanvasItem.TEXTURE_FILTER_LINEAR
		)
		art.visible = true
		art.modulate = Color.WHITE

func _get_upgrade_choice_art(button: Button) -> Texture2D:
	var upgrade_id := String(button.get_meta("choice_upgrade_id", ""))
	if not upgrade_id.is_empty():
		var upgrade_art := CARD_ART_CATALOG.get_upgrade_texture(upgrade_id)
		if upgrade_art != null:
			return upgrade_art

	var role := String(button.get_meta("choice_role", ""))
	match role:
		"knight":
			return CARD_ART_CATALOG.get_upgrade_texture("knight_executioner")
		"ranger":
			return CARD_ART_CATALOG.get_upgrade_texture("ranger_arrowstorm")
		"mage":
			return CARD_ART_CATALOG.get_upgrade_texture("mage_glass_heart")
	return null

func _apply_event_backdrop() -> void:
	var card_id := active_card.card_id
	var accent := _get_event_accent()
	screen_visual.set("accent", accent)
	screen_visual.set("secondary", accent.darkened(0.62))
	screen_visual.set("variant", _get_event_visual_variant())

	var path := ""
	if FINAL_FIVE.IDS.has(card_id) or card_id == "jack":
		path = "res://assets/pixel/events/%s/backdrop.webp" % (card_id if card_id == "jack" else "final_five/" + card_id)
	elif EVENT_SCENE_ART_PATHS.has(card_id):
		path = CARD_UNIFICATION_V1.get_event_art_path(card_id, EVENT_SCENE_ART_PATHS[card_id])
	if path.is_empty():
		return

	backdrop.hide()
	feature_scene_art.call("load_webp_path", path, Vector2i(1280, 720))
	feature_scene_art.size = Vector2(1280, 720)
	feature_scene_art.modulate = Color(0.91, 0.86, 0.83)
	feature_scene_art.show()
	screen_visual.modulate = Color(1, 1, 1, 0.27)


func _get_event_accent() -> Color:
	match active_card.card_id:
		"curse_forge", "gravedigger_shop", "candle_seller":
			return Color(0.94, 0.38, 0.12, 1.0)
		"chained_prisoner", "bone_tax", "blood_ledger":
			return Color(0.82, 0.20, 0.16, 1.0)
		"black_altar", "faceless_card":
			return Color(0.66, 0.30, 0.82, 1.0)
		"ash_rest", "last_camp":
			return Color(0.52, 0.62, 0.28, 1.0)
		"rattling_bridge":
			return Color(0.34, 0.58, 0.72, 1.0)
		"broken_crown":
			return Color(0.84, 0.56, 0.18, 1.0)
		_:
			return Color(0.82, 0.32, 0.16, 1.0)

func _get_event_visual_variant() -> String:
	match active_card.card_id:
		"curse_forge":
			return "forge"
		"chained_prisoner", "bone_tax":
			return "chains"
		"black_altar", "faceless_card", "blood_ledger":
			return "altar"
		"rattling_bridge":
			return "bridge"
		"gravedigger_shop", "candle_seller", "ash_rest", "last_camp":
			return "candles"
		"debtor_bones", "lost_purse", "broken_crown":
			return "bones"
		_:
			return "generic"

func _apply_castle_memory_hint() -> void:
	if active_card == null:
		return
	var hint: String = CASTLE_MEMORY_TEXT.event_memory_hint(active_card.card_id, RunState.castle_memory_facts)
	if not hint.is_empty():
		description_label.text += "\n" + hint


func _configure_card() -> void:
	if FINAL_FIVE.IDS.has(active_card.card_id):
		_configure_final_five()
		return
	match active_card.card_id:
		"jack":
			_configure_jack()
		"moon_seal":
			_configure_moon_seal()
		"echo_crypt":
			_configure_echo_crypt()
		"ash_rest":
			_configure_ash_rest()
		"gravedigger_shop":
			_configure_shop()
		"curse_forge":
			_configure_curse_forge()
		"black_altar":
			_configure_black_altar()
		"chained_prisoner":
			_configure_chained_prisoner()
		"debtor_bones":
			_configure_debtor_bones()
		"wizard_tithe":
			_configure_wizard_tithe()
		"faceless_card":
			_configure_faceless_card()
		"blood_ledger":
			_configure_blood_ledger()
		"broken_crown":
			_configure_broken_crown()
		"last_camp":
			_configure_last_camp()
		"rattling_bridge":
			_configure_rattling_bridge()
		"lost_purse":
			_configure_lost_purse()
		"candle_seller":
			_configure_candle_seller()
		"bone_tax":
			_configure_bone_tax()
		_:
			push_warning("Unsupported act choice card: %s" % active_card.card_id)
			leave_button.text = "ВЕРНУТЬСЯ К СТОЛУ"
			_set_choices_visible(false)



# D149: two stand-alone noncombat choices with a conditional event-outcome echo.
# They use the shared event presentation.
func _configure_moon_seal() -> void:
	var observation: String = CASTLE_MEMORY_TEXT.moon_seal_observation(RunState.protagonist_role)
	if not observation.is_empty():
		description_label.text += "\n" + observation
	choice_a.text = "СОХРАНИТЬ ПЕЧАТЬ\n\n+10 золота\nСклеп запомнит знак"
	choice_b.text = "ПРОДАТЬ ПЕЧАТЬ\n\n+30 золота"
	choice_c.set_meta("event_kind", "РИТУАЛ")
	choice_c.text = "СЖЕЧЬ СИГИЛ\n\nУрон отряда +1\nЗдоровье отряда -10"
	leave_button.text = "ОСТАВИТЬ В ЧАШЕ"
	choice_a.pressed.connect(_resolve_moon_seal.bind("keep"))
	choice_b.pressed.connect(_resolve_moon_seal.bind("sell"))
	choice_c.pressed.connect(_resolve_moon_seal.bind("burn"))


func _configure_echo_crypt() -> void:
	var remembered: bool = RunState.get_event_outcome("moon_seal") == "kept"
	var relics_available: bool = not RunState.get_available_artifact_ids().is_empty()
	if not relics_available:
		choice_a.text = "ПУСТОЙ РЕЛИКВАРИЙ\n\n+35 золота вместо реликвии"
	else:
		choice_a.text = ("ОТКРЫТЬ ПЕЧАТЬЮ\n\nСлучайная реликвия бесплатно" if remembered
			else "ВСКРЫТЬ ГРОБ\n\nСлучайная реликвия\nЗдоровье отряда -15")
	choice_b.text = ("ВЗЯТЬ ПОДНОШЕНИЯ\n\n+40 золота" if remembered
		else "ВЗЯТЬ ПОДНОШЕНИЯ\n\n+25 золота")
	choice_c.text = ("СЛУШАТЬ ОТЗВУК\n\nУрон отряда +1.5\nЗдоровье отряда -5" if remembered
		else "СЛУШАТЬ ОТЗВУК\n\nУрон отряда +1.5\nЗдоровье отряда -15")
	if remembered:
		wizard_line.text = "— Неужели ты сохранил печать? Что ж, склеп умеет ценить вежливость."
	leave_button.text = "ЗАКРЫТЬ СКЛЕП"
	choice_a.pressed.connect(_resolve_echo_crypt.bind("relic"))
	choice_b.pressed.connect(_resolve_echo_crypt.bind("gold"))
	choice_c.pressed.connect(_resolve_echo_crypt.bind("listen"))


func _configure_ash_rest() -> void:
	if RunState.can_recruit_companion("ranger"):
		description_label.text = "У пепла сидит молодой следопыт. В прошлой жизни вы разделили с ним огонь."
		wizard_line.text = "— В прошлый раз ты позвал его к костру. Повторишь?"
		choice_a.text = "ПОЗВАТЬ К ОГНЮ\n\nШРАМ ДОРОГИ • -8 макс. HP\nСЛЕДОПЫТ ПРИСОЕДИНИТСЯ"
		choice_b.text = "ЗАБРАТЬ ПРИПАСЫ\n\n+20 золота\nСЛЕДОПЫТ БУДЕТ ПОТЕРЯН"
		choice_c.text = "УЙТИ ДО РАССВЕТА\n\nБез награды\nСЛЕДОПЫТ БУДЕТ ПОТЕРЯН"
		leave_button.visible = false
		choice_a.pressed.connect(_resolve_ash_rest.bind("recruit"))
		choice_b.pressed.connect(_resolve_ash_rest.bind("loot"))
		choice_c.pressed.connect(_resolve_ash_rest.bind("abandon"))
		return

	_set_role_upgrade_button(choice_a, "knight", "ПОДЛАТАТЬ ДОСПЕХ")
	_set_role_upgrade_button(choice_b, "ranger", "ПРОВЕРИТЬ ТЕТИВУ")
	_set_role_upgrade_button(choice_c, "mage", "РАЗДУТЬ УГЛИ")
	leave_button.text = "НЕ ЗАДЕРЖИВАТЬСЯ"

	choice_a.pressed.connect(_resolve_ash_rest.bind("knight"))
	choice_b.pressed.connect(_resolve_ash_rest.bind("ranger"))
	choice_c.pressed.connect(_resolve_ash_rest.bind("mage"))

func _configure_shop() -> void:
	var price: int = RunState.get_gravedigger_shop_price()
	var purse_outcome: String = RunState.get_event_outcome("lost_purse")
	if purse_outcome == "untouched" or purse_outcome == "safe":
		description_label.text = "Могильщик замечает, как осторожно вы обращались с мёртвыми монетами. Сегодня секреты стоят дешевле."
		wizard_line.text = "— Надо же. Репутация добралась до тебя раньше."
	elif purse_outcome == "greedy" or purse_outcome == "all_in":
		description_label.text = "Могильщик узнаёт монеты из кошеля своего недавнего клиента. Торговаться он больше не хочет."
		wizard_line.text = "— Какая тесная маленькая жизнь. Даже украденные деньги умеют возвращаться."

	_set_role_upgrade_button(choice_a, "knight", "МОГИЛЬНЫЙ УРОК — %d" % price)
	_set_role_upgrade_button(choice_b, "ranger", "ОХОТНИЧЬЯ СХЕМА — %d" % price)
	_set_role_upgrade_button(choice_c, "mage", "ЗАПРЕТНАЯ ЗАПИСКА — %d" % price)
	leave_button.text = "НИЧЕГО НЕ ПОКУПАТЬ"

	choice_a.disabled = choice_a.disabled or RunState.gold < price
	choice_b.disabled = choice_b.disabled or RunState.gold < price
	choice_c.disabled = choice_c.disabled or RunState.gold < price
	for button in [choice_a, choice_b, choice_c]:
		CHOICE_COPY.gold(button, price)

	choice_a.pressed.connect(_resolve_shop.bind("knight"))
	choice_b.pressed.connect(_resolve_shop.bind("ranger"))
	choice_c.pressed.connect(_resolve_shop.bind("mage"))

func _configure_curse_forge() -> void:
	var artifact_ids := ["dead_mans_shield", "blind_quiver", "cracked_focus"]
	var buttons := [choice_a, choice_b, choice_c]

	for index in range(buttons.size()):
		var artifact_id: String = artifact_ids[index]
		var artifact := RunState.get_artifact(artifact_id)
		var button: Button = buttons[index]

		if artifact == null:
			button.visible = false
			continue

		button.text = "%s\n\n%s" % [artifact.title, artifact.description]
		var role_missing := artifact.target_role != "*" and not RunState.is_role_in_party(artifact.target_role)
		if role_missing:
			button.text += "\n\nГЕРОЙ НЕ В ОТРЯДЕ"
		button.disabled = RunState.has_artifact(artifact_id) or role_missing
		button.set_meta("event_kind", "РЕЛИКВИЯ")
		if button.disabled:
			CHOICE_COPY.restrict(button, "Герой не в отряде" if role_missing else "Реликвия уже получена")
			button.set_meta("event_outcome", artifact.description)
		button.pressed.connect(_resolve_forge.bind(artifact_id))

	leave_button.text = "ОТКАЗАТЬСЯ ОТ КОВКИ"


func _configure_black_altar() -> void:
	if RunState.can_recruit_companion("mage"):
		description_label.text = "В центре ритуала лежит молодой маг. Вы уже видели эту ночь — и однажды вытащили его живым."
		wizard_line.text = "— Знание всегда требовало платы. Даже когда платил кто-то другой."
		choice_a.text = "ОТДАТЬ КРОВЬ\n\nШЁПОТ ПОД КОЖЕЙ • -12 макс. HP\nМАГ ПРИСОЕДИНИТСЯ"
		choice_b.text = "ПОДКУПИТЬ РИТУАЛ — 35\n\nМАГ ПРИСОЕДИНИТСЯ"
		choice_b.disabled = RunState.gold < 35
		CHOICE_COPY.gold(choice_b, 35)
		choice_c.text = "ЗАБРАТЬ ПОДНОШЕНИЕ\n\n+40 золота\nМАГ БУДЕТ ПОТЕРЯН"
		leave_button.visible = false
		choice_a.pressed.connect(_resolve_black_altar.bind("recruit_blood"))
		choice_b.pressed.connect(_resolve_black_altar.bind("recruit_gold"))
		choice_c.pressed.connect(_resolve_black_altar.bind("abandon_loot"))
		return

	_set_role_upgrade_button(choice_a, "knight", "КРОВЬ РЫЦАРЯ", "-20 здоровья отряда")
	_set_role_upgrade_button(choice_b, "ranger", "КРОВЬ СЛЕДОПЫТА", "-15 здоровья отряда")
	_set_role_upgrade_button(choice_c, "mage", "КРОВЬ МАГА", "-20 здоровья отряда")
	leave_button.text = "НЕ КАСАТЬСЯ АЛТАРЯ"

	choice_a.pressed.connect(_resolve_black_altar.bind("knight"))
	choice_b.pressed.connect(_resolve_black_altar.bind("ranger"))
	choice_c.pressed.connect(_resolve_black_altar.bind("mage"))

func _jack_detail_texture(detail: String) -> Texture2D:
	var image := Image.new()
	var bytes := FileAccess.get_file_as_bytes("res://assets/pixel/events/jack/"+detail+".webp")
	return ImageTexture.create_from_image(image) if image.load_webp_from_buffer(bytes) == OK else null

func _configure_jack() -> void:
	choice_a.text = "ВЗЯТЬ ДЖЕКА\n\nПёс поможет Следопыту в боях. Место героя не занято."
	choice_b.text = "ПРОЙТИ МИМО\n\nБез изменений.\nДжек останется у развалин."
	choice_c.text = "ВЗЯТЬ ЖЕТОН\n\nУрон следопыта +10% до конца забега.\nДжек не присоединится."
	var eligible := RunState.is_card_eligible("jack")
	choice_a.disabled = not eligible or RunState.gold < RunState.JACK_RESCUE_PRICE
	choice_b.disabled = not eligible
	choice_c.disabled = not eligible
	if not eligible:
		for button in [choice_a, choice_b, choice_c]:
			CHOICE_COPY.restrict(button, "Встреча доступна Следопыту с нерешённой судьбой Джека")
	CHOICE_COPY.gold(choice_a, RunState.JACK_RESCUE_PRICE)
	leave_button.visible = false
	choice_a.pressed.connect(_resolve_jack.bind("recruited"))
	choice_b.pressed.connect(_resolve_jack.bind("passed"))
	choice_c.pressed.connect(_resolve_jack.bind("token"))

func _resolve_jack(choice: String) -> void:
	if resolved or not RunState.resolve_jack_event(choice):
		return
	match choice:
		"recruited":
			_finish("Следопыт перевязывает лапу Джека. -25 золота. Пёс будет сражаться рядом с ним; место героя не занято.", choice)
		"passed":
			_finish("Вы проходите мимо. Пёс остаётся у развалин. Ничего не получено и не потеряно.", choice)
		"token":
			_finish("Следопыт снимает охотничий жетон. Его урон +10% до конца забега. Джек остаётся у развалин.", choice)

func _configure_chained_prisoner() -> void:
	if RunState.can_recruit_companion("knight"):
		description_label.text = "В цепях сидит рыцарь, которого вы однажды отказались оставить умирать."
		wizard_line.text = "— Его ты тоже называл спасённым. Цепи, кажется, помнят иначе."
		choice_a.text = "РАЗБИТЬ ЦЕПИ\n\nШРАМ ЦЕПЕЙ • -10 макс. HP\nРЫЦАРЬ ПРИСОЕДИНИТСЯ"
		choice_b.text = "ОБЫСКАТЬ ПЛЕННИКА\n\n+25 золота\nРЫЦАРЬ БУДЕТ ПОТЕРЯН"
		choice_c.text = "ОСТАВИТЬ В ЦЕПЯХ\n\nБез награды\nРЫЦАРЬ БУДЕТ ПОТЕРЯН"
		leave_button.visible = false
		choice_a.pressed.connect(_resolve_chained_prisoner.bind("recruit"))
		choice_b.pressed.connect(_resolve_chained_prisoner.bind("loot_recruitment"))
		choice_c.pressed.connect(_resolve_chained_prisoner.bind("abandon"))
		return

	_set_least_developed_upgrade_button(choice_a, "ОСВОБОДИТЬ — 25", "Пленник обучит самого отстающего героя.")
	choice_a.disabled = choice_a.disabled or RunState.gold < 25
	CHOICE_COPY.gold(choice_a, 25)

	if RunState.get_available_artifact_ids().is_empty():
		choice_b.text = "СОРВАТЬ ЦЕПИ\n\n-15 здоровья отряду\n+35 золота — реликвий больше нет"
	else:
		choice_b.text = "СОРВАТЬ ЦЕПИ\n\n-15 здоровья отряду\nСлучайная реликвия"

	choice_c.text = "ОБЫСКАТЬ ПЛЕННИКА\n\n+25 золота\n-10 здоровья отряда"
	leave_button.text = "ОСТАВИТЬ В ЦЕПЯХ"

	choice_a.pressed.connect(_resolve_chained_prisoner.bind("mentor"))
	choice_b.pressed.connect(_resolve_chained_prisoner.bind("chains"))
	choice_c.pressed.connect(_resolve_chained_prisoner.bind("loot"))

func _configure_debtor_bones() -> void:
	choice_a.text = "БРОСИТЬ КОСТИ\n\n50%: +45 золота\n50%: проклятие"
	choice_b.text = "ВЗЯТЬ МЕЛОЧЬ\n\nГарантированно +15 золота"
	choice_c.text = "РАЗБИТЬ КОСТИ\n\n+25 золота\n-10 здоровья"
	leave_button.text = "НЕ ТРОГАТЬ ДОЛГ"

	choice_a.pressed.connect(_resolve_debtor_bones.bind("gamble"))
	choice_b.pressed.connect(_resolve_debtor_bones.bind("safe"))
	choice_c.pressed.connect(_resolve_debtor_bones.bind("break"))


func _configure_wizard_tithe() -> void:
	var gold_price: int = RunState.get_wizard_tithe_gold_price()
	var bones_outcome: String = RunState.get_event_outcome("debtor_bones")
	if bones_outcome == "safe":
		description_label.text = "Волшебник перебирает монеты и вспоминает, как осторожно вы обошлись с чужим долгом."
		wizard_line.text = "— Редкая аккуратность. Сегодня я даже сделаю скидку."
	elif bones_outcome == "gamble" or bones_outcome == "break":
		description_label.text = "На ладони Волшебника перекатываются те же метки долга, что были на костях должника."
		wizard_line.text = "— Долги разговаривают друг с другом. Твой уже успел похвастаться."

	choice_a.text = "ЗАПЛАТИТЬ %d ЗОЛОТА\n\nДолг закрыт сразу" % gold_price
	choice_b.text = "ЗАПЛАТИТЬ КРОВЬЮ\n\n-20 здоровья отряду\nДолг закрыт сразу"
	choice_c.text = "ОТКАЗАТЬ\n\nВраги +25% урона\nСледующая обычная награда x2"
	choice_a.disabled = RunState.gold < gold_price
	CHOICE_COPY.gold(choice_a, gold_price)
	leave_button.visible = false

	choice_a.pressed.connect(_resolve_wizard_tithe.bind("gold"))
	choice_b.pressed.connect(_resolve_wizard_tithe.bind("blood"))
	choice_c.pressed.connect(_resolve_wizard_tithe.bind("refuse"))



func _configure_faceless_card() -> void:
	choice_a.set_meta("event_kind", "РИСК")
	choice_a.text = "ПЕРЕВЕРНУТЬ КАРТУ\n\nИсход неизвестен:\nзолото, реликвия или развитие"

	var fate_price: int = 15 if RunState.has_rescue_scar("ranger") else 30
	var fate_title: String = "ИДТИ ПО ШРАМУ — %d" % fate_price if RunState.has_rescue_scar("ranger") else "ПОДКУПИТЬ СУДЬБУ — %d" % fate_price
	var fate_description: String = "ШРАМ ДОРОГИ показывает короткий путь к гарантированному развитию." if RunState.has_rescue_scar("ranger") else "Гарантированное развитие самого отстающего героя."
	_set_least_developed_upgrade_button(choice_b, fate_title, fate_description)
	choice_b.disabled = choice_b.disabled or RunState.gold < fate_price
	CHOICE_COPY.gold(choice_b, fate_price)

	if RunState.wizard_debt_active:
		choice_c.text = "СЖЕЧЬ КАРТУ\n\nСнять ДОЛГ ВОЛШЕБНИКУ"
	else:
		choice_c.text = "СЖЕЧЬ КАРТУ\n\n+20 золота"

	var reckoning_profile: String = RunState.get_act1_reckoning_profile()
	match reckoning_profile:
		"witnessless":
			leave_button.text = "ПОКАЗАТЬ ПУСТЫЕ МЕСТА\n\nБЕЗ СВИДЕТЕЛЕЙ • +50 золота"
			wizard_line.text = "— Карта считает не только тех, кто дошёл сюда. Она считает и тех, кого рядом больше нет."
		"scarred":
			leave_button.text = "ПОКАЗАТЬ ШРАМЫ\n\nИСПИСАН ШРАМАМИ • реликвия"
			wizard_line.text = "— У карты нет лица. Зато у тебя достаточно отметин за двоих."
		"riskbound":
			leave_button.text = "ПОКАЗАТЬ ПОДПИСИ\n\nЛЮБИМЕЦ СТАВОК • развитие"
			wizard_line.text = "— Столько моих условий на одной судьбе. Даже карта впечатлена."
		_:
			leave_button.text = "НЕ ТРОГАТЬ КАРТУ"
			if RunState.has_rescue_scar("ranger"):
				wizard_line.text = "— Дорога оставила на тебе метку. Похоже, карта её тоже видит."

	choice_a.pressed.connect(_resolve_faceless_card.bind("reveal"))
	choice_b.pressed.connect(_resolve_faceless_card.bind("bribe"))
	choice_c.pressed.connect(_resolve_faceless_card.bind("burn"))

func _configure_blood_ledger() -> void:
	var gold_price: int = RunState.get_blood_ledger_gold_price()
	if RunState.has_castle_fact(RunState.CASTLE_FACT_CONFLICT):
		description_label.text += "\n" + CASTLE_MEMORY_TEXT.blood_ledger_observation(RunState.protagonist_role)
	_set_least_developed_upgrade_button(choice_a, "ПОДПИСАТЬ ЗОЛОТОМ — %d" % gold_price, "Книга усилит самого отстающего героя.")
	choice_a.disabled = choice_a.disabled or RunState.gold < gold_price
	CHOICE_COPY.gold(choice_a, gold_price)

	var blood_cost: int = 10 if RunState.has_rescue_scar("mage") else 25
	if RunState.get_available_artifact_ids().is_empty():
		_set_least_developed_upgrade_button(choice_b, "ПОДПИСАТЬ КРОВЬЮ", "-%d здоровья. Реликвий больше нет — книга предложит развитие." % blood_cost)
	else:
		choice_b.text = "ПОДПИСАТЬ КРОВЬЮ\n\n-%d здоровья отряду\nСлучайная реликвия" % blood_cost

	if RunState.has_rescue_scar("mage"):
		wizard_line.text = "— Книга уже слышит ШЁПОТ ПОД КОЖЕЙ. На этот раз крови ей нужно меньше."

	var last_upgrade_id := RunState.get_last_hero_upgrade_id()
	choice_c.set_meta("event_cost", "−1 развитие")
	if last_upgrade_id.is_empty():
		choice_c.text = "ВЫЧЕРКНУТЬ ИМЯ"
		choice_c.disabled = true
		CHOICE_COPY.restrict(choice_c, "У отряда пока нет развития")
	else:
		var last_upgrade := RunState.get_hero_upgrade(last_upgrade_id)
		choice_c.text = "ВЫЧЕРКНУТЬ: %s\n\n+70 золота. Исчезнет последнее развитие." % last_upgrade.title

	leave_button.text = "ЗАКРЫТЬ КНИГУ"

	choice_a.pressed.connect(_resolve_blood_ledger.bind("gold"))
	choice_b.pressed.connect(_resolve_blood_ledger.bind("blood"))
	choice_c.pressed.connect(_resolve_blood_ledger.bind("erase"))

func _configure_broken_crown() -> void:
	choice_a.text = "НАДЕТЬ КОРОНУ\n\n+22% урона всей партии\n-10 здоровья каждому герою"
	choice_a.disabled = RunState.has_artifact("broken_crown")
	if choice_a.disabled:
		CHOICE_COPY.restrict(choice_a, "Корона уже получена")
	choice_b.text = "РАЗЛОМАТЬ КОРОНУ\n\n+40 золота"
	if RunState.has_blood_ledger_knowledge():
		wizard_line.text = "— Книга уже показывала тебе, как переписывать вещи. Посмотрим, научился ли ты."
		_set_least_developed_upgrade_button(choice_c, "ПЕРЕПЛАВИТЬ ПО ЗАПИСЯМ", "Развитие слабейшему герою и +15 золота.")
	else:
		_set_least_developed_upgrade_button(choice_c, "ПЕРЕПЛАВИТЬ ОСКОЛКИ", "Осколки станут развитием самого отстающего героя.")
	leave_button.text = "ОСТАВИТЬ КОРОНУ"

	choice_a.pressed.connect(_resolve_broken_crown.bind("wear"))
	choice_b.pressed.connect(_resolve_broken_crown.bind("break"))
	choice_c.pressed.connect(_resolve_broken_crown.bind("melt"))


func _configure_last_camp() -> void:
	if RunState.can_recruit_companion("knight"):
		description_label.text = "У последнего костра лежит раненый рыцарь. Это поздняя версия встречи, которую судьба почти вычеркнула."
		wizard_line.text = "— Всё ещё хочешь тащить чужую жизнь до самого конца?"
		choice_a.text = "ПОДНЯТЬ ЕГО\n\nШРАМ ЦЕПЕЙ • -10 макс. HP\nРЫЦАРЬ ПРИСОЕДИНИТСЯ"
		var healer_price: int = RunState.get_last_camp_healer_price()
		choice_b.text = "ОПЛАТИТЬ ЛЕКАРЯ — %d\n\nРЫЦАРЬ ПРИСОЕДИНИТСЯ" % healer_price
		choice_b.disabled = RunState.gold < healer_price
		CHOICE_COPY.gold(choice_b, healer_price)
		choice_c.text = "ЗАБРАТЬ СНАРЯЖЕНИЕ\n\n+40 золота\nРЫЦАРЬ БУДЕТ ПОТЕРЯН"
		leave_button.visible = false
		choice_a.pressed.connect(_resolve_last_camp.bind("recruit_blood"))
		choice_b.pressed.connect(_resolve_last_camp.bind("recruit_gold"))
		choice_c.pressed.connect(_resolve_last_camp.bind("abandon_loot"))
		return

	_set_role_upgrade_button(choice_a, "knight", "ГОТОВИТЬ РЫЦАРЯ")
	_set_role_upgrade_button(choice_b, "ranger", "ГОТОВИТЬ СЛЕДОПЫТА")
	_set_role_upgrade_button(choice_c, "mage", "ГОТОВИТЬ МАГА")
	leave_button.text = "ИДТИ ДАЛЬШЕ СРАЗУ"

	choice_a.pressed.connect(_resolve_last_camp.bind("knight"))
	choice_b.pressed.connect(_resolve_last_camp.bind("ranger"))
	choice_c.pressed.connect(_resolve_last_camp.bind("mage"))

func _configure_rattling_bridge() -> void:
	if RunState.can_recruit_companion("ranger"):
		description_label.text = "На другом конце моста зажат молодой следопыт. Вы помните, что однажды вернулись за ним."
		wizard_line.text = "— Давай проверим, насколько дорого теперь стоит твоя память."
		choice_a.text = "ВЕРНУТЬСЯ ЗА НИМ\n\nШРАМ ДОРОГИ • -8 макс. HP\nСЛЕДОПЫТ ПРИСОЕДИНИТСЯ"
		choice_b.text = "ЗАБРАТЬ ЕГО СУМКУ\n\n+20 золота\nСЛЕДОПЫТ БУДЕТ ПОТЕРЯН"
		choice_c.text = "ПЕРЕЙТИ ОДНОМУ\n\nБез риска\nСЛЕДОПЫТ БУДЕТ ПОТЕРЯН"
		leave_button.visible = false
		choice_a.pressed.connect(_resolve_rattling_bridge.bind("recruit"))
		choice_b.pressed.connect(_resolve_rattling_bridge.bind("loot_recruitment"))
		choice_c.pressed.connect(_resolve_rattling_bridge.bind("abandon"))
		return

	choice_a.text = "ПЕРЕБЕЖАТЬ\n\n50%: +25 золота\n50%: -20 здоровья"
	choice_b.text = "СОБРАТЬ МОНЕТЫ С ПЕРИЛ\n\n+15 золота\n-5 здоровья"
	choice_c.text = "ИДТИ МЕДЛЕННО\n\nБез награды и без риска"
	leave_button.visible = false

	choice_a.pressed.connect(_resolve_rattling_bridge.bind("rush"))
	choice_b.pressed.connect(_resolve_rattling_bridge.bind("scavenge"))
	choice_c.pressed.connect(_resolve_rattling_bridge.bind("careful"))

func _configure_lost_purse() -> void:
	choice_a.text = "ВЗЯТЬ ВЕРХНИЕ МОНЕТЫ\n\n+15 золота"
	choice_b.text = "ЗАПУСТИТЬ РУКУ ГЛУБЖЕ\n\n+35 золота\n-10 здоровья"
	choice_c.text = "ВЫРВАТЬ КОШЕЛЬ ЦЕЛИКОМ\n\n+55 золота\n-25 здоровья"
	leave_button.text = "ОСТАВИТЬ МЕРТВЕЦУ"

	choice_a.pressed.connect(_resolve_lost_purse.bind("safe"))
	choice_b.pressed.connect(_resolve_lost_purse.bind("greedy"))
	choice_c.pressed.connect(_resolve_lost_purse.bind("all_in"))

func _configure_candle_seller() -> void:
	_set_role_upgrade_button(choice_a, "knight", "СИНЯЯ СВЕЧА — 25")
	_set_role_upgrade_button(choice_b, "ranger", "ЗЕЛЁНАЯ СВЕЧА — 25")
	_set_role_upgrade_button(choice_c, "mage", "ФИОЛЕТОВАЯ СВЕЧА — 25")
	choice_a.disabled = choice_a.disabled or RunState.gold < 25
	choice_b.disabled = choice_b.disabled or RunState.gold < 25
	choice_c.disabled = choice_c.disabled or RunState.gold < 25
	for button in [choice_a, choice_b, choice_c]:
		CHOICE_COPY.gold(button, 25)
	leave_button.text = "НИЧЕГО НЕ ПОКУПАТЬ"

	choice_a.pressed.connect(_resolve_candle_seller.bind("knight"))
	choice_b.pressed.connect(_resolve_candle_seller.bind("ranger"))
	choice_c.pressed.connect(_resolve_candle_seller.bind("mage"))


func _configure_bone_tax() -> void:
	var gold_price: int = RunState.get_bone_tax_gold_price()
	choice_a.text = "ЗАПЛАТИТЬ %d ЗОЛОТА\n\nПройти без последствий" % gold_price
	choice_a.disabled = RunState.gold < gold_price
	CHOICE_COPY.gold(choice_a, gold_price)
	if RunState.has_rescue_scar("knight"):
		choice_b.text = "ПОКАЗАТЬ ШРАМ ЦЕПЕЙ\n\nСтраж узнаёт Шрам цепей, полученный при спасении рыцаря, и пропустит бесплатно."
		wizard_line.text = "— Некоторые цепи всё-таки открывают двери."
	else:
		choice_b.text = "ЗАПЛАТИТЬ КРОВЬЮ\n\n-15 здоровья отряду\nСтраж пропустит отряд."
	_set_least_developed_upgrade_button(choice_c, "ПРОРВАТЬСЯ СИЛОЙ", "-25 здоровья, но драка закалит самого отстающего героя.")
	leave_button.visible = false

	choice_a.pressed.connect(_resolve_bone_tax.bind("gold"))
	choice_b.pressed.connect(_resolve_bone_tax.bind("blood"))
	choice_c.pressed.connect(_resolve_bone_tax.bind("force"))

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

func _set_role_upgrade_button(button: Button, role: String, heading: String, extra_text: String = "") -> void:
	button.set_meta("choice_role", role)
	button.remove_meta("choice_upgrade_id")
	var preview_upgrade_id := RunState.get_next_extra_hero_upgrade_id(role)
	if not preview_upgrade_id.is_empty():
		button.set_meta("choice_upgrade_id", preview_upgrade_id)

	if not RunState.is_role_in_party(role):
		button.text = heading
		CHOICE_COPY.restrict(button, "%s — вне отряда" % _get_role_label(role).capitalize())
		button.disabled = true
		return

	if not RunState.can_claim_extra_hero_upgrade():
		button.text = heading
		CHOICE_COPY.restrict(button, "Предел доп. развития: %s" % RunState.get_extra_upgrade_progress_text())
		button.disabled = true
		return

	var upgrade_id := RunState.get_next_extra_hero_upgrade_id(role)
	if upgrade_id.is_empty():
		button.text = heading
		CHOICE_COPY.restrict(button, "Все пути развития освоены")
		button.disabled = true
		return

	var upgrade := RunState.get_hero_upgrade(upgrade_id)
	var tail := ""
	if not extra_text.is_empty():
		tail = "\n\n%s" % extra_text

	button.text = "%s\n\n%s — %s\n%s%s" % [
		heading,
		_get_role_label(role),
		upgrade.title,
		upgrade.description,
		tail
	]

func _set_least_developed_upgrade_button(button: Button, heading: String, extra_text: String = "") -> void:
	if not RunState.can_claim_extra_hero_upgrade():
		button.text = heading
		CHOICE_COPY.restrict(button, "Предел доп. развития: %s" % RunState.get_extra_upgrade_progress_text())
		button.disabled = true
		return

	var role := RunState.get_least_developed_extra_role()
	if role.is_empty():
		button.text = heading
		CHOICE_COPY.restrict(button, "Все пути развития освоены")
		button.disabled = true
		return

	_set_role_upgrade_button(button, role, heading, extra_text)

func _grant_role_upgrade(role: String) -> String:
	return RunState.add_next_extra_hero_upgrade(role)

func _grant_least_developed_upgrade() -> String:
	return RunState.add_extra_upgrade_to_least_developed_role()

func _format_upgrade_gain(upgrade_id: String) -> String:
	if upgrade_id.is_empty():
		return "Новых путей развития не осталось."

	var upgrade := RunState.get_hero_upgrade(upgrade_id)
	if upgrade == null:
		return "Развитие изменилось."
	return "%s получает развитие: %s." % [_get_role_label(upgrade.target_role), upgrade.title]


func _resolve_ash_rest(choice: String) -> void:
	if resolved:
		return

	if RunState.can_recruit_companion("ranger"):
		match choice:
			"recruit":
				RunState.recruit_companion("ranger", "Вы снова разделили с ним огонь у пепельного привала. Дорога оставила на вас Шрам дороги.")
				RunState.add_rescue_scar("ranger")
				_finish("Следопыт поднимается от костра. Теперь эта версия дороги принадлежит вам обоим. ШРАМ ДОРОГИ: -8 макс. HP.", "recruit")
			"loot":
				RunState.gold += 20
				RunState.lose_companion("ranger", "Вы забрали припасы и оставили его у остывающего костра.")
				_finish("Получено 20 золота. Следопыт остаётся в прошлом.", "loot")
			"abandon":
				RunState.lose_companion("ranger", "Вы ушли до рассвета, не позвав его за собой.")
				_finish("Вы уходите до рассвета. Эта судьба закрывается.", "abandon")
		return

	var upgrade_id := _grant_role_upgrade(choice)
	if upgrade_id.is_empty():
		return
	_finish("У костра рождается новый приём. %s" % _format_upgrade_gain(upgrade_id), choice)

func _resolve_shop(role: String) -> void:
	var price: int = RunState.get_gravedigger_shop_price()
	if resolved or RunState.gold < price:
		return

	var upgrade_id := _grant_role_upgrade(role)
	if upgrade_id.is_empty():
		return

	RunState.gold -= price
	RunState.set_event_outcome("gravedigger_shop", "bought")
	presentation_choice_role = role
	_finish("Могильщик берёт %d монет и передаёт чужой секрет. %s" % [price, _format_upgrade_gain(upgrade_id)])

func _resolve_forge(artifact_id: String) -> void:
	if resolved or RunState.has_artifact(artifact_id):
		return

	if not RunState.add_artifact(artifact_id):
		return

	presentation_action = artifact_id
	var artifact := RunState.get_artifact(artifact_id)
	_finish("Кузница принимает выбор. Получен артефакт: %s." % artifact.title)


func _resolve_black_altar(choice: String) -> void:
	if resolved:
		return

	if RunState.can_recruit_companion("mage"):
		match choice:
			"recruit_blood":
				RunState.recruit_companion("mage", "Вы разорвали ритуал собственной кровью и снова вывели его из круга. Шёпот ритуала остался под вашей кожей.")
				RunState.add_rescue_scar("mage")
				_finish("Круг гаснет. Маг открывает глаза и встаёт рядом с вами. ШЁПОТ ПОД КОЖЕЙ: -12 макс. HP.", "rescue_blood")
			"recruit_gold":
				if RunState.gold < 35:
					return
				RunState.gold -= 35
				RunState.recruit_companion("mage", "Вы заплатили алтарю и выкупили его из ритуала.")
				_finish("Монеты чернеют на камне. Маг освобождён.", "rescue_gold")
			"abandon_loot":
				RunState.gold += 40
				RunState.lose_companion("mage", "Вы забрали подношение и позволили ритуалу завершиться.")
				_finish("Получено 40 золота. Ритуал заканчивается без вашего вмешательства.", "abandon_loot")
		return

	var hp_cost := -15.0 if choice == "ranger" else -20.0
	var upgrade_id := _grant_role_upgrade(choice)
	if upgrade_id.is_empty():
		return

	RunState.party_hp_bonus += hp_cost
	_finish("Алтарь принимает кровь. Здоровье отряда %d. %s" % [int(hp_cost), _format_upgrade_gain(upgrade_id)], choice)

func _resolve_chained_prisoner(choice: String) -> void:
	if resolved:
		return

	if RunState.can_recruit_companion("knight"):
		match choice:
			"recruit":
				RunState.recruit_companion("knight", "Вы снова разбили его цепи и приняли его в отряд. На протагонисте остался Шрам цепей.")
				RunState.add_rescue_scar("knight")
				RunState.record_castle_fact(RunState.CASTLE_FACT_SILENCED, "chained_prisoner")
				_finish("Цепи падают на камень. Рыцарь встаёт рядом с вами. ШРАМ ЦЕПЕЙ: -10 макс. HP.", "recruit")
			"loot_recruitment":
				RunState.gold += 25
				RunState.lose_companion("knight", "Вы обыскали пленника и оставили его в цепях.")
				_finish("Получено 25 золота. Звон цепей остаётся за спиной.", "loot_recruitment")
			"abandon":
				RunState.lose_companion("knight", "Вы оставили его в цепях.")
				_finish("Вы уходите. В этой версии прошлого цепи не разорваны.", "abandon")
		return

	match choice:
		"mentor":
			if RunState.gold < 25:
				return
			var upgrade_id := _grant_least_developed_upgrade()
			if upgrade_id.is_empty():
				return
			RunState.gold -= 25
			RunState.record_castle_fact(RunState.CASTLE_FACT_SILENCED, "chained_prisoner")
			_finish("Пленник покупает свободу знанием. %s" % _format_upgrade_gain(upgrade_id), "mentor")
		"chains":
			RunState.party_hp_bonus -= 15.0
			RunState.record_castle_fact(RunState.CASTLE_FACT_SILENCED, "chained_prisoner")
			var artifact_id := RunState.add_random_available_artifact()
			if artifact_id.is_empty():
				RunState.gold += 35
				_finish("Цепи ломаются, но тайник пуст. Здоровье -15, получено 35 золота.", "chains_empty")
			else:
				var artifact := RunState.get_artifact(artifact_id)
				_finish("За цепями спрятана реликвия: %s. Здоровье отряда -15." % artifact.title, "chains_relic")
		"loot":
			RunState.gold += 25
			RunState.party_hp_bonus -= 10.0
			_finish("Монеты ваши. Цепи оставляют след. Получено 25 золота, здоровье -10.", "loot")

func _resolve_debtor_bones(choice: String) -> void:
	if resolved:
		return

	match choice:
		"gamble":
			RunState.set_event_outcome("debtor_bones", "gamble")
			presentation_roll_success = randf() < 0.5
			if presentation_roll_success:
				RunState.gold += 45
				_finish("Кости падают удачно. Получено 45 золота.")
			else:
				RunState.party_hp_bonus -= 15.0
				RunState.party_damage_bonus -= 1.0
				_finish("Кости помнят старого должника. Здоровье -15, урон отряда -1.")
		"safe":
			RunState.gold += 15
			RunState.set_event_outcome("debtor_bones", "safe")
			_finish("Вы берёте только мелочь. Получено 15 золота.")
		"break":
			RunState.gold += 25
			RunState.party_hp_bonus -= 10.0
			RunState.set_event_outcome("debtor_bones", "break")
			_finish("Кости трескаются вместе с обещаниями. +25 золота, здоровье -10.")

func _resolve_wizard_tithe(choice: String) -> void:
	if resolved:
		return

	match choice:
		"gold":
			var gold_price: int = RunState.get_wizard_tithe_gold_price()
			if RunState.gold < gold_price:
				return
			RunState.gold -= gold_price
			RunState.set_event_outcome("wizard_tithe", "gold")
			_finish("Волшебник пересчитывает %d монет и кивает. На этот раз вы квиты." % gold_price)
		"blood":
			RunState.party_hp_bonus -= 20.0
			RunState.set_event_outcome("wizard_tithe", "blood")
			_finish("Кровь исчезает с ладони хозяина стола. Здоровье отряда -20.")
		"refuse":
			RunState.activate_wizard_debt()
			RunState.set_event_outcome("wizard_tithe", "refuse")
			_finish("Волшебник улыбается. До следующей обычной награды враги наносят +25% урона, зато награда будет удвоена.")


func _resolve_faceless_card(choice: String) -> void:
	if resolved:
		return

	match choice:
		"reveal":
			var outcome := randi_range(0, 2)
			match outcome:
				0:
					RunState.gold += 60
					_finish("На карте проступает золотая маска. Получено 60 золота.", "reveal_gold")
				1:
					var artifact_id := RunState.add_random_available_artifact()
					if artifact_id.is_empty():
						RunState.gold += 35
						_finish("Лицо на карте пусто. Реликвий не осталось: получено 35 золота.", "reveal_relic_empty")
					else:
						var artifact := RunState.get_artifact(artifact_id)
						_finish("На карте проступает реликвия: %s." % artifact.title, "reveal_relic")
				_:
					var upgrade_id := _grant_least_developed_upgrade()
					if upgrade_id.is_empty():
						RunState.gold += 35
						_finish("Карта не находит, что ещё изменить. Получено 35 золота.", "reveal_upgrade_empty")
					else:
						_finish("Карта показывает возможное будущее. %s" % _format_upgrade_gain(upgrade_id), "reveal_upgrade")
		"bribe":
			var fate_price: int = 15 if RunState.has_rescue_scar("ranger") else 30
			if RunState.gold < fate_price:
				return
			var upgrade_id := _grant_least_developed_upgrade()
			if upgrade_id.is_empty():
				return
			RunState.gold -= fate_price
			if RunState.has_rescue_scar("ranger"):
				_finish("ШРАМ ДОРОГИ проводит между строк. Потрачено %d золота. %s" % [fate_price, _format_upgrade_gain(upgrade_id)], "bribe_scar")
			else:
				_finish("Монеты исчезают под картой. %s" % _format_upgrade_gain(upgrade_id), "bribe")
		"burn":
			if RunState.wizard_debt_active:
				RunState.clear_wizard_debt()
				_finish("Карта вспыхивает чёрным пламенем. ДОЛГ ВОЛШЕБНИКУ исчезает вместе с ней.", "burn_debt")
			else:
				RunState.gold += 20
				_finish("Карта горит без дыма. В пепле остаётся 20 золота.", "burn_gold")


func _resolve_blood_ledger(choice: String) -> void:
	if resolved:
		return

	match choice:
		"gold":
			var gold_price: int = RunState.get_blood_ledger_gold_price()
			if RunState.gold < gold_price:
				return
			var upgrade_id := _grant_least_developed_upgrade()
			if upgrade_id.is_empty():
				return
			RunState.gold -= gold_price
			RunState.set_event_outcome("blood_ledger", "gold")
			var reason := " по оспоренной записи" if RunState.has_castle_fact(RunState.CASTLE_FACT_CONFLICT) else ""
			_finish("Книга принимает %d монет%s. %s" % [gold_price, reason, _format_upgrade_gain(upgrade_id)])
		"blood":
			var blood_cost: float = 10.0 if RunState.has_rescue_scar("mage") else 25.0
			RunState.party_hp_bonus -= blood_cost
			RunState.set_event_outcome("blood_ledger", "blood")
			var artifact_id := RunState.add_random_available_artifact()
			if artifact_id.is_empty():
				var upgrade_id := _grant_least_developed_upgrade()
				if upgrade_id.is_empty():
					RunState.gold += 40
					_finish("Книга забирает кровь, но страниц больше нет. Здоровье -%d, получено 40 золота." % int(blood_cost))
				else:
					_finish("Книга забирает кровь и переписывает героя. Здоровье -%d. %s" % [int(blood_cost), _format_upgrade_gain(upgrade_id)])
			else:
				var artifact := RunState.get_artifact(artifact_id)
				_finish("Книга забирает кровь и выдаёт реликвию: %s. Здоровье -%d." % [artifact.title, int(blood_cost)])
		"erase":
			var removed_id := RunState.remove_last_hero_upgrade()
			if removed_id.is_empty():
				return
			var removed := RunState.get_hero_upgrade(removed_id)
			RunState.gold += 70
			RunState.set_event_outcome("blood_ledger", "erase")
			_finish("Строка исчезает из книги. Потеряно развитие %s. Получено 70 золота." % removed.title)

func _resolve_broken_crown(choice: String) -> void:
	if resolved:
		return

	match choice:
		"wear":
			if not RunState.add_artifact("broken_crown"):
				return
			RunState.set_event_outcome("broken_crown", "wear")
			_finish("Корона садится слишком плотно. Получен артефакт: СЛОМАННАЯ КОРОНА.")
		"break":
			RunState.gold += 40
			RunState.set_event_outcome("broken_crown", "break")
			RunState.record_wizard_memory("greed", "broken_crown")
			_finish("Корона раскалывается окончательно. В оправе спрятано 40 золота.")
		"melt":
			var ledger_bonus: int = 15 if RunState.has_blood_ledger_knowledge() else 0
			var upgrade_id := _grant_least_developed_upgrade()
			RunState.set_event_outcome("broken_crown", "melt")
			if upgrade_id.is_empty():
				RunState.gold += 30 + ledger_bonus
				_finish("Осколки уже не могут улучшить отряд. Получено %d золота." % (30 + ledger_bonus))
			else:
				RunState.gold += ledger_bonus
				var bonus_text: String = " И ещё %d золота по записям Кровавой книги." % ledger_bonus if ledger_bonus > 0 else ""
				_finish("Осколки переплавлены в новый приём. %s%s" % [_format_upgrade_gain(upgrade_id), bonus_text])


func _resolve_last_camp(choice: String) -> void:
	if resolved:
		return

	if RunState.can_recruit_companion("knight"):
		match choice:
			"recruit_blood":
				RunState.recruit_companion("knight", "Вы подняли раненого рыцаря у последнего привала. Старые цепи снова оставили след на вас.")
				RunState.add_rescue_scar("knight")
				_finish("Вы помогаете ему встать. До надзирателя теперь идёте вместе. ШРАМ ЦЕПЕЙ: -10 макс. HP.", "rescue_blood")
			"recruit_gold":
				var healer_price: int = RunState.get_last_camp_healer_price()
				if RunState.gold < healer_price:
					return
				RunState.gold -= healer_price
				RunState.recruit_companion("knight", "Вы оплатили лечение и вернули рыцаря в эту версию пути.")
				_finish("Лекарь забирает %d монет. Рыцарь снова может держать меч." % healer_price, "rescue_gold")
			"abandon_loot":
				RunState.gold += 40
				RunState.lose_companion("knight", "Вы забрали его снаряжение у последнего костра.")
				_finish("Получено 40 золота. Рыцарь остаётся у последнего костра.", "abandon_loot")
		return

	var upgrade_id := _grant_role_upgrade(choice)
	if upgrade_id.is_empty():
		return

	_finish("Последняя ночь перед надзирателем не проходит зря. %s" % _format_upgrade_gain(upgrade_id), choice)

func _resolve_rattling_bridge(choice: String) -> void:
	if resolved:
		return

	presentation_action = choice
	presentation_recruitment = RunState.can_recruit_companion("ranger")
	if presentation_recruitment:
		match choice:
			"recruit":
				RunState.recruit_companion("ranger", "Вы вернулись за ним на гремучем мосту. Падение оставило на протагонисте Шрам дороги.")
				RunState.add_rescue_scar("ranger")
				_finish("Мост едва держится, но вы переходите его вдвоём. Следопыт присоединяется. ШРАМ ДОРОГИ: -8 макс. HP.")
			"loot_recruitment":
				RunState.gold += 20
				RunState.lose_companion("ranger", "Вы забрали его сумку и перешли мост без него.")
				_finish("Получено 20 золота. На другой стороне остаётся человек, за которым вы не вернулись.")
			"abandon":
				RunState.lose_companion("ranger", "Вы перешли мост и не вернулись за ним.")
				_finish("Вы переходите один. Волшебник запоминает этот выбор.")
		return

	match choice:
		"rush":
			presentation_roll_success = randf() < 0.5
			if presentation_roll_success:
				RunState.gold += 25
				_finish("Мост выдерживает. Между костями нашлось 25 золота.")
			else:
				RunState.party_hp_bonus -= 20.0
				_finish("Мост кусается за ноги. Здоровье отряда -20.")
		"scavenge":
			RunState.gold += 15
			RunState.party_hp_bonus -= 5.0
			_finish("Переход занимает вечность. Получено 15 золота, здоровье -5.")
		"careful":
			_finish("Вы переходите мост медленно и скучно. Даже волшебник зевает.")


func _resolve_moon_seal(choice: String) -> void:
	if resolved:
		return
	match choice:
		"keep":
			RunState.gold += 10
			RunState.set_event_outcome("moon_seal", "kept")
			RunState.record_castle_fact(RunState.CASTLE_FACT_PROMISE, "moon_seal")
			_finish("Вы прячете серебряную печать и находите под ней 10 золотых. Камень запомнит ваш выбор.", choice)
		"sell":
			RunState.gold += 30
			RunState.set_event_outcome("moon_seal", "sold")
			RunState.record_castle_fact(RunState.CASTLE_FACT_PROMISE, "moon_seal")
			RunState.record_wizard_memory("greed", "moon_seal")
			_finish("Монета исчезает в руке Волшебника. Получено 30 золота.", choice)
		"burn":
			RunState.party_hp_bonus -= 10.0
			RunState.party_damage_bonus += 1.0
			RunState.set_event_outcome("moon_seal", "burned")
			RunState.record_castle_fact(RunState.CASTLE_FACT_PROMISE, "moon_seal")
			_finish("Печать становится пеплом: урон отряда +1, здоровье отряда -10.", choice)


func _resolve_echo_crypt(choice: String) -> void:
	if resolved:
		return
	var remembered: bool = RunState.get_event_outcome("moon_seal") == "kept"
	match choice:
		"relic":
			var artifact_id: String = RunState.add_random_available_artifact()
			RunState.set_event_outcome("echo_crypt", "opened")
			if remembered:
				RunState.record_castle_fact(RunState.CASTLE_FACT_CONFLICT, "echo_crypt")
			if artifact_id.is_empty():
				RunState.gold += 35
				var clue_text := "Под печатью — два несовместимых приказа. " if remembered else ""
				_finish("%sРеликварий пуст. Получено 35 золота." % clue_text, "empty_kept" if remembered else "empty_plain")
			else:
				if not remembered:
					RunState.party_hp_bonus -= 15.0
				var artifact := RunState.get_artifact(artifact_id)
				var cost_text := "Под печатью найдены два несовместимых приказа. Дверь открылась без крови." if remembered else "Открытие стоило 15 здоровья."
				_finish("%s Получена реликвия: %s." % [cost_text, artifact.title], "relic_kept" if remembered else "relic_forced")
		"gold":
			var gain: int = 40 if remembered else 25
			RunState.gold += gain
			RunState.set_event_outcome("echo_crypt", "gold")
			_finish("Вы собираете подношения. Получено %d золота." % gain, "gold_kept" if remembered else "gold_plain")
		"listen":
			var hp_cost: float = 5.0 if remembered else 15.0
			RunState.party_hp_bonus -= hp_cost
			RunState.party_damage_bonus += 1.5
			RunState.set_event_outcome("echo_crypt", "listened")
			RunState.record_castle_fact(RunState.CASTLE_FACT_CONFLICT, "echo_crypt")
			_finish("Шёпот выдаёт два противоречивых приказа. Урон отряда +1.5, здоровье отряда -%d." % int(hp_cost), "listen_kept" if remembered else "listen_plain")


func _resolve_lost_purse(choice: String) -> void:
	if resolved:
		return

	match choice:
		"safe":
			RunState.gold += 15
			RunState.set_event_outcome("lost_purse", "safe")
			_finish("Вы берёте только то, что лежит сверху. Получено 15 золота.")
		"greedy":
			RunState.gold += 35
			RunState.party_hp_bonus -= 10.0
			RunState.set_event_outcome("lost_purse", "greedy")
			RunState.record_wizard_memory("greed", "lost_purse")
			_finish("Мёртвые пальцы сжимаются. +35 золота, здоровье -10.")
		"all_in":
			RunState.gold += 55
			RunState.party_hp_bonus -= 25.0
			RunState.set_event_outcome("lost_purse", "all_in")
			RunState.record_wizard_memory("greed", "lost_purse")
			_finish("Кошель ваш. Кусок руки тоже. +55 золота, здоровье -25.")

func _resolve_candle_seller(role: String) -> void:
	if resolved or RunState.gold < 25:
		return

	var upgrade_id := _grant_role_upgrade(role)
	if upgrade_id.is_empty():
		return

	presentation_choice_role = role
	RunState.gold -= 25
	_finish("Свеча сгорает за секунду, оставляя знание вместо воска. %s" % _format_upgrade_gain(upgrade_id))


func _resolve_bone_tax(choice: String) -> void:
	if resolved:
		return

	match choice:
		"gold":
			var gold_price: int = RunState.get_bone_tax_gold_price()
			if RunState.gold < gold_price:
				return
			RunState.gold -= gold_price
			_finish("Пошлина уплачена: %d золота. Страж отводит взгляд." % gold_price, "gold")
		"blood":
			if RunState.has_rescue_scar("knight"):
				_finish("Страж видит ШРАМ ЦЕПЕЙ и отступает. Сегодня уже было заплачено достаточно.", "scar")
			else:
				RunState.party_hp_bonus -= 15.0
				_finish("Страж принимает кровь вместо монет. Здоровье отряда -15.", "blood")
		"force":
			var upgrade_id := _grant_least_developed_upgrade()
			if upgrade_id.is_empty():
				return
			RunState.party_hp_bonus -= 25.0
			_finish("Пошлина превращается в драку. Здоровье -25. %s" % _format_upgrade_gain(upgrade_id), "force")


func _resolve_leave() -> void:
	if resolved:
		return
	resolving_leave = true

	match active_card.card_id:
		"jack":
			_resolve_jack("passed")
		"moon_seal":
			RunState.set_event_outcome("moon_seal", "left")
			_finish("Лунная печать остаётся в чаше. Вы ничего не берёте.", "leave")
		"echo_crypt":
			RunState.set_event_outcome("echo_crypt", "left")
			_finish("Вы запираете склеп и оставляете его тайны нетронутыми.", "leave")
		"ash_rest":
			_finish("Вы оставляете пепел остывать. Волшебник выглядит разочарованным.", "leave")
		"gravedigger_shop":
			presentation_choice_role = "leave"
			_finish("Монеты остаются при вас. Могильщик пожимает плечами.")
		"curse_forge":
			presentation_action = "leave"
			_finish("Вы уходите без артефакта. Молот за спиной ударяет сам собой.")
		"black_altar":
			_finish("Вы не касаетесь камня. Алтарь продолжает ждать следующего.", "leave")
		"chained_prisoner":
			_finish("Цепи звенят за спиной. Волшебник ничего не комментирует — и это хуже.", "leave")
		"debtor_bones":
			presentation_action = "leave"
			_finish("Вы оставляете чужой долг лежать в пыли.")
		"faceless_card":
			var reckoning_profile: String = RunState.get_act1_reckoning_profile()
			match reckoning_profile:
				"witnessless":
					RunState.gold += 50
					RunState.set_event_outcome("faceless_card", "witnessless")
					_finish("На пустом лице проступают два отсутствующих силуэта. Карта платит за тишину: +50 золота.", "witnessless")
				"scarred":
					RunState.set_event_outcome("faceless_card", "scarred")
					var artifact_id: String = RunState.add_random_available_artifact()
					if artifact_id.is_empty():
						RunState.gold += 35
						_finish("Карта читает ваши шрамы, но свободных реликвий не осталось. Получено 35 золота.", "scarred_empty")
					else:
						var artifact := RunState.get_artifact(artifact_id)
						_finish("Шрамы складываются в знакомый знак. Карта выдаёт реликвию: %s." % artifact.title, "scarred_relic")
				"riskbound":
					RunState.set_event_outcome("faceless_card", "riskbound")
					var upgrade_id: String = _grant_least_developed_upgrade()
					if upgrade_id.is_empty():
						RunState.gold += 35
						_finish("Карта видит слишком много принятых условий, но развивать больше нечего. Получено 35 золота.", "riskbound_empty")
					else:
						_finish("Карта узнаёт почерк Волшебника на вашей судьбе. %s" % _format_upgrade_gain(upgrade_id), "riskbound_upgrade")
				_:
					_finish("Карта остаётся лежать лицом вниз. Волшебник явно считает это скучным.", "leave")
		"blood_ledger":
			presentation_action = "leave"
			_finish("Книга закрывается сама. Вашего имени внутри пока нет.")
		"broken_crown":
			presentation_action = "leave"
			_finish("Корона остаётся без хозяина. Возможно, это самый разумный исход.")
		"last_camp":
			_finish("Вы не задерживаетесь. До надзирателя остаётся совсем немного.", "leave")
		"lost_purse":
			RunState.set_event_outcome("lost_purse", "untouched")
			_finish("Вы оставляете кошель мертвецу. Волшебник разочарован вашей сдержанностью.")
		"candle_seller":
			presentation_action = "leave"
			presentation_choice_role = "leave"
			_finish("Свечи остаются у торговца. Темнота — у вас.")
		_:
			_finish("Вы возвращаетесь к столу.")

# Sources are actual successful choices, not deals, abandoned events or
# failed transactions. A repeated source never requeues the same clue.
func _record_castle_memory_for_event() -> void:
	if resolving_leave or active_card == null:
		return
	match active_card.card_id:
		"ash_rest", "rattling_bridge":
			RunState.record_castle_fact(RunState.CASTLE_FACT_MARCH, active_card.card_id)
		"debtor_bones":
			if RunState.get_event_outcome("debtor_bones") == "safe":
				RunState.record_castle_fact(RunState.CASTLE_FACT_RATIONS, active_card.card_id)
		"candle_seller":
			RunState.record_castle_fact(RunState.CASTLE_FACT_RATIONS, active_card.card_id)
		"gravedigger_shop":
			if RunState.get_event_outcome("gravedigger_shop") == "bought":
				RunState.record_castle_fact(RunState.CASTLE_FACT_RATIONS, active_card.card_id)


func _finish(message: String, batch_03_action: String = "") -> void:
	if resolved: return
	var presentation := {
		"choice_role": presentation_choice_role,
		"visual_action": presentation_action,
		"roll_success": presentation_roll_success,
		"recruitment": presentation_recruitment,
		"batch_03_action": batch_03_action,
		"jack_companion": RunState.has_jack_companion(),
	}
	travel_context = preload("res://scripts/travel/travel_catalog.gd").context_for(
		active_card.card_id, RunState.get_event_outcome(active_card.card_id),
		RunState.party_roles, active_card.wizard_line, false, presentation)
	resolved = true
	_disable_choices()
	_record_castle_memory_for_event()
	RunState.complete_active_card()
	preload("res://scripts/core/run_save_service.gd").instance().write_slot(RunState)
	result_label.text = message
	var after := BUILD_FEEDBACK.capture(RunState)
	var delta := BUILD_FEEDBACK.changes(_entry_build, after, 1)
	if not delta.is_empty():
		result_label.tooltip_text = message + "\n" + BUILD_FEEDBACK.changes(_entry_build, after)
		result_label.mouse_filter = Control.MOUSE_FILTER_PASS
		result_label.text += "\n" + delta
	SoundDirector.play_event_result(_entry_gold, _entry_hp, _entry_relics)
	_refresh_run_labels()
	choice_view.show_result(continue_button)


func _disable_choices() -> void:
	choice_a.disabled = true
	choice_b.disabled = true
	choice_c.disabled = true
	leave_button.disabled = true

func _set_choices_visible(value: bool) -> void:
	choice_a.visible = value
	choice_b.visible = value
	choice_c.visible = value

func _refresh_run_labels() -> void:
	gold_label.text = "ЗОЛОТО: %d" % RunState.gold
	artifacts_label.text = "ОТРЯД: %d/3   |   РАЗВИТИЕ: %d   |   ДОП.: %s   |   РЕЛИКВИИ: %d" % [
		RunState.get_party_size(),
		RunState.hero_upgrade_ids.size(),
		RunState.get_extra_upgrade_progress_text(),
		RunState.artifact_ids.size()
	]
	var condition_text := RunState.get_run_condition_text()
	if not condition_text.is_empty():
		artifacts_label.text += "   |   %s" % condition_text
	gold_label.tooltip_text = gold_label.text
	artifacts_label.tooltip_text = artifacts_label.text

func _return_to_table() -> void:
	if not resolved or returning:
		return
	returning = true
	continue_button.disabled = true
	SCENE_ROUTER.after_resolution(self, travel_context)

func _configure_final_five() -> void:
	leave_button.hide()
	var buttons: Array[Button] = [choice_a, choice_b, choice_c]
	var entries: Array = FINAL_FIVE.CHOICES[active_card.card_id]
	for index in range(3):
		var entry: Array = entries[index]
		buttons[index].text = entry[1]
		buttons[index].disabled = not FINAL_FIVE.available(RunState, active_card.card_id, entry[0])
		if RunState.has_event_outcome(active_card.card_id):
			CHOICE_COPY.restrict(buttons[index], "Событие уже завершено")
		if index == 0:
			if not buttons[index].has_meta("event_restriction"):
				if active_card.card_id == "unsent_letters" and RunState.defiance_order_ready:
					CHOICE_COPY.restrict(buttons[index], "«Неповиновение» уже подготовлено")
				elif active_card.card_id == "last_signal" and not RunState.wizard_debt_active:
					CHOICE_COPY.restrict(buttons[index], "У вас нет долга Волшебнику")
			if FINAL_FIVE.GOLD_COSTS.has(active_card.card_id):
				CHOICE_COPY.gold(buttons[index], FINAL_FIVE.GOLD_COSTS[active_card.card_id])
		buttons[index].pressed.connect(_resolve_final_five.bind(index))


func _resolve_final_five(index: int) -> void:
	if resolved or index < 0 or index > 2: return
	var entry: Array = FINAL_FIVE.CHOICES[active_card.card_id][index]
	if not FINAL_FIVE.resolve(RunState, active_card.card_id, entry[0]): return
	_finish(entry[2])
