extends Node

@export var projectile_scene: PackedScene
@export var fire_rate: float = 0.2

@onready var fire_timer: Timer = $FireTimer

func _ready() -> void:
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	fire_timer.wait_time = fire_rate
	fire_timer.start()

func _on_fire_timer_timeout() -> void:
	spawn_projectile()

func spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	var parent = get_tree().get_root().get_node("World")
	var player = parent.get_node("Player")
	var fire_direction = -player.transform.basis.z.normalized()

	# Todo: what do we do with this as the player grows?
	var fire_offset = fire_direction * 1.0

	parent.add_child(projectile)
	projectile.global_position = player.global_position + fire_offset
	projectile.direction = fire_direction