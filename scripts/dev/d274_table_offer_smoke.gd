extends SceneTree

const SKIN := preload("res://scripts/table/table_offer_skin.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")

func _initialize() -> void:
	call_deferred("_verify")

func _verify() -> void:
	var scene := load("res://scenes/table/table.tscn") as PackedScene
	if scene == null:
		push_error("D274_TABLE_UI_FAIL: cannot load Table scene")
		quit(1)
		return
	var table := scene.instantiate() as Control
	if table == null:
		push_error("D274_TABLE_UI_FAIL: invalid Table root")
		quit(1)
		return
	var a := table.get_node("Cards/BonePatrolCard") as Button
	var b := table.get_node("Cards/GraveyardCard") as Button
	var ha := table.get_node("Cards/HoldAButton") as Button
	var hb := table.get_node("Cards/HoldBButton") as Button
	SKIN.prepare(a)
	SKIN.prepare(b)
	SKIN.style_hold_button(ha)
	SKIN.style_hold_button(hb)
	UI.apply_parchment_offer_card_frame(a)
	UI.apply_parchment_offer_card_frame(b, false, true, false)
	var valid := a.has_node("ParchmentFace") and b.has_node("ParchmentFace")
	valid = valid and a.size == Vector2(272.0, 338.0)
	valid = valid and b.size == Vector2(272.0, 338.0)
	valid = valid and a.has_node("ChooseFace") and b.has_node("ChooseFace")
	valid = valid and a.get_node("Art") is TextureRect and a.get_node("Hint") is Label
	valid = valid and ha.position.y == 295.0 and hb.position.y == 295.0
	valid = valid and SKIN.short_description("Длинное описание должно быть доступно для просмотра на карте.") != ""
	var lore := "ЛУННАЯ ПЕЧАТЬ\nСОБЫТИЕ\n\nВ погребальной чаше лежит серебряная печать. Она ещё помнит, кому должны были открыть склеп."
	var popup := a.call("_make_custom_tooltip", lore) as PanelContainer
	valid = valid and popup != null
	if popup != null:
		var copy := popup.get_node_or_null("LoreCopy") as Label
		valid = valid and copy != null and copy.text == lore
		valid = valid and popup.get_combined_minimum_size().x <= 350.0
		popup.free()
	valid = valid and ha.z_index > 20 and hb.z_index > 20
	if not valid:
		push_error("D274_TABLE_UI_FAIL: material or clickable nodes invalid")
		table.free()
		quit(1)
		return
	table.free()
	print("D274_TABLE_UI_PASS: two parchment offers, bounded full-lore tooltip, readable ink, hold tabs above hovered cards")
	quit(0)
