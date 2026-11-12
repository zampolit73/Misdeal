extends Node2D
## Only the residual loose strap moves; the squire is never deformed.
var outcome := "passed"
var strap: Sprite2D
func build(texture: Texture2D) -> void:
	strap=Sprite2D.new()
	strap.name="LooseLightPairStrap"
	strap.texture=texture
	strap.position=Vector2(859,535)
	strap.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(strap)
func update_time(time: float) -> void:
	strap.visible=outcome=="repair"
	strap.rotation=sin(time*1.7)*0.025
	strap.position=Vector2(859,535)+Vector2(sin(time*1.7)*0.45,0)
