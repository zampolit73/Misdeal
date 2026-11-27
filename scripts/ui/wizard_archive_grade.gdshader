shader_type canvas_item;
render_mode unshaded;

// The supplied archive textures are kept intact. Grade only the cabinet
// and old UI decoration; live artwork and text are separate CanvasItems.
uniform bool full_plate = false;
uniform bool illustration = false;
uniform sampler2D room : source_color, filter_linear;
uniform vec4 detail_rect = vec4(834.0, 168.0, 344.0, 514.0);

vec3 aged_bronze(vec3 c) {
	float luma = dot(c, vec3(0.299, 0.587, 0.114));
	float warm = smoothstep(0.035, 0.33, c.r - c.b);
	float gilt = warm * smoothstep(0.18, 0.62, c.g);
	// Low saturation copper, dark brown wood and muted wine fabric.
	vec3 material = mix(c, vec3(luma * 1.15, luma * 0.93, luma * 0.91), warm * 0.48);
	material = mix(material, vec3(luma * 1.13, luma * 0.85, luma * 0.74), gilt * 0.42);
	return material * (1.0 - warm * 0.11 - gilt * 0.14);
}

float region(vec2 p, vec4 r, float feather) {
	vec2 d = min(p - r.xy, r.xy + r.zw - p);
	return smoothstep(0.0, feather, min(d.x, d.y));
}

void fragment() {
	vec4 original = COLOR;
	vec3 color = aged_bronze(original.rgb);
	float alpha = original.a;
	if (full_plate) {
		vec2 pixel = UV * vec2(1280.0, 720.0);
		// Quiet stone behind the shared, native menu-derived chrome.
		// Cover the old skull, finials and tab borders without hiding the
		// outer curtains, window, bookcase, or the physical cabinet.
		float header = max(region(pixel, vec4(312.0, -14.0, 535.0, 125.0), 11.0),
			region(pixel, vec4(979.0, 39.0, 215.0, 61.0), 8.0));
		header = max(header, region(pixel, vec4(151.0, 102.0, 932.0, 65.0), 7.0));
		color = mix(color, texture(room, UV).rgb * 0.93, header);
		// The native detail plaque covers this area; quiet any old paper
		// that could otherwise peek through its transparent corners.
		float paper = smoothstep(0.38, 0.68, original.g) * smoothstep(0.53, 0.81, original.r);
		float detail = region(pixel, detail_rect, 3.0);
		color = mix(color, vec3(0.105, 0.088, 0.082) + color * 0.16, detail * paper);
	}
	if (illustration) {
		// Chronicle/challenge decorative landscapes are still sampled from
		// their approved plates. Drop the old paper and keep the ink visible.
		float paper = smoothstep(0.44, 0.74, original.g) * smoothstep(0.61, 0.85, original.r);
		alpha *= 1.0 - paper;
		color = mix(color, vec3(0.36, 0.27, 0.23), 0.22);
	}
	COLOR = vec4(color, alpha);
}
