shader_type canvas_item;

// Scrolling parameters
uniform float rotate_degree : hint_range(0.0, 360.0, 0.1) = 0;
uniform float move_degree :  hint_range(0.0, 360.0, 0.1) = 0;
uniform float speed : hint_range(0.0, 100.0) = 1;
uniform float scale : hint_range(0.01, 100.0, 0.01) = 0.2;
uniform vec2 gap = vec2(0.5, 0.5);
uniform vec2 node_scale = vec2(1.0);

// Transition parameters (0 to 1 over the entire In/Out transition)
uniform float progress : hint_range(0, 1);
uniform float diamondPixelSize = 10.0;

// Helper function for the background rotation
vec2 rotate(vec2 uv, float local_angle) {
	mat2 rotation = mat2(vec2(sin(local_angle), -cos(local_angle)),
			vec2(cos(local_angle), sin(local_angle)));

    uv = uv * rotation;
    return uv;
}

void fragment() {
    // 1. Transition logic (Diamond Sweep)
    float xFraction = fract(FRAGCOORD.x / diamondPixelSize);
    float yFraction = fract(FRAGCOORD.y / diamondPixelSize);
    float xDistance = abs(xFraction - 0.5);
    float yDistance = abs(yFraction - 0.5);
    
    // Using raw UV so diamonds don't scroll with the background
    float val = xDistance + yDistance + UV.x + UV.y;
    
    // Transition IN
    if (progress <= 0.5) {
        float t = progress * 2.0; 
        if (val > t * 4.0) {
            discard;
        }
    } 
    // Transition OUT
    else {
        float t = (progress - 0.5) * 2.0; 
        if (val < t * 4.0) {
            discard;
        }
    }

    // 2. Scrolling logic (Only runs if pixel survived the discard above)
	vec2 scaled_uv = UV * node_scale / scale;
	float rotate_radians = radians(rotate_degree + 90.0);
	float move_radians = radians(move_degree + 180.0) - rotate_radians;
	vec2 normilazed_vector = vec2(cos(move_radians), sin(move_radians));
	vec2 rotated_uv = rotate(scaled_uv, rotate_radians);
	vec2 scrolled_uv = rotated_uv + normilazed_vector * speed * TIME;

	vec2 period = 1.0 + max(gap, vec2(0,0));
	vec2 cell_idx = floor(scrolled_uv / period);
	vec2 pos = scrolled_uv - cell_idx * period;

	float alpha = step(max(pos.x, pos.y), 1.0);
	vec4 tex = texture(TEXTURE, pos);

	COLOR = vec4(vec3(tex.rgb), alpha);
}