shader_type canvas_item;
render_mode unshaded;
uniform sampler2D motion_mask : filter_linear, repeat_disable;
uniform sampler2D alpha_mask : filter_linear, repeat_disable;
uniform bool use_alpha_mask = false;
uniform float elapsed = 0.0;
uniform sampler2D shine_mask : filter_linear, repeat_disable;
uniform float work_glint = 0.0;
void fragment() {
 vec4 m=texture(motion_mask,UV);
 vec2 drift=vec2(sin(elapsed*0.65)*1.1*m.r,sin(elapsed*2.1)*0.65*m.b)*TEXTURE_PIXEL_SIZE;
 vec4 c=texture(TEXTURE,clamp(UV+drift,vec2(0),vec2(1)));
 c.rgb*=1.0+0.025*m.g*sin(elapsed*2.4)+work_glint*texture(shine_mask,UV).r;
 if(use_alpha_mask) c.a*=texture(alpha_mask,UV).a;
 COLOR=c;
}
