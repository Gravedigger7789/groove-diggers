extends CanvasLayer

@onready var score_label: Label = %Score
@onready var health_bar: ProgressBar = %Health
@onready var song_progress: ProgressBar = %SongProgress

var health : int
var max_health : int

var current_beat : int
var max_beats := 1

func update_score(value: int) -> void:
	score_label.text = "Score: " + str(value)

func _process(_delta: float) -> void:
	if health_bar.max_value != max_health:
		health_bar.max_value = max_health
	health_bar.value = health

	if song_progress.max_value != max_beats:
		song_progress.max_value = max_beats
	song_progress.value = current_beat

func _on_dwarf_health_changed(new_health: int) -> void:
	if new_health > max_health:
		max_health = new_health
	var tween := create_tween()
	tween.tween_property(self, "health", new_health, 0.5)

func _on_conductor_beat(position: int, seconds_per_beat: float, song_length_beats: int) -> void:
	if song_length_beats > max_beats:
		max_beats = song_length_beats
	var tween := create_tween()
	tween.tween_property(self, "current_beat", position, seconds_per_beat / 2)
