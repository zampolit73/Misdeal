shader_type canvas_item;
render_mode unshaded;

// D281: preserve the existing Misdeal wordmark's ivory ink and ruby accent,
// not the dark screenshot rectangle embedded in its PNG background.
// Use only on the hero-choice logo; leave the original Table assets intact.
void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float brightness = max(tex.r, max(tex.g, tex.b));
	float ivory = smoothstep(0.31, 0.52, brightness) * smoothstep(0.14, 0.27, tex.g);
	float ruby = smoothstep(0.23, 0.46, tex.r - tex.g * 0.58) * (1.0 - smoothstep(0.19, 0.35, tex.g));
	float foreground = max(ivory, ruby);
	COLOR = vec4(tex.rgb, tex.a * foreground);
}
