extends PanelContainer

@onready var timer_label: Label = $MarginContainer/TimerLabel

@export var time_score: int

func _process(_delta: float) -> void:
	timer_label.text = Util.format_time_string(time_score)

func reset() -> void:
	time_score = 0
