extends Node

@export var player: Player
@export var game_over_screen: Control

func _ready() -> void:
	player.player_died.connect(Callable(game_over_screen.show))
	pass

func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("quick_quit"):
		get_tree().quit()

	if event.is_action_pressed("quick_restart"):
		get_tree().reload_current_scene()

func _process(_delta: float) -> void:
	pass
