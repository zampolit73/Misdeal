shader_type canvas_item;
render_mode unshaded;
uniform vec4 source_rect;
uniform float elapsed = 0.0;
uniform int kind = 0;
uniform bool passed = false;
void fragment(){
	vec2 p=source_rect.xy+UV*source_rect.zw;
	vec2 q=UV;
	// Wind only in the cloth interior, anchored ends never move the pole.
	if(kind==3){
		float cloth=smoothstep(1498.0,1518.0,p.x)*(1.0-smoothstep(1580.0,1603.0,p.x))*smoothstep(115.0,145.0,p.y)*(1.0-smoothstep(340.0,410.0,p.y));
		q.x+=cloth*sin(elapsed*0.8+p.y*0.023)*0.65/source_rect.z;
	}
	if(kind==2 && passed){
		float shutter=smoothstep(576.0,588.0,p.x)*(1.0-smoothstep(674.0,688.0,p.x))*smoothstep(429.0,443.0,p.y)*(1.0-smoothstep(548.0,563.0,p.y));
		q.x+=shutter*sin(elapsed*3.1)*0.55/source_rect.z;
	}
	COLOR=texture(TEXTURE,q);
	if(kind==2){
		vec2 patch=(p-vec2(710.0,140.0))/vec2(110.0);
		if(all(greaterThanEqual(patch,vec2(0.0))) && all(lessThanEqual(patch,vec2(1.0)))){
			COLOR.a*=smoothstep(-0.02,0.035,COLOR.r-COLOR.b);
		}
		float lamp=1.0-smoothstep(0.45,1.0,length((p-vec2(394.0,399.0))/vec2(31.0,69.0)));
		COLOR.rgb*=1.0+lamp*(sin(elapsed*3.7)+sin(elapsed*6.1)*0.35)*0.018;
	}
	if((kind==2 && p.y<300.0) || (kind==3 && p.y<550.0)){
		float sky=smoothstep(0.42,0.60,COLOR.g)*(1.0-smoothstep(-0.015,0.035,COLOR.r-COLOR.b));
		COLOR.a*=1.0-sky;
	}
	// Clear pale sky between distant battlements/roof struts, retain smoke.
	if(kind==1 && p.y<285.0){
		float sky=smoothstep(0.38,0.55,COLOR.g)*(1.0-smoothstep(-0.025,0.03,COLOR.r-COLOR.b));
		COLOR.a*=1.0-sky;
	}
	if(kind==1){
		COLOR.a *= 1.0-smoothstep(284.0,350.0,p.y);
		if(p.y<120.0) COLOR.a *= 1.0-smoothstep(0.22,0.48,COLOR.g);
	}
	if(kind==4 && p.y<530.0){
		float sky=smoothstep(0.42,0.61,COLOR.g)*(1.0-smoothstep(-0.02,0.03,COLOR.r-COLOR.b));
		COLOR.a*=1.0-sky*0.8;
	}
}
