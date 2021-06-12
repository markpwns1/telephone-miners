extends Node2D

enum Option {NONE, MOVING_TO}

var selecting_state = Option.NONE

var selection: Node

func _unhandled_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		if selecting_state == Option.NONE:
			var selected = false
			for child in get_children():
				if child.get("mouse_on"):
					selected = true
					selection = child
					$commands.set_position(event.position)
					$commands.select(selection)
			if not selected:
				selection = null
				$commands.hide()
		else:
			selecting_state = Option.NONE
			# get mouse position and give move command

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
