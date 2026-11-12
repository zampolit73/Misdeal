extends Node2D
## Readable hush-money pile on the desk; presentation only, no rewards.
var outcome := "passed"
var coins: Sprite2D
var elapsed := 0.0
func build(coin_texture: Texture2D, rect: Array) -> void:
	coins=Sprite2D.new()
	coins.texture=coin_texture
	coins.centered=false
	coins.position=Vector2(rect[0],rect[1])
	add_child(coins)
func update_time(time: float) -> void:
	elapsed=time
	# Bribe must remain readable for the whole shot, not disappear under an
	# unrelated foreground plate. Original ledger and pile share one plane.
	coins.visible=outcome=="silence"
	queue_redraw()
func _draw() -> void:
	# Sparse dust within existing cold roof beams, not animated straw soldiers.
	for i in range(14):
		var x := 1255.0+fposmod(i*27.0+sin(elapsed*0.3+i)*3.0,210.0)
		var y := 120.0+fposmod(i*41.0+elapsed*5.0,300.0)
		draw_circle(Vector2(x,y),0.7,Color(0.72,0.72,0.67,0.07+0.025*sin(i+elapsed)))
