extends Area2D

enum State {Idle, Moving, Mining}

var receiver: String = ""
var state: int = State.Idle

func _process(delta):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _on_receive(_receiver: String):
	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	if command == "move":
		var coord = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		state = State.Moving
	elif command == "mine":
		state = State.Mining
