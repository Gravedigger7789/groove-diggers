extends AudioStreamPlayer

@export var song : Song

@onready var offset_timer: Timer = $OffsetTimer

#const COMPENSATE_FRAMES := 2
#const COMPENSATE_HZ := 60.0

var bpm : int
var measures : int
var offset : int
var seconds_per_beat : float
var song_position := 0.0
var song_position_beats := 1
var last_reported_beat := 0
var beats_before_start := 0
var current_measure := 1

signal beat(position: int)
signal measure(position: int)

func _ready() -> void:
	song.initialize()
	bpm = song.bpm
	seconds_per_beat = 60.0 / bpm
	measures = song.measures
	offset = song.offset
	stream = song.audio_stream

func _process(_delta: float) -> void:
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		#song_position += (1 / COMPENSATE_HZ) * COMPENSATE_FRAMES
		song_position_beats = int(floor(song_position / seconds_per_beat)) + beats_before_start
		#print("Song Position: ", song_position)
		#print("Song Position Beats: ", song_position_beats)
		_report_beat()

func _report_beat() -> void:
	if last_reported_beat < song_position_beats:
		if current_measure > measures:
			current_measure = 1
		emit_signal("beat", song_position_beats)
		emit_signal("measure", current_measure)
		last_reported_beat = song_position_beats
		current_measure += 1

func play_from_beat(beat_number: int) -> void:
	play()
	seek(beat_number * seconds_per_beat)
	beats_before_start = offset
	current_measure = beat_number % measures

func play_with_offset() -> void:
	beats_before_start = offset
	offset_timer.wait_time = seconds_per_beat
	offset_timer.start()

func _on_offset_timer_timeout() -> void:
	song_position_beats += 1
	if song_position_beats < beats_before_start - 1:
		offset_timer.start()
	elif song_position_beats == beats_before_start - 1:
		var adjusted_offset_time := offset_timer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		offset_timer.wait_time = adjusted_offset_time
		offset_timer.start()
	else:
		play()
		offset_timer.stop()
	_report_beat()
