extends Button

# D275: inspect lore only by an intentional secondary action. A hover tooltip
# (even wrapped) hid both cards and their choice actions at 1280x720.
signal inspect_requested

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var click := event as InputEventMouseButton
		if click.button_index == MOUSE_BUTTON_RIGHT and click.pressed and not disabled:
			accept_event()
			inspect_requested.emit()
