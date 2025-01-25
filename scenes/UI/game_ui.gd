extends PanelContainer

@onready var timer_label: Label = $MarginContainer/TimerLabel

@export var time_score: int

func _process(delta: float) -> void:
	timer_label.text = str(time_score)
