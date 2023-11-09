extends AudioStreamPlayer

@export var bpm := 100
@export var measures := 4

@onready var seconds_per_beat := 60.0 / bpm
@onready var offset_timer: Timer = $OffsetTimer
#@onready var time_since_last_reported_beat := Time.get_unix_time_from_system()

#const COMPENSATE_FRAMES := 2
#const COMPENSATE_HZ := 60.0
#var time_begin: float
#var time_delay: float

var song_position := 0.0
var song_position_beats := 1
var last_reported_beat := 0
var beats_before_start := 0
var current_measure := 1


signal beat(position: int)
signal measure(position: int)

func _process(_delta: float) -> void:
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		#song_position += (1 / COMPENSATE_HZ) * COMPENSATE_FRAMES
		song_position_beats = int(floor(song_position / seconds_per_beat)) + beats_before_start
		#print("Seconds per beat: ", seconds_per_beat)
		#print("Song position: ", song_position)
		#print("Song position beats: ", song_position_beats)
		#print("Song position beats time: ", song_position_beats * seconds_per_beat)
		#var time := (Time.get_ticks_usec() - time_begin) / 1000000.0
		#time -= time_delay
		#song_position_beats = int(time * bpm / 60.0)
		_report_beat()

func _report_beat() -> void:
	if last_reported_beat < song_position_beats:
		if current_measure > measures:
			current_measure = 1
		#print("new beat: ", Time.get_unix_time_from_system() - time_since_last_reported_beat)
		emit_signal("beat", song_position_beats)
		emit_signal("measure", current_measure)
		last_reported_beat = song_position_beats
		#time_since_last_reported_beat = Time.get_unix_time_from_system()
		current_measure += 1

func play_from_beat(beat_number: int, offset: int) -> void:
	#time_begin = Time.get_ticks_usec()
	#time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	play()
	seek(beat_number * seconds_per_beat)
	beats_before_start = offset
	current_measure = beat_number % measures

func play_with_offset(offset: int) -> void:
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
		#time_begin = Time.get_ticks_usec()
		#time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
		play()
		offset_timer.stop()
	_report_beat()
