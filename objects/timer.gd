extends Node2D

export var beats_per_second = 1.0
export var offset: float

var beat_interval = 1.0 / beats_per_second

var timer = 0.0

signal beat


func _ready():
	timer = offset

func _process(dt):
	timer += dt
	if timer >= beat_interval:
		timer -= beat_interval
		emit_signal("beat")
