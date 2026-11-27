shader_type canvas_item;
render_mode unshaded;
uniform float elapsed = 0.0;
uniform float alpha = 0.16;
varying vec4 tint;
void vertex(){tint=COLOR;}
void fragment(){
	vec2 uv=UV+vec2(sin(UV.y*59.0+elapsed*2.25)*0.009,0.0);
	vec4 ink=texture(TEXTURE,uv);
	// Source bottom (now at the water line) stays strongest; broken tiles
	// and damp specular streaks dissolve away from the actual sole.
	float fade=smoothstep(0.26,0.91,UV.y);
	float breaks=0.55+0.45*smoothstep(0.1,0.45,abs(sin(UV.y*48.0+0.7)));
	COLOR=vec4(ink.rgb*vec3(0.44,0.50,0.55),ink.a*alpha*fade*breaks)*tint;
}
