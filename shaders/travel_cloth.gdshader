shader_type canvas_item;
render_mode unshaded;
uniform float elapsed=0.0;
void fragment(){float a=1.0-smoothstep(0.45,1.0,length((UV-vec2(0.89,0.29))/vec2(0.025,0.14)));float shift=a*sin(elapsed*0.55+UV.y*14.0)*0.00045;COLOR=texture(TEXTURE,UV+vec2(shift,0.0));}
