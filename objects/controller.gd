extends Area2D

export var transmitting = []

func check():
	for obj in transmitting:
		get_node(obj).receiver = "check"

func _on_global_timer_beat():
	for child in get_parent().get_children():
		if child.get("connected") != null:
			child.connected = false
	check()
