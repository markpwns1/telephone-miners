extends Pathfinder

enum State { Moving, Fighting, Defending }

export var moving_sprite: Texture
export var defending_sprite: Texture
export var attack_sprite: Texture

var connected = true
var receiver: String = ""
var fstate: int = State.Defending
var mouse_on: bool = false
var defense_spot: Vector2

var enemy_fight_detected
var enemy_defend_detected
var enemy_list

signal fight
signal die

func _ready():
	nav = get_node("../world/nav") as Navigation2D
	target_pos = position
	enemy_list = []
	enemy_fight_detected = []
	enemy_defend_detected = []
	defense_spot = position
	self.connect("die", get_node("../sfx_controller"), "_on_die")
	self.connect("fight", get_node("../sfx_controller"), "_on_fight")

	
func _process(delta):
	update()
	if receiver != "":
		_on_receive(receiver)
		receiver = ""
	if not is_moving and fstate == State.Moving:
		fstate = State.Defending
		defense_spot = position
	
	$anim_plr.animation_set_next("fight", "fighter idle")

func _draw():
	if mouse_on:
		var point = target_pos - position
		var dir = point.normalized()
		draw_line(dir * 8, point, Color(0, 0, 0, .5), 1)
		draw_line(point, point - dir.rotated(deg2rad(45)) * 4, Color(0, 0, 0, .5), 1.5)
		draw_line(point, point - dir.rotated(deg2rad(-45)) * 4, Color(0, 0, 0, .5), 1.5)

		var def_a = .2
		var att_a = .05
		if(fstate == State.Fighting):
			def_a = .05
			att_a = .15
		# show defense radius
		draw_circle(Vector2.ZERO, get_node("fighter_defend_range/collider").shape.radius, Color(0.1, .3, .5, def_a))
		# show attack radius
		draw_circle(Vector2.ZERO, get_node("fighter_fight_range/collider").shape.radius, Color(0.1, .3, .5, att_a))
	

func _on_receive(_receiver: String):
	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	if command == "move":
		target_pos = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		is_moving = true
		fstate = State.Moving
	elif command == "fight":
		fstate = State.Fighting
	elif command == "beat":
		connected = true
		if fstate == State.Moving:
			move_towards_target()
			if position.distance_to(target_pos) < 4:
				$task_icon.texture = null
			else:
				$task_icon.texture = moving_sprite
		elif fstate == State.Fighting or fstate == State.Defending:
			if(fstate == State.Fighting):
				$task_icon.texture = attack_sprite
			else:
				$task_icon.texture = defending_sprite
			is_moving = true
			var target = find_closest_enemy()
			if enemy_list.empty():
				if fstate == State.Defending:
					target_pos = defense_spot
					move_towards_target()
				return
			target_pos = target.position
			move_towards_target()
			if position.distance_to(target.position) < 12:
				enemy_list.erase(target)
				target.queue_free()
				if rand_range(0, 1.0) > 0.9:
					emit_signal("die")
				else:
					emit_signal("fight")
				$anim_plr.play("fight")

func find_closest_enemy():
	if fstate == State.Fighting:
		enemy_list = enemy_fight_detected
	else:
		enemy_list = enemy_defend_detected
	if enemy_list.empty():
		return
	var closest = enemy_list[0]
	var dist = position.distance_to(closest.position)
	for e in enemy_list:
		var d = position.distance_to(e.position)
		if d < dist:
			dist = d
			closest = e
	return closest


func _on_fighter_mouse_entered():
	mouse_on = true

func _on_fighter_mouse_exited():
	mouse_on = false


func _on_fighter_defend_range_area_entered(area):
	if area.is_in_group("enemies"):
		enemy_defend_detected.append(area)


func _on_fighter_defend_range_area_exited(area):
	if area == null:
		pass
	if area in enemy_defend_detected:
		enemy_defend_detected.erase(area)


func _on_fighter_fight_range_area_entered(area):
	if area.is_in_group("enemies"):
		enemy_fight_detected.append(area)


func _on_fighter_fight_range_area_exited(area):
	if area == null:
		pass
	if area in enemy_fight_detected:
		enemy_fight_detected.erase(area)
