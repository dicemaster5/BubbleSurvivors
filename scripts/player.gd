extends CharacterBody3D

@export var max_rotate_speed: float = 5.0
@export var max_speed : float = 5
@export var acceleration : float = 5
@export var friction : float = 5
@export var angular_friction : float = 5

@export var tank_controls: bool = true

var move_speed: float
var rotate_speed: float

func _physics_process(delta: float) -> void:
	
	# Do Tank Controls
	if tank_controls:
		# Rotation
		var rotate_dir = Input.get_axis("move_right", "move_left")
		if rotate_dir != 0:
			rotate_speed = move_toward(rotate_speed, max_rotate_speed, acceleration)
		else:
			rotate_speed = move_toward(rotate_speed, 0, angular_friction)
		
		rotation += Vector3(0, rotate_speed * rotate_dir * delta, 0)

		# Movement
		var move_dir = clamp(Input.get_axis("move_down", "move_up"), 0, 1)
		if move_dir > 0:
			move_speed = move_toward(move_speed, max_speed, acceleration)
			# velocity = move_toward(velocity.x, direction * max_speed, acceleration)
			velocity = (-transform.basis.z * move_dir) * move_speed
		else:
			move_speed = move_toward(move_speed, 0, friction)
			velocity.x = move_toward(velocity.x, 0, friction)
			velocity.z = move_toward(velocity.z, 0, friction)
		
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
