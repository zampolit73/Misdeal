extends SceneTree

# D308 - opens the actual F6 preview scene (with real production D307 art
# and layout methods), changes its visible conditions, and never saves a run.
const PREVIEW := "res://scenes/dev/d308_wizard_panel_preview.tscn"

func _initialize() -> void:
	call_deferred("_verify")


func _verify() -> void:
	var packed := load(PREVIEW) as PackedScene
	if packed == null:
		_fail("test scene not loadable")
		return
	var scene := packed.instantiate() as Control
	root.add_child(scene)
	await process_frame
	var panel := scene.get_node("SideObjectivePanel") as Panel
	var original := scene.get_node("SideObjectivePanel/ObjectiveLabel") as Label
	var art := panel.get_node_or_null("D307WizardArt") as Control
	if art == null or art.get("art_texture") == null:
		_fail("approved D307 binary art did not load in the F6 scene")
		return
	if art.size != Vector2(258, 138) or art.position != Vector2(-16, -14):
		_fail("D311 F6 art failed to stay inside a compact fixed-size canvas")
		return
	var initial_bounds := Rect2(panel.position + art.position, art.size)
	if initial_bounds.position.y < 0 or initial_bounds.end.y > 720 or initial_bounds.end.x > 330:
		_fail("D311 F6 art clips beyond the 720px preparation viewport")
		return
	if art.mouse_filter != Control.MOUSE_FILTER_IGNORE:
		_fail("D307 art can intercept preview controls")
		return
	var header := panel.get_node("D307WizardHeading") as Label
	var body := panel.get_node("D307WizardBody") as Label
	if not original.text.contains("Звонарь должен пасть первым") or header.text != "УСЛОВИЕ ВОЛШЕБНИКА":
		_fail("native default Grave Bell wording missing")
		return
	var reward := panel.get_node_or_null("D312WizardReward") as Label
	if reward == null or not reward.visible or reward.text != "+15 золота" or original.visible:
		_fail("D312 live reward inset missing or old source Label visible")
		return
	if body.text.contains("+15 золота") or body.position != Vector2(56, 44) or reward.position != Vector2(65, 80):
		_fail("D312 reward overlaps original rule body")
		return
	if header.position != Vector2(63, 9):
		_fail("D312 title inset no longer aligned with approved medallion")
		return
	var rule_rect := Rect2(body.position, body.size)
	var bonus_rect := Rect2(reward.position, reward.size)
	if rule_rect.intersects(bonus_rect) or bonus_rect.end.y > 96.0:
		_fail("D313 bonus still crosses main rule or bottom ornament")
		return
	if reward.size.y < 15 or body.size.y < 32:
		_fail("D313 live two-line rule or reward has insufficient label space")
		return
	if panel.position != Vector2(22, 571):
		_fail("D312 preview preparation position differs from live Battle")
		return
	var picker := scene.get_node("PreviewTools/RulePicker") as OptionButton
	if picker.item_count != 3:
		_fail("not all three actual Wizard objective text lengths are offered")
		return
	scene.call("_set_phase", true)
	if panel.position != Vector2(98, 165) or not panel.visible:
		_fail("combat preview does not use original D306 geometry")
		return
	var combat_bounds := Rect2(panel.position + art.position, art.size)
	if combat_bounds.end.x > 345 or combat_bounds.end.y > 320:
		_fail("D311 F6 combat artwork grew past its designated corner")
		return
	scene.call("_set_outcome", 1)
	if header.text != "УСЛОВИЕ ВЫПОЛНЕНО" or not body.text.contains("Звонарь пал первым"):
		_fail("success is not reflected in both live art wells")
		return
	if reward.visible:
		_fail("D312 success description should not duplicate a floating reward")
		return
	scene.call("_set_outcome", 2)
	if header.text != "УСЛОВИЕ ПРОВАЛЕНО" or not body.text.contains("первым пал не звонарь"):
		_fail("failure is not reflected in both live art wells")
		return
	if reward.visible:
		_fail("D312 failed condition incorrectly shows gold")
		return
	scene.call("_on_rule_selected", 1)
	if header.text != "УСЛОВИЕ ВОЛШЕБНИКА" or not body.text.contains("25% HP"):
		_fail("the health limit preview was not restored")
		return
	if not reward.visible or reward.text != "+15 золота":
		_fail("D312 reward did not return for the health objective")
		return
	scene.call("_on_rule_selected", 2)
	if not body.text.contains("16 сек"):
		_fail("the production fast-crush condition was not restored")
		return
	if not reward.visible or reward.text != "+15 золота":
		_fail("D312 gold reward lost on timed condition")
		return
	scene.call("_set_phase", false)
	if panel.position != Vector2(22, 571):
		_fail("D312 preparation location did not restore")
		return
	if (scene.get_node("PreviewTools/RealBattleButton") as Button).pressed.get_connections().is_empty():
		_fail("real Battle launch has no connected button")
		return
	print("D308_WIZARD_PREVIEW_NATIVE_PASS: D312 typography and live reward, 3 rules, all phases and outcomes")
	scene.queue_free()
	await process_frame
	quit(0)


func _fail(reason: String) -> void:
	push_error("D308_WIZARD_PREVIEW_FAIL: " + reason)
	quit(1)
