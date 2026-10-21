shader_type canvas_item;

// D318: retain the approved scarlet/black warmth WITHOUT crushing the
// original scene silhouette, masonry and characters into near-black.
// Shared between live Table, Reward, Fate Spread and the F6 gallery.
uniform float grade_mix : hint_range(0.0, 1.0) = 0.30;
uniform float midtone_lift : hint_range(0.0, 0.25) = 0.085;
uniform float ember_strength : hint_range(0.0, 0.7) = 0.32;

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    float lum = dot(original.rgb, vec3(0.299, 0.587, 0.114));
    float warmth = clamp(original.r - original.b * 0.65, 0.0, 1.0);
    vec3 readable = pow(max(original.rgb, vec3(0.0)), vec3(0.82));
    vec3 bronze = vec3(lum * 1.02, lum * 0.78, lum * 0.67);
    bronze += vec3(1.0, 0.06, 0.06) * ember_strength * pow(warmth, 0.85);
    vec3 graded = mix(readable, bronze, grade_mix);
    float detail_mask = smoothstep(0.012, 0.18, lum) *
        (1.0 - smoothstep(0.35, 0.85, lum));
    graded += midtone_lift * (vec3(1.0) - graded) * detail_mask;
    COLOR = vec4(clamp(graded, 0.0, 1.0), original.a) * COLOR;
}
