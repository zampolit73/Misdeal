shader_type canvas_item;

// D315: unified colors, NOT a replacement for each card's unique painting.
// Desaturates cold scene highlights while respecting original silhouettes.
void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float lum = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    float warmth = clamp(tex.r - tex.b * 0.65, 0.0, 1.0);
    vec3 ink = vec3(lum * 0.64, lum * 0.44, lum * 0.42);
    vec3 crimson = vec3(0.81, 0.09, 0.09) * pow(max(warmth, lum * 0.40), 1.20);
    vec3 graded = mix(tex.rgb, ink + crimson * 0.55, 0.54);
    graded = clamp((graded - 0.5) * 1.12 + 0.5, 0.0, 1.0);
    COLOR = vec4(graded, tex.a) * COLOR;
}
