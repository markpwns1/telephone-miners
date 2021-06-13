extends Area2D

class_name Pathfinder

var nav: Navigation2D

var target_pos: Vector2
var is_moving = false
var out_of_range = false
var out_of_range_timer = 0
var path: PoolVector2Array

func resolve_path():
	if nav:
		path = nav.get_simple_path(position, target_pos)

func move_towards_target():
	if out_of_range:
		out_of_range_timer += 1
		if out_of_range_timer > 2:
			out_of_range_timer = 0
			out_of_range = false
	update()
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


func _draw():
	if is_moving:
		var point = target_pos - position
		var dir = point.normalized()
		draw_line(dir * 8, point, Color(0, 0, 0, .2), 1)
		draw_line(point, point - dir.rotated(deg2rad(45)) * 4, Color(0, 0, 0, .2), 1.5)
		draw_line(point, point - dir.rotated(deg2rad(-45)) * 4, Color(0, 0, 0, .2), 1.5)
