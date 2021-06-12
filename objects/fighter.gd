extends Pathfinder

enum State {Idle, Moving, Fighting, Defending, Disconnected}

var connected = true
var receiver: String = ""
var fstate: int = State.Idle
var mouse_on: bool = false

func _ready():
	nav = get_node("../world/nav") as Navigation2D
	target_pos = position
	
func _process(delta):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _on_receive(_receiver: String):
	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	if command == "move":
		target_pos = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		is_moving = true
		fstate = State.Moving
	elif command == "fight":
		fstate = State.Fighting
	elif command == "defend":
		fstate = State.Defending
	elif command == "beat":
		connected = true
		move_towards_target()

func _on_fighter_mouse_entered():
	mouse_on = true

func _on_fighter_mouse_exited():
	mouse_on = false
