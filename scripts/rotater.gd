class_name RotaterNode extends Node3D

@export var rotation_speed : float
@export var rotation_direction : Vector3
@export var ping_pong:bool = false

@export var amplitude: Vector3

var time: float

func _process(delta: float) -> void:
	if ping_pong:
		time += delta
		rotation_direction = amplitude * sin(rotation_speed * time)
		rotation = rotation_direction
	else:
		rotate(rotation_direction, delta * rotation_speed)