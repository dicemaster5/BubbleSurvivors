extends Node3D

@export var base_spawn_radius: float = 20.0
@export var spawn_radius_variance: float = 50.0

# The desired total value of all enemies. The spawner will spawn enemies until this value is reached.
@export var target_enemy_value: int = 5000

@export var enemy_scene: PackedScene

var player_target: Node3D

# The current value of all enemies.
var current_enemy_value: int = 0

func _ready() -> void:
	player_target = get_tree().get_root().get_node("World/Player")

func _process(_delta: float) -> void:
	while current_enemy_value < target_enemy_value:
		spawn_enemy()

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_parent = get_tree().get_root()

	enemy.target = player_target

	var rand_dir = randf_range(0, 2.0 * PI)

	# Square root interpolation ensures uniform distribution in the ring around player
	var min_square = pow(base_spawn_radius, 2)
	var max_square = pow(base_spawn_radius + spawn_radius_variance, 2)
	var rand_radius = sqrt(min_square + randf() * (max_square - min_square))

	enemy.global_position = global_position + Vector3(cos(rand_dir) * rand_radius, 0, sin(rand_dir) * rand_radius)
	enemy.despawned.connect(on_enemy_despawned)

	enemy_parent.add_child(enemy)

	current_enemy_value += enemy.value

func on_enemy_despawned(value: int) -> void:
	current_enemy_value -= value
