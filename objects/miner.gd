extends Pathfinder

export var mine_radius = 12*12
export var mining_sprite: Texture
export var moving_sprite: Texture

enum State { Idle, Moving, Mining }

var connected = true
var receiver: String = ""
var mstate: int = State.Idle
var mouse_on: bool = false

var to_mine = [ ]
var currently_mining: Ore
var desired_ore: Ore

signal mine 

func _ready():
	nav = get_node("../world/nav") as Navigation2D
	target_pos = position
	connect("mine", get_tree().root.get_child(0).get_node("sfx_controller"), "_on_mine")

func _process(_dt):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""
	update()

func sort_by_distance(a, b):
	return is_instance_valid(a) and is_instance_valid(b) and (position.distance_squared_to(a.position) < position.distance_squared_to(b.position))

# WHY TF ISNT THIS WORKING!!!!
# it's supposed to draw the miner's path
func _draw():
	draw_circle(position, 20, Color.blue) # testing, remove this after
	var p = position
	for pos in path:
		draw_line(p, pos, Color.blue)
		p = pos

func _on_receive(_receiver: String):
	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	if command == "move":
		target_pos = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float()).floor()
		is_moving = true
		to_mine = [ ]

		if currently_mining:
			currently_mining.in_use_by = null
		currently_mining = null
		mstate = State.Moving
	elif command == "mine":

		var ores = get_tree().get_nodes_in_group("ore")
		for ore in ores:
			if ore.position.distance_to(position) <= mine_radius:
				to_mine.append(ore)

		mstate = State.Mining
	elif command == "beat":
		connected = true

		if mstate == State.Moving:
			move_towards_target()
			$task_icon.texture = moving_sprite
			if position.distance_to(target_pos) < 4:
				$task_icon.texture = null
		elif mstate == State.Mining:
			$task_icon.texture = mining_sprite
			if currently_mining:
				currently_mining.resources_left -= 1
				get_tree().root.get_child(0).currency += 1
				emit_signal("mine")
				if currently_mining.resources_left <= 0:
					to_mine.erase(currently_mining)
					currently_mining.in_use_by = null
					currently_mining.queue_free()
					currently_mining = null
			elif desired_ore and is_instance_valid(desired_ore):
				target_pos = desired_ore.position
				is_moving = true
				move_towards_target()
				if not is_moving:
					currently_mining = desired_ore
					currently_mining.in_use_by = self
					desired_ore = null
			elif to_mine.size() == 0:
				mstate = State.Idle
			else:
				for ore in to_mine:
					if not is_instance_valid(ore) or not ore.position:
						to_mine.erase(ore)
				
				to_mine.sort_custom(self, "sort_by_distance")

				if to_mine.size() == 0:
					mstate = State.Idle
					return

				for ore in to_mine:
					if not is_instance_valid(ore) or not ore.position:
						to_mine.erase(ore)
						continue

					if ore.in_use_by == self or ore.in_use_by == null:
						desired_ore = ore
						ore.in_use_by = self
						break
		
		
				


func _on_miner_mouse_entered():
	mouse_on = true

func _on_miner_mouse_exited():
	mouse_on = false
