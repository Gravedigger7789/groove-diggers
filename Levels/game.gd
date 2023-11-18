extends Node2D

@onready var conductor: AudioStreamPlayer = $Conductor
@onready var song: Song = $Song
@onready var background: Node2D = $Background
@onready var bar: Node2D = $Bar


const NOTE := preload("res://Notes/note.tscn")

const TOP_LANE_EVENT_ID = 0
const BOTTOM_LANE_EVENT_ID = 1
const BEATS_VISIBLE_ON_SCREEN = 4.0

func _ready() -> void:
	song.initialize()
	conductor.play_with_offset(BEATS_VISIBLE_ON_SCREEN)
	background.speed = (bar.position.x - 672) / (conductor.seconds_per_beat * BEATS_VISIBLE_ON_SCREEN)
	#conductor.play_from_beat(350, BEATS_VISIBLE_ON_SCREEN)

func _spawn_notes(beat: int, screen_time: float) -> void:
	var temp_beat := beat % 10
	for i in range(song.events.size()):
		#match song.events[i][temp_beat]:
			#"1":
		var instance := NOTE.instantiate()
		instance.setup_note(i, screen_time, bar.position.x)
		add_child(instance)

func _on_conductor_measure(_measure_position: int) -> void:
	pass

func _on_conductor_beat(beat_position: int, seconds_per_beat: float) -> void:
	var screen_time := seconds_per_beat * BEATS_VISIBLE_ON_SCREEN
	_spawn_notes(beat_position, screen_time)
