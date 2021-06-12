extends Pathfinder

signal die
signal fight

export var alert_sprite: Texture

var enemy_list

# Called when the node enters the scene tree for the first time.
func _ready():
	nav = get_node("../world/nav") as Navigation2D
	enemy_list = []
	
	get_node("../global_timer").connect("beat", self, "_on_global_timer_beat")
	self.connect("die", get_node("../sfx_controller"), "_on_die")
	self.connect("fight", get_node("../sfx_controller"), "_on_fight")


func _update():
	if enemy_list.empty():
		move_towards_target()
		$alert_icon.texture = null
		return
	
	$alert_icon.texture = alert_sprite
	is_moving = true
	var target = find_closest_enemy()
	target_pos = target.position
	move_towards_target()
	if position.distance_to(target.position) < 12:
		enemy_list.erase(target)
		target.queue_free()
		if rand_range(0, 1.0) > 0.1:
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



func _on_detection_range_area_entered(area: Area2D):
	print(area.name)
	print(area.get_groups())
	if area.is_in_group("robots"):
		enemy_list.append(area)

func _on_detection_range_area_exited(area: Area2D):
	if area == null:
		return
	if area in enemy_list:
		enemy_list.erase(area)


func _on_global_timer_beat():
	_update()
