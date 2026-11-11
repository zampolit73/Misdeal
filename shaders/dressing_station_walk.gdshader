shader_type canvas_item;
render_mode unshaded;
uniform float haze_amount = 0.0;
uniform vec3 haze_color : source_color = vec3(0.36,0.35,0.37);
varying vec4 item_tint;
void vertex() { item_tint=COLOR; }
void fragment() {
	vec4 pigment=texture(TEXTURE,UV);
	pigment.rgb=mix(pigment.rgb,haze_color,haze_amount);
	COLOR=pigment*item_tint;
}
