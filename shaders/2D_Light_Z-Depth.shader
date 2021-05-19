shader_type canvas_item;

// Light height variables
uniform bool fake_light_depth = false;
uniform float obj_height : hint_range(-2048.0, 2048.0) = 0.0; 
uniform float light_change_thresh : hint_range(0.0, 4080.0) = 0.0;
uniform bool light_fade = false;
uniform float light_fade_end : hint_range(0.0, 4080.0) = 0.0;

void light() {
	if (fake_light_depth) {
		float base_height = LIGHT_HEIGHT;
		float new_height = base_height - obj_height;
		LIGHT_HEIGHT = new_height;
		if (light_fade && new_height > light_change_thresh) {
			float n_height_safety = new_height;
			if (n_height_safety == 0.0) { n_height_safety += 0.01; }
			float light_dist_safety = light_change_thresh;
			if (light_dist_safety == 0.0) { light_dist_safety += 0.001; }
			float new_intens = 1.0;
			float dark_distance = light_fade_end;
			if (dark_distance == 0.0) {dark_distance = 1.0;}
			new_intens = 1.0 - abs(abs(light_dist_safety) - abs(n_height_safety)) / dark_distance;
			float light_drop_a = clamp(LIGHT_COLOR.a * new_intens, 0.0, 1.0);
			LIGHT_COLOR *= light_drop_a;
		}
	}
	LIGHT = LIGHT;
}
