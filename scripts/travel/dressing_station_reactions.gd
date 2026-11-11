extends Node2D
## One cloth scrap, retained original props. All motion uses V2's local clock.
var outcome := "passed"
var scrap: Sprite2D
var scissors: Sprite2D
var rolls: Sprite2D

func build(scrap_texture: Texture2D, scissors_texture: Texture2D, rolls_texture: Texture2D) -> void:
	scrap = _prop("SingleFallingScrap",scrap_texture)
	scissors = _prop("RestingScissors",scissors_texture)
	scissors.position = Vector2(388,714)
	scissors.rotation = -0.24
	scissors.scale = Vector2.ONE*0.62
	rolls = _prop("ReceivedBandages",rolls_texture)
	rolls.position = Vector2(369,775)
	rolls.scale = Vector2.ONE*0.72

func _prop(id: String, texture: Texture2D) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = id
	sprite.texture = texture
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(sprite)
	return sprite

func update_time(time: float) -> void:
	scissors.visible = outcome=="standard"
	rolls.visible = outcome=="bandages"
	scrap.visible = outcome=="bandages" and time>=0.95
	# A single original fabric offcut settles beside the road, no emitter/timer.
	var u := clampf((time-0.95)/2.1,0,1)
	scrap.position = Vector2(420,240).bezier_interpolate(Vector2(577,360),Vector2(615,570),Vector2(858,804),u)
	scrap.position.x += sin(u*PI*3.0)*14.0*sin(u*PI)
	scrap.rotation = sin(u*PI*3.0)*0.45
	scrap.scale = Vector2(0.65+0.2*sin(u*PI),0.7+0.3*absf(cos(u*PI*3.0)))
