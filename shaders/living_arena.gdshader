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
uniform float reaction_strength = 0.0;
uniform vec4 reaction_area = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec2 reaction_gain = vec2(0.0);
uniform int visible_motion = 0;
uniform vec4 visible_area = vec4(0.0, 0.0, 1.0, 1.0);
const vec2 PLATE = vec2(1280.0, 720.0);

// Bounded packets grow, crest and recede in place. No translating water sheet.
float packet(vec2 p, vec2 center, vec2 extent, float phase) {
	vec2 q = (p-center)/extent;
	float locality = exp(-dot(q,q)*2.0);
	float cycle = 0.5-0.5*cos(elapsed*0.79+phase);
	return locality*cycle*cycle*sin(p.x*0.027+p.y*0.19-elapsed*1.07+phase);
}

float hot_flame(vec3 pixel) {
	return smoothstep(0.58, 0.88, pixel.r) * smoothstep(0.36, 0.68, pixel.g)
		* smoothstep(0.16, 0.50, pixel.r - pixel.b);
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
	if (reaction_strength > 0.0 && p.y < 360.0) {
		float locality = (1.0 - smoothstep(0.15, 1.0, length((p - reaction_area.xy) / reaction_area.zw)))
			* (1.0 - smoothstep(348.0, 360.0, p.y)) * reaction_strength;
		// The Court window and Ossuary veil use the atmospheric mask.
		float light = reaction_gain.x < 0.0 ? mask.g : mask.b;
		color.rgb *= 1.0 + reaction_gain.x * light * locality;
		color.rgb = mix(color.rgb, haze_style.rgb, reaction_gain.y * mask.g * locality);
	}
	if (visible_motion != 0 && p.y < 360.0) {
		vec2 q = (p - visible_area.xy) / visible_area.zw;
		float floor_fade = 1.0 - smoothstep(345.0, 360.0, p.y);
		if (visible_motion <= 2 && abs(q.x) < 1.2 && q.y > -2.2 && q.y < 0.0) {
			// Anchor the bottom of the flame and bend only the warm painted tips.
			float tip = smoothstep(0.0, 0.55, -q.y) * (1.0 - smoothstep(0.65, 1.0, length(q)));
			float heat = hot_flame(original.rgb) * mask.b;
			float sway = sin(elapsed * 5.6 + q.y * 4.0) + 0.38 * sin(elapsed * 9.4);
			vec2 shift = vec2(sway * 15.0, (0.62 + 0.54 * sin(elapsed * 6.2 + q.x * 2.0)) * 17.0);
			vec3 flame = texture(source_plate, UV + shift * tip * (1.0 + reaction_strength * 0.55) / PLATE).rgb;
			float warm_tip = hot_flame(flame);
			float flame_weight = max(heat, warm_tip * mask.b) * tip;
			color.rgb = mix(color.rgb, flame, flame_weight * floor_fade);
			// Sparse sparks follow fixed tracks in the shader above the source.
			float sparks = 0.0;
			for (int i = 0; i < 4; i++) {
				float n = float(i);
				float life = fract(elapsed * (0.58 + n * 0.07) + n * 0.37);
				vec2 ember = visible_area.xy + vec2((n - 1.5) * 5.5 + sin(life * 3.0 + n) * 10.0,
					-18.0 - life * (visible_motion == 2 ? 63.0 : 38.0));
				vec2 gap = (p - ember) / vec2(1.35, 2.2);
				float envelope = smoothstep(0.0, 0.18, life) * (1.0 - smoothstep(0.4, 0.86, life));
				sparks += (1.0 - smoothstep(0.2, 1.0, length(gap))) * envelope;
			}
			color.rgb += vec3(0.48, 0.26, 0.10) * sparks * floor_fade * (0.62 + 0.36 * reaction_strength);
			if (visible_motion == 2 && mask.g > 0.0) {
				float lift = smoothstep(0.12, 0.85, sin(p.y * 0.095 + p.x * 0.047 + elapsed * 2.6));
				float plume = (1.0 - smoothstep(0.25, 1.5, length(q + vec2(-0.35, 0.85))))
					* smoothstep(0.15, 0.7, -q.y);
				color.rgb = mix(color.rgb, haze_style.rgb, lift * plume * mask.g * floor_fade
					* (0.18 + 0.29 * reaction_strength));
			}
		} else if (visible_motion >= 3) {
			float locality = (1.0 - smoothstep(0.25, 1.1, length(q))) * floor_fade * mask.g;
			if (visible_motion == 3) {
				// Moving folds in the portal mist, with clear gaps between them.
				float fold = sin(p.x * 0.027 + p.y * 0.063 - elapsed * 1.9 + sin(p.y * 0.026 + elapsed * 0.8));
				float curl = 0.5 + 0.5 * sin(p.x * 0.021 - p.y * 0.035 - elapsed * 1.1);
				color.rgb = mix(color.rgb, haze_style.rgb * 1.17,
					smoothstep(0.12, 0.83, fold) * (0.3 + 0.7 * curl) * locality * (0.48 + 0.18 * reaction_strength));
			} else {
				// Light travels down the existing stained glass mask.
				float ribbon = smoothstep(0.1, 0.85, sin(p.y * 0.055 + p.x * 0.012 - elapsed * 1.45));
				color.rgb += vec3(0.085, 0.115, 0.16) * ribbon * locality * (1.0 - reaction_strength);
			}
		}
	}
	COLOR = vec4(color.rgb,original.a);
}
