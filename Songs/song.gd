class_name Song extends Node

@export_file("*.json") var data_path: String

var file_path : String
var audio_stream : AudioStream
var bpm : int
var measures : int
var offset : int
var beat := []
var initialized := false

func initialize() -> void:
	if !initialized:
		var song_data := load_song_from_file(data_path)
		file_path = song_data["file_path"]
		if FileAccess.file_exists(file_path):
			audio_stream = load(file_path)
		bpm = song_data["bpm"]
		measures = song_data["measures"]
		offset = song_data["offset"]
		beat = song_data["beat"]

func load_song_from_file(filePath: String) -> Dictionary:
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
