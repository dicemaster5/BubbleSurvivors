extends RigidBody3D

@export var speed: float
@export var direction: Vector3 = Vector3.ZERO
@export var distance_target: Node3D
@export var perish_distance: float

var new_direction: Vector3

func _ready() -> void:
	transform.basis = Basis.looking_at(direction)

func _process(_delta: float) -> void:
	if distance_target == null:
		return
	var distance = global_position.distance_to(distance_target.global_position)
	if distance > perish_distance:
		queue_free()

func _physics_process(delta: float) -> void:
	global_position += delta * speed * direction.normalized()

func _on_timer_timeout() -> void:
	queue_free()
