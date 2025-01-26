class_name Collectable extends Node

var is_attached: bool

signal connected
signal popped

func _ready() -> void:
	get_parent().body_entered.connect(on_body_entered)

func on_body_entered(body: Node) -> void:
	print("Collided with ", body.name)
	if body.has_node("Collectable"):
		print("Collectable found")
		if !is_attached:
			print("Connecting to ", body.name)
			connect_to_body(body)
	else:
		print("No Collectable found")
		if body.collision_layer != 1:
			print("popped from ", body.collision_layer)
			pop_bubble()

func connect_to_body(body: Node3D) -> void:
	connected.emit(body)

	print("Connected to ", body.name)
	get_parent().freeze = true
	get_parent().reparent.call_deferred(body)
	is_attached = true

func pop_bubble() -> void:
	popped.emit()

	await get_tree().create_timer(0.12).timeout
	get_parent().queue_free()
