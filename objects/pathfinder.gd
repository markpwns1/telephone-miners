extends Area2D

class_name Pathfinder

var nav: Navigation2D

var target_pos: Vector2
var path: PoolVector2Array

func resolve_path():
    if nav:
	    path = nav.get_simple_path(position, target_pos)

func move_towards_target():
    var dist = position.distance_to(target_pos)

    if dist < 12:
        position = target_pos
        return

    resolve_path()

    if path and path[1]:
        position += (path[1] - position).normalized() * min(12, dist)