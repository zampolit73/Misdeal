extends RefCounted

# Reward/Shop reuse the approved table painting. Replace only its obsolete
# painted numeric/UI readouts with truthful passive native labels.
static func apply(scene: Control, context: String) -> void:
	if scene.has_node("BackdropReadouts"):
		refresh(scene)
		return
	var host := Control.new()
	host.name = "BackdropReadouts"
	host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scene.add_child(host)
	var at := Vector2(1113,25) if context == "НАГРАДА" else Vector2(1108,25)
	_label(host,"Context",context,at,Vector2(1240-at.x,37))
	_label(host,"Deck","",Vector2(148,539),Vector2(28,25))
	_label(host,"Discard","",Vector2(1168,539),Vector2(52,25))
	refresh(scene)

static func refresh(scene: Control) -> void:
	var host := scene.get_node_or_null("BackdropReadouts")
	if host == null:
		return
	var deck := RunState.remaining_card_ids.size()
	if not RunState.has_active_card():
		deck = maxi(0,deck-RunState.current_offer_ids.size())
	host.get_node("Deck").text = "%02d" % deck
	host.get_node("Discard").text = "%02d" % RunState.rejected_card_ids.size()

static func _label(parent: Control, name: String, text: String, at: Vector2, area: Vector2) -> void:
	var label := Label.new()
	label.name = name
	label.text = text
	label.position = at
	label.size = area
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size",12)
	label.add_theme_color_override("font_color",Color("dfb77e"))
	var matte := StyleBoxFlat.new()
	matte.bg_color = Color("100a0b")
	label.add_theme_stylebox_override("normal",matte)
	parent.add_child(label)
