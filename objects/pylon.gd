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
	target_pos = position
	
	var inspector_transmit = transmitting
	transmitting = []
	for x in inspector_transmit:
		transmitting.append(x)

func _process(delta):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _on_receive(_receiver: String):
	var to_remove = []
	for x in transmitting:
		if get_node(x) == null:
			to_remove.append(x)
	for x in to_remove:
		transmitting.erase(x)

	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]

	if command == "move":
		target_pos = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		is_moving = true
		pstate = State.Moving
		var i = 1
		var j = 1
		for obj in transmitting:
			if "pylon" in get_node(obj).name:
				get_node(obj).receiver = "move " + String(splitted_receiver[1].to_float() + 48 * j) + " " + splitted_receiver[2]
				j += 1
			else:
				get_node(obj).receiver = "move " + String(splitted_receiver[1].to_float() + 12 * (i % 4)) + " " + String(splitted_receiver[2].to_float() + 12 * floor(i / 4))
				i += 1
	elif command == "smove":
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
