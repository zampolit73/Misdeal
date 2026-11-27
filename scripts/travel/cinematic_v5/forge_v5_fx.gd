extends Node2D
## Small deterministic scene-local accents; no external FX dependency.
var elapsed := 0.0
var hits: Array[float] = []
var impact := Vector2.ZERO
func sample(time: float, strikes: Array[float], at: Vector2) -> void:
	elapsed = time
	hits.assign(strikes)
	impact = at
	queue_redraw()

func _draw() -> void:
	# Only the opening beyond the roof and wall receives live rain. The baked
	# painting stays intact. Several dim, subpixel-scale streaks imply movement.
	for i in 82:
		var x := 515.0+fposmod(float(i)*137.31,695.0)
		var sky_top := lerpf(236.0,132.0,(x-515.0)/695.0)
		var y := sky_top+fposmod(float(i)*53.1+elapsed*196.0, maxf(20.0,337.0-sky_top))
		draw_line(Vector2(x,y),Vector2(x-2.5,y+13.0),Color(0.68,0.77,0.84,0.12),1.0)
	for beat in hits:
		var age := elapsed-beat
		if age < 0.0 or age > 0.44:
			continue
		var fade := 1.0-age/0.44
		if age < 0.10:
			draw_circle(impact,7.0*(1.0-age/0.10),Color(1.0,0.67,0.28,0.36))
		for i in 15:
			var direction := lerpf(-2.75,-0.20,float(i)/14.0)+sin(float(i)*3.8)*0.12
			var speed := 50.0+fposmod(float(i)*43.2,128.0)
			var velocity := Vector2.from_angle(direction)*speed
			var p := impact+velocity*age+Vector2(0,130.0*age*age)
			draw_line(p-velocity.normalized()*3.5*fade,p,Color(1.0,0.66+0.17*fade,0.22,fade*0.9),1.5)
	# A few cinders rise directly from the furnace rather than covering actors.
	for i in 12:
		var u := fposmod(elapsed*0.48+float(i)*0.193,1.0)
		var p := Vector2(111.0+sin(float(i)*5.13+u*2.8)*31.0+u*11.0, 362.0-u*93.0)
		draw_circle(p,1.2,Color(1.0,0.46,0.13,sin(u*PI)*0.37))
