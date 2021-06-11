extends Camera2D

export var camera_speed = 200

func _process(dt):
	if Input.is_action_pressed("control_up"):
		position.y -= camera_speed * dt
	elif Input.is_action_pressed("control_down"):
		position.y += camera_speed * dt

	if Input.is_action_pressed("control_right"):
		position.x += camera_speed * dt
	elif Input.is_action_pressed("control_left"):
		position.x -= camera_speed * dt
