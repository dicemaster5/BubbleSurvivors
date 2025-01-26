extends PanelContainer

@onready var timer_label: Label = $MarginContainer/TimerLabel

@export var time_score: int

func _process(_delta: float) -> void:
	timer_label.text = format_time_string(time_score)

func _on_timer_timeout() -> void:
	time_score += 1

func format_time_string(time: int) -> String:
	var hrs = time / 3600
	var min = fmod(time / 60, 60)
	var sec = fmod(time, 60)
	
	if hrs > 0:
		return "%02d:%02d:%02d" % [hrs, min, sec]
	elif min > 0:
		return "%02d:%02d" % [min, sec]

	return str(sec)

func reset() -> void:
	time_score = 0
