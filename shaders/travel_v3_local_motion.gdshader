shader_type canvas_item;
render_mode unshaded;

// Original pilot masks plus location-specific rollout masks. The authored pixels are sampled
// in-place; no TIME, no changes to heroes, terrain silhouettes or heraldry.
uniform int scene_kind = 0;
uniform float elapsed = 0.0;
uniform vec4 local_lights[3];
uniform vec4 local_cloth = vec4(0.0);
varying vec4 canvas_tint;

void vertex() {
	canvas_tint = COLOR;
}

float oval(vec2 p, vec2 center, vec2 radii) {
	float d = length((p-center)/radii);
	return 1.0-smoothstep(0.18, 1.0, d);
}

float pulse(float t, float seed) {
	return sin(t*9.1+seed)*0.46 + sin(t*15.7+seed*2.3)*0.30
		+ sin(t*5.4+seed*3.7)*0.24;
}

vec2 flame(vec2 p, vec2 center, vec2 radii, float seed) {
	float mask = oval(p, center, radii);
	return vec2(sin(elapsed*11.0+seed+p.y*0.075)*1.65, cos(elapsed*9.0+seed)*0.8)*mask;
}

void fragment() {
	vec2 pixels = vec2(1280.0, 720.0);
	vec2 p = UV*pixels;
	vec2 shift = vec2(0.0);
	float heat = 0.0;
	if (scene_kind == 0) { // Blood Ledger: both candle flames and their pools.
		shift += flame(p, vec2(93.0, 327.0), vec2(10.0, 25.0), 0.8);
		shift += flame(p, vec2(638.0, 303.0), vec2(8.0, 20.0), 2.9);
		heat = oval(p,vec2(100.0,360.0),vec2(125.0,115.0))*pulse(elapsed,0.8)*0.085;
		heat += oval(p,vec2(641.0,345.0),vec2(130.0,100.0))*pulse(elapsed,2.9)*0.085;
	} else if (scene_kind == 1) { // Well: lamp and a faint reflected water shimmer.
		shift += flame(p,vec2(320.0,318.0),vec2(10.0,21.0),1.6);
		float water = oval(p,vec2(489.0,342.0),vec2(122.0,26.0));
		shift.x += sin(p.y*0.33+elapsed*2.8)*0.9*water;
		heat = oval(p,vec2(320.0,343.0),vec2(110.0,100.0))*pulse(elapsed,1.6)*0.07;
	} else if (scene_kind == 2) { // Bridge: pinned cloth interior and braziers, not the planks/poles.
		float cloth = oval(p,vec2(234.0,205.0),vec2(58.0,138.0));
		float hang = smoothstep(76.0,175.0,p.y);
		shift.x += sin(p.y*0.035-elapsed*2.1)*4.2*cloth*hang;
		shift.y += cos(p.x*0.06-elapsed*2.1)*1.7*cloth*hang;
		shift += flame(p,vec2(349.0,322.0),vec2(22.0,48.0),0.2);
		shift += flame(p,vec2(799.0,245.0),vec2(12.0,26.0),2.2);
		heat = oval(p,vec2(349.0,353.0),vec2(105.0,105.0))*pulse(elapsed,0.2)*0.095;
		heat += oval(p,vec2(799.0,270.0),vec2(75.0,70.0))*pulse(elapsed,2.2)*0.075;
		heat += oval(p,vec2(963.0,228.0),vec2(46.0,48.0))*pulse(elapsed,4.9)*0.065;
	} else {
		for (int i = 0; i < 3; i++) {
			vec4 light = local_lights[i];
			if (light.z > 0.0 && light.w > 0.0) {
				float seed = float(i) * 2.7 + 0.6;
				shift += flame(p, light.xy, light.zw, seed) * 0.65;
				heat += oval(p, light.xy+vec2(0.0, 18.0), light.zw*vec2(4.2, 2.7))*pulse(elapsed,seed)*0.065;
			}
		}
		if (local_cloth.z > 0.0 && local_cloth.w > 0.0) {
			float mask = oval(p, local_cloth.xy, local_cloth.zw);
			float hang = smoothstep(local_cloth.y-local_cloth.w, local_cloth.y, p.y);
			shift.x += sin(p.y*0.040-elapsed*1.9)*1.8*mask*hang;
			shift.y += cos(p.x*0.04-elapsed*1.9)*0.6*mask*hang;
		}
	}
	vec4 ink = texture(TEXTURE, clamp(UV+shift/pixels,vec2(0.0),vec2(1.0)));
	ink.rgb *= vec3(1.0+heat,1.0+heat*0.64,1.0+heat*0.30);
	COLOR = ink*canvas_tint;
}
