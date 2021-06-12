extends Node


enum Sound{ None = 0, SpawnR = 1, SpawnH = 2, Mine = 4, Fight = 8, Die = 16}

export var mine_clip: AudioStream
export var die_clip: AudioStream
export var fight_clip: AudioStream
export var spawnR_clip: AudioStream
export var spawnH_clip: AudioStream

var backing_track: AudioStreamPlayer
var fx_player: AudioStreamPlayer2D

var type: int = Sound.None


func _ready():
	backing_track = $backing
	fx_player = $sfx


func _process(delta):
	if(type > 1):
		if((type & Sound.Die) != 0):
			fx_player.stream = die_clip
		elif((type & Sound.Fight) != 0):
			fx_player.stream = fight_clip
		elif((type & Sound.Mine) != 0):
			fx_player.stream = mine_clip
		elif((type & Sound.SpawnH) != 0):
			fx_player.stream = spawnH_clip
		elif((type & Sound.SpawnR) != 0):
			fx_player.stream = spawnR_clip
		
		fx_player.play()
		backing_track.volume_db = -80
		type = 0

func _on_global_timer_beat():
	backing_track.volume_db = 0


func _on_game_spawn_unit():
	type |= Sound.SpawnR

func _on_spawner_spawn_enemy():
	type |= Sound.SpawnH

func _on_miner_mine():
	type |= Sound.Mine

func _on_fighter_fight():
	type |= Sound.Fight

func _on_unit_die():
	type |= Sound.Die
