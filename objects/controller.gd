extends Position2D

var selected = []

export var transmitting = []

func _ready():
	for obj in transmitting:
		get_node(obj).receiver = "mine 0 -3"
