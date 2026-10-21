extends SceneTree

const SKIN := preload("res://scripts/table/table_offer_skin.gd")
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")
const LORE_SCENE := preload("res://scenes/table/card_lore_inspect.tscn")

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
	# D315: approval superseded the historical DS2 parchment art.
	var valid := a.has_node("DS3CardFrame") and b.has_node("DS3CardFrame")
	valid = valid and a.size == Vector2(272, 338) and b.size == Vector2(272, 338)
	for card in [a, b]:
		var skin := card.get_node_or_null("DS3CardFrame") as TextureRect
		valid = valid and skin != null and skin.texture != null
		if skin != null and skin.texture != null:
			var pixels: Image = skin.texture.get_image()
			valid = valid and pixels.get_size() == Vector2i(375, 509)
			valid = valid and pixels.get_pixel(200, 200).a < 0.05
			valid = valid and skin.mouse_filter == Control.MOUSE_FILTER_IGNORE
		valid = valid and card.get_node_or_null("DS3Roman") != null
	valid = valid and a.get_node("Art") is TextureRect and a.get_node("Hint") is Label
	valid = valid and ha.position.y == 295.0 and hb.position.y == 295.0
	valid = valid and SKIN.short_description("Длинное описание должно быть доступно для просмотра на карте.") != ""
	var lore := "ЛУННАЯ ПЕЧАТЬ\nСОБЫТИЕ\n\nВ погребальной чаше лежит серебряная печать. Она ещё помнит, кому должны были открыть склеп."
	valid = valid and a.has_signal("inspect_requested") and b.has_signal("inspect_requested")
	var inspect := LORE_SCENE.instantiate() as Control
	root.add_child(inspect)
	inspect.call("present", "ЛУННАЯ ПЕЧАТЬ", "СОБЫТИЕ", lore, null, "")
	var body := inspect.get_node_or_null("Frame/FullDescription") as RichTextLabel
	valid = valid and body != null and body.text == lore
	valid = valid and inspect.get_node_or_null("Frame/CloseButton") != null
	var modal_frame := inspect.get_node_or_null("Frame") as Panel
	valid = valid and modal_frame != null
	if modal_frame != null:
		valid = valid and modal_frame.size == Vector2(720.0, 364.0)
		valid = valid and modal_frame.position == Vector2(280.0, 178.0)
		valid = valid and modal_frame.get_node_or_null("ArtHint") == null
		valid = valid and modal_frame.get_node_or_null("ArtEmblem") != null
		valid = valid and modal_frame.get_node_or_null("InnerBronzeFrame") != null
		valid = valid and modal_frame.get_node_or_null("ChapterSeal") != null
	valid = valid and a.tooltip_text.is_empty() and b.tooltip_text.is_empty()
	valid = valid and ha.z_index > 20 and hb.z_index > 20
	inspect.queue_free()
	if not valid:
		push_error("D274_TABLE_UI_FAIL: material or clickable nodes invalid")
		table.free()
		quit(1)
		return
	table.free()
	print("D278_TABLE_UI_PASS: artist-authored transparent frame on both real Buttons, live copy and LMB/RMB preserved")
	quit(0)
