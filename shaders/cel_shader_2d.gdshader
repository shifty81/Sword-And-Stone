shader_type canvas_item;

// 2D Cel-shading shader for Crimson Isles
// Applies cartoon-style lighting and outlines to 2D sprites and tiles

uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform int cel_levels : hint_range(2, 8) = 3;
uniform float outline_thickness : hint_range(0.0, 5.0) = 1.0;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float shadow_intensity : hint_range(0.0, 1.0) = 0.3;
uniform vec2 light_direction = vec2(0.5, -0.5);  // Direction of light in 2D

void fragment() {
	// Get the base texture color
	vec4 base_color = texture(TEXTURE, UV);
	
	if (base_color.a < 0.01) {
		// Fully transparent, skip processing
		COLOR = base_color;
		return;
	}
	
	// Calculate pseudo-lighting based on position
	// Use UV and light direction to simulate lighting
	vec2 uv_centered = UV - vec2(0.5, 0.5);
	float light_intensity = dot(normalize(uv_centered), normalize(light_direction));
	light_intensity = (light_intensity + 1.0) * 0.5; // Normalize to 0-1
	
	// Apply cel-shading quantization
	float cel_intensity = floor(light_intensity * float(cel_levels)) / float(cel_levels);
	cel_intensity = max(cel_intensity, 0.6); // Minimum brightness
	
	// Apply shadow
	vec3 shaded_color = base_color.rgb * mix(1.0, cel_intensity, shadow_intensity);
	
	// Apply tint
	shaded_color *= tint_color.rgb;
	
	// Edge detection for outline
	float alpha_threshold = 0.5;
	vec2 texel_size = 1.0 / vec2(textureSize(TEXTURE, 0));
	
	// Sample neighboring pixels for edge detection
	float edge = 0.0;
	if (outline_thickness > 0.0) {
		float alpha_center = base_color.a;
		
		// Check 4 cardinal directions
		float alpha_left = texture(TEXTURE, UV + vec2(-texel_size.x * outline_thickness, 0.0)).a;
		float alpha_right = texture(TEXTURE, UV + vec2(texel_size.x * outline_thickness, 0.0)).a;
		float alpha_up = texture(TEXTURE, UV + vec2(0.0, -texel_size.y * outline_thickness)).a;
		float alpha_down = texture(TEXTURE, UV + vec2(0.0, texel_size.y * outline_thickness)).a;
		
		// If we're on an edge (neighbor has different alpha), mark as edge
		if (alpha_center > alpha_threshold && 
		    (alpha_left < alpha_threshold || alpha_right < alpha_threshold || 
		     alpha_up < alpha_threshold || alpha_down < alpha_threshold)) {
			edge = 1.0;
		}
	}
	
	// Mix outline color
	vec3 final_color = mix(shaded_color, outline_color.rgb, edge);
	
	COLOR = vec4(final_color, base_color.a);
}
