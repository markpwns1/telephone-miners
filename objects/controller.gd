extends Area2D

export var transmitting = []

var mouse_on: bool = false
var connected: bool = true # Constant

func check():
	for obj in transmitting:
		get_node(obj).receiver = "check"

func _on_global_timer_beat():
	for child in get_parent().get_children():
		if child.get("connected") != null:
			child.connected = false
	check()


func _on_controller_mouse_entered():
	mouse_on = true


func _on_controller_mouse_exited():
	mouse_on = false
