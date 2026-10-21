shader_type canvas_item;

// D321: source-first DS3 grading. CanvasItem.COLOR in fragment already includes
// TEXTURE. Multiplying a manually sampled texture by COLOR SQUARED its RGB,
// causing the near-black cards shown in the user's real 1280x720 gallery.
// Capture the original vertex tint BEFORE Godot's automatic texture multiply.
// Keep authored blue moonlight, scarlet fire and warm bronze rather than
// repainting every scene with an opaque brown/crimson cast.
varying vec4 card_vertex_tint;

uniform float grade_mix : hint_range(0.0, 1.0) = 0.10;
uniform float midtone_lift : hint_range(0.0, 0.25) = 0.035;
uniform float ember_strength : hint_range(0.0, 0.7) = 0.20;

void vertex() {
    card_vertex_tint = COLOR;
}

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    float lum = dot(original.rgb, vec3(0.299, 0.587, 0.114));
    float warmth = clamp(original.r - original.b * 0.65, 0.0, 1.0);

    // Subtle scene lift only: preserve source saturation and all real detail.
    vec3 readable = pow(max(original.rgb, vec3(0.0)), vec3(0.92));
    vec3 bronze = vec3(lum * 1.02, lum * 0.78, lum * 0.67);
    bronze += vec3(1.0, 0.06, 0.06) * ember_strength * pow(warmth, 0.85);
    vec3 graded = mix(readable, bronze, grade_mix);
    float detail_mask = smoothstep(0.012, 0.18, lum) *
        (1.0 - smoothstep(0.35, 0.85, lum));
    graded += midtone_lift * (vec3(1.0) - graded) * detail_mask;

    // NEVER multiply by fragment COLOR: it already contains the sampled texel.
    // The saved vertex tint preserves true card hover/selection modulation.
    COLOR = vec4(clamp(graded, 0.0, 1.0), original.a) * card_vertex_tint;
}
