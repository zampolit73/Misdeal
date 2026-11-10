shader_type canvas_item;
render_mode unshaded;
uniform float elapsed=0.0;
void fragment(){
	// Cloth interior only. Fade displacement to zero before the silhouette,
	// pole and surrounding masonry; stone never receives wind distortion.
	float ymask=smoothstep(0.18,0.22,UV.y)*(1.0-smoothstep(0.52,0.565,UV.y));
	float centre=mix(0.891,0.881,clamp((UV.y-0.18)/0.39,0.0,1.0));
	float xmask=1.0-smoothstep(0.012,0.023,abs(UV.x-centre));
	float shift=ymask*xmask*sin(elapsed*0.75+UV.y*18.0)*0.00065;
	COLOR=texture(TEXTURE,UV+vec2(shift,0.0));
	float sky=smoothstep(0.085,0.115,COLOR.b-COLOR.r)*smoothstep(0.25,0.32,COLOR.g);
	COLOR.a *= 1.0-sky*(1.0-smoothstep(0.44,0.55,UV.y));
}
