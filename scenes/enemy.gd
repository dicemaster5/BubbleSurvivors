extends CharacterBody3D

@export var target: Node3D
@export var speed: float = 0.5

# The enemy will despawn if it is too far from the target.
@export var max_dist_from_target: float = 70.0

# The value of the enemy. Higher value means that the enemy is more difficult to kill and should be spawned less often.
@export var value: int = 10

signal despawned(value: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Damageable.died.connect(handle_despawn)

func _physics_process(delta: float) -> void:
	if target == null:
		return
	velocity = (target.global_position - global_position).normalized() * speed

	# make the enemy face the target
	var target_xy = Vector2(target.global_position.x, target.global_position.z)
	var self_xy = Vector2(global_position.x, global_position.z)
	rotation.y = -(target_xy - self_xy).angle() + PI / 2.0

	move_and_slide()

	if global_position.distance_to(target.global_position) > max_dist_from_target:
		handle_despawn()

func handle_despawn() -> void:
	despawned.emit(value)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
