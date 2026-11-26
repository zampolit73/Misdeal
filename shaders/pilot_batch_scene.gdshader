shader_type canvas_item;
render_mode unshaded;
uniform sampler2D motion_mask : filter_linear, repeat_disable;
uniform sampler2D alpha_mask : filter_linear, repeat_disable;
uniform bool use_alpha_mask = false;
uniform float elapsed = 0.0;
uniform sampler2D shine_mask : filter_linear, repeat_disable;
uniform float work_glint = 0.0;
uniform bool mute_lost_purse_sunset = false;

vec3 lost_purse_grade(vec3 rgb, vec2 uv) {
 // Only the distant sky, water and its immediate reflection. Smooth spatial
 // transitions use the same scene coordinates on the body/road/occluder.
 float distant = smoothstep(0.32, 0.56, uv.x) * (1.0 - smoothstep(0.52, 0.77, uv.y));
 float red = smoothstep(0.06, 0.30, rgb.r - rgb.g) * smoothstep(0.10, 0.50, rgb.r);
 float amount = distant * red;
 float lum = dot(rgb, vec3(0.299, 0.587, 0.114));
 vec3 muted = mix(vec3(lum), rgb, 0.46) * vec3(0.84, 0.92, 0.97);
 return mix(rgb, muted, amount);
}
void fragment() {
 vec4 m=texture(motion_mask,UV);
 vec2 drift=vec2(sin(elapsed*0.65)*1.1*m.r,sin(elapsed*2.1)*0.65*m.b)*TEXTURE_PIXEL_SIZE;
 vec4 c=texture(TEXTURE,clamp(UV+drift,vec2(0),vec2(1)));
 c.rgb*=1.0+0.025*m.g*sin(elapsed*2.4)+work_glint*texture(shine_mask,UV).r;
 if(mute_lost_purse_sunset) c.rgb=lost_purse_grade(c.rgb,UV);
 if(use_alpha_mask) c.a*=texture(alpha_mask,UV).a;
 COLOR=c;
}
