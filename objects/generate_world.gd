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

onready var controller = get_node("../../../controller")
onready var miner = get_node("../../../miner")
onready var pylon = get_node("../../../pylon")
onready var cam = get_viewport().get_camera() # get_tree().root.get_child(0).get_node("rts_camera/camera")

const ISLAND_HEIGHT = 3

const SIDE_TILE_START = 4
const SIDE_TILE_COUNT = 3
# const TOP_TILE_START

func get_random_side_tile():
	return rng.randi_range(SIDE_TILE_START, SIDE_TILE_START + SIDE_TILE_COUNT - 1)

func get_position_with_difficulty_dist(s = 1.0):
	var x = rng.randi_range(0, 128)
	var y = rng.randi_range(0, 128)

	while get_cell(x, y) != 1 or y > rng.randi_range(0, 128.0 * s):
		x = rng.randi_range(0, 128)
		y = rng.randi_range(0, 128)

	return Vector2(x, y)

func _ready():
	var s = OS.get_unix_time()
	noise.seed = s
	print("SEED: " + String(s))
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
					set_cell(x, y - i, get_random_side_tile())
				set_cell(x, y - ISLAND_HEIGHT, 1)
			else:
				set_cell(x, y, 3)

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
		inst.max_count = pos.y / 16
		inst.position = pos * 12 + Vector2(6, 6)
		add_child(inst)
		i += 1

	var pos = Vector2(rng.randi_range(0, 128), rng.randi_range(128-32, 128))#get_position_with_difficulty_dist(1/8.0) * 12 + Vector2(6, 6)
	
	while get_cellv(pos) != 1:
		pos = Vector2(rng.randi_range(0, 128), rng.randi_range(128-32, 128))

	pos *= 12
	pos += Vector2(6, 6)
	# pos.y = 128*12-pos.y
	cam = get_current_camera2D()
	print(cam)
	cam.smoothing_enabled = false
	controller.position = pos
	pylon.position = Vector2(controller.position.x, controller.position.y - 24)
	miner.position = Vector2(pylon.position.x, pylon.position.y - 12)
	cam.global_position = controller.position
	cam.reset_smoothing()
	cam.smoothing_enabled = true
	
		# print(inst.position)

	if(surface_material):
		tile_set.tile_set_material(1, surface_material)

func get_current_camera2D():
	var viewport = get_viewport()
	if not viewport:
		return null
	var camerasGroupName = "__cameras_%d" % viewport.get_viewport_rid().get_id()
	var cameras = get_tree().get_nodes_in_group(camerasGroupName)
	for camera in cameras:
		if camera is Camera2D and camera.current:
			return camera
	return null
