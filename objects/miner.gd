extends Area2D

enum State {Idle, Moving, Mining, Disconnected}

var connected = true
var receiver: String = ""
var mstate: int = State.Idle
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
		mstate = State.Moving
	elif command == "mine":
		mstate = State.Mining
	elif command == "check":
		connected = true

func _on_miner_mouse_entered():
	mouse_on = true

func _on_miner_mouse_exited():
	mouse_on = false
