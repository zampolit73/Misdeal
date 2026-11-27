shader_type canvas_item;
render_mode unshaded;
uniform float elapsed = 0.0;
uniform float ripple = 0.0;
varying vec4 tint;
void vertex(){tint=COLOR;}
void fragment(){
	vec2 p=UV-vec2(0.5,0.14);
	float m=1.0-smoothstep(0.2,1.0,length(p/vec2(0.43,0.12)));
	vec2 uv=UV+vec2(sin(length(p)*50.0-elapsed*27.0)*0.012*ripple*m,0.0);
	vec4 ink=texture(TEXTURE,uv);
	COLOR=ink*tint;
}
