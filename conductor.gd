extends AudioStreamPlayer

@export var song : Song

@onready var offset_timer: Timer = $OffsetTimer

#const COMPENSATE_FRAMES := 2
#const COMPENSATE_HZ := 60.0

var bpm : int
var measures : int
var seconds_per_beat : float
var play_from_position := 0.0
var song_position := 0.0
var song_position_beats := 1
var song_length_beats := 0
var last_reported_beat := 0.0
var beats_before_start := 0
var current_measure := 1

signal beat(position: int, seconds_per_beat: float, song_length_beats: int)
signal measure(position: int)

func _ready() -> void:
	song.initialize()
	bpm = song.bpm
	seconds_per_beat = 60.0 / bpm
	measures = song.measures
	stream = song.audio_stream
	song_length_beats = int(stream.get_length() / seconds_per_beat)

func _process(_delta: float) -> void:
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		#song_position += (1 / COMPENSATE_HZ) * COMPENSATE_FRAMES
		song_position_beats = int(song_position / seconds_per_beat) + beats_before_start + 1
		#print("Song Position: ", song_position)
		#print("Song Position Beats: ", song_position_beats)
		_report_beat()

func _report_beat() -> void:
	if last_reported_beat < song_position_beats:
		if current_measure > measures:
			current_measure = 1
		beat.emit(song_position_beats, seconds_per_beat, song_length_beats)
		measure.emit(current_measure)
		last_reported_beat = song_position_beats
		current_measure += 1

func play_song(offset: int, beat_number := 0) -> void:
	if beat_number > 0:
		play_from_position = beat_number * seconds_per_beat
		current_measure = beat_number % measures
	beats_before_start = offset
	offset_timer.wait_time = seconds_per_beat
	offset_timer.start()

func _on_offset_timer_timeout() -> void:
	if song_position_beats < beats_before_start:
		offset_timer.start()
	elif song_position_beats == beats_before_start:
		var adjusted_offset_time := offset_timer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		offset_timer.wait_time = adjusted_offset_time
		offset_timer.start()
	else:
		play(play_from_position)
		offset_timer.stop()
	_report_beat()
	song_position_beats += 1
