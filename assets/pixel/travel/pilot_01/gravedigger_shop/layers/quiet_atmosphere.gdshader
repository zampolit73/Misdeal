shader_type canvas_item;
uniform sampler2D motion_mask : filter_linear, repeat_disable;
uniform float elapsed = 0.0;
// Local scene clock supplied by Travel V2. Pause freezes elapsed.
void fragment() {
    vec4 m = texture(motion_mask, UV);
    vec2 px = TEXTURE_PIXEL_SIZE;
    vec2 drift = vec2(sin(elapsed * 0.65) * 1.1 * m.r,
                     sin(elapsed * 2.1) * 0.65 * m.b) * px;
    vec4 c = texture(TEXTURE, clamp(UV + drift, vec2(0.0), vec2(1.0)));
    c.rgb *= 1.0 + 0.025 * m.g * sin(elapsed * 2.4);
    COLOR = c;
}
