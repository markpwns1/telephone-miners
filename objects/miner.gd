extends Area2D

enum State { Idle, Moving, Mining, Disconnected }

var nav: Navigation2D

var connected = true
var receiver: String = ""
var mstate: int = State.Idle
var mouse_on: bool = false

var target_pos: Vector2
var path: PoolVector2Array

func resolve_path():
	path = nav.get_simple_path(position, target_pos)

func _ready():
	nav = get_node("../world/nav") as Navigation2D

func _process(dt):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _on_receive(_receiver: String):
	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	if command == "move":
		target_pos = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		print("Command to move to: ")
		print(target_pos)
		resolve_path()
		mstate = State.Moving
	elif command == "mine":
		mstate = State.Mining
	elif command == "check":
		connected = true

func _on_miner_mouse_entered():
	mouse_on = true

func _on_miner_mouse_exited():
	mouse_on = false

func _on_global_timer_beat():
	resolve_path()
	if path and path[0]:
		position = path[0]
