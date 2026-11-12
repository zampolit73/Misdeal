extends Node2D
## Source brass coins disappear under the existing ledger edge; no rewards.
var outcome := "passed"
var coins: Sprite2D
var edge: Sprite2D
var elapsed := 0.0
func build(coin_texture: Texture2D, edge_texture: Texture2D, edge_rect: Array) -> void:
	coins=Sprite2D.new()
	coins.texture=coin_texture
	coins.position=Vector2(497,755)
	add_child(coins)
	edge=Sprite2D.new()
	edge.texture=edge_texture
	edge.centered=false
	edge.position=Vector2(edge_rect[0],edge_rect[1])
	add_child(edge)
func update_time(time: float) -> void:
	elapsed=time
	coins.visible=outcome=="silence"
	edge.visible=coins.visible
	coins.position=Vector2(497-16*smoothstep(0.45,2.4,time),755-4*smoothstep(0.45,2.4,time))
	queue_redraw()
func _draw() -> void:
	# Sparse dust within existing cold roof beams, not animated straw soldiers.
	for i in range(14):
		var x := 1255.0+fposmod(i*27.0+sin(elapsed*0.3+i)*3.0,210.0)
		var y := 120.0+fposmod(i*41.0+elapsed*5.0,300.0)
		draw_circle(Vector2(x,y),0.7,Color(0.72,0.72,0.67,0.07+0.025*sin(i+elapsed)))
