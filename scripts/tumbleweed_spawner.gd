extends Node

@onready var timer: Timer = $Timer

@export var player_ref: Node3D
@export var tumbleweed_speed: float
@export var tumbleweed_perish_distance: float
@export var spawn_radius: float
@export var spawn_interval: float

const TUMBLEWEED = preload("res://scenes/tumbleweed.tscn")

func _ready() -> void:
	timer.wait_time = spawn_interval
	timer.start()

func _on_timer_timeout() -> void:
	if is_instance_valid(player_ref):
		var tumbleweed = TUMBLEWEED.instantiate()
		var rand_dir = randf_range(0, 2.0 * PI)
		var pos = player_ref.global_position + Vector3(cos(rand_dir) * spawn_radius, 0, sin(rand_dir) * spawn_radius)
		tumbleweed.direction = player_ref.global_position - pos + Vector3(randf_range(-15, 15), 0, randf_range(-15, 15))
		tumbleweed.speed = tumbleweed_speed
		tumbleweed.distance_target = player_ref
		tumbleweed.perish_distance = tumbleweed_perish_distance
		var tumbleweed_root = get_tree().current_scene
		tumbleweed_root.add_child(tumbleweed)
		tumbleweed.global_position = pos
