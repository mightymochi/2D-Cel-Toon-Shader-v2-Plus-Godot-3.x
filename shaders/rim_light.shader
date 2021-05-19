shader_type canvas_item;

uniform bool rim_light = false;
uniform float rim_thickness : hint_range(0, 40) = 5.0;
uniform float rim_intense : hint_range(0, 1) = 1.0;
uniform bool rim_extra_thick = false;

void light() {
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
		float rim_cap = outline * color.a * rim_intense;
		LIGHT += rim_cap;
	}
}
