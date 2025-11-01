shader_type spatial;

// Simple cel-shaded shader that prioritizes vertex colors

uniform vec4 albedo : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform int cel_levels : hint_range(2, 8) = 4;
uniform float outline_thickness : hint_range(0.0, 0.1) = 0.01;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

varying vec4 vertex_color;

void vertex() {
vertex_color = COLOR;
}

void fragment() {
// Use vertex color as base
vec3 base_color = vertex_color.rgb * albedo.rgb;

// Simple diffuse lighting
vec3 light_dir = normalize(vec3(0.5, 1.0, 0.3));
float NdotL = dot(NORMAL, light_dir);

// Cel-shading: quantize lighting into discrete levels
float cel_intensity = floor(max(NdotL, 0.0) * float(cel_levels)) / float(cel_levels);
cel_intensity = max(cel_intensity, 0.3); // Minimum ambient lighting

// Apply lighting to base color
vec3 final_color = base_color * cel_intensity;

// Simple outline based on view angle
vec3 view_dir = normalize(VIEW);
float edge = 1.0 - abs(dot(NORMAL, view_dir));
edge = smoothstep(0.0, outline_thickness * 5.0, edge);

// Mix with outline color
final_color = mix(final_color, outline_color.rgb, edge * 0.3);

ALBEDO = final_color;
ALPHA = albedo.a;
}
