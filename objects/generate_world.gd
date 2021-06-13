extends TileMap

export var island_falloff = 20
export var size_x = 128
export var size_y = 128
export var surface_material: Material
export var enemy_spawner: PackedScene

export var ore_count = 20
export var spawner_count: int

var rng = RandomNumberGenerator.new()
var noise = OpenSimplexNoise.new()

var center = Vector2(0.5, 0.5)

onready var ore = preload("res://objects/ore.tscn")

const ISLAND_HEIGHT = 3

func get_position_with_difficulty_dist():
	var x = rng.randi_range(0, 128)
	var y = rng.randi_range(0, 128)

	while get_cell(x, y) != 1 or y > rng.randi_range(0, 128):
		x = rng.randi_range(0, 128)
		y = rng.randi_range(0, 128)

	return Vector2(x, y)

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
				for i in range(ISLAND_HEIGHT):
					set_cell(x, y - 1, 2)
				set_cell(x, y - ISLAND_HEIGHT, 1)

	var i = 0
	while i < ore_count:
		var pos = get_position_with_difficulty_dist()
		var inst = ore.instance()
		inst.position = pos * 12 + Vector2(6, 6)
		add_child(inst)
		i += 1

	i = 0
	while i < spawner_count:
		var pos = get_position_with_difficulty_dist()
		var inst = enemy_spawner.instance()
		inst.position = pos * 12 + Vector2(6, 6)
		add_child(inst)
		i += 1

		# print(inst.position)

	if(surface_material):
		tile_set.tile_set_material(1, surface_material)
