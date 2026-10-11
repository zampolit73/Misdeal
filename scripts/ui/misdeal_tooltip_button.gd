extends Button

# Opt-in reusable Button with the native Godot tooltip lifecycle.
# Existing controls keep their standard tooltip behavior until migrated.
const UI := preload("res://scripts/ui/misdeal_ui_kit.gd")

@export var tooltip_accent: Color = Color(0.42, 0.60, 0.72, 1.0)


func _make_custom_tooltip(for_text: String) -> Object:
	return UI.make_tooltip(for_text, tooltip_accent)
