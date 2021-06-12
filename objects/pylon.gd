extends Area2D

export var transmitting = []

var connected = true
var receiver: String = ""
var mouse_on: bool = false

func _ready():
	$anim_plr.play("pylon_idle")

func _process(delta):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _on_receive(_receiver: String):
	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	for obj in transmitting:
		get_node(obj).receiver = _receiver
	if command == "check":
		connected = true

func _on_pylon_mouse_entered():
	mouse_on = true

func _on_pylon_mouse_exited():
	mouse_on = false

func _on_global_timer_beat():
	# move_towards_target()
	pass
