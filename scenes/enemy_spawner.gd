extends Node3D

@export var base_spawn_radius: float = 20.0
@export var spawn_radius_variance: float = 30.0

# The desired total value of all enemies. The spawner will spawn enemies until this value is reached.
@export var target_enemy_value: int = 3000

@export var enemy_scene: PackedScene

var player_target: Node3D

# The current value of all enemies.
var current_enemy_value: int = 0

func _ready() -> void:
	player_target = get_parent()

func _process(_delta: float) -> void:
	while current_enemy_value < target_enemy_value:
		spawn_enemy()

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_parent = get_tree().get_root()
	enemy_parent.add_child(enemy)

	enemy.target = player_target

	var rand_dir = randf_range(0, 2.0 * PI)
	var radius = base_spawn_radius + randf_range(0.0, spawn_radius_variance)
	enemy.global_position = global_position + Vector3(cos(rand_dir) * radius, 0, sin(rand_dir) * radius)
	current_enemy_value += enemy.value
	
	enemy.died.connect(on_enemy_died)

func on_enemy_died(value: int) -> void:
	current_enemy_value -= value
