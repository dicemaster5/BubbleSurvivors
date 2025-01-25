extends CharacterBody3D

@export var target: Node3D
@export var speed: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Damageable.died.connect(on_died)

func _physics_process(delta: float) -> void:
	velocity = (target.global_position - global_position).normalized() * speed
	move_and_slide()

func on_died() -> void:
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
