extends Position2D

export var transmitting = []

var receiver: String = ""

func _ready():
	$anim_plr.play("pylon_idle")

func _process(delta):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _on_receive(_receiver: String):
	for obj in transmitting:
		get_node(obj).receiver = _receiver
