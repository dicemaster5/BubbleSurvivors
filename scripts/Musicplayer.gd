extends AudioStreamPlayer3D

@export var player: Player
@export var gameover_music: AudioStream
# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(Playnexttrack)
	print("Nuts")
	player.player_died.connect(stop_music)
	
func stop_music():
	stop()
	stream = gameover_music
	play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Playnexttrack():
	play()
