shader_type canvas_item;
render_mode unshaded;
uniform float elapsed = 0.0;
uniform float gesture = 0.0;
uniform float trace = 0.0;
uniform vec4 npc_hand = vec4(0.0);
uniform vec4 npc_hood = vec4(0.0);
uniform vec4 cloth = vec4(0.0);
uniform vec4 lights[3];
varying vec4 tint;
void vertex(){tint=COLOR;}
float mask(vec2 p,vec4 r){
	if(r.z<=0.0||r.w<=0.0) return 0.0;
	return 1.0-smoothstep(0.05,1.0,length((p-r.xy)/r.zw));
}
void fragment(){
	vec2 size=vec2(1280.0,720.0);
	vec2 p=UV*size;
	vec2 offset=vec2(0.0);
	float hand=mask(p,npc_hand);
	float hood=mask(p,npc_hood);
	float fabric=mask(p,cloth);
	// The fixed seat, table and feet are never displaced. Small directed
	// shoulder/hand follow-through and cloth motion stay within their masks.
	offset+=vec2(-gesture*7.0,gesture*4.0)*hand;
	offset+=vec2(sin(elapsed*1.55)*0.8-gesture*1.45,cos(elapsed*1.55)*0.5)*hood;
	offset+=vec2(sin(elapsed*2.3+p.y*0.07)*1.1,cos(elapsed*1.9+p.x*0.06)*0.55)*fabric;
	float heat=0.0;
	for(int i=0;i<3;i++){
		vec4 l=lights[i];
		float f=mask(p,l);
		float wave=sin(elapsed*11.0+float(i)*2.5);
		offset+=vec2(wave*1.2,cos(elapsed*8.9+float(i))*0.7)*f;
		heat+=(wave*0.045+sin(elapsed*14.1)*0.02)*mask(p,vec4(l.xy+vec2(0.,10.),l.zw*3.7));
	}
	vec4 ink=texture(TEXTURE,clamp(UV+offset/size,vec2(0.0),vec2(1.0)));
	ink.rgb*=vec3(1.0+heat,1.0+heat*0.6,1.0+heat*0.25);
	// Only the collected crown leaves the compressed, faded cloth footprint.
	float footprint=mask(p,vec4(916.0,478.0,33.0,8.0));
	ink.rgb+=vec3(0.035,0.024,0.017)*footprint*trace;
	COLOR=ink*tint;
}
