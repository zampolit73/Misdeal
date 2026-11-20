shader_type canvas_item;
render_mode unshaded;
uniform sampler2D region_mask : filter_linear, repeat_disable;
uniform sampler2D source_plate : filter_linear, repeat_disable;
uniform float elapsed = 0.0;
uniform int arena_mode = 0;
uniform vec4 haze_style = vec4(0.0);
uniform vec4 mote_area = vec4(0.0);
uniform float mote_strength = 0.0;
uniform float phase_strength = 0.0;
uniform float cycle_seconds = 24.0;
// Profile: wind direction, turbulence, source-light strength, local sway (px).
uniform vec4 local_motion = vec4(0.0);
uniform float wave_strength = 0.0;
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
	vec4 color = arena_mode >= 4 ? original : texture(source_plate,UV+offset/PLATE);
	// Modulate existing warm pixels; do not paint new flames or glow discs.
	if (arena_mode < 4 || (arena_mode == 4 && mask.b > 0.0)) {
		float flicker = sin(elapsed*2.7+p.x*0.034)*0.026+sin(elapsed*4.13+p.y*0.053)*0.014;
		color.rgb *= 1.0+mask.b*flicker;
	}
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
	} else if (arena_mode == 4) {
		if (mask.g > 0.001) {
			// Two broad, slow bands follow the mask along the rear wall/valley.
			float veil = 0.5 + 0.5*sin(p.x*0.018 + p.y*0.083 - elapsed*0.79);
			float drift = 0.5 + 0.5*cos(p.x*0.008 - p.y*0.038 - elapsed*0.44);
			float opacity = mask.g*(0.12 + 0.88*veil*drift);
			color.rgb = mix(color.rgb, haze_style.rgb, opacity*haze_style.a);
			float threat = 0.55 + 0.45*sin(elapsed*1.4 + p.y*0.019);
			color.rgb += vec3(0.14,0.039,0.024)*opacity*phase_strength*threat;
		}
		// Pull more energy from the painted red recesses in Phase II.
		if (phase_strength > 0.0 && mask.b > 0.0) {
			float ember = 0.62 + 0.38*sin(elapsed*1.4 + p.y*0.019);
			color.rgb *= 1.0 + phase_strength * mask.b * ember * 0.30;
		}
	} else if (arena_mode == 5 && dot(mask, vec4(1.0)) > 0.001) {
		// Integer harmonics on a local clock close the loop without a dissolve.
		float cycle = elapsed * TAU / cycle_seconds;
		if (mask.r > 0.001) {
			float sway = (sin(cycle*3.0 + p.x*0.013) + 0.24*sin(cycle*7.0)) * local_motion.w;
			color.rgb = texture(source_plate, UV + vec2(sway * mask.r, 0.0) / PLATE).rgb;
		}
		if (mask.g > 0.001) {
			float wind = local_motion.x;
			float veil = 0.5 + 0.5*sin(p.x*0.015 + p.y*(0.041+0.026*local_motion.y) - cycle*sign(wind)*2.0);
			float eddy = 0.5 + 0.5*cos(p.x*0.008 - p.y*0.037 + sin(cycle)*wind);
			float opacity = mask.g * (0.10 + 0.9*veil*eddy);
			color.rgb = mix(color.rgb, haze_style.rgb, opacity*haze_style.a*(1.0+0.42*wave_strength));
		}
		if (mask.b > 0.001) {
			// Reveal existing fire and lit stone, with no added glow discs.
			float breath = 0.056*sin(cycle*5.0 + p.x*0.025) + 0.022*sin(cycle*13.0 + p.y*0.047);
			color.rgb *= 1.0 + mask.b*local_motion.z*(breath + 0.055*wave_strength);
		}
	}
	if (arena_mode != 2 && mask.a > 0.001) {
		float dust = 0.0;
		for (int i=0;i<8;i++) {
			float n = float(i);
			vec2 center;
			if (arena_mode == 1) center = vec2(632.0+mod(n*57.0,213.0),287.0+mod(n*29.0,62.0));
			else if (arena_mode >= 4) center = mote_area.xy + mote_area.zw*fract(vec2(0.13+n*0.618,0.24+n*0.381));
			else center = vec2(543.0+mod(n*37.0,126.0),169.0+mod(n*43.0,149.0));
			float drift_clock = arena_mode == 5 ? elapsed*TAU/cycle_seconds : elapsed;
			vec2 drift;
			float fade;
			if (arena_mode == 5) {
				drift = vec2(sin(drift_clock+n)*local_motion.x*19.0, sin(drift_clock*2.0+n*2.7)*local_motion.y*15.0);
				fade = 0.5 + 0.5*sin(drift_clock*2.0+n*2.0);
			} else {
				drift = vec2(sin(elapsed*0.19+n)*7.0,sin(elapsed*0.13+n*2.7)*13.0);
				fade = 0.5 + 0.5*sin(elapsed*0.37+n*2.0);
			}
			center += drift;
			vec2 q = (p-center)/vec2(1.05,1.25);
			dust += exp(-dot(q,q)*2.0)*fade;
		}
		float strength = arena_mode >= 4 ? mote_strength*(1.0 + phase_strength*0.45 + wave_strength*0.3) : 0.24;
		color.rgb += vec3(0.22,0.20,0.15)*dust*mask.a*strength;
	}
	COLOR = vec4(color.rgb,original.a);
}
