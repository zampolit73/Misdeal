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
	var hud_style := hud.get_theme_stylebox("panel") as StyleBoxFlat
	if hud_style == null or hud_style.border_width_left != 1 or hud_style.bg_color.a < 0.90:
		_fail("DS3 top bar not applied to real Table")
		return
	var wizard_style := wizard.get_theme_stylebox("panel") as StyleBoxFlat
	if wizard_style == null or wizard_style.border_width_left != 1:
		_fail("DS3 Wizard commentary plate absent")
		return
	if hud.get_node_or_null("StatusDS3EdgeTop") == null or wizard.get_node_or_null("WizardDS3Seal") == null:
		_fail("restrained bronze edge details missing")
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
		if not card.has_node("IllustratedFrame") or not card.has_node("ParchmentFace") or card.get_node("Art").texture == null:
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
	if wager.get_node_or_null("WagerDS3EdgeTop") == null:
		_fail("DS3 Wager ornament missing")
		return
	if accept.pressed.get_connections().is_empty() or refuse.pressed.get_connections().is_empty():
		_fail("real Wager accept/refuse actions disconnected")
		return
	if accept.get_theme_stylebox("disabled") == null or refuse.get_theme_stylebox("hover") == null:
		_fail("Wager DS3 button state incomplete")
		return

	print("D289_DS3_TABLE_NATIVE_PASS: exactly two live painted offers, real counters/Wizard, Fate Spread, Hold, Squad, Wager actions and DS3 peripheral chrome")
	table.queue_free()
	await process_frame
	quit(0)

func _fail(reason: String) -> void:
	push_error("D289_DS3_TABLE_FAIL: " + reason)
	quit(1)
