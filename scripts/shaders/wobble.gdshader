shader_type canvas_item;
uniform sampler2D noiseTexture : repeat_enable;
uniform float noise_strength_x = 32.0;
uniform float noise_strength_y = 32.0;
uniform float uv_scale = 1.0;
uniform float time_scale = .05;

void vertex() {
	vec2 uv = UV*uv_scale + TIME*time_scale;
	vec2 offset = 2.0 * vec2(UV.x-0.5, UV.y-0.5);
	float noise_val_x = texture(noiseTexture, uv).r;
	float noise_val_y =  texture(noiseTexture, uv + vec2(3.5,3.5)).r;
	VERTEX.x += offset.x * (noise_val_x-0.5) * noise_strength_x;
	VERTEX.y += offset.y * (noise_val_y-0.5) * noise_strength_y;
	VERTEX = uv_scale * offset; 
	}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
