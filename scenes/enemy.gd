extends CharacterBody3D

@export var target: Node3D
@export var speed: float = 0.5

# The value of the enemy. Higher value means that the enemy is more difficult to kill and should be spawned less often.
@export var value: int = 10

signal died(value: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Damageable.died.connect(on_died)

func _physics_process(delta: float) -> void:
	velocity = (target.global_position - global_position).normalized() * speed
	move_and_slide()

func on_died() -> void:
	died.emit(value)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
