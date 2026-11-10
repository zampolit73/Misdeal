shader_type canvas_item;
render_mode unshaded;
uniform float elapsed=0.0;
void fragment(){float edge=smoothstep(0.0,0.24,UV.y)*(1.0-smoothstep(0.72,1.0,UV.y));float clouds=0.5+0.5*sin(UV.x*8.0+elapsed*0.12+sin(UV.x*17.0)*0.4);COLOR=vec4(0.40,0.45,0.49,edge*clouds*0.035);}
