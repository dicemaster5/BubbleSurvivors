extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#body_entered.connect(on_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_body_entered(body: Node3D) -> void:
	pass
	# if body is CollectableBubble:
	# 	body.linear_velocity = 