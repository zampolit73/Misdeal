extends SceneTree

# D289: load the real Table with actual RunState in Godot, then assert that
# the new DS3 chrome did not change two-card dealing, buttons or lore signals.
const SCENE := "res://scenes/table/table.tscn"

func _initialize() -> void:
	call_deferred("_verify")

func _verify() -> void:
	var state: Node = root.get_node_or_null("RunState")
	if state == null:
		state = (load("res://scripts/core/run_state.gd") as Script).new() as Node
		state.name = "RunState"
		root.add_child(state)
	state.call("reset_run")
	if not state.call("choose_protagonist", "knight"):
		_fail("Knight protagonist setup failed")
		return

	var packed := load(SCENE) as PackedScene
	if packed == null:
		_fail("could not load production Table")
		return
	var table := packed.instantiate() as Control
	if table == null:
		_fail("Table root is not a Control")
		return
	root.add_child(table)
	await process_frame

	var hud := table.get_node("HudPanel") as Panel
	var wizard := table.get_node("WizardLinePanel") as Panel
	var status := table.get_node("Stats") as Label
	var wizard_line := table.get_node("WizardLine") as Label
	var menu := preload("res://scripts/ui/system_dialog.gd")
	for panel in [hud, wizard]:
		var style := panel.get_theme_stylebox("panel") as StyleBoxTexture
		if style == null or style.texture != menu.plate_style(menu.SECONDARY).texture:
			_fail("HUD V2 must reuse the real menu material")
			return
	if hud.position != Vector2(312, 13) or hud.size != Vector2(656, 54) or wizard.position != Vector2(336, 66) or wizard.size != Vector2(608, 40):
		_fail("HUD V2 approved starting geometry changed")
		return
	if hud.get_node_or_null("MetricValue4") == null or wizard.get_node_or_null("Speaker") == null or status.visible:
		_fail("HUD V2 grouped metrics or speaker missing / duplicate source text")
		return
	for index in range(5):
		var value := hud.get_node("MetricValue%d" % index) as Label
		if value.text.is_empty() or not hud.get_global_rect().encloses(value.get_global_rect()):
			_fail("HUD V2 live metric missing or outside plate")
			return
	# D290 screenshot regression: avoid doubled DS2+DS3 brackets.
	for panel in [hud, wizard]:
		var old_chrome := panel.get_node_or_null("_MisdealChrome") as CanvasItem
		if old_chrome != null and old_chrome.visible:
			_fail("legacy thick DS2 corner chrome still double-drawn on DS3 bar")
			return
	# The original painterly table contains a fixed '22' in the left deck
	# footer. The live RunState number MUST be the only legible number there.
	var deck_mask := table.get_node("DeckCountMask") as ColorRect
	var deck_value := table.get_node("DeckCount") as Label
	if deck_mask.position.x > 149.0 or deck_mask.size.x < 69.0 or deck_mask.color.a < 0.97:
		_fail("D290 old printed deck number is not fully covered")
		return
	var expected_deck: int = state.remaining_card_ids.size()
	if not state.has_active_card():
		expected_deck = maxi(0, expected_deck - state.current_offer_ids.size())
	if deck_value.text != "%02d" % expected_deck:
		_fail("D290 real deck count accidentally changed while masking painted number")
		return
	if status.text.is_empty() or not status.text.contains("ЗОЛОТО") or wizard_line.text.is_empty():
		_fail("Table RunState live status/Wizard line missing")
		return

	var cards := [table.get_node("Cards/BonePatrolCard") as Button, table.get_node("Cards/GraveyardCard") as Button]
	var offers: Array = state.call("get_offer_cards")
	if offers.size() != 2:
		_fail("two-offer Fate Spread deal contract changed")
		return
	for card in cards:
		if not card.has_node("DS3CardFrame") or not card.has_node("DS3Roman") or card.get_node("Art").texture == null:
			_fail("approved painted encounter card art/paratext missing")
			return
		if card.size != Vector2(272, 338):
			_fail("existing card size changed")
			return
		if not card.has_signal("inspect_requested") or card.pressed.get_connections().is_empty():
			_fail("original choose/inspect callback disconnected")
			return
	for name in ["HoldAButton", "HoldBButton"]:
		var hold := table.get_node("Cards/" + name) as Button
		if hold.pressed.get_connections().is_empty():
			_fail("Hold action disconnected: " + name)
			return
	var fate_button := table.get_node("FateSpreadButton") as Button
	var squad_button := table.get_node("SquadButton") as Button
	if fate_button.pressed.get_connections().is_empty() or squad_button.pressed.get_connections().is_empty():
		_fail("Fate Spread or Squad button lost its action")
		return
	if fate_button.get_theme_stylebox("normal") == null or squad_button.get_theme_stylebox("hover") == null:
		_fail("DS3 buttons have missing interaction states")
		return
	if table.get_node("CardInspectHint").text.is_empty():
		_fail("RMB card lore affordance missing")
		return

	var wager := table.get_node("WagerOverlay/Root/WagerPanel") as Panel
	var accept := table.get_node("WagerOverlay/Root/WagerPanel/AcceptButton") as Button
	var refuse := table.get_node("WagerOverlay/Root/WagerPanel/RefuseButton") as Button
	if not wager.get_node_or_null("WagerPlate") is TextureRect:
		_fail("Wizard Wager V1 plate missing")
		return
	if accept.pressed.get_connections().is_empty() or refuse.pressed.get_connections().is_empty():
		_fail("real Wager accept/refuse actions disconnected")
		return
	if accept.get_theme_stylebox("disabled") == null or refuse.get_theme_stylebox("hover") == null:
		_fail("Wager DS3 button state incomplete")
		return

	await create_timer(1.0).timeout
	var save := preload("res://scripts/core/run_save_service.gd").instance()
	var before: Dictionary = save.snapshot(state).state
	table.archive_button.pressed.emit()
	if not table.has_table_modal() or not table._table_modal.opens_over_table:
		_fail("Archive must open over the live table")
		return
	table.get_node("MemoryTable").open_viewer()
	fate_button.pressed.emit()
	if is_instance_valid(table.get_node("MemoryTable").viewer) or is_instance_valid(table.fate_spread_overlay):
		_fail("Archive must own all table navigation")
		return
	table.close_table_modal()
	await process_frame
	await process_frame
	if table.has_table_modal() or save.snapshot(state).state != before:
		_fail("Closing the Archive changed run state")
		return

	print("D289_DS3_TABLE_NATIVE_PASS: exactly two live painted offers, real counters/Wizard, Fate Spread, Hold, Squad, Wager actions and DS3 peripheral chrome")
	table.queue_free()
	await process_frame
	quit(0)

func _fail(reason: String) -> void:
	push_error("D289_DS3_TABLE_FAIL: " + reason)
	quit(1)
