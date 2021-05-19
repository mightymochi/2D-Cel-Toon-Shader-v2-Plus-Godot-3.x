tool
extends Node2D

var change_compare = 0.0
export var scale_with_depth:bool = true
export(NodePath) var lit_node
onready var scaled_node:Node2D = get_node(lit_node)


func _process(delta):
	pass
	if (scale_with_depth):
		if (scaled_node == null):
			print("setting node")
			scaled_node = get_node(lit_node)
		if (scaled_node.material.get_shader_param("fake_light_depth") && scaled_node != null):
			var scale_max = scaled_node.material.get_shader_param("max_scale");
			var scale_min = scaled_node.material.get_shader_param("min_scale");
			var safe_range_height = scaled_node.material.get_shader_param("obj_height");
			if (safe_range_height == -2048.0): 
				safe_range_height = -2047.99
			self.z_index = int(safe_range_height)
			if (change_compare != safe_range_height):
				change_compare = safe_range_height
				var perc_diff:float = (safe_range_height + 2048) / 4096
				var new_scale = (scale_max * perc_diff) + abs((scale_min * perc_diff) - scale_min)
				self.scale.x = new_scale
				self.scale.y = new_scale
