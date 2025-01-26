extends Node

@onready var timer: Timer = $Timer

@export var player_ref: Node3D
@export var spawn_radius: float
@export var spawn_interval: float

const CROW = preload("res://scenes/crow.tscn")

func _ready() -> void:
	timer.wait_time = spawn_interval
	timer.start()

func _on_timer_timeout() -> void:
	if is_instance_valid(player_ref):
		var crow = CROW.instantiate()
		var rand_dir = randf_range(0, 2.0 * PI)
		var pos = player_ref.global_position + Vector3(cos(rand_dir) * spawn_radius, 0, sin(rand_dir) * spawn_radius)
		pos.y = 0
		crow.spook_radius = 10
		crow.flight_speed = 5
		crow.move_speed = 3
		var root = get_tree().current_scene
		root.add_child(crow)
		crow.global_position = pos
