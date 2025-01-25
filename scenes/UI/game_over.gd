extends CenterContainer

@onready var score_label: Label = $VBoxContainer/ScoreLabel

@export var time_score: int

signal restart_game

var WORLD = preload("res://scenes/world.tscn").instantiate()

func _ready() -> void:
	score_label.text = "You survived for %s seconds" % time_score

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_retry_button_pressed() -> void:
	restart_game.emit()
