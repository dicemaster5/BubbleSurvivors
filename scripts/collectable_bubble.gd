class_name CollectableBubble extends RigidBody3D

var is_attached: bool

func _ready() -> void:
	body_entered.connect(on_body_entered)
	pass

func _process(_delta: float) -> void:
	pass

func on_body_entered(body: Node) -> void:
	print("Collided with ", body.name)
	if body is CollectableBubble:
		if !is_attached:
			connect_to_body(body)
	else:
		print("popped from ", body.collision_layer)
		pop_bubble()

func connect_to_body(body: Node3D) -> void:
	print("Bubble Connected! to ", body.name)
	squish(self, Vector3(1.2,0.6,1.2), Vector3.ONE, 0.2)
	freeze = true
	reparent.call_deferred(body)
	is_attached = true

func pop_bubble() -> void:
	squish(self, Vector3(0.75,1.5,0.75), Vector3.ONE, 0.12)
	await get_tree().create_timer(0.12).timeout
	queue_free()

## Squish tween.
static func squish(node_to_squish: Node3D, squich_amount: Vector3, start_scale: Vector3, squish_duration: float = 0.5) -> void:
	var time := squish_duration / 3.0
	var tween: Tween = node_to_squish.create_tween().chain().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node_to_squish, "scale", squich_amount, time)
	tween.tween_property(node_to_squish, "scale", start_scale + (start_scale * 0.15), time)
	tween.tween_property(node_to_squish, "scale", start_scale, time)
