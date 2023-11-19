extends Node2D

@onready var conductor: AudioStreamPlayer = $Conductor
@onready var song: Song = $Song
@onready var background: Node2D = $Background
@onready var notes: CanvasLayer = $Notes
@onready var bar: Node2D = $Notes/Bar
@onready var player: Node2D = $Dwarf
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var gui: CanvasLayer = $GUI

const NOTE := preload("res://Notes/note.tscn")

const TOP_LANE_EVENT_ID = 0
const BOTTOM_LANE_EVENT_ID = 1
const BEATS_VISIBLE_ON_SCREEN = 4.0

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
	var temp_beat := beat % 10
	for i in range(song.events.size()):
		#match song.events[i][temp_beat]:
			#"1":
		var instance := NOTE.instantiate()
		instance.setup_note(i, screen_time, bar.position.x, Global.BEAT.FULL)
		instance.note_hit.connect(_on_note_hit)
		instance.note_missed.connect(_on_note_missed)
		notes.add_child(instance)

func _on_note_hit(value: int) -> void:
	print(value)

func _on_note_missed(value: int) -> void:
	player.damage(value)

func _on_conductor_measure(_measure_position: int) -> void:
	pass

func _on_conductor_beat(beat_position: int, seconds_per_beat: float, _song_length_beats: int) -> void:
	var screen_time := seconds_per_beat * BEATS_VISIBLE_ON_SCREEN
	_spawn_notes(beat_position, screen_time)
