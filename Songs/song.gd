class_name Song extends Node

@export_file("*.json") var data_path: String

var file_path : String
var audio_stream : AudioStream
var bpm : int
var measures : int
var chart := []
var events := []
var initialized := false

func _ready() -> void:
	initialize()

func initialize() -> void:
	if !initialized:
		var song_data := load_from_file(data_path)
		file_path = song_data["file_path"]
		print(file_path)
		if FileAccess.file_exists(file_path):
			print("exists!")
		audio_stream = load(file_path)
		bpm = song_data["bpm"]
		measures = song_data["measures"]
		chart = song_data["chart"]
		for i in range(chart.size()):
			events.append(chart[i]["event"])
		initialized = true
		print("song initialized")

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
