extends RigidBody3D

@export var speed: float
@export var direction: Vector3 = Vector3.ZERO

var new_direction: Vector3

func _ready() -> void:
	transform.basis = Basis.looking_at(direction)

func _physics_process(delta: float) -> void:
	global_position += delta * speed * direction.normalized()

func _on_timer_timeout() -> void:
	queue_free()
