extends Node3D

@export var direction: Vector3 = Vector3.ZERO
@export var speed: float = 30.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Lifetime.timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
