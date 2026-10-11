extends RefCounted

# Pack 2 / Stage A: short attack-contact accents for the four undead roles
# that still use static v4 artwork. These are NOT sprite-frame animations
# or telegraphs: damage continues to resolve at the attack trigger.
# Effects only use native Godot Line2D + Tween and free themselves.

const FLOOR_Y := 36.0
const CHEST_Y := -17.0
const ARC_SEGMENTS := 28


static func spawn(role: String, canvas: Node, target_position: Vector2) -> void:
	if canvas == null:
		return

	match role:
		"grave_bellkeeper":
			# Bell's metallic resonance blooms across the ground.
			var floor_position := target_position + Vector2(0.0, FLOOR_Y)
			_ring(canvas, floor_position, Color(0.54, 0.88, 0.70, 0.76), 21.0, 0.27, 0.32)
			_ring(canvas, floor_position, Color(0.90, 0.76, 0.46, 0.42), 30.0, 0.36, 0.25)
		"bone_thrall":
			# A quick, close-range pair of bone-claw cuts.
			var center := target_position + Vector2(0.0, CHEST_Y)
			_stroke(canvas, center + Vector2(-12.0, 7.0), center + Vector2(8.0, -13.0), Color(0.93, 0.77, 0.60, 0.82), 2.5, 0.17)
			_stroke(canvas, center + Vector2(-3.0, 11.0), center + Vector2(15.0, -8.0), Color(0.92, 0.47, 0.31, 0.62), 1.6, 0.21)
		"crypt_guard":
			# Heavy shield impact: restrained bronze cross at contact.
			var center := target_position + Vector2(0.0, CHEST_Y)
			_stroke(canvas, center + Vector2(-10.0, -11.0), center + Vector2(10.0, 11.0), Color(0.96, 0.68, 0.36, 0.86), 2.7, 0.19)
			_stroke(canvas, center + Vector2(9.0, -10.0), center + Vector2(-9.0, 10.0), Color(0.91, 0.85, 0.68, 0.52), 1.8, 0.23)
		"bone_warden":
			# A compact double ground-impact pulse for the boss.
			var floor_position := target_position + Vector2(0.0, FLOOR_Y)
			_ring(canvas, floor_position, Color(1.0, 0.45, 0.22, 0.74), 28.0, 0.25, 0.30)
			_ring(canvas, floor_position, Color(0.85, 0.58, 0.35, 0.43), 40.0, 0.36, 0.26)
			var center := target_position + Vector2(0.0, CHEST_Y)
			_stroke(canvas, center + Vector2(-14.0, -12.0), center + Vector2(12.0, 12.0), Color(0.94, 0.72, 0.45, 0.70), 3.0, 0.19)
		_:
			pass


static func _ring(parent: Node, origin: Vector2, color: Color, radius: float, lifetime: float, flatten: float) -> void:
	var ring := Line2D.new()
	ring.width = 1.8
	ring.default_color = color
	ring.z_index = 1900
	ring.position = origin
	ring.scale = Vector2(0.70, 0.70)
	var points := PackedVector2Array()
	for index in range(ARC_SEGMENTS + 1):
		var theta := TAU * float(index) / float(ARC_SEGMENTS)
		points.append(Vector2(cos(theta) * radius, sin(theta) * radius * flatten))
	ring.points = points
	parent.add_child(ring)
	var tween := ring.create_tween()
	tween.set_parallel(true)
	tween.tween_property(ring, "scale", Vector2.ONE * 1.28, lifetime).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(ring, "modulate:a", 0.0, lifetime)
	tween.chain().tween_callback(ring.queue_free)


static func _stroke(parent: Node, start_point: Vector2, end_point: Vector2, color: Color, width: float, lifetime: float) -> void:
	var stroke := Line2D.new()
	stroke.default_color = color
	stroke.width = width
	stroke.z_index = 1900
	stroke.points = PackedVector2Array([start_point, end_point])
	parent.add_child(stroke)
	var tween := stroke.create_tween()
	tween.tween_property(stroke, "modulate:a", 0.0, lifetime)
	tween.tween_callback(stroke.queue_free)
