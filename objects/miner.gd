extends Position2D

var receiver: String = ""

func _process(delta):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""
	pass

func _on_receive(_receiver: String):
	print(_receiver)
