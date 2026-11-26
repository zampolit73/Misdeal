shader_type canvas_item;
render_mode unshaded;

varying vec4 tint;

void vertex() {
	tint = COLOR;
}

void fragment() {
	vec2 pixel = UV * vec2(1280.0, 720.0);
	vec2 flame = pixel - vec2(1202.5, 358.0);
	vec2 sample_uv = UV;
	float sway = sin(TIME * 6.7) * 0.65 + sin(TIME * 11.3) * 0.36;
	float falloff = 1.0 - smoothstep(0.3, 1.0, length(flame / vec2(13.0, 23.0)));
	float wick_weight = 1.0 - smoothstep(2.0, 15.0, flame.y);
	sample_uv.x += sway * falloff * wick_weight / 1280.0;
	vec4 paint = texture(TEXTURE, sample_uv);
	float glow = 1.0 - smoothstep(0.05, 1.0, length(flame / vec2(39.0, 42.0)));
	float flicker = sin(TIME * 7.1) * 0.035 + sin(TIME * 13.6) * 0.021;
	paint.rgb *= 1.0 + glow * flicker;
	COLOR = paint * tint;
}
