extends AudioStreamPlayer

@export var song : Song

@onready var offset_timer: Timer = $OffsetTimer

var time_begin: float
var time_delay: float
var time_paused_start: float
var total_time_paused: float
var song_position: float
var bpm: int
var measures: int
var beats_per_measure: int
var seconds_per_beat: float
var song_position_beats := 1
var song_length := 0.0
var song_length_beats := 0
var song_length_measures := 0
var last_reported_beat := -1
var beats_before_start := 0
var last_reported_measure := -1

signal beat(position: int, seconds_per_beat: float, song_length_beats: int)
signal measure(position: int, song_length_measures: int)

func _ready() -> void:
	song.initialize()
	bpm = song.bpm
	beats_per_measure = song.beats_per_measure
	seconds_per_beat = 60.0 / bpm
	measures = song.measures
	stream = song.audio_stream
	song_length = stream.get_length() 
	song_length_beats = int(stream.get_length() / seconds_per_beat)
	song_length_measures = ceil(song_length_beats / measures)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PAUSED:
			time_paused_start = Time.get_ticks_usec()
		NOTIFICATION_UNPAUSED:
			if playing:
				total_time_paused += Time.get_ticks_usec() - time_paused_start

func _process(_delta: float) -> void:
	if playing:
		song_position = (Time.get_ticks_usec() - time_begin - total_time_paused) / 1000000.0
		song_position -= time_delay
		song_position -= song.offset
		song_position_beats = int(song_position * bpm / 60.0) + beats_before_start + 1
		_report_beat()

func _report_beat() -> void:
	if last_reported_beat < song_position_beats:
		last_reported_beat = song_position_beats
		var current_measure := int((last_reported_beat - 1) / measures)
		if last_reported_measure < current_measure:
			last_reported_measure = current_measure
			measure.emit(current_measure - (beats_before_start / measures), song_length_measures)
		var beat_number_in_measure := last_reported_beat - (beats_per_measure * (last_reported_measure))
		beat.emit(beat_number_in_measure - 1, seconds_per_beat, song_length_beats)

func play_song(offset_beats: int) -> void:
	beats_before_start = offset_beats
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
		time_begin = Time.get_ticks_usec()
		time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
		play()
		offset_timer.stop()
	_report_beat()
	song_position_beats += 1
