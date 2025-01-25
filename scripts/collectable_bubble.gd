class_name CollectableBubble extends RigidBody3D

var is_attached: bool

func _ready() -> void:
	body_entered.connect(on_body_entered)
	pass # Replace with function body.

func _process(_delta: float) -> void:
	pass

func on_body_entered(body: Node) -> void:
	print("Collided with ", body.name)
	if body is PhysicsBody3D:
		if body.collision_layer == 2:
			print("player collided!")
			connect_to_body(body)
			return
		elif body.collision_layer == 8:
			print("Bubble collided!")
			connect_to_body(body)
			return
	pop_bubble()

func connect_to_body(body: Node3D) -> void:
	print("Bubble Connected! to ", body.name)
	freeze = true
	reparent.call_deferred(body)
	is_attached = true

func pop_bubble() -> void:
	print("OOF I POPPED!")
	queue_free()