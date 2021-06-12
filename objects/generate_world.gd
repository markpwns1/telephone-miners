extends TileMap

export var island_falloff = 20
export var size_x = 128
export var size_y = 128

var noise = OpenSimplexNoise.new()

var center = Vector2(0.5, 0.5)

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
				set_cell(x, y - 1, 0)
			else:
				set_cell(x, y, 1)
