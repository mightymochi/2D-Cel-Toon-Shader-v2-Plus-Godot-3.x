shader_type canvas_item;

uniform vec4 before_light_modulate : hint_color = vec4(1.0,1.0,1.0,1.0);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (AT_LIGHT_PASS) {
		COLOR = texture_color;
	} else {
		COLOR = texture_color * before_light_modulate;
	}
}
