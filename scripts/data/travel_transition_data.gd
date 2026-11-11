extends Resource
class_name TravelTransitionData
@export var title := "Тропа вдоль мёртвых стен"
@export_file("*.png") var background_path := "res://assets/pixel/travel/ruined_castle_road/source.png"
@export_file("*.png") var foreground_path := "res://assets/pixel/travel/ruined_castle_road/foreground.png"
@export_file("*.png") var underpaint_path := "res://assets/pixel/travel/ruined_castle_road/underpaint.png"
@export_file("*.png") var sky_path := "res://assets/pixel/travel/ruined_castle_road/sky.png"
@export_range(3.0,5.0) var duration_sec := 4.0
@export var panorama_script: Script = preload("res://scripts/travel/travel_panorama.gd")
@export var party_origin := Vector2(420,604)
@export var party_spacing := 120.0
@export var party_depth_step := -3.0
@export var party_scale := 1.0
@export var party_tint := Color(0.86,0.89,0.94)
@export var fog_rect := Rect2(0,260,1280,205)
