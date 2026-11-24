shader_type canvas_item;
render_mode unshaded;

varying vec4 tint;

void vertex() {
	tint = COLOR;
}

void fragment() {
	vec4 plate = texture(TEXTURE, UV);
	vec3 base = plate.rgb;
	// The existing frame contains gold, red cloth and pale parchment.
	// Grade each material from its color so the expanded frame also works.
	float gold = smoothstep(0.30, 0.58, base.g / max(base.r, 0.001));
	float paper = smoothstep(0.50, 0.74, base.b / max(base.r, 0.001));
	float light = dot(base, vec3(0.299, 0.587, 0.114));
	vec3 burgundy = mix(base, light * vec3(1.28, 0.65, 0.71), 0.53) * 0.78;
	vec3 bronze = mix(base, light * vec3(1.18, 0.99, 0.82), 0.48) * 0.77;
	vec3 parchment = mix(base, light * vec3(1.10, 0.99, 0.88), 0.35) * 0.91;
	COLOR = vec4(mix(mix(burgundy, bronze, gold), parchment, paper), plate.a) * tint;
}
