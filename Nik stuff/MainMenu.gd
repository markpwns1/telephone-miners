extends MarginContainer

# const first_scene = preload("../scenes/game.tcsn") #scene goes here?

export var first_scene: PackedScene

onready var selector_one = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector
onready var selector_two = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector
onready var selector_three = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Selector


var select_inputs = ["Enter", "Right", "Space"]

var current_selection = 0

func _ready():
	set_current_selection(0)

func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)

func handle_selection(_current_selection):
	if _current_selection ==0:
		get_parent().add_child(first_scene.instance())
		queue_free()
	if _current_selection == 2:
		get_tree().quit()

func _unhandled_input(event):
	if event.as_text() in select_inputs:
		handle_selection(current_selection)

func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	selector_three.text = ""
	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"
	elif _current_selection == 2:
		selector_three.text = ">"
		
