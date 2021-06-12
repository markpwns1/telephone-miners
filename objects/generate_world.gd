extends TileMap

export var island_falloff = 20
export var size_x = 128
export var size_y = 128

export var ore_count = 20

var rng = RandomNumberGenerator.new()
var noise = OpenSimplexNoise.new()

var center = Vector2(0.5, 0.5)

onready var ore = preload("res://objects/ore.tscn")

func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

	for x in range(0, size_x):
		for y in range(0, size_y):
			var v = Vector2((x as float) / (size_x as float), (y as float) / (size_y as float))
			var dist = v.distance_to(center)
			v *= 60
			var height = noise.get_noise_2dv(v) + 0.5 - dist * 2
			if height > 0:
				set_cell(x, y, 2)
				set_cell(x, y - 1, 1)

	# var i = 0
	# while i < ore_count:
	# 	var x = rng.randi_range(0, 128)
	# 	var y = rng.randi_range(0, 128)
	# 	while get_cell(x, y) == 2:
	# 		x = rng.randi_range(0, 128)
	# 		y = rng.randi_range(0, 128)

	# 	var inst = ore.instance()
	# 	inst.position.x = x * 12
	# 	inst.position.y = y * 12
	# 	i += 1

	# 	print(inst.position)
