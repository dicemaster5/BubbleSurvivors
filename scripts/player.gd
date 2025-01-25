extends CharacterBody3D

@export var move_speed: float = 1.0
@export var rotate_speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var tank_controls: bool = false

func _physics_process(delta: float) -> void:
	
	# Do Tank Controls
	if tank_controls:
		var rotate_dir = Input.get_axis("move_left", "move_right")
		rotation += Vector3(0, rotate_speed * rotate_dir * delta, 0)

		var move_dir = Input.get_axis("move_up", "move_down")
		#velocity = transform.basis move_speed * move_dir
		move_and_slide()
		return

	# Else regular controls
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