extends Node2D
## Bounded immediate-mode contact FX; local time only, no emitters or timers.
var feet: Array[Vector2] = []
var time := 0.0
var stride_period := 6.0 / 6.5
var contact_scales: Array[float] = []
var dust_direction := Vector2(-1,0)

func update_contacts(positions: Array[Vector2], local_time: float) -> void:
	feet.assign(positions)
	time = local_time
	queue_redraw()

func _draw() -> void:
	for i in range(feet.size()):
		var sole := feet[i]
		var perspective := contact_scales[i] if i<contact_scales.size() else 1.0
		draw_set_transform(sole + Vector2(-4,1)*perspective,0,Vector2(25,4.2)*perspective)
		for ring in range(6):
			draw_circle(Vector2.ZERO,1.0 - ring * 0.13,Color(0.018,0.022,0.03,0.035))
		draw_set_transform(Vector2.ZERO)
		# Two support contacts / stride. Four tiny motes/contact, pooled by math.
		var phase := fposmod(time + i * 0.17, stride_period * 0.5)
		if phase > 0.25 or time < 0.18: continue
		for mote in range(4):
			var age := phase + mote * 0.023
			var alpha := maxf(0.0,1.0 - age / 0.30) * 0.09 * minf(perspective,1.0)
			var point := sole + (dust_direction*(8+age*(20+mote*4))+Vector2(0,-1-sin(age*7)*(2+mote)))*perspective
			draw_circle(point,(0.7 + age * 2.0)*perspective,Color(0.57,0.53,0.45,alpha))
