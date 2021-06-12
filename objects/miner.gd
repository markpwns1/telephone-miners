extends Pathfinder

export var mine_radius = 12*6

enum State { Idle, Moving, Mining, Disconnected }

var connected = true
var receiver: String = ""
var mstate: int = State.Idle
var mouse_on: bool = false

var to_mine = [ ]
var currently_mining: Ore
var desired_ore: Ore

func _ready():
	nav = get_node("../world/nav") as Navigation2D
	target_pos = position

func _process(dt):
	if receiver != "":
		_on_receive(receiver)
		receiver = ""

func sort_by_distance(a, b):
	return position.distance_squared_to(a.position) < position.distance_squared_to(b.position)

func _on_receive(_receiver: String):
	var splitted_receiver = _receiver.split(" ")
	var command = splitted_receiver[0]
	if command == "move":
		target_pos = Vector2(splitted_receiver[1].to_float(), splitted_receiver[2].to_float())
		is_moving = true
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
		elif mstate == State.Mining:
			if currently_mining:
				currently_mining.resources_left -= 1
				get_owner().currency += 1
				if currently_mining.resources_left <= 0:
					to_mine.erase(currently_mining)
					currently_mining.queue_free()
					currently_mining = null
			elif desired_ore:
				target_pos = desired_ore.position
				is_moving = true
				move_towards_target()
				if not is_moving:
					currently_mining = desired_ore
					desired_ore = null
			elif to_mine.size() == 0:
				mstate = State.Idle
			else:
				to_mine.sort_custom(self, "sort_by_distance")
				desired_ore = to_mine[0]


func _on_miner_mouse_entered():
	mouse_on = true

func _on_miner_mouse_exited():
	mouse_on = false
