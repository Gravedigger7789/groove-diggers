extends AudioStreamPlayer

@export var song : Song

@onready var offset_timer: Timer = $OffsetTimer

#const COMPENSATE_FRAMES := 2
#const COMPENSATE_HZ := 60.0

var bpm : int
var measures : int
var beats_per_measure : int
var seconds_per_beat : float
var play_from_position := 0.0
var song_position := 0.0
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

func _process(_delta: float) -> void:
	if playing:
		var time_since_last_mix: float = AudioServer.get_time_since_last_mix()
		# Some bug exists only when running in web
		# https://github.com/godotengine/godot/pull/45036
		# Try to get the time once more, if can't skip this iteration and continue on
		if time_since_last_mix > song_length:
			#print("Time since last mix: ", time_since_last_mix)
			time_since_last_mix = AudioServer.get_time_since_last_mix()
			#print("Time since last mix try 2: ", time_since_last_mix)
		if time_since_last_mix > song_length:
			#print("Failed on 2nd attempt, returning")
			return
		
		song_position = get_playback_position() + time_since_last_mix
		var output_latency := AudioServer.get_output_latency()
		song_position -= output_latency
		song_position -= song.offset # song offset
		#song_position += (1 / COMPENSATE_HZ) * COMPENSATE_FRAMES
		song_position_beats = int(song_position / seconds_per_beat) + beats_before_start + 1
		#print("Song Position: ", song_position)
		#print("Song Position Beats: ", song_position_beats)
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

func play_song(offset: int, beat_number := 0) -> void:
	if beat_number > 0:
		play_from_position = beat_number * seconds_per_beat
		#last_reported_measure = int((beat_number - 1) / measures)
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
