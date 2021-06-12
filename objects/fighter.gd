extends Pathfinder

enum State {Idle, Moving, Fighting, Defending, Disconnected}

var connected = true
var receiver: String = ""
var fstate: int = State.Idle
var mouse_on: bool = false

var enemy_fight_detected
var enemy_defend_detected
var enemy_list

func _ready():
	nav = get_node("../world/nav") as Navigation2D
	target_pos = position
	enemy_list = []
	enemy_fight_detected = []
	enemy_defend_detected = []
	
func _process(delta):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func _on_receive(_receiver: String):
	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	if command == "move":
		target_pos = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		is_moving = true
		fstate = State.Moving
	elif command == "fight":
		fstate = State.Fighting
	elif command == "defend":
		fstate = State.Defending
	elif command == "beat":
		connected = true
		if fstate == State.Moving:
			move_towards_target()
		elif fstate == State.Fighting or fstate == State.Defending:
			is_moving = true
			var target = find_closest_enemy()
			if enemy_list.empty():
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
