shader_type spatial;

// Borderlands-style cel-shaded shader with thick outlines
// Fixed version to handle edge cases and ensure proper color rendering

uniform vec4 albedo : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform int cel_levels : hint_range(2, 8) = 4;
uniform float outline_thickness : hint_range(0.0, 0.1) = 0.01;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float specular_strength : hint_range(0.0, 1.0) = 0.3;
uniform float rim_strength : hint_range(0.0, 1.0) = 0.5;

varying vec4 vertex_color;

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
	// Use vertex color as base (ensure it's not lost)
	vec3 base_color = vertex_color.rgb * albedo.rgb;
	
	// Calculate lighting from fixed directional light
	vec3 light_dir = normalize(vec3(0.5, 1.0, 0.3));
	float NdotL = dot(NORMAL, light_dir);
	
	// Cel-shading: quantize lighting into discrete levels
	float cel_intensity = floor(max(NdotL, 0.0) * float(cel_levels)) / float(cel_levels);
	cel_intensity = max(cel_intensity, 0.5); // Minimum ambient lighting (increased for better visibility)
	
	// Rim lighting for Borderlands-style effect
	vec3 view_dir = normalize(VIEW);
	float rim = 1.0 - max(dot(view_dir, NORMAL), 0.0);
	rim = smoothstep(0.6, 1.0, rim);
	vec3 rim_light = vec3(rim) * rim_strength;
	
	// Specular highlight
	vec3 half_dir = normalize(light_dir + view_dir);
	float spec = pow(max(dot(NORMAL, half_dir), 0.0), 32.0);
	spec = step(0.5, spec) * specular_strength;
	
	// Combine lighting
	vec3 final_color = base_color * cel_intensity;
	final_color += rim_light * base_color;
	final_color += vec3(spec);
	
	// Edge detection for outline (view-angle based)
	float edge = 1.0 - abs(dot(view_dir, NORMAL));
	edge = smoothstep(0.0, outline_thickness * 10.0, edge);
	
	// Apply outline
	final_color = mix(final_color, outline_color.rgb, edge * 0.5);
	
	ALBEDO = final_color;
	ALPHA = albedo.a;
}
