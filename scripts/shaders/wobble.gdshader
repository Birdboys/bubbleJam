shader_type canvas_item;
uniform sampler2D noiseTexture;
uniform float noise_strength = 50.0;
uniform float time_scale;

void vertex() {
	vec2 uv = UV + TIME*time_scale;
	vec2 offset = vec2(UV.x-0.5, UV.y-0.5);
	float noise_val = texture(noiseTexture, uv).r;
	VERTEX += noise_val * offset * noise_strength;
	//VERTEX.y += offset * noise_strength;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
