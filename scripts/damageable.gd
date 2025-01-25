class_name Damageablev extends Node

@export var max_health: int = 100
var current_health: int

signal damaged(amount: int)

func _ready() -> void:
	current_health = max_health

func damage(amount := 1):
	damaged.emit(amount)
