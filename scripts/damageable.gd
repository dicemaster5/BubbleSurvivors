class_name Damageable extends Node

@export var max_health: int = 100
var current_health: int

signal damaged(amount: int)
signal died()

func _ready() -> void:
	current_health = max_health

func scale_max_health(scale_factor: float) -> void:
	max_health = max(int(float(max_health) * scale_factor), 1)
	current_health = max_health

func damage(amount := 1):
	damaged.emit(amount)
	current_health -= amount

	if current_health <= 0:
		died.emit()