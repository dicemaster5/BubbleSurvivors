class_name Player extends CharacterBody3D

@export var damageable: Damageable

@export var max_rotate_speed: float = 5.0
@export var max_speed: float = 5
@export var acceleration: float = 5
@export var friction: float = 5
@export var angular_friction: float = 5

var move_speed: float
var rotate_speed: float

signal player_died

signal add_upgrade(upgrade: Upgrade)

signal remove_upgrade(upgrade: Upgrade)

enum Upgrade {
	None,
	FireSpread,
	FireRate,
	MovementSpeed,
	MegaShotgun,
}

var upgrade_set: Array[Upgrade] = []

func _ready():
	damageable.died.connect(death)
	add_upgrade.connect(on_add_upgrade)
	remove_upgrade.connect(on_remove_upgrade)

func _physics_process(delta: float) -> void:
	# Rotation
	var rotate_dir = Input.get_axis("move_right", "move_left")
	if rotate_dir != 0:
		rotate_speed = move_toward(rotate_speed, max_rotate_speed, acceleration)
	else:
		rotate_speed = move_toward(rotate_speed, 0, angular_friction)
	
	rotation += Vector3(0, rotate_speed * rotate_dir * delta, 0)

	# Movement
	#var move_dir = clamp(Input.get_axis("move_down", "move_up"), 0, 1) # Clamped movement NO REVERSE
	var move_dir = Input.get_axis("move_down", "move_up")
	if move_dir != 0:
		var move_speed_multiplier = 1.0
		if has_upgrade(Upgrade.MovementSpeed):
			move_speed_multiplier = 1.5

		move_speed = move_toward(move_speed, max_speed * move_speed_multiplier, acceleration)
		velocity = (-transform.basis.z * move_dir) * move_speed * move_speed_multiplier
	else:
		move_speed = move_toward(move_speed, 0, friction)
		velocity.x = move_toward(velocity.x, 0, friction)
		velocity.z = move_toward(velocity.z, 0, friction)

	if get_slide_collision_count() > 0 && damageable.current_health > 0:
		var body = get_slide_collision(0)
		var col_layer = body.get_collider().get_collision_layer()
		if col_layer != 1 && col_layer != 8:
			print("collided and died from col layer: ", col_layer)
			death()

	move_and_slide()

func _process(_delta: float) -> void:
	if has_upgrade(Upgrade.FireRate):
		$ProjectileSpawner.fire_rate = 0.5
	else:
		$ProjectileSpawner.fire_rate = 1.0
	
	if has_upgrade(Upgrade.MegaShotgun):
		$ProjectileSpawner.active_wep_index = 3
	elif has_upgrade(Upgrade.FireSpread):
		$ProjectileSpawner.active_wep_index = 2
	else:
		$ProjectileSpawner.active_wep_index = 0
	

func on_add_upgrade(upgrade: Upgrade) -> void:
	upgrade_set = upgrade_set.filter(func(u): return u != upgrade)
	upgrade_set.append(upgrade)

func on_remove_upgrade(upgrade: Upgrade) -> void:
	upgrade_set = upgrade_set.filter(func(u): return u != upgrade)

func has_upgrade(upgrade: Upgrade) -> bool:
	return upgrade in upgrade_set

func death() -> void:
	player_died.emit()
	squish(self, Vector3(0.75, 1.5, 0.75), Vector3.ONE, 0.25)
	await get_tree().create_timer(0.25).timeout
	queue_free.call_deferred()


## Squish tween.
static func squish(node_to_squish: Node3D, squich_amount: Vector3, start_scale: Vector3, squish_duration: float = 0.5) -> void:
	var time := squish_duration / 3.0
	var tween: Tween = node_to_squish.create_tween().chain().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node_to_squish, "scale", squich_amount, time)
	tween.tween_property(node_to_squish, "scale", start_scale + (start_scale * 0.15), time)
	tween.tween_property(node_to_squish, "scale", start_scale, time)
