extends CanvasLayer

@onready var score_label: Label = %Score
@onready var combo_container: VBoxContainer = %ComboContainer
@onready var combo_label: Label = %Combo
@onready var health_bar: ProgressBar = %Health
@onready var song_progress: ProgressBar = %SongProgress

var health : int
var max_health : int

var current_measure : int
var max_measures := 1

func update_score(value: int) -> void:
	score_label.text = "Gold: " + str(value)

func update_combo(value: int) -> void:
	if value > 1:
		combo_label.text = str(value)
		combo_container.show()
	else:
		combo_container.hide()

func _process(_delta: float) -> void:
	if health_bar.max_value != max_health:
		health_bar.max_value = max_health
	health_bar.value = health

	if song_progress.max_value != max_measures:
		song_progress.max_value = max_measures
	song_progress.value = current_measure

func _on_dwarf_health_changed(new_health: int) -> void:
	if new_health > max_health:
		max_health = new_health
	var tween := create_tween()
	tween.tween_property(self, "health", new_health, 0.5)

func _on_conductor_measure(position: int, song_length_measures: int) -> void:
	if song_length_measures > max_measures:
		max_measures = song_length_measures
	var tween := create_tween()
	tween.tween_property(self, "current_measure", position, 0.5)
