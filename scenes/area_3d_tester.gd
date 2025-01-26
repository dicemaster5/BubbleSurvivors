extends Area3D

func _ready() -> void:
	body_shape_entered.connect(area_test)

func _process(_delta: float) -> void:
	pass

func area_test(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	print(body.name)
	if body.has_node("Collectable"):
		body.get_node("Collectable").connect_to_body(self)
