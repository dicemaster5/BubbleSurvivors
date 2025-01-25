extends RigidBody3D

@export var direction: Vector3 = Vector3.ZERO
@export var speed: float = 30.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Lifetime.timeout.connect(queue_free)
	body_entered.connect(on_body_entered)
	transform.basis = Basis.looking_at(direction)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func on_body_entered(body: Node3D) -> void:
	if body.has_node("Damageable"):
		body.get_node("Damageable").damage(25)
		queue_free()
