extends Position2D

export var transmitting = []

func _ready():
	for obj in transmitting:
		get_node(obj).receiver = "YAYA"
