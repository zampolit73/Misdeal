extends Node2D

# D209 footprint and 2x silhouette clearance envelopes only.
const FLOOR_SCREEN := Rect2(Vector2(110.0, 380.0), Vector2(1080.0, 158.0))
var show_floor_guide: bool = false
var heroes: Array[Vector2] = []
var enemies: Array[Vector2] = []

func configure(hero_points: Array[Vector2], enemy_points: Array[Vector2]) -> void:
	heroes = hero_points.duplicate()
	enemies = enemy_points.duplicate()
	queue_redraw()

func _draw() -> void:
	if show_floor_guide:
		draw_rect(FLOOR_SCREEN, Color(0.44, 0.75, 0.46, 0.10))
		draw_rect(FLOOR_SCREEN, Color(0.47, 0.81, 0.53, 0.76), false, 1.0)
	for foot in heroes:
		_draw_actor(foot, 68.0, 25.0, Color(0.51, 0.77, 0.97))
	for i in range(enemies.size()):
		_draw_actor(enemies[i], 175.0 if i == 0 else 76.0, 52.0 if i == 0 else 27.0, Color(0.96, 0.72, 0.42))

func _draw_actor(foot: Vector2, height_px: float, width_px: float, outline: Color) -> void:
	var box := Rect2(foot.x - width_px * 0.5, foot.y - height_px, width_px, height_px)
	draw_circle(foot + Vector2(0.0, 4.0), 15.0, Color(0.0, 0.0, 0.0, 0.62))
	draw_rect(box, Color(0.04, 0.04, 0.06, 0.28))
	draw_rect(box, outline, false, 2.0)
	draw_line(foot + Vector2(-13.0, 0.0), foot + Vector2(13.0, 0.0), outline, 2.0)
