class_name Song extends Node

@export_file("*.json") var data_path: String

var file_path : String
var audio_stream : AudioStream
var bpm : int
var measures : int
var beats_per_measure : int
var beat_map := []
var initialized := false
var offset := 0.0

func _ready() -> void:
	initialize()

func initialize() -> void:
	if !initialized:
		var song_data := load_from_file(data_path)
		file_path = song_data["file_path"]
		audio_stream = load(file_path)
		bpm = song_data["bpm"]
		measures = song_data["measures"]
		beats_per_measure = song_data["beats_per_measure"]
		offset = song_data["offset"]
		beat_map = song_data["beat_map"]
		initialized = true

func load_from_file(filePath: String) -> Dictionary:
	var parsed_data := {}
	if FileAccess.file_exists(filePath):
		var data := FileAccess.open(filePath, FileAccess.READ)
		var json := JSON.new()
		var error := json.parse(data.get_as_text())
		if error == OK:
			var json_data: Variant = json.data
			if json_data is Dictionary:
				parsed_data = json_data
			else:
				print("Unexpected Data")
		else:
			print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
	return parsed_data
