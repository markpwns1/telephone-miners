extends Node2D

var follow_mouse = true

var follow_node: Node


func _process(_delta):
	if follow_mouse:
		position.x = 6 + floor(get_global_mouse_position().x / 12) * 12
		position.y = 6 + floor(get_global_mouse_position().y / 12) * 12
	elif is_instance_valid(follow_node):
		position.x = follow_node.position.x
		position.y = follow_node.position.y

func follow_node(node: Node):
	follow_node = node
