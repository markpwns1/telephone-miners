extends Pathfinder

enum State { Idle, Moving, Mining, Disconnected }

var connected = true
var receiver: String = ""
var mstate: int = State.Idle
var mouse_on: bool = false

func _ready():
	nav = get_node("../world/nav") as Navigation2D
	target_pos = position

func _process(dt):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _on_receive(_receiver: String):
	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	if command == "move":
		target_pos = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		mstate = State.Moving
	elif command == "mine":
		mstate = State.Mining
	elif command == "beat":
		connected = true
		move_towards_target()

func _on_miner_mouse_entered():
	mouse_on = true

func _on_miner_mouse_exited():
	mouse_on = false
