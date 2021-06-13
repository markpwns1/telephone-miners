extends Pathfinder

enum State { Idle, Moving }

export var transmitting = []
export var moving_sprite: Texture

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
	update();
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _draw():
	if mouse_on:
		#darken direction
		var point = target_pos - position
		var dir = point.normalized()
		draw_line(dir * 8, point, Color(0, 0, 0, .5), 1)
		draw_line(point, point - dir.rotated(deg2rad(45)) * 4, Color(0, 0, 0, .5), 1.5)
		draw_line(point, point - dir.rotated(deg2rad(-45)) * 4, Color(0, 0, 0, .5), 1.5)
		# show radius
		draw_circle(Vector2.ZERO, 120, Color(0.1, .3, .5, .15))

func _on_receive(_receiver: String):
	cull_null_transmitees()

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
		is_moving = true
		pstate = State.Moving
	else:
		for obj in transmitting:
			get_node(obj).receiver = _receiver
		if command == "beat":
			connected = true
			if not is_moving:
				pstate == State.Idle
			move_towards_target()
			if position.distance_to(target_pos) < 4:
				$task_icon.texture = null
			else:
				$task_icon.texture = moving_sprite
			if pstate != State.Moving:
				for transmittee in transmitting:
					var unit = get_node(transmittee)
					if position.distance_to(unit.target_pos) > 120:
						var move_to = position + (position.direction_to(unit.position) * 10).floor() * 12
						unit.target_pos = move_to
						unit.is_moving = true
						if unit.get("mstate") != null:
							unit.mstate = 1
						elif unit.get("fstate") != null:
							unit.fstate = 0
						elif unit.get("pstate") != null:
							unit.pstate = 1

func _on_pylon_mouse_entered():
	mouse_on = true

func _on_pylon_mouse_exited():
	mouse_on = false


func cull_null_transmitees():
	var to_remove = []
	for x in transmitting:
		if get_node(x) == null:
			to_remove.append(x)
	for x in to_remove:
		transmitting.erase(x)
