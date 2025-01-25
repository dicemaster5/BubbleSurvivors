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
	get_parent().add_child(projectile)
	projectile.global_position = get_parent().global_position
	projectile.direction = -get_parent().transform.basis.z.normalized()
