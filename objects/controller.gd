extends Pathfinder
#extends Node2D

enum State { Idle, Moving }

export var transmitting = []

var mouse_on: bool = false
var receiver: String = ""
var pstate = State.Idle
var connected: bool = true # Constant

func _ready():
	nav = get_node("../world/nav") as Navigation2D
	target_pos = position

func _process(delta):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _on_receive(_receiver: String):
	cull_null_transmitees()

	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	if command == "move":
		target_pos = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		is_moving = true
		pstate = State.Moving
		var i = 0
		var j = 0
		var x = splitted_receiver[1].to_float()
		var y = splitted_receiver[2].to_float()
		for obj in transmitting:
			if "pylon" in get_node(obj).name:
				get_node(obj).receiver = "move " + String(x + 48 * j) + " " + splitted_receiver[2]
				if j < 1:
					i += 1
				j += 1
			else:
				get_node(obj).receiver = "move " + String(x + 12 * (i % 4)) + " " + String(y + 12 * floor(i / 4))
				i += 1
	elif command == "smove":
		target_pos = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		pstate = State.Moving
	else:
		for obj in transmitting:
			get_node(obj).receiver = _receiver

func check():
	cull_null_transmitees()
	for obj in transmitting:
		get_node(obj).receiver = "beat"
	connected = true

func _on_global_timer_beat():
	for child in get_parent().get_children():
		if child.get("connected") != null:
			child.connected = false
	check()
	move_towards_target()

func _on_controller_mouse_entered():
	mouse_on = true

func _on_controller_mouse_exited():
	mouse_on = false

	
func cull_null_transmitees():
	var to_remove = []
	for x in transmitting:
		if get_node(x) == null:
			to_remove.append(x)
	for x in to_remove:
		transmitting.erase(x)
