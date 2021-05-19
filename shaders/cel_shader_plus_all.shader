shader_type canvas_item;

uniform float first_stage : hint_range(0.0, 1.0) = 0.5; 
uniform float first_smooth : hint_range(0.0, 1.0) = 0.0; // Lengthens the color transition
uniform float second_stage : hint_range(0.0, 1.0) = 0.0;   // If left at 0, only level 1 is used.
uniform float second_smooth : hint_range(0.0, 1.0) = 0.0;
uniform bool rim_light = false;
uniform float rim_thickness : hint_range(0, 40) = 5.0;
uniform float rim_intense : hint_range(0, 1) = 1.0;
uniform bool rim_extra_thick = false;
uniform float min_light : hint_range(0.0, 1.0) = 0.0;
uniform float mid_light : hint_range(0.0, 1.0) = 0.0;
uniform float max_light : hint_range(0.0, 1.0) = 1.0;
uniform float obj_light_add : hint_range(0.0, 1.0) = 0.0;
// Light height variables
uniform bool fake_light_depth = false;
uniform float obj_height : hint_range(-2048.0, 2048.0) = 0.0; 
uniform float min_scale : hint_range(0.0, 10.0) = 0.2;
uniform float max_scale : hint_range(0.0, 10.0) = 2.0; 
uniform float light_change_thresh : hint_range(0.0, 4080.0) = 0.0;
uniform bool light_fade = false;
uniform float light_fade_end : hint_range(0.0, 4080.0) = 0.0;
uniform bool fake_spot_light = false;
uniform float first_shrink_speed : hint_range(0.0, 120.0) = 0.0; 
uniform float second_shrink_speed : hint_range(0.0, 120.0) = 0.0; 
//---------------Color Override
uniform vec4 before_light_modulate : hint_color = vec4(1.0,1.0,1.0,1.0);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (AT_LIGHT_PASS) {
		COLOR = texture_color;
	} else {
		COLOR = texture_color * before_light_modulate;
	}
}
float light_calc(float light_strength, float would_be_strength) {
	float target_strength = light_strength + would_be_strength * obj_light_add;
	if (target_strength == 0.0) {target_strength = 0.000001;}
	if (would_be_strength == 0.0) {would_be_strength = 1.0;}
	return(target_strength / would_be_strength);
}

void light() {
	float level_1 = first_stage;
	float level_1_smooth = first_smooth;
	float level_2 = second_stage;
	float level_2_smooth = second_smooth;
	//---- Light height calc start ------------------------------------
	//-----------------------------------------------------------------
	if (fake_light_depth) {
		float base_height = LIGHT_HEIGHT;
		float new_height = base_height - obj_height;
		LIGHT_HEIGHT = new_height;
		if (fake_spot_light && obj_height < base_height && light_change_thresh < new_height ){
			if (level_1 != 1.0) {
				level_1 -= (light_change_thresh - new_height) * (first_shrink_speed * .0001);
				if (level_2 != 0.0 && level_2 != 1.0) {
					level_2 -= (light_change_thresh - new_height) * (second_shrink_speed * .0001);
				}
			}
		}
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
	//---- Light height calc end --------------------------------------
	//-----Light Rim start------------------------------------------------------
	float mid_range_light = mid_light;
	if (mid_light == 0.0) { mid_range_light = max_light * 0.5; }
	vec3 light_normal = normalize(vec3(LIGHT_VEC, -LIGHT_HEIGHT));
	float would_be_strength = max(dot(-light_normal, NORMAL), 0.0);
	if (rim_light) {
		vec2 size = TEXTURE_PIXEL_SIZE * rim_thickness;
		float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
		outline *= texture(TEXTURE, UV + vec2(0, size.y)).a;
		outline *= texture(TEXTURE, UV + vec2(size.x, 0)).a;
		outline *= texture(TEXTURE, UV + vec2(0, -size.y)).a;
		if (rim_extra_thick) {
			outline *= texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
			outline *= texture(TEXTURE, UV + vec2(size.x, size.y)).a;
			outline *= texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
			outline *= texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
		}
		outline = 1.0 - outline;

		vec4 color = texture(TEXTURE, UV);
		float rim_cap = outline * color.a * rim_intense * (max_light - min_light);
		LIGHT += rim_cap;
	}
	//-----Light Rim end------------------------------------------------------
	if (would_be_strength > level_1 && level_2 == 0.0 ) {
		float diff = smoothstep(level_1, (level_1 + level_1_smooth), would_be_strength) + min_light;
		if (diff >= max_light) {diff = max_light;}
		LIGHT *= light_calc(diff, would_be_strength);
	} else if (would_be_strength > level_1 && would_be_strength < level_2 && level_2 != 0.0 ) {
		float diff = smoothstep(level_1, (level_1 + level_1_smooth), would_be_strength) + min_light;
		if (diff >= mid_range_light ) {diff = mid_range_light;}
		LIGHT *= light_calc(diff, would_be_strength);
	} else if (would_be_strength >= level_2 && level_2 != 0.0 ) {
		float diff = smoothstep(level_2, (level_2 + level_2_smooth), would_be_strength) + mid_range_light;
		if (diff < mid_range_light ) {diff = mid_range_light;}
		if (diff >= max_light) {diff = max_light;}
		LIGHT *= light_calc(diff, would_be_strength);
	} else { 
		if (min_light != 0.0) { 
			LIGHT_VEC = -NORMAL.xy*length(LIGHT_VEC); 
		}
		LIGHT *= min_light;                                                                                                                                  
	}
}
