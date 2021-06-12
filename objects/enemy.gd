extends Pathfinder

signal die
signal fight

var enemy_list

# Called when the node enters the scene tree for the first time.
func _ready():
	nav = get_node("../world/nav") as Navigation2D
	enemy_list = []
	target_pos = position
	print(get_owner().name)
	get_owner().connect("beat", self, "_on_global_timer_beat")


func _update():
	print("update")
	if enemy_list.empty():
		return
	
	var target = find_closest_enemy()
	print(target)
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
	var closest = enemy_list[0]
	var dist = position.distance_to(closest.position)
	for e in enemy_list:
		var d = position.distance_to(e.position)
		if d < dist:
			dist = d
			closest = e
	return closest



func _on_fighter_area_entered(area: Area2D):
	if area.is_in_group("robots"):
		enemy_list.append(area)

func _on_fighter_area_exited(area: Area2D):
	if area == null:
		return
	if area in enemy_list:
		enemy_list.erase(area)


func _on_global_timer_beat():
	_update()
