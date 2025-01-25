extends CenterContainer

var WORLD = preload("res://scenes/world.tscn").instantiate()

func _on_quit_button_pressed() -> void:
	get_tree().quit() 

func _on_play_button_pressed() -> void:
	get_tree().get_root().add_child(WORLD)
	get_tree().get_current_scene().queue_free()
