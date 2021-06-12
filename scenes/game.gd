extends Node2D

enum Option {NONE, MOVING_TO, SPAWNING}

export var fighter_prefab: PackedScene
export var miner_prefab: PackedScene
export var pylon_prefab: PackedScene

var selecting_state = Option.NONE
var selection: Node

var spawning_position: Vector2

export var currency: int = 0

func _unhandled_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		$grid_selection_icon.position = Vector2(6, 6) + (get_global_mouse_position() / 12).floor() * 12
		if selecting_state == Option.NONE or selecting_state == Option.SPAWNING:
			var selected = false
			for child in get_children():
				if child.get("mouse_on") and child.get("connected"):
					if selecting_state == Option.NONE:
						selected = true
						selection = child

						var menu_offset = $commands.rect_pivot_offset
						$commands.set_position(get_global_mouse_position() - menu_offset)
						$commands.select(selection)
						$spawning.hide()
					elif child.get("transmitting") != null:
						selected = true
						child.transmitting.append(selection)
						add_child(selection)
						
			if not selected:
				selection = null
				$commands.hide()
				$spawning.set_position(get_global_mouse_position())
				$spawning.visible = !$spawning.visible
				spawning_position = $grid_selection_icon.position
		else:
			selecting_state = Option.NONE
			selection.receiver = "move " + String(6 + floor(get_global_mouse_position().x / 12) * 12) + " " + String(6 + floor(get_global_mouse_position().y / 12) * 12)

func _on_move_pressed():
	selecting_state = Option.MOVING_TO
	$commands.hide()

func _on_mine_pressed():
	selection.receiver = "mine"
	selection = null
	$commands.hide()

func _on_fight_pressed():
	selection.receiver = "fight"
	selection = null
	$commands.hide()

func _on_defend_pressed():
	selection.receiver = "defend"
	selection = null
	$commands.hide()

func _on_miner_pressed():
	selection = miner_prefab.instance()
	selection.position = spawning_position
	selecting_state = Option.SPAWNING
	$spawning.hide()

func _on_fighter_pressed():
	selection = fighter_prefab.instance()
	selection.position = spawning_position
	selecting_state = Option.SPAWNING
	$spawning.hide()

func _on_pylon_pressed():
	selection = pylon_prefab.instance()
	selection.position = spawning_position
	selecting_state = Option.SPAWNING
	$spawning.hide()
