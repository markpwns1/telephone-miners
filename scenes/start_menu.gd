extends Node2D



func _on_start_pressed():
	get_tree().change_scene("res://scenes/game.tscn")


func _on_quit_pressed():
	get_tree().quit()
