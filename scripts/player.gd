extends CharacterBody3D

@export var move_speed: float = 5.0
@export var jump_velocity: float = 4.5

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, 0.1)
		velocity.z = move_toward(velocity.z, 0, 0.1)

	move_and_slide()