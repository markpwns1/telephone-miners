extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var corner_offset: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(_d):
	var cam = get_parent()
	var pos = cam.get_camera_screen_center()
	pos -= cam.get_viewport_rect().size / 2.0
	set_global_position(pos + corner_offset)
