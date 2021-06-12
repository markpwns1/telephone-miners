extends Area2D

class_name Pathfinder

var nav: Navigation2D

var target_pos: Vector2
var is_moving = false
var path: PoolVector2Array

func resolve_path():
	if nav:
		path = nav.get_simple_path(position, target_pos)

func move_towards_target():
	if not is_moving:
		return

	var dist = position.distance_to(target_pos)

	if dist < 12:
		position = target_pos
		is_moving = false
		return

	resolve_path()

	if path and path[1]:
		var dist_to_next_node = position.distance_to(path[1].floor())
		position += (path[1].floor() - position).normalized() * min(12, dist_to_next_node)
