extends Node


enum Sound{ None = 0, Mine = 1, SpawnH = 2, SpawnR = 4, Die = 8, Fight = 16}

export var mine_clip: AudioStream
export var mine_cymb: AudioStream

export var die_clip: AudioStream
export var die_cymb: AudioStream

export var fight_clip: AudioStream
export var fight_cymb: AudioStream

export var spawnR_clip: AudioStream
export var spawnR_cymb: AudioStream

export var spawnH_clip: AudioStream
export var spawnH_cymb: AudioStream

var backing_track: AudioStreamPlayer
var fx_player: AudioStreamPlayer

var type: int = Sound.None
var prev_type: int = Sound.None


func _ready():
	backing_track = $backing
	fx_player = $sfx
	get_owner().get_node("global_timer").connect("beat", self, "_on_global_timer_beat")

func _on_global_timer_beat():
	backing_track.volume_db = 0

func _process(delta):
	if(type >= 1):
		if play_sound(Sound.Fight, fight_clip, fight_cymb):
			return
		if play_sound(Sound.Die, die_clip, die_cymb):
			return
		if play_sound(Sound.SpawnR, spawnR_clip, spawnR_cymb):
			return
		if play_sound(Sound.SpawnH, spawnH_clip, spawnH_cymb):
			return
		if play_sound(Sound.Mine, mine_clip, mine_cymb):
			return


func play_sound(t: int, main: AudioStream, cymb: AudioStream):
	if (type & t) != 0:
		if (prev_type & t) != 0:
			fx_player.stream = cymb
			prev_type = 0
		else:
			fx_player.stream = main
			prev_type = type

		fx_player.play()
		backing_track.volume_db = -80
		type = 0
		return true
	return false



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
