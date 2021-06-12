extends Pathfinder

enum State { Idle, Moving }

export var transmitting = []

var mouse_on: bool = false
var receiver: String = ""
var pstate = State.Idle
var connected: bool = true # Constant

func _ready():
	nav = get_node("../world/nav") as Navigation2D

func _process(delta):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _on_receive(_receiver: String):
	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	if command == "move":
		target_pos = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		pstate = State.Moving
	else:
		for obj in transmitting:
			get_node(obj).receiver = _receiver

func check():
	for obj in transmitting:
		get_node(obj).receiver = "check"
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
