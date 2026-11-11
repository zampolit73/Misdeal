shader_type canvas_item;
render_mode unshaded;
uniform vec4 source_rect;
uniform float elapsed = 0.0;
uniform int kind = 0;
uniform int outcome = 0; // passed / standard / bandages
void fragment() {
	vec2 p = source_rect.xy+UV*source_rect.zw;
	vec2 q = UV;
	if (kind==1) {
		// Only cloth interiors move. Pole, stone and approved faces stay rigid.
		float cloth = smoothstep(165.0,192.0,p.x)*(1.0-smoothstep(370.0,405.0,p.x))*smoothstep(100.0,135.0,p.y)*(1.0-smoothstep(345.0,390.0,p.y));
		q.x += cloth*sin(elapsed*1.1+p.y*0.024)*0.8/source_rect.z;
		float linens = smoothstep(461.0,475.0,p.x)*(1.0-smoothstep(635.0,655.0,p.x))*smoothstep(300.0,322.0,p.y)*(1.0-smoothstep(358.0,389.0,p.y));
		q.y += linens*sin(elapsed*1.35+p.x*0.02)*0.45/source_rect.w;
	}
	if (kind==2 && outcome!=1) {
		float offcuts = smoothstep(355.0,385.0,p.x)*(1.0-smoothstep(520.0,575.0,p.x))*smoothstep(663.0,679.0,p.y)*(1.0-smoothstep(738.0,774.0,p.y));
		q.x += offcuts*sin(elapsed*2.4+p.y*0.035)*0.65/source_rect.z;
		// Under one source pixel: scissors only, never hand/arm deformation.
		float blade = smoothstep(353.0,368.0,p.x)*(1.0-smoothstep(443.0,458.0,p.x))*smoothstep(614.0,625.0,p.y)*(1.0-smoothstep(637.0,645.0,p.y));
		q.y += blade*sin(elapsed*3.8)*0.45/source_rect.w;
	}
	COLOR = texture(TEXTURE,q);
	float lamp = 1.0-smoothstep(0.2,1.0,length((p-vec2(97.0,651.0))/vec2(36.0,76.0)));
	float lamp2 = 1.0-smoothstep(0.2,1.0,length((p-vec2(958.0,519.0))/vec2(28.0,50.0)));
	COLOR.rgb *= 1.0+(lamp+lamp2)*(sin(elapsed*3.7)+sin(elapsed*5.9)*0.3)*0.012;
}
