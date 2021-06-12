extends Pathfinder

enum State { Idle, Moving }

export var transmitting = []

var connected = true
var receiver: String = ""
var pstate = State.Idle
var mouse_on: bool = false

func _ready():
	$anim_plr.play("pylon_idle")
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
		if command == "beat":
			connected = true
			move_towards_target()

func _on_pylon_mouse_entered():
	mouse_on = true

func _on_pylon_mouse_exited():
	mouse_on = false
