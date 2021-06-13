extends MarginContainer

# const first_scene = preload("../scenes/game.tcsn") #scene goes here?

export var first_scene: PackedScene

onready var selector_one = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/Start/HBoxContainer/Selector
onready var selector_two = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/Exit/HBoxContainer/Selector
# onready var selector_three = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Selector


var select_inputs = ["Enter", "Right", "Space"]

var current_selection = 0

func _ready():
	set_current_selection(0)

func _process(delta):
	if Input.is_action_just_pressed("ui_down")and current_selection < 1:
		current_selection += 1
		set_current_selection(current_selection)
		$sfx_click.play()
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
		$sfx_click.play()
	
	$ColorRect.material.set_shader_param("offset", get_global_mouse_position())

func handle_selection(_current_selection):
	if _current_selection ==0:
		get_parent().add_child(first_scene.instance())
		queue_free()
	if _current_selection == 1:
		get_tree().quit()

func _unhandled_input(event):
	if event.as_text() in select_inputs:
		handle_selection(current_selection)

func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"
		

func _on_start_button_pressed():
	handle_selection(0)

func _on_start_button_mouse_entered():
	if current_selection == 1:
		$sfx_click.play()
	current_selection = 0
	set_current_selection(0)

func _on_exit_button_pressed():
	handle_selection(1)

func _on_exit_button_mouse_entered():
	if current_selection == 0:
		$sfx_click.play()
	current_selection = 1
	set_current_selection(1)
