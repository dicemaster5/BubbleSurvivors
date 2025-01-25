class_name Player extends CharacterBody3D

@export var damageable: Damageable

@export var max_rotate_speed: float = 5.0
@export var max_speed : float = 5
@export var acceleration : float = 5
@export var friction : float = 5
@export var angular_friction : float = 5

var move_speed: float
var rotate_speed: float

signal player_died

func _ready():
	damageable.died.connect(death)

func _physics_process(delta: float) -> void:
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

	# var collider : KinematicCollision3D = move_and_collide(velocity)
	# if collider != null:
	# 	print("Collided with: ", collider)
	# 		# if move_and_collide(Vector3.ZERO, true).get_collider().get_collision_layer() != 8:
	# 		# 	print("Player got hit and died!")
	# 		# 	damageable.damage(100)
	
	move_and_slide()

func death() -> void:
	player_died.emit()
	queue_free.call_deferred()
