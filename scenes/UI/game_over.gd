extends HBoxContainer

@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var line_edit: LineEdit = $VBoxContainer/EnterNameContainer/LineEdit
@onready var highscores_container: VBoxContainer = $VBoxContainer3/HighscoresContainer
@onready var no_highscores: Label = $VBoxContainer3/NoHighscores
@onready var reset_highscores_btn: Button = $VBoxContainer3/ResetHighscores
@onready var enter_name_container: VBoxContainer = $VBoxContainer/EnterNameContainer

@export var time_score: int = 0

var high_score
var saved_high_scores: Array
var save_path = "user://score.save"

signal restart_game

func _ready() -> void:
	load_score()

func _process(_delta) -> void:
	score_label.text = "You survived for %s" % Util.format_time_string(time_score, true)

func enable_screen() -> void:
	show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
	restart_game.emit()

func _on_button_pressed() -> void:
	save_score()

func save_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var current_highscore = [line_edit.text, Util.format_time_string(time_score)]

	if saved_high_scores:
		saved_high_scores.append(current_highscore)
	else:
		saved_high_scores = [current_highscore]
	saved_high_scores.sort_custom(sort_scores)
	saved_high_scores = saved_high_scores.slice(0, 10)
	file.store_var(saved_high_scores)
	set_labels()
	enter_name_container.visible = false

func reset_highscores() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var([])
	saved_high_scores = []
	set_labels()

func sort_scores(a, b) -> bool:
	if a[1] < b[1]:
		return true
	return false

func load_score():
	var save_file = load_savefile(save_path)
	if save_file:
		var saved_scores = save_file.get_var()
		saved_high_scores = saved_scores if saved_scores else []
	else:
		saved_high_scores = []

	set_labels()

func set_labels() -> void:
	no_highscores.visible = !saved_high_scores || saved_high_scores.size() == 0
	reset_highscores_btn.visible = saved_high_scores && saved_high_scores.size() > 0
	for n in highscores_container.get_children():
		highscores_container.remove_child(n)
	for score in saved_high_scores:
		var newLabel = Label.new()
		newLabel.text = "%s - %s" % [score[0], score[1]]
		highscores_container.add_child(newLabel)

func load_savefile(path) -> FileAccess:
	if FileAccess.file_exists(path):
		return FileAccess.open(path, FileAccess.READ)
	return null
