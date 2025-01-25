extends Node3D

@export var hat_node: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() > 0.75:
		hat_node.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
