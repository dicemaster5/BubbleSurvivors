extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_shape_entered.connect(area_test)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func area_test(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	print(body.name)
	if body is CollectableBubble:
		body.connect_to_body(self)
