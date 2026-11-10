shader_type canvas_item;
render_mode unshaded;
uniform bool valley = false;
void fragment(){
	COLOR=texture(TEXTURE,UV);
	if(valley){
		COLOR.a *= (1.0-smoothstep(0.55,0.64,UV.y))*(1.0-smoothstep(0.44,0.55,UV.x));
	}else{
		// Original sky fringe is bluer and brighter than stone. Preserve warm
		// windows and dark masonry; let the independent sky show through gaps.
		float sky=smoothstep(0.085,0.115,COLOR.b-COLOR.r)*smoothstep(0.25,0.32,COLOR.g);
		COLOR.a *= 1.0-sky*(1.0-smoothstep(0.28,0.35,UV.y));
	}
}
