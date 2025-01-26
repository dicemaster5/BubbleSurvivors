extends Node

@export var projectile_scene: PackedScene
@export var fire_rate: float = 0.2
@export var weapon_kind: WeaponKind = WeaponKind.Shotgun
@export var sfx_player: AudioStreamPlayer3D

@export var active_wep_index = 0;

@onready var fire_timer: Timer = $FireTimer

enum WeaponKind {
	BasicGun = 0,
	Shotgun = 1,
	BigShotgun = 2,
}

func _ready() -> void:
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	fire_timer.start()

func _process(_delta: float) -> void:
	fire_timer.wait_time = fire_rate

func _input(event):
	if event.is_action_pressed("change_weapon"):
		active_wep_index += 1
	pass

func _on_fire_timer_timeout() -> void:
	match active_wep_index:
		0:
			spawn_basic_gun_projectile()
		1:
			spawn_shotgun_projectiles(3, PI / 6.0)
		2:
			spawn_shotgun_projectiles(5, PI / 3.0)
	
	sfx_player.play()

func spawn_basic_gun_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	var parent = get_tree().current_scene
	var player = parent.get_node("Player")
	var fire_direction = -player.transform.basis.z.normalized()
	fire_direction.y = 0

	var fire_offset = fire_direction * 2.0

	projectile.direction = fire_direction
	parent.add_child(projectile)
	projectile.global_position = player.global_position + fire_offset

func spawn_shotgun_projectiles(num_projectiles: int, angle_spread: float) -> void:
	for i in range(num_projectiles):
		var projectile = projectile_scene.instantiate()
		var parent = get_tree().get_root().get_node("World")
		var player = parent.get_node("Player")
		var central_fire_direction = -player.transform.basis.z.normalized()
		var fire_direction = central_fire_direction.rotated(Vector3.UP, angle_spread * ((float(i) / float(num_projectiles - 1)) - 0.5))

		var fire_offset = fire_direction * 2.0
		projectile.direction = fire_direction
		parent.add_child(projectile)
		projectile.global_position = player.global_position + fire_offset
