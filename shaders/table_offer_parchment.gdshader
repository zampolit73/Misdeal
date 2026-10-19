shader_type canvas_item;
render_mode unshaded;

// D277: a deterministic, warmer handmade sheet. Broad uneven pigment,
// sparse foxing, fine fibres and irregular baked edges; no visual noise
// overprints the independent illustration or the Godot text controls.
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
	float patch = cloud(uv * vec2(6.0, 9.0) + vec2(3.1, 1.7));
	float grain_medium = cloud(uv * vec2(25.0, 36.0));
	float grain_fine = cloud(uv * vec2(92.0, 132.0));
	float fibres = grain(floor(uv * vec2(510.0, 610.0)));
	float foxing = cloud(uv * vec2(11.0, 14.0) + vec2(8.4, 4.3));
	float irregularity = (patch - 0.5) * 0.022;
	float edge = min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));
	float edge_burn = 1.0 - smoothstep(0.003, 0.112, edge + irregularity);
	float corners = (1.0 - smoothstep(0.04, 0.32, length(uv - vec2(0.0, 0.0)))) * 0.15;
	corners += (1.0 - smoothstep(0.04, 0.32, length(uv - vec2(1.0, 0.0)))) * 0.14;
	corners += (1.0 - smoothstep(0.04, 0.32, length(uv - vec2(0.0, 1.0)))) * 0.16;
	corners += (1.0 - smoothstep(0.04, 0.32, length(uv - vec2(1.0, 1.0)))) * 0.17;
	float stains = smoothstep(0.66, 0.89, foxing) * 0.16;
	vec3 paper = vec3(0.85, 0.737, 0.557);
	paper += vec3(0.13, 0.11, 0.072) * (patch - 0.5);
	paper += vec3(0.06, 0.046, 0.027) * (grain_medium - 0.5);
	paper += vec3(0.034, 0.027, 0.016) * (grain_fine - 0.5);
	paper += vec3(0.033, 0.025, 0.014) * (fibres - 0.5);
	paper -= vec3(0.21, 0.177, 0.118) * (edge_burn * 0.78 + corners + stains);
	COLOR = vec4(clamp(paper, vec3(0.29, 0.21, 0.14), vec3(0.94, 0.87, 0.73)), 1.0);
}
