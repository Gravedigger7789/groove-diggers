extends Node2D

@onready var conductor: AudioStreamPlayer = $Conductor
@onready var song: Song = $Song
@onready var background: Node2D = $Background
@onready var notes: CanvasLayer = $Notes
@onready var bar: Node2D = $Notes/Bar
@onready var player: Node2D = $Dwarf
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var game_over_menu: CanvasLayer = $GameOverMenu
@onready var gui: CanvasLayer = $GUI
@onready var sun: DirectionalLight2D = $Sun

const NOTE := preload("res://Notes/note.tscn")
const BEATS_VISIBLE_ON_SCREEN = 4.0

var score := 0 : 
	set(value): 
		score = value
		gui.update_score(value)
		game_over_menu.update_score(value)
var beat_map := []


func _ready() -> void:
	song.initialize()
	conductor.play_song(BEATS_VISIBLE_ON_SCREEN)
	background.speed = (bar.position.x - 672) / (conductor.seconds_per_beat * BEATS_VISIBLE_ON_SCREEN)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		pause_menu.show()
		get_tree().paused = true

func _spawn_notes(beat: int, screen_time: float) -> void:
	var number_of_notes := int(beat_map.size() / song.beats_per_measure)
	#print(number_of_notes)
	print("Beat ", beat)

	var instance := NOTE.instantiate()
	instance.setup_note(1, screen_time, bar.position.x, Global.BEAT.FULL)
	instance.note_hit.connect(_on_note_hit)
	instance.note_missed.connect(_on_note_missed)
	notes.add_child(instance)

func _on_note_hit(value: int) -> void:
	score += value

func _on_note_missed(value: int) -> void:
	player.damage(value)

func _on_conductor_measure(measure_position: int) -> void:
	var measure_look_ahead := int (BEATS_VISIBLE_ON_SCREEN / song.beats_per_measure) + measure_position
	var song_beat_map: String = song.beat_map[measure_position]
	beat_map = song_beat_map.split()
	print("Measure Look Ahead ", measure_look_ahead)
	print("Measure ", measure_position)
	pass

func _on_conductor_beat(beat_position: int, seconds_per_beat: float, _song_length_beats: int) -> void:
	var screen_time := seconds_per_beat * BEATS_VISIBLE_ON_SCREEN
	_spawn_notes(beat_position, screen_time)

func _on_dwarf_death() -> void:
	conductor.stop()
	background.speed = 0
	notes.queue_free()
	var tween := create_tween()
	tween.tween_property(sun, "energy", 0.9, 1.0)
	await get_tree().create_timer(1.0).timeout
	gui.hide()
	game_over_menu.show()
