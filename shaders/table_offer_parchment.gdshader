shader_type canvas_item;
render_mode unshaded;

float grain(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}
float cloud(vec2 p) {
	vec2 cell = floor(p);
	vec2 t = fract(p);
	t = t * t * (3.0 - 2.0 * t);
	float a = grain(cell);
	float b = grain(cell + vec2(1.0, 0.0));
	float c = grain(cell + vec2(0.0, 1.0));
	float d = grain(cell + vec2(1.0, 1.0));
	return mix(mix(a, b, t.x), mix(c, d, t.x), t.y);
}
void fragment() {
	vec2 uv = UV;
	float coarse = cloud(uv * vec2(13.0, 21.0));
	float medium = cloud(uv * vec2(43.0, 67.0));
	float fibre = grain(floor(uv * vec2(480.0, 580.0)));
	float stains = cloud(uv * vec2(5.0, 7.0) + vec2(2.7, 9.3));
	float edge = min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));
	float scorch = 1.0 - smoothstep(0.002, 0.105, edge);
	float blotches = smoothstep(0.55, 0.95, stains) * 0.14;
	vec3 paper = vec3(0.79, 0.66, 0.48);
	paper += vec3(0.09, 0.073, 0.054) * (coarse - 0.5);
	paper += vec3(0.06, 0.051, 0.038) * (medium - 0.5);
	paper += vec3(0.045, 0.037, 0.022) * (fibre - 0.5);
	paper -= vec3(0.19, 0.15, 0.10) * (scorch * 0.70 + blotches);
	COLOR = vec4(clamp(paper, vec3(0.23), vec3(0.94)), 1.0);
}
