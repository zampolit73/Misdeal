extends GutTest
const PROFILE:=preload("res://scripts/memory/memory_profile.gd")
const VIEWER:=preload("res://scripts/memory/memory_viewer.gd")
func viewer(count: int) -> Control:
	var node:=VIEWER.new()
	node.profile=PROFILE.new()
	for index in range(count): node.profile.unlocked.append("SG%02d"%(index+1))
	add_child_autofree(node)
	return node
func test_locked_viewer_does_not_leak_or_unlock_content() -> void:
	var node:=viewer(0)
	node._select(PROFILE.catalog()[11])
	assert_eq(node.title_label.text,"Нераскрытая память")
	assert_false(node.reader.text.contains("Канцлер"))
	assert_false(node.closure_button.visible)
	assert_false(node.full_button.visible)
	var message: String=node.reader.text
	node._closure()
	node._full_closure()
	assert_eq(node.reader.text,message)
	assert_true(node.profile.unlocked.is_empty())
	assert_eq(node.page,2)
	assert_has(node.fragments,"SG12")
func test_all_fragments_readable_via_pages_and_art_without_mutating_profile() -> void:
	var node:=viewer(24)
	var before: Array=node.profile.unlocked.duplicate()
	for item in PROFILE.catalog():
		node._select(item)
		assert_has(node.fragments,item.id)
		assert_eq(node.title_label.text,item.title_ru)
		assert_true(node.reader.text.contains(item.memory_ru))
		assert_eq(node.group,item.group)
	assert_true(node.closure_button.visible)
	assert_true(node.full_button.visible)
	node._group("chronicle")
	node._turn_page(1)
	node._turn_page(1)
	assert_has(node.fragments,"SG12")
	assert_true(node.next.disabled)
	node._closure()
	assert_true(node.reader.text.contains("Замок был домом"))
	node._full_closure()
	assert_true(node.reader.text.contains("Канцлер"))
	assert_eq(node.profile.unlocked,before)
	assert_false(node.reader.get_global_rect().intersects(node.list.get_global_rect()))

func test_art_selection_and_scaled_layout_keep_the_same_fragment_mapping() -> void:
	var node:=viewer(24)
	var image: Image=(load("res://assets/story/a1v2/regions.png") as Texture2D).get_image()
	var region:=roundi(image.get_pixel(561,701).r*255)
	var event:=InputEventMouseButton.new()
	event.button_index=MOUSE_BUTTON_LEFT
	event.pressed=true
	event.position=node.art.size*0.5
	node._art_input(event)
	assert_eq(node.selected_id,"SG%02d"%region)
	node.set_anchors_preset(Control.PRESET_TOP_LEFT)
	node.size=Vector2(960,540)
	node._layout_canvas()
	assert_eq(node.canvas.scale,Vector2(0.75,0.75))
	assert_false(node.reader.get_global_rect().intersects(node.list.get_global_rect()))

