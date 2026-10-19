shader_type canvas_item;
render_mode unshaded;

// D279R: local-only visual matte hides card/hold UI irreversibly BAKED
// into the old approved table_exact screenshot. Never modify real Table.
float rnd(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}
float smooth_noise(vec2 v) {
	vec2 cell = floor(v);
	vec2 f = fract(v);
	f = f*f*(3.0-2.0*f);
	return mix(
		mix(rnd(cell), rnd(cell+vec2(1.,0.)), f.x),
		mix(rnd(cell+vec2(0.,1.)), rnd(cell+vec2(1.,1.)), f.x),
		f.y
	);
}
void fragment() {
	vec2 uv=UV;
	float grain=smooth_noise(uv*vec2(73.0,44.0));
	float broad=smooth_noise(uv*vec2(11.0,7.0));
	vec3 redbrown=vec3(0.071,0.031,0.034);
	redbrown+=(grain-0.5)*vec3(0.037,0.017,0.015);
	redbrown+=(broad-0.5)*vec3(0.049,0.016,0.021);
	// Fine embossed circular traces recall the real table's ritual circle.
	float radius=length((uv-vec2(0.5))*vec2(1.0,1.52));
	float ring=1.0-smoothstep(0.002,0.008,abs(radius-0.42));
	ring+=0.55*(1.0-smoothstep(0.002,0.008,abs(radius-0.28)));
	redbrown+=vec3(0.083,0.011,0.013)*ring;
	float edge=min(min(uv.x,1.0-uv.x),min(uv.y,1.0-uv.y));
	float alpha=smoothstep(0.0,0.065,edge);
	COLOR=vec4(clamp(redbrown,vec3(0.028),vec3(0.18,0.08,0.09)),alpha);
}
