extends AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(Playnexttrack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Playnexttrack():
	play()
