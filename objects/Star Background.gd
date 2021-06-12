extends MeshInstance2D

export var node_to_follow: NodePath
var to_follow

# Called when the node enters the scene tree for the first time.
func _ready():
	to_follow = get_node(node_to_follow).get_node("camera")


func _process(delta):
	global_transform = to_follow.global_transform
	material.set_shader_param("offset", position)
