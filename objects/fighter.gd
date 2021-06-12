extends Area2D

enum State {Idle, Moving, Fighting, Defending}

var receiver: String = ""
var fstate: int = State.Idle
var mouse_on: bool = false

func _process(delta):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _on_receive(_receiver: String):
	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	if command == "move":
		var coord = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		fstate = State.Moving
	elif command == "fight":
		fstate = State.Fighting
	elif command == "defend":
		fstate = State.Defending


func _on_fighter_mouse_entered():
	mouse_on = true


func _on_fighter_mouse_exited():
	mouse_on = false
