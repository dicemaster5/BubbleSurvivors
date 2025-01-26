extends CenterContainer

@onready var score_label: Label = $VBoxContainer/ScoreLabel

@export var time_score: int

signal restart_game

func _process(_delta) -> void:
	score_label.text = "You survived for %s" % Util.format_time_string(time_score, true)

func enable_screen() -> void:
	show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
	restart_game.emit()
