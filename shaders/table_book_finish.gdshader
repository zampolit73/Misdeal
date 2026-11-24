shader_type canvas_item;
render_mode unshaded;

uniform bool contact_shadow = false;

void fragment() {
	vec4 paint = COLOR;
	if (contact_shadow) {
		vec2 step_uv = TEXTURE_PIXEL_SIZE * 1.8;
		float edge = (texture(TEXTURE, UV + vec2(step_uv.x, 0.0)).a
			+ texture(TEXTURE, UV - vec2(step_uv.x, 0.0)).a
			+ texture(TEXTURE, UV + vec2(0.0, step_uv.y)).a
			+ texture(TEXTURE, UV - vec2(0.0, step_uv.y)).a) * 0.25;
		COLOR = vec4(vec3(0.019, 0.010, 0.012), edge * 0.52);
	} else {
		float warm_metal = smoothstep(0.33, 0.75, paint.r)
			* smoothstep(0.16, 0.47, paint.g);
		float luminance = dot(paint.rgb, vec3(0.299, 0.587, 0.114));
		vec3 patina = mix(paint.rgb, vec3(luminance), 0.25) * vec3(0.74, 0.78, 0.83);
		COLOR = vec4(mix(paint.rgb, patina, warm_metal), paint.a);
	}
}
