extends Node2D

class_name Game

enum Option {NONE, MOVING_TO, SPAWNING}

export var fighter_prefab: PackedScene
export var miner_prefab: PackedScene
export var pylon_prefab: PackedScene

var selecting_state = Option.NONE
var selection: Node
var stealth = false

var available_pylon
var connectable_pylon

var spawning_position: Vector2

export var currency: int = 0

signal spawn_unit
func _ready():
	self.connect("spawn_unit", get_node("sfx_controller"), "_on_unit_spawn")
	available_pylon = []
	connectable_pylon = []
	$selection_icon.follow_mouse = false
	$selection_icon.visible = false

func _unhandled_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		$cursor_range.position = get_global_mouse_position()
		$move_selection_icon.position = Vector2(6, 6) + (get_global_mouse_position() / 12).floor() * 12
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
						
						$selection_icon.visible = true
						$selection_icon.follow_node(child)
						if Input.is_action_pressed("control_stealth"):
							stealth = true
					elif child in connectable_pylon:
						selected = true
						add_child(selection)
						child.transmitting.append(selection.get_path())
						$pylon_selection_icon.visible = false
						$grid_selection_icon.visible = true
						$selection_icon.visible = false
						selecting_state = Option.NONE
						currency -= 1
						emit_signal("spawn_unit")
					else:
						$pylon_selection_icon.visible = false
						$grid_selection_icon.visible = true
						$selection_icon.visible = false
						$move_selection_icon.visible = false
						$spawning.hide()
						
			if not selected:
				selection = null
				$commands.hide()
				if currency > 0 and not available_pylon.empty():
					connectable_pylon = []
					for x in available_pylon:
						connectable_pylon.append(x)
					$spawning.set_position(get_global_mouse_position())
					$spawning.visible = !$spawning.visible
					spawning_position = $move_selection_icon.position
					$grid_selection_icon.visible = true
					$pylon_selection_icon.visible = false
					$selection_icon.visible = true
					$selection_icon.position = spawning_position
					$selection_icon.follow_node(null)
				selecting_state = Option.NONE
		else:
			selecting_state = Option.NONE
			$pylon_selection_icon.visible = false
			$grid_selection_icon.visible = true
			$selection_icon.visible = false
			$move_selection_icon.visible = false
			if stealth:
				selection.receiver = "smove " + String(6 + floor(get_global_mouse_position().x / 12) * 12) + " " + String(6 + floor(get_global_mouse_position().y / 12) * 12)
			else:
				selection.receiver = "move " + String(6 + floor(get_global_mouse_position().x / 12) * 12) + " " + String(6 + floor(get_global_mouse_position().y / 12) * 12)
			stealth = false
			$selection_icon.visible = false

func _draw():
	for child in get_children():
		if child.get("transmitting") != null:
			child.cull_null_transmitees()
			for transmittee in child.transmitting:
				var dir = (child.get_node(transmittee).position - child.position).normalized()
				draw_line(child.position + dir * 6, child.get_node(transmittee).position - dir * 6, Color(0, 0, 0, 0.5), 1)

func _on_move_pressed():
	if Input.is_action_pressed("control_stealth"):
		stealth = true
	selecting_state = Option.MOVING_TO
	$commands.hide()
	$move_selection_icon.visible = true
	$grid_selection_icon.visible = false

func _on_mine_pressed():
	selection.receiver = "mine"
	selection = null
	$commands.hide()
	$grid_selection_icon.visible = true
	$selection_icon.visible = false

func _on_fight_pressed():
	selection.receiver = "fight"
	selection = null
	$commands.hide()
	$grid_selection_icon.visible = true
	$selection_icon.visible = false

func _on_defend_pressed():
	selection.receiver = "defend"
	selection = null
	$commands.hide()
	$grid_selection_icon.visible = true
	$selection_icon.visible = false

func _on_miner_pressed():
	selection = miner_prefab.instance()
	configure_spawn_ui()

func _on_fighter_pressed():
	selection = fighter_prefab.instance()
	configure_spawn_ui()

func _on_pylon_pressed():
	selection = pylon_prefab.instance()
	configure_spawn_ui()


func configure_spawn_ui():
	selection.position = spawning_position
	selecting_state = Option.SPAWNING
	$spawning.hide()
	$pylon_selection_icon.visible = true
	$grid_selection_icon.visible = false

func _on_global_timer_beat():
	get_node("rts_camera/camera/currency").text = String(currency)
	update()

func _on_cursor_range_area_entered(area):
	if area.get("transmitting") != null:
		available_pylon.append(area)

func _on_cursor_range_area_exited(area):
	if area == null:
		return
	if area in available_pylon:
		available_pylon.erase(area)
