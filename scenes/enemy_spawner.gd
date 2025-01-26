extends Node3D

@export var base_spawn_radius: float = 20.0
@export var spawn_radius_variance: float = 50.0

@export var spawn_delay: float = 2

@export var enemy_scene: PackedScene

@export var spawn_amount_curve: Curve

var player_target: Node3D
var spawn_delay_timer: Timer

const seconds_till_max_rates = 600
var max_spawn_amount_limit: int

var current_time: float

# The current value of all enemies.
var current_enemy_value: int = 0

func _ready() -> void:
	spawn_delay_timer = Timer.new()
	add_child(spawn_delay_timer)
	spawn_delay_timer.wait_time = spawn_delay
	spawn_delay_timer.timeout.connect(spawn_enemy)
	spawn_delay_timer.start()
	player_target = get_tree().get_root().get_node("World/Player")

func _process(delta: float) -> void:
	current_time += delta
	
	var sample_spawn_amount: float = (1.0 / seconds_till_max_rates) * current_time
	max_spawn_amount_limit = spawn_amount_curve.sample(sample_spawn_amount) as int
	
func spawn_enemy() -> void:
	if current_enemy_value >= max_spawn_amount_limit:
		return
	var enemy: Enemy = enemy_scene.instantiate()
	var enemy_parent = get_tree().get_root()

	enemy.target = player_target

	var rand_dir = randf_range(0, 2.0 * PI)

	# Square root interpolation ensures uniform distribution in the ring around player
	var min_square = pow(base_spawn_radius, 2)
	var max_square = pow(base_spawn_radius + spawn_radius_variance, 2)
	var rand_radius = sqrt(min_square + randf() * (max_square - min_square))

	enemy.position = global_position + Vector3(cos(rand_dir) * rand_radius, 0, sin(rand_dir) * rand_radius)
	enemy_parent.add_child(enemy)

	enemy.despawned.connect(on_enemy_despawned)

	current_enemy_value += enemy.value

func on_enemy_despawned(value: int) -> void:
	current_enemy_value -= value
