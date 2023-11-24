extends CanvasLayer

@onready var score_label: Label = %Score
@onready var combo_container: VBoxContainer = %ComboContainer
@onready var combo_label: Label = %Combo
@onready var health_bar: ProgressBar = %Health
@onready var song_progress: ProgressBar = %SongProgress
@onready var health_empty: TextureRect = %Empty
@onready var health_33: TextureRect = %"33"
@onready var health_66: TextureRect = %"66"
@onready var health_full: TextureRect = %Full

var health : int
var max_health : int

var current_measure : int
var max_measures := 1

signal pause_button_pressed

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
	update_health_icons()

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

func update_health_icons() -> void:
	var health_percent := health / float(max_health)
	var full_color := Color(1, 1, 1, 1)
	var empty_color := Color(0.4, 0.4, 0.4, 1)
	if health_percent >= 0.99:
		health_full.modulate = full_color
	else:
		health_full.modulate = empty_color
	if health_percent >= 0.66:
		health_66.modulate = full_color
	else:
		health_66.modulate = empty_color
	if health_percent >= 0.33:
		health_33.modulate = full_color
	else:
		health_33.modulate = empty_color
	if health_percent >= 0:
		health_empty.modulate = full_color
	else:
		health_empty.modulate = empty_color

func _on_pause_button_pressed() -> void:
	pause_button_pressed.emit()
