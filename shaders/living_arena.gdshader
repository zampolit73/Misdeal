shader_type canvas_item;
render_mode unshaded;
uniform sampler2D region_mask : filter_linear, repeat_disable;
uniform sampler2D source_plate : filter_linear, repeat_disable;
uniform float elapsed = 0.0;
uniform int arena_mode = 0;
const vec2 PLATE = vec2(1280.0, 720.0);

// Bounded packets grow, crest and recede in place. No translating water sheet.
float packet(vec2 p, vec2 center, vec2 extent, float phase) {
	vec2 q = (p-center)/extent;
	float locality = exp(-dot(q,q)*2.0);
	float cycle = 0.5-0.5*cos(elapsed*0.79+phase);
	return locality*cycle*cycle*sin(p.x*0.027+p.y*0.19-elapsed*1.07+phase);
}
void fragment() {
	vec2 p = UV*PLATE;
	vec4 mask = texture(region_mask, UV);
	vec2 offset = vec2(0.0);
	float wave = 0.0;
	if (arena_mode == 2) {
		wave = packet(p,vec2(580.0,312.0),vec2(270.0,49.0),0.0)
			+packet(p,vec2(930.0,331.0),vec2(91.0,37.0),2.2)
			+packet(p,vec2(1160.0,328.0),vec2(145.0,35.0),4.3);
		offset = vec2(sin(elapsed*0.63+p.y*0.06)*0.42, wave*2.0)*mask.r;
	} else if (arena_mode == 3) {
		float weight = smoothstep(12.0,350.0,p.y);
		offset.x = (sin(elapsed*0.52+p.y*0.012)*1.25+sin(elapsed*0.31+p.y*0.021)*0.45)*weight*mask.r;
		offset.y = sin(elapsed*0.41+p.x*0.02)*0.25*mask.r;
	}
	vec4 original = texture(TEXTURE,UV);
	vec4 color = texture(source_plate,UV+offset/PLATE);
	// Modulate existing warm pixels; do not paint new flames or glow discs.
	float flicker = sin(elapsed*2.7+p.x*0.034)*0.026+sin(elapsed*4.13+p.y*0.053)*0.014;
	color.rgb *= 1.0+mask.b*flicker;
	if (arena_mode == 1) {
		float fog = (0.5+0.5*sin(p.x*0.018+p.y*0.031+sin(elapsed*0.17)*0.65))
			*(0.5+0.5*cos(p.x*0.009-p.y*0.022-elapsed*0.12));
		color.rgb = mix(color.rgb,vec3(0.31,0.37,0.41),mask.g*fog*0.055);
		color.rgb *= 1.0+mask.g*sin(elapsed*0.23)*0.009;
	} else if (arena_mode == 2) {
		// Reveal only foam already painted in the sea. Smooth breaking/recession.
		float foam = smoothstep(0.27,0.68,max(original.r,max(original.g,original.b)));
		color.rgb *= 1.0+mask.r*foam*max(0.0,wave)*0.065;
		// Rare distant cloud illumination, broad gentle rise/fall; no bolt/flash.
		float storm = pow(max(0.0,cos(elapsed*0.202+1.7)),64.0);
		color.rgb *= 1.0+mask.g*storm*0.028;
	}
	if (arena_mode != 2 && mask.a > 0.001) {
		float dust = 0.0;
		for (int i=0;i<8;i++) {
			float n = float(i);
			vec2 center;
			if (arena_mode == 1) center = vec2(632.0+mod(n*57.0,213.0),287.0+mod(n*29.0,62.0));
			else center = vec2(543.0+mod(n*37.0,126.0),169.0+mod(n*43.0,149.0));
			center += vec2(sin(elapsed*0.19+n)*7.0,sin(elapsed*0.13+n*2.7)*13.0);
			vec2 q = (p-center)/vec2(1.05,1.25);
			dust += exp(-dot(q,q)*2.0)*(0.5+0.5*sin(elapsed*0.37+n*2.0));
		}
		color.rgb += vec3(0.22,0.20,0.15)*dust*mask.a*0.24;
	}
	COLOR = vec4(color.rgb,original.a);
}
