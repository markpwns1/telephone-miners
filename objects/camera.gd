extends Camera2D

const PIXELS_PER_TILE = 12

export var camera_speed = 200.0
export var camera_bounds_x = 128
export var camera_bounds_y = 128

var camera_bounds_x_px = camera_bounds_x * PIXELS_PER_TILE
var camera_bounds_y_px = camera_bounds_y * PIXELS_PER_TILE

var shake_magnitude: float = 0.0
var shake_duration: float = 0.0

func shake(mag: float, dur: float):
	shake_magnitude = mag
	shake_duration += dur

func _process(dt):
	var movement = camera_speed * dt

	if Input.is_action_pressed("control_up"):# and position.y - screen_size.y - movement > 0:
		position.y -= movement
	elif Input.is_action_pressed("control_down"):# and position.y + screen_size.y + movement < camera_bounds_y_px:
		position.y += movement

	if Input.is_action_pressed("control_right"):# and position.x + screen_size.x + movement < camera_bounds_x_px:
		position.x += movement
	elif Input.is_action_pressed("control_left"):# and position.x - screen_size.x - movement > 0:
		position.x -= movement

	if shake_duration < 0:
		shake_duration = 0
	elif shake_duration > 0:
		shake_duration -= dt 
		set_offset(Vector2(rand_range(-1.0, 1.0) * shake_magnitude, rand_range(-1.0, 1.0) * shake_magnitude))
	else:
		set_offset(Vector2(0, 0))
