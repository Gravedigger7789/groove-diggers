extends Node2D

@onready var conductor: AudioStreamPlayer = $Conductor
@onready var song: Song = $Song

const NOTE := preload("res://Notes/tooth.tscn")

const TOP_LANE_EVENT_ID = 0
const BOTTOM_LANE_EVENT_ID = 1

func _ready() -> void:
	song.initialize()
	conductor.play_with_offset()
	#conductor.play_from_beat(350)

func _spawn_notes(beat: int, seconds_per_beat: float) -> void:
	var temp_beat := beat % 10
	for i in range(song.events.size()):
		#match song.events[i][temp_beat]:
			#"1":
		var instance := NOTE.instantiate()
		instance.setup_note(i, seconds_per_beat)
		add_child(instance)

func _on_conductor_measure(_measure_position: int) -> void:
	pass

func _on_conductor_beat(beat_position: int, seconds_per_beat: float) -> void:
	_spawn_notes(beat_position, seconds_per_beat)
