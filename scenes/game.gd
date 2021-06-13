extends Node2D

class_name Game

enum Option { NONE, MOVING_TO, SPAWNING }

export var fighter_prefab: PackedScene
export var miner_prefab: PackedScene
export var pylon_prefab: PackedScene

var selecting_state = Option.NONE
var selection: Node
var stealth = false

var available_pylon
var connectable_pylon

var spawning_position: Vector2
var spawn_time: float

export var currency: int = 0
export var unit_spawn_sound_time_window: float

export var select_sfx: AudioStream
export var command_press_sfx: AudioStream
export var alt_select_sfx: AudioStream
export var choose_pos_sfx: AudioStream
var sfx: AudioStreamPlayer

signal spawn_unit
func _ready():
	self.connect("spawn_unit", get_node("sfx_controller"), "_on_unit_spawn")
	available_pylon = []
	connectable_pylon = []
	$selection_icon.follow_mouse = false
	$selection_icon.visible = false
	sfx = $menu_sfx

func _process(delta):
	$cursor_range.position = get_global_mouse_position()
	update()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed() and (event.button_index == BUTTON_LEFT or event.button_index == BUTTON_RIGHT or event.button_index == BUTTON_MIDDLE):
		$move_selection_icon.position = Vector2(6, 6) + (get_global_mouse_position() / 12).floor() * 12
		if selecting_state == Option.NONE or selecting_state == Option.SPAWNING:
			var selected = false
			for child in get_children():
				if child.get("mouse_on") and child.get("connected"):
					if selecting_state == Option.NONE:
						selected = true
						selection = child
						
						if event.button_index == BUTTON_LEFT:
							# Select an unit with left mouse -> command
							var menu_offset = $commands.rect_pivot_offset
							$commands.set_position(get_global_mouse_position() - menu_offset)
							$commands.select(selection)
							play_sound(select_sfx)
							$selection_icon.visible = true
							$selection_icon.follow_node(child)
						elif event.button_index == BUTTON_RIGHT:
							# Select an unit with right mouse -> move
							_on_move_pressed()
							play_sound(alt_select_sfx)
							$selection_icon.visible = true
							$selection_icon.follow_node(child)
						else:
							# Select an unit with middle mouse
							if is_instance_valid(selection):
								selection.receiver = "do"
							selection = null
							$commands.hide()
							$grid_selection_icon.visible = true
							$selection_icon.visible = false
							play_sound(alt_select_sfx)
							# if child.get("fstate") != null:
							# 	_on_fight_pressed()
							# elif child.get("mstate") != null:
							# 	_on_mine_pressed()
						$spawning.hide()
						
						if Input.is_action_pressed("control_stealth"):
							# If shift key pressed
							stealth = true
					elif child in connectable_pylon: # Selected unit need to be in connectable_pylon
						# Connecting spawned unit to pylon
						selected = true
						add_child(selection)
						child.transmitting.append(selection.get_path())
						$pylon_selection_icon.visible = false
						$grid_selection_icon.visible = true
						$selection_icon.visible = false
						selecting_state = Option.NONE
						currency -= 1
						spawn_time = OS.get_ticks_msec()
					else:
						# Canceling everything
						$pylon_selection_icon.visible = false
						$grid_selection_icon.visible = true
						$selection_icon.visible = false
						$move_selection_icon.visible = false
						$spawning.hide()
						
			if not selected:
				# Not click on any unit
				selection = null
				$commands.hide()
				if currency > 0 and not available_pylon.empty() and event.button_index == BUTTON_LEFT:
					# Spawning
					connectable_pylon = []
					for x in available_pylon:
						connectable_pylon.append(x)
					$spawning.set_position(get_global_mouse_position())
					$spawning.visible = !$spawning.visible
					spawning_position = $move_selection_icon.position
					$grid_selection_icon.visible = true
					$pylon_selection_icon.visible = false
					$selection_icon.visible = $spawning.visible
					$selection_icon.position = spawning_position
					$selection_icon.follow_node(null)
				else:
					# No spawning
					$spawning.hide()
					$selection_icon.hide()
				selecting_state = Option.NONE
		elif event.button_index == BUTTON_LEFT:
			# Left click while choosing a place to move to
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
			play_sound(choose_pos_sfx)
		elif event.button_index == BUTTON_RIGHT:
			# Right click to cancel moving state
			selecting_state = Option.NONE
			selection = null
			$pylon_selection_icon.visible = false
			$grid_selection_icon.visible = true
			$selection_icon.visible = false
			$move_selection_icon.visible = false

func _draw():
	for child in get_children():
		if child.get("transmitting") != null:
			child.cull_null_transmitees()
			for transmittee in child.transmitting:
				var dir = (child.get_node(transmittee).position - child.position).normalized()
				draw_line(child.position + dir * 6, child.get_node(transmittee).position - dir * 6, Color(0, 0, 0, 0.5), 1)

func _on_move_pressed():
	if is_instance_valid(selection):
		if Input.is_action_pressed("control_stealth"):
			stealth = true
		selecting_state = Option.MOVING_TO
	else:
		selection = null
		selecting_state = Option.NONE
	$commands.hide()
	$move_selection_icon.visible = true
	$grid_selection_icon.visible = false
	play_sound(command_press_sfx)

func _on_mine_pressed():
	if is_instance_valid(selection):
		selection.receiver = "mine"
	selection = null
	$commands.hide()
	$grid_selection_icon.visible = true
	$selection_icon.visible = false
	play_sound(command_press_sfx)

func _on_fight_pressed():
	if is_instance_valid(selection):
		selection.receiver = "fight"
	selection = null
	$commands.hide()
	$grid_selection_icon.visible = true
	$selection_icon.visible = false
	play_sound(command_press_sfx)

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
	play_sound(command_press_sfx)

func _on_global_timer_beat():
	get_node("rts_camera/camera/currency").text = String(currency)
	if OS.get_ticks_msec() - spawn_time < unit_spawn_sound_time_window:
		emit_signal("spawn_unit")

func _on_cursor_range_area_entered(area):
	if area.get("transmitting") != null:
		available_pylon.append(area)

func _on_cursor_range_area_exited(area):
	if area == null:
		return
	if area in available_pylon:
		available_pylon.erase(area)

func play_sound(stream: AudioStream):
	sfx.stream = stream
	sfx.play()