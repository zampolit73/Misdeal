shader_type canvas_item;
render_mode unshaded;
void fragment(){
	COLOR=texture(TEXTURE,UV);
	// Natural skyline from the reconstruction plate. Exact visible original
	// mountain pixels are overlaid above it; this supplies occluded terrain.
	float peak=0.23-0.16*exp(-pow((UV.x-0.66)/0.105,2.0));
	COLOR.a*=smoothstep(peak-0.006,peak+0.008,UV.y);
}
