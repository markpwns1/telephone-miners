extends Pathfinder

signal die
signal fight

export var alert_sprite: Texture

var enemy_list

# Called when the node enters the scene tree for the first time.
func _ready():
	nav = get_node("../world/nav") as Navigation2D
	enemy_list = []
	if target_pos.x == 0:
		target_pos = position
	
	$anim_plr.animation_set_next("fight", "fighter idle")

	get_node("../global_timer").connect("beat", self, "_on_global_timer_beat")
	self.connect("die", get_node("../sfx_controller"), "_on_die")
	self.connect("fight", get_node("../sfx_controller"), "_on_fight")

func _process(_d):
	update()

func _draw():
	# show radius
	var radius = get_node("detection_range/collider").shape.radius
	var points = []
	var rad = 0
	while rad < 2 * PI:
		points.append(Vector2(radius * cos(rad), radius * sin(rad)))
		rad += PI / 16.0
	
	var point = points[-1]
	for x in points:
		draw_line(point, x, Color(0.5, .1, .3, .06), 1)
		point = x
	draw_circle(Vector2.ZERO, radius, Color(0.5, .1, .3, .03))


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
		if "currently_mining" in target and target.currently_mining:
			target.currently_mining.in_use_by = null
		if "desired_ore" in target and target.desired_ore:
			target.desired_ore.in_use_by = null
		target.queue_free()
		if rand_range(0, 1.0) > 0.1:
			emit_signal("die")
		else:
			emit_signal("fight")
		$anim_plr.play("fight")


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
	if area.is_in_group("robots"):
		enemy_list.append(area)

func _on_detection_range_area_exited(area: Area2D):
	if area == null:
		return
	if area in enemy_list:
		enemy_list.erase(area)


func _on_global_timer_beat():
	_update()
