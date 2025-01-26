class_name Enemy extends CharacterBody3D

@export var target: Node3D
@export var speed: float = 0.5

@export var drop_item: PackedScene
@export var drop_chance: float = 0.25

# The enemy will despawn if it is too far from the target.
@export var max_dist_from_target: float = 70.0

# The value of the enemy. Higher value means that the enemy is more difficult to kill and should be spawned less often.
@export var value: int = 10
@export var collider: CollisionShape3D

@export var projectile_impact: PackedScene
@export var enemy_model: Node3D

var did_start_dying: bool = false

signal despawned(value: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Damageable.died.connect(handle_killed)
	# $Damageable.damaged.connect(play_hit_sound)
	$Damageable.died.connect(spawn_drop)
	$Damageable.died.connect(handle_despawn)
	$Damageable.damaged.connect(play_hit_effects)

	var scale_factor = randfn(1.0, 0.2)
	scale = Vector3(scale_factor, scale_factor, scale_factor)

	value = max(int(float(value) * scale_factor), 1)

	speed *= 1.0 / pow(scale_factor, 4.0)

	$Damageable.scale_max_health(scale_factor)

func play_hit_effects(_amount: int) -> void:
	$HitAnimations.play("hit")
	CollectableBubble.squish(enemy_model, Vector3(0.75, 1.5, 0.75), Vector3.ONE, 0.12)

	var impact = projectile_impact.instantiate()
	add_child(impact)

func _physics_process(_delta: float) -> void:
	if target == null:
		return
	velocity = (target.global_position - global_position).normalized() * speed
	
	# Stay on ground!
	global_position.y = 0

	# make the enemy face the target
	var target_xy = Vector2(target.global_position.x, target.global_position.z)
	var self_xy = Vector2(global_position.x, global_position.z)
	rotation.y = -(target_xy - self_xy).angle() - PI / 2.0

	move_and_slide()

	if global_position.distance_to(target.global_position) > max_dist_from_target:
		handle_despawn()

func _process(delta: float) -> void:
	if randf() < 0.01 * delta:
		$AnimationPlayer.play("make_noises")


func handle_killed() -> void:
	if did_start_dying:
		return
	did_start_dying = true
	$CollisionShape3D.set_deferred("disabled", true)

	$HitAnimations.play("death")

func handle_despawn() -> void:
	despawned.emit(value)
	queue_free()

func spawn_drop() -> void:
	if randf() < drop_chance:
		var item: Node3D = drop_item.instantiate()
		get_tree().current_scene.add_child(item)
		item.global_position = global_position + (Vector3.UP * 0.5)
		print("dropping item!")
