extends Node


enum Sound{ None = 0, Mine = 1, SpawnH = 2, SpawnR = 4, Die = 8, Fight = 16}

export var mine_clip: AudioStream
export var die_clip: AudioStream
export var fight_clip: AudioStream
export var spawnR_clip: AudioStream
export var spawnH_clip: AudioStream

var backing_track: AudioStreamPlayer
var fx_player: AudioStreamPlayer

var type: int = Sound.None


func _ready():
	backing_track = $backing
	fx_player = $sfx
	get_owner().get_node("global_timer").connect("beat", self, "_on_global_timer_beat")


func _process(delta):
	if(type >= 1):
		if((type & Sound.Fight) != 0):
			fx_player.stream = fight_clip
		elif((type & Sound.Die) != 0):
			fx_player.stream = die_clip
		elif((type & Sound.SpawnR) != 0):
			fx_player.stream = spawnR_clip
		elif((type & Sound.SpawnH) != 0):
			fx_player.stream = spawnH_clip
		elif((type & Sound.Mine) != 0):
			fx_player.stream = mine_clip
		
		fx_player.play()
		backing_track.volume_db = -80
		type = 0

func _on_global_timer_beat():
	backing_track.volume_db = 0


func _on_unit_spawn():
	type |= Sound.SpawnR

func _on_enemy_spawn():
	type |= Sound.SpawnH

func _on_mine():
	type |= Sound.Mine

func _on_fight():
	type |= Sound.Fight

func _on_die():
	type |= Sound.Die
