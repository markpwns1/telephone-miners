extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var follow_mouse = true

var follow_node: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if follow_mouse:
		position.x = 6 + floor(get_global_mouse_position().x / 12) * 12
		position.y = 6 + floor(get_global_mouse_position().y / 12) * 12
	elif follow_node != null:
		position.x = follow_node.position.x
		position.y = follow_node.position.y

func follow_node(node: Node):
	follow_node = node
