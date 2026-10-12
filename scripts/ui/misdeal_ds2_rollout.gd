extends RefCounted

# Opt-in rollout to existing production UI nodes. Positions, art, battle
# systems, interactive signals and saved run data remain owned by each scene.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")

static func class_select(scene: Control) -> void:
	var frame := scene.get_node("Frame") as Panel
	UI.apply_v2_material_plate(frame, true)
	_style_heading(scene.get_node("Frame/Title") as Label, 30)
	_style_subtitle(scene.get_node("Frame/WizardLine") as Label)
	_style_subtitle(scene.get_node("Frame/Rule") as Label)
	_style_subtitle(scene.get_node("Frame/Status") as Label)
	for path in ["Frame/Cards/Knight", "Frame/Cards/Ranger", "Frame/Cards/Mage"]:
		var card := scene.get_node(path) as Button
		UI.apply_v2_reward_card(card)
		card.add_theme_color_override("font_color", UI.PARCHMENT_WARM)
		# Keep the original illustrated portraits and class-specific copy.
		for label_name in ["ClassTitle", "Stats", "Role", "Description"]:
			var label := card.get_node_or_null(label_name) as Label
			if label != null:
				label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
				label.clip_text = true
		var class_title := card.get_node_or_null("ClassTitle") as Label
		if class_title != null:
			class_title.add_theme_color_override("font_color", UI.PARCHMENT_WARM)


static func squad(scene: Control) -> void:
	for name in ["Frame", "Frame/PortraitFrame", "Frame/BuildPanel", "Frame/RelicsPanel", "Frame/CommonPanel"]:
		UI.apply_v2_material_plate(scene.get_node(name) as Panel, name == "Frame")
	_style_heading(scene.get_node("Frame/Title") as Label, 28)
	var hint := scene.get_node("Frame/Hint") as Label
	hint.add_theme_color_override("font_color", UI.TEXT_SECONDARY)
	for name in ["KnightButton", "RangerButton", "MageButton"]:
		var role := scene.get_node("Frame/" + name) as Button
		UI.apply_action_button(role, UI.AGED_BRONZE, false)
	# Selected role and lost/absent text colors are set by _refresh_role_buttons.
	UI.apply_action_button(scene.get_node("Frame/CloseButton") as Button, UI.AGED_BRONZE, false)
	for name in ["StatsTitle", "BuildTitle", "RelicsTitle"]:
		var heading := scene.get_node_or_null("Frame/" + name) as Label
		if heading != null:
			heading.add_theme_color_override("font_color", UI.PARCHMENT_WARM)


static func run_end(scene: Control) -> void:
	UI.apply_v2_material_plate(scene.get_node("SummaryPanel") as Panel, true)
	_style_heading(scene.get_node("Title") as Label, 38)
	_style_subtitle(scene.get_node("WizardLine") as Label)
	var summary := scene.get_node("Summary") as Label
	summary.add_theme_color_override("font_color", UI.TEXT_ON_DARK)
	# Summary remains a sibling of its panel; retain original full-run data.
	summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UI.apply_action_button(scene.get_node("NewRunButton") as Button, UI.AGED_BRONZE, true)


static func battle(scene: Control) -> void:
	# Combat UI has lower opacity than event cards: combatants and tactical
	# floor stay unobstructed. No repositioning or resizing of button islands.
	for name in ["TopHudPanel", "RunHudPanel", "BottomHudPanel", "FightHudPanel", "WizardCommentaryPanel", "SideObjectivePanel"]:
		var target := scene.get_node(name) as Panel
		UI.apply_battle_panel(target, UI.AGED_BRONZE, 0.55 if name == "TopHudPanel" or name == "RunHudPanel" else 0.72)
	UI.apply_v2_material_plate(scene.get_node("ResultOverlay/ResultBackdrop") as Panel, true)
	_style_heading(scene.get_node("Title") as Label, 26)
	for name in ["DealLabel", "RunConditionLabel", "OrderDescription", "WizardCommentary"]:
		var label := scene.get_node(name) as Label
		label.add_theme_color_override("font_color", UI.TEXT_ON_DARK if name == "DealLabel" else UI.TEXT_SECONDARY)
	for name in ["AssaultOrderButton", "HuntOrderButton", "FormationOrderButton"]:
		UI.apply_battle_button(scene.get_node(name) as Button, UI.AGED_BRONZE)
	UI.apply_battle_button(scene.get_node("FightButton") as Button, UI.RITUAL_CRIMSON.lightened(0.28), true)
	UI.apply_battle_button(scene.get_node("ContinueButton") as Button, UI.AGED_BRONZE, true)
	UI.apply_action_button(scene.get_node("ResultOverlay/LastDealAccept") as Button, UI.RITUAL_CRIMSON.lightened(0.28), true)
	UI.apply_action_button(scene.get_node("ResultOverlay/LastDealRefuse") as Button, UI.MOONLIT_STEEL, false)


static func table(scene: Control) -> void:
	# Explicitly exclude FateSpreadOverlay, table art, card geometry and
	# RunState offer logic. Only the table's peripheral chrome is updated.
	UI.apply_v2_material_plate(scene.get_node("HudPanel") as Panel)
	UI.apply_v2_material_plate(scene.get_node("WizardLinePanel") as Panel)
	_style_subtitle(scene.get_node("WizardLine") as Label)
	for name in ["SquadButton", "FateSpreadButton"]:
		UI.apply_action_button(scene.get_node(name) as Button, UI.AGED_BRONZE, false)
	var wager := scene.get_node("WagerOverlay/Root/WagerPanel") as Panel
	UI.apply_v2_material_plate(wager, true)
	UI.apply_v2_material_plate(scene.get_node("WagerOverlay/Root/WagerPanel/RiskPanel") as Panel)
	UI.apply_v2_material_plate(scene.get_node("WagerOverlay/Root/WagerPanel/RewardPanel") as Panel)
	UI.apply_action_button(scene.get_node("WagerOverlay/Root/WagerPanel/AcceptButton") as Button, UI.RITUAL_CRIMSON.lightened(0.30), true)
	UI.apply_action_button(scene.get_node("WagerOverlay/Root/WagerPanel/RefuseButton") as Button, UI.MOONLIT_STEEL, false)


static func _style_heading(label: Label, size: int) -> void:
	label.add_theme_color_override("font_color", UI.PARCHMENT_WARM)
	label.add_theme_font_size_override("font_size", size)


static func _style_subtitle(label: Label) -> void:
	label.add_theme_color_override("font_color", UI.TEXT_SECONDARY)
