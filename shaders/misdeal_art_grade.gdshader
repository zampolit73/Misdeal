shader_type canvas_item;

uniform float pixel_block : hint_range(1.0, 4.0, 1.0) = 2.0;
uniform float grade_strength : hint_range(0.0, 1.0) = 0.72;
uniform float saturation : hint_range(0.0, 1.2) = 0.72;
uniform float contrast : hint_range(0.6, 1.4) = 1.08;
uniform float poster_steps : hint_range(4.0, 20.0, 1.0) = 10.0;

vec3 misdeal_tone(float luma) {
	vec3 shadow = vec3(0.020, 0.016, 0.026);
	vec3 dark = vec3(0.095, 0.085, 0.105);
	vec3 mid = vec3(0.255, 0.235, 0.220);
	vec3 bone = vec3(0.670, 0.610, 0.500);

	if (luma < 0.26) {
		return mix(shadow, dark, luma / 0.26);
	}
	if (luma < 0.62) {
		return mix(dark, mid, (luma - 0.26) / 0.36);
	}
	return mix(mid, bone, clamp((luma - 0.62) / 0.38, 0.0, 1.0));
}

void fragment() {
	vec4 vertex_color = COLOR;
	vec2 sample_uv = UV;
	if (pixel_block > 1.0) {
		vec2 block = TEXTURE_PIXEL_SIZE * pixel_block;
		sample_uv = (floor(UV / block) + vec2(0.5)) * block;
	}

	vec4 source = texture(TEXTURE, sample_uv);
	vec3 color = source.rgb;
	float luma = dot(color, vec3(0.299, 0.587, 0.114));

	color = mix(vec3(luma), color, saturation);
	color = clamp((color - vec3(0.5)) * contrast + vec3(0.5), 0.0, 1.0);

	float red_accent = max(color.r - max(color.g, color.b), 0.0);
	float teal_accent = max(min(color.g, color.b) - color.r, 0.0);
	float gold_accent = max(min(color.r, color.g) - color.b, 0.0);

	vec3 graded = misdeal_tone(luma);
	graded += vec3(0.62, 0.10, 0.055) * red_accent * 1.45;
	graded += vec3(0.035, 0.48, 0.43) * teal_accent * 1.35;
	graded += vec3(0.46, 0.31, 0.075) * gold_accent * 0.85;
	graded = clamp(graded, 0.0, 1.0);
	graded = floor(graded * poster_steps + vec3(0.5)) / poster_steps;

	vec3 final_rgb = mix(source.rgb, graded, grade_strength);
	COLOR = vec4(final_rgb, source.a) * vertex_color;
}
