class_name VFXPlayer3D extends GPUParticles3D

## Starts emitting when the node has entred the tree. 
@export var emit_on_ready: bool = false
## Deletes itself when finished emitting, using the GPUParticles3D finished signal.
@export var self_delete_on_finished: bool = false

@export_group("Sound Effect")
## Sfx to play when emitting.
@export var sfx: AudioStreamRandomizer
## Add a random pitch to the sfx when played.
@export var sfx_positional_3d_range: float = 10

var audio_player: AudioStreamPlayer3D
var can_emit_again: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_audio_player()

	finished.connect(
		func()->void: 
			can_emit_again = true 	
	)

	one_shot = true
	if emit_on_ready:
		play_vfx()

	if self_delete_on_finished:
		finished.connect(queue_free)

func play_vfx() -> void:
	if !can_emit_again: return
	restart()
	_play_sfx()
	can_emit_again = false

func set_partcile_color(new_color: Color) -> void:
	process_material.color = new_color

func _play_sfx() -> void:
	if !sfx: return
	audio_player.stream = sfx
	audio_player.max_distance = sfx_positional_3d_range
	audio_player.play()

func _create_audio_player() -> void:
	audio_player = AudioStreamPlayer3D.new()
	add_child(audio_player)
