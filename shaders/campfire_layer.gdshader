shader_type canvas_item;
render_mode unshaded;
uniform vec4 source_rect;
uniform float elapsed = 0.0;
uniform int kind = 0;
uniform bool passed = false;
void fragment() {
	vec2 p=source_rect.xy+UV*source_rect.zw;
	vec2 q=UV;
	if(kind==1) {
		// Interior only: canopy seams, ropes, posts, hands and faces stay rigid.
		float cloth=smoothstep(842.0,866.0,p.x)*(1.0-smoothstep(931.0,948.0,p.x))*smoothstep(78.0,105.0,p.y)*(1.0-smoothstep(280.0,333.0,p.y));
		q.x+=cloth*sin(elapsed*0.8+p.y*0.02)*0.45/source_rect.z;
		if(passed) {
			float buckle=(1.0-smoothstep(3.0,9.0,abs(p.x-541.0)))*(1.0-smoothstep(1.0,4.0,abs(p.y-589.0)));
			q.y+=buckle*sin(elapsed*2.5)*0.25/source_rect.w;
		}
	}
	COLOR=texture(TEXTURE,q);
	if(kind==1) {
		float lamp=1.0-smoothstep(0.2,1.0,length((p-vec2(195.0,157.0))/vec2(36.0,69.0)));
		float ember=1.0-smoothstep(0.2,1.0,length((p-vec2(863.0,833.0))/vec2(102.0,31.0)));
		COLOR.rgb*=1.0+lamp*(sin(elapsed*3.1)+sin(elapsed*5.4)*0.3)*0.013+ember*sin(elapsed*1.8)*0.025;
	}
}
