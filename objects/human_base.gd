extends Area2D

export var max_count: int
export var spawn_time: int
export var roam_dist: float

export var human_prefab: PackedScene

var spawn_timer = 0
var instances

signal human_spawn

func _ready():
	get_node("../../../../global_timer").connect("beat", self, "_on_beat")
	self.connect("human_spawn", get_node("../sfx_controller"), "_on_enemy_spawn")
	instances = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_beat():
	spawn_timer += 1
	if spawn_timer > spawn_time && instances.size() < max_count:
		var instance = human_prefab.instance()
		instance.position = position + Vector2.DOWN * 8
		instance.target_pos = position + Vector2(rand_range(-roam_dist, roam_dist), rand_range(-roam_dist, roam_dist))
		instance.is_moving = true
		get_node("../../../..").add_child(instance)
		instances.append(instance)
		spawn_timer = 0
		emit_signal("human_spawn")

func cull_empty():
	var to_cull = []
	for x in instances:
		if get_node(x) == null:
			to_cull.append(x)
	for x in to_cull:
		instances.erase(x)
