extends GPUParticles3D

func _ready() -> void:
	$DespawnTimer.timeout.connect(queue_free)
