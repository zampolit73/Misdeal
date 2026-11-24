shader_type canvas_item;
render_mode unshaded;

float candle_mask(vec2 uv, vec2 center) {
	vec2 offset = (uv - center) * vec2(1.78, 1.0);
	return 1.0 - smoothstep(0.015, 0.105, length(offset));
}

void fragment() {
	vec4 library = COLOR;
	float left = candle_mask(UV, vec2(0.105, 0.413));
	float right = candle_mask(UV, vec2(0.906, 0.413));
	float flicker = left * (0.045 * sin(TIME * 5.8) + 0.03 * sin(TIME * 9.3));
	flicker += right * (0.055 * sin(TIME * 6.3 + 2.1) + 0.02 * sin(TIME * 11.1));
	COLOR = vec4(library.rgb * (1.0 + flicker * vec3(1.0, 0.68, 0.38)), library.a);
}
