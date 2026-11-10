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

func test_keyboard_focus_cycles_inside_modal() -> void:
	var node:=viewer(24)
	var event:=InputEventKey.new()
	event.keycode=KEY_TAB
	event.pressed=true
	for index in range(40):
		node._input(event)
		assert_true(node.is_ancestor_of(get_viewport().gui_get_focus_owner()))

func test_zoom_preserves_locked_pixels_selection_and_profile() -> void:
	for count in [0,7,24]:
		var node:=viewer(count)
		node._select(PROFILE.catalog()[6])
		var before: Array=node.profile.unlocked.duplicate()
		var selected: String=node.selected_id
		var page: int=node.page
		node._open_zoom()
		assert_eq(node.zoom_image.get_child_count(),count+1 if count<24 else 1)
		if count<24: assert_eq(node.zoom_image.get_child(0).modulate,Color(0.045,0.045,0.045))
		var wheel:=InputEventMouseButton.new()
		wheel.button_index=MOUSE_BUTTON_WHEEL_UP
		wheel.pressed=true
		wheel.position=node.zoom_clip.size*0.5
		node._zoom_gui_input(wheel)
		assert_gt(node.zoom_factor,1.0)
		node._native_zoom()
		node.zoom_dragging=true
		var motion:=InputEventMouseMotion.new()
		motion.relative=Vector2(0,50)
		node._input(motion)
		assert_gt(node.zoom_pan.y,0.0)
		node.zoom_dragging=false
		assert_almost_eq(node.zoom_image.scale.x,1.0,0.0001)
		node._set_zoom(100)
		assert_eq(node.zoom_factor,4.0)
		node.zoom_pan=Vector2(100000,100000)
		node._layout_zoom()
		var bounds: Vector2=((node.zoom_image.size*node.zoom_image.scale-node.zoom_clip.size)*0.5).max(Vector2.ZERO)
		assert_eq(node.zoom_pan,bounds)
		node._fit_zoom()
		assert_eq(node.zoom_pan,Vector2.ZERO)
		var event:=InputEventKey.new()
		event.keycode=KEY_ESCAPE
		event.pressed=true
		node._input(event)
		assert_false(is_instance_valid(node.zoom_layer))
		assert_false(node.is_queued_for_deletion())
		assert_eq(node.selected_id,selected)
		assert_eq(node.page,page)
		assert_eq(node.profile.unlocked,before)

func test_zoom_keyboard_focus_stays_in_inspector() -> void:
	var node:=viewer(24)
	node._open_zoom()
	var event:=InputEventKey.new()
	event.keycode=KEY_TAB
	event.pressed=true
	for index in range(20):
		node._input(event)
		assert_true(node.zoom_layer.is_ancestor_of(get_viewport().gui_get_focus_owner()))
	node._close_zoom()
