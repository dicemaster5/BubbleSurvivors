extends Node

@onready var score_timer: Timer = $ScoreTimer

@export var player: Player
@export var game_over_screen: Control
@export var game_ui: Control

var player_score: int

func _ready() -> void:
	player.player_died.connect(game_over)

func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("quick_quit"):
		get_tree().quit()

	if event.is_action_pressed("quick_restart"):
		get_tree().reload_current_scene()

func _process(_delta: float) -> void:
	pass

func _on_score_timer_timeout() -> void:
	player_score += 1
	game_over_screen.time_score = player_score
	game_ui.time_score = player_score

func game_over():
	score_timer.stop()
	game_over_screen.enable_screen()
